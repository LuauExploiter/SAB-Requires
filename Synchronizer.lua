local Synchronizer = {}
local Channels = {}

local function CreateChannel(index, data)
    local channel = {
        _index = index,
        _data = data or {}
    }
    
    function channel:GetIndex()
        return self._index
    end
    
    function channel:Get(key)
        return self._data[key]
    end
    
    function channel:Set(key, value)
        self._data[key] = value
        return self
    end
    
    function channel:GetTable()
        return self._data
    end
    
    function channel:Destroy()
        self._data = nil
        return nil
    end
    
    return channel
end

function Synchronizer:Get(index)
    if not index then
        return nil
    end
    
    if not Channels[index] then
        Channels[index] = CreateChannel(index, {})
    end
    
    return Channels[index]
end

function Synchronizer:Create(index, data)
    if not index then
        return nil
    end
    
    Channels[index] = CreateChannel(index, data)
    return Channels[index]
end

function Synchronizer:Destroy(index)
    if not index then
        return nil
    end
    
    if Channels[index] then
        Channels[index]:Destroy()
        Channels[index] = nil
    end
end

function Synchronizer:GetTableFromChannel(index)
    local channel = Channels[index]
    if channel then
        return channel:GetTable()
    end
    return nil
end

function Synchronizer:GetAllChannels()
    return Channels
end

function Synchronizer:Wait(index)
    local channel = Channels[index]
    if channel then
        return channel
    end
    
    local thread = coroutine.running()
    local connection
    
    connection = game:GetService("RunService").Heartbeat:Connect(function()
        local ch = Channels[index]
        if ch then
            if connection then
                connection:Disconnect()
            end
            coroutine.resume(thread, ch)
        end
    end)
    
    return coroutine.yield()
end

return Synchronizer
