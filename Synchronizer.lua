local RunService = game:GetService("RunService")
local IsServer = RunService:IsServer()

local CommunicationRoute
local RequestData

if IsServer then
    CommunicationRoute = Instance.new("RemoteEvent")
    CommunicationRoute.Name = "CommunicationRoute"
    CommunicationRoute.Parent = script
    
    RequestData = Instance.new("RemoteFunction")
    RequestData.Name = "RequestData"
    RequestData.Parent = script
else
    CommunicationRoute = script:WaitForChild("CommunicationRoute")
end

local ChannelModule = script:FindFirstChild("Channel")
if not ChannelModule then
    ChannelModule = Instance.new("ModuleScript")
    ChannelModule.Name = "Channel"
    ChannelModule.Source = [[
        local Channel = {}
        Channel.__index = Channel
        
        function Channel.new(index, data, synchronizer)
            local self = setmetatable({}, Channel)
            self._index = index
            self._data = data or {}
            self._synchronizer = synchronizer
            self._listeners = {}
            return self
        end
        
        function Channel:GetIndex()
            return self._index
        end
        
        function Channel:Get(key)
            return self._data[key]
        end
        
        function Channel:Set(key, value)
            self._data[key] = value
            return self
        end
        
        function Channel:GetTable()
            return self._data
        end
        
        function Channel:Destroy()
            self._data = nil
            self._listeners = nil
            self._synchronizer = nil
        end
        
        return Channel
    ]]
    ChannelModule.Parent = script
end

local SignalModule = script.Parent:FindFirstChild("Signal")
if not SignalModule then
    SignalModule = Instance.new("ModuleScript")
    SignalModule.Name = "Signal"
    SignalModule.Source = [[
        local Signal = {}
        Signal.__index = Signal
        
        function Signal.new()
            local self = setmetatable({}, Signal)
            self._connections = {}
            return self
        end
        
        function Signal:Connect(callback)
            local connection = {
                Connected = true,
                Disconnect = function(self)
                    self.Connected = false
                    for i, conn in ipairs(self._parent._connections) do
                        if conn == self then
                            table.remove(self._parent._connections, i)
                            break
                        end
                    end
                end
            }
            connection._parent = self
            connection._callback = callback
            table.insert(self._connections, connection)
            return connection
        end
        
        function Signal:Fire(...)
            for _, connection in ipairs(self._connections) do
                if connection.Connected then
                    task.spawn(connection._callback, ...)
                end
            end
        end
        
        return Signal
    ]]
    SignalModule.Parent = script.Parent
end

local Channel = require(ChannelModule)
local Signal = require(SignalModule)

local Channels = {}
local Events = {
    OnChannelCreated = Signal.new(),
    OnChannelDestroyed = Signal.new(),
    OnChannelListenerAdded = Signal.new(),
    OnChannelListenerRemoved = Signal.new()
}

local Synchronizer = {}

Synchronizer.Create = function(index, data)
    assert(index, "Invalid Channel Index")
    
    local existingChannel = Channels[index]
    if not existingChannel then
        local newChannel = Channel.new(index, data, Synchronizer)
        Channels[index] = newChannel
        existingChannel = newChannel
        Events.OnChannelCreated:Fire(newChannel)
    end
    
    return existingChannel
end

Synchronizer.Destroy = function(index)
    assert(index, "Invalid Channel Index")
    
    local channel = Channels[index]
    if channel then
        Events.OnChannelDestroyed:Fire(channel)
        channel:Destroy()
        Channels[index] = nil
    end
    
    return nil
end

Synchronizer.Get = function(index)
    assert(index, "Invalid Channel Index")
    return Channels[index]
end

Synchronizer.GetTableFromChannel = function(index)
    local channel = Channels[index]
    if channel then
        return channel:GetTable()
    else
        return nil
    end
end

Synchronizer.GetAllChannels = function()
    return Channels
end

Synchronizer.Wait = function(index)
    assert(index, "Invalid Channel Index")
    
    local channel = Channels[index]
    if channel then
        return channel
    else
        local runningCoroutine = coroutine.running()
        local connection
        connection = Events.OnChannelCreated:Connect(function(newChannel)
            if newChannel:GetIndex() == index then
                connection:Disconnect()
                task.spawn(runningCoroutine, newChannel)
            end
        end)
        return coroutine.yield()
    end
end

Synchronizer.WaitAndCall = function(index, callback)
    assert(index, "Invalid Channel Index")
    
    local channel = Channels[index]
    if channel then
        return callback(channel)
    else
        if not Synchronizer.WaitingList then
            Synchronizer.WaitingList = {}
            Events.OnChannelCreated:Connect(function(newChannel)
                for i = #Synchronizer.WaitingList, 1, -1 do
                    local waitingData = Synchronizer.WaitingList[i]
                    if newChannel:GetIndex() == waitingData[1] then
                        task.spawn(waitingData[2], newChannel)
                        table.remove(Synchronizer.WaitingList, i)
                    end
                end
            end)
        end
        table.insert(Synchronizer.WaitingList, {index, callback})
        return nil
    end
end

if IsServer then
    if RequestData then
        RequestData.OnServerInvoke = function(player, index)
            if not index then
                return nil
            else
                local channel = Channels[index]
                if not channel then
                    return nil
                else
                    return channel:GetTable()
                end
            end
        end
    end
    
    Events.OnChannelListenerAdded:Connect(function(channel, player)
        local message = {
            {"ListenerAdded", channel:GetIndex()}
        }
        CommunicationRoute:FireClient(player, message)
    end)
    
    Events.OnChannelListenerRemoved:Connect(function(channel, player)
        local message = {
            {"ListenerRemoved", channel:GetIndex()}
        }
        CommunicationRoute:FireClient(player, message)
    end)
else
    CommunicationRoute.OnClientEvent:Connect(function(messages)
        for _, message in ipairs(messages) do
            local messageType = message[1]
            local channelIndex = message[2]
            
            if messageType == "ListenerAdded" then
                Synchronizer:Create(channelIndex)
            elseif messageType == "ListenerRemoved" then
                Synchronizer:Destroy(channelIndex)
            end
        end
    end)
end

return Synchronizer
