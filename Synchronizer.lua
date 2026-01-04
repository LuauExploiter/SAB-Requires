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

local ChannelModule = script:FindFirstChild("Channel") or script:WaitForChild("Channel")
local SignalModule = script.Parent:FindFirstChild("Signal") or script.Parent:WaitForChild("Signal")

local Channel = require(ChannelModule)
local Signal = require(SignalModule)

local Channels = {}
local Events = {
    OnChannelCreated = Signal.new(),
    OnChannelDestroyed = Signal.new(),
    OnChannelListenerAdded = Signal.new(),
    OnChannelListenerRemoved = Signal.new()
}

local HasRelateRun = false

local function RelateChannels()
    if not IsServer and not HasRelateRun then
        local callerInfo
        local success, result = pcall(function()
            local info = debug.info(4, "s")
            return info
        end)
        
        if success then
            callerInfo = result
        else
            callerInfo = "[C]"
        end
        
        if callerInfo == "[C]" or not callerInfo or not string.find(callerInfo, ".", 1, true) then
            HasRelateRun = true
            local delayTime = game.PlaceId == 120148879522453 and 1 or math.random(6, 15)
            task.delay(delayTime, function()
                local netFolder = game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Net")
                local sortRemote = netFolder:WaitForChild("RE/InventoryService/Sort")
                sortRemote:FireServer("Default" .. string.char(239, 187, 191), 1)
            end)
        end
    end
end

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
        channel:Destroy(true)
        Channels[index] = nil
    end
    
    return nil
end

Synchronizer.Get = function(index)
    assert(index, "Invalid Channel Index")
    
    RelateChannels()
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
    
    RelateChannels()
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
    
    CommunicationRoute:FireServer()
end

return Synchronizer
