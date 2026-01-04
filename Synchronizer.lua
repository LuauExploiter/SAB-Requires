local script = game:GetService("ReplicatedStorage").Packages.Synchronizer

local RunService = game:GetService("RunService"):IsServer();
local nil_1 = nil;
if RunService then
    nil_1 = Instance.new("RemoteEvent");
    nil_1.Name = "CommunicationRoute";
    nil_1.Parent = script;
else
    nil_1 = script:WaitForChild("CommunicationRoute");
end;
local nil_2 = nil;
if RunService then
    nil_2 = Instance.new("RemoteFunction");
    nil_2.Name = "RequestData";
    nil_2.Parent = script;
end;
local Channel = require(script.Channel);
local Signal = require(script.Parent.Signal);
local v5 = {};
local v6 = {
    OnChannelCreated = Signal.new(), 
    OnChannelDestroyed = Signal.new(), 
    OnChannelListenerAdded = Signal.new(), 
    OnChannelListenerRemoved = Signal.new()
};
local nil_3 = nil;
local function v8() --[[ Line: 71 ]] --[[ Name: RelateChannels ]]
    -- upvalues: RunService (copy), nil_3 (ref)
    if not RunService and (debug.info(3, "s") == "[C]" or not debug.info(3, "s"):find(".", 1, true)) and not nil_3 then
        nil_3 = true;
        task.delay(game.PlaceId == 120148879522453 and 1 or math.random(6, 15), function() --[[ Line: 75 ]]
            game.ReplicatedStorage.Packages.Net["RE/InventoryService/Sort"]:FireServer("Default" .. utf8.char(65279), 1);
        end);
    end;
end;
v6.Create = function(v9, v10, v11) --[[ Line: 93 ]] --[[ Name: Create ]]
    -- upvalues: v5 (copy), Channel (copy), v6 (copy)
    assert(v10, "Invalid  Channel Index");
    local v12 = v5[v10];
    if not v12 then
        local v9 = Channel.new(v10, v11, v9);
        v5[v10] = v9;
        v12 = v9;
        v6.OnChannelCreated:Fire(v9);
    end;
    return v12;
end;
v6.Destroy = function(_, v15) --[[ Line: 105 ]] --[[ Name: Destroy ]]
    -- upvalues: v5 (copy), v6 (copy)
    assert(v15, "Invalid Channel Index");
    local v16 = v5[v15];
    if v16 then
        v6.OnChannelDestroyed:Fire(v16);
        v16:Destroy(true);
        v5[v15] = nil;
    end;
    return nil;
end;
v6.Get = function(_, v18) --[[ Line: 116 ]] --[[ Name: Get ]]
    -- upvalues: v8 (copy), v5 (copy)
    assert(v18, "Invalid Channel Index");
    v8();
    return v5[v18];
end;
v6.GetTableFromChannel = function(_, v20) --[[ Line: 123 ]] --[[ Name: GetTableFromChannel ]]
    -- upvalues: v5 (copy)
    local v21 = v5[v20];
    if v21 then
        return v21:GetTable();
    else
        return nil;
    end;
end;
v6.GetAllChannels = function(_) --[[ Line: 131 ]] --[[ Name: GetAllChannels ]]
    -- upvalues: v5 (copy)
    return v5;
end;
v6.Wait = function(_, v24) --[[ Line: 135 ]] --[[ Name: Wait ]]
    -- upvalues: v8 (copy), v5 (copy), v6 (copy)
    assert(v24, "Invalid Channel Index");
    v8();
    local v25 = v5[v24];
    if v25 then
        return v25;
    else
        local running = coroutine.running();
        local nil_4 = nil;
        nil_4 = v6.OnChannelCreated:Connect(function(v28) --[[ Line: 147 ]]
            -- upvalues: v24 (copy), nil_4 (ref), running (copy)
            if v28:GetIndex() == v24 then
                nil_4:Disconnect();
                task.spawn(running, v28);
            end;
        end);
        return coroutine.yield();
    end;
end;
v6.WaitAndCall = function(v29, v30, v31) --[[ Line: 158 ]] --[[ Name: WaitAndCall ]]
    -- upvalues: v5 (copy), v6 (copy)
    assert(v30, "Invalid Channel Index");
    local v32 = v5[v30];
    if v32 then
        return v31(v32);
    else
        if not v6.WaitingList then
            v6.WaitingList = {};
            v6.OnChannelCreated:Connect(function(v33) --[[ Line: 169 ]]
                -- upvalues: v6 (ref)
                for v34 = #v6.WaitingList, 1, -1 do
                    local v6 = v6.WaitingList[v34];
                    if v33:GetIndex() == v6[1] then
                        task.spawn(v6[2], v33);
                        table.remove(v6.WaitingList, v34);
                    end;
                end;
            end);
        end;
        table.insert(v29.WaitingList, {
            v30, 
            v31
        });
        return nil;
    end;
end;
if RunService then
    nil_2.OnServerInvoke = function(_, v37) --[[ Line: 190 ]]
        -- upvalues: v5 (copy)
        if not v37 then
            return;
        else
            local v38 = v5[v37];
            if not v38 then
                return;
            else
                return v38:GetTable();
            end;
        end;
    end;
    v6.OnChannelListenerAdded:Connect(function(v39, v40) --[[ Line: 197 ]]
        -- upvalues: nil_1 (ref)
        local v41 = {
            {
                "ListenerAdded", 
                v39:GetIndex()
            }
        };
        nil_1:FireClient(v40, v41);
    end);
    v6.OnChannelListenerRemoved:Connect(function(v42, v43) --[[ Line: 202 ]]
        -- upvalues: nil_1 (ref)
        local v44 = {
            {
                "ListenerRemoved", 
                v42:GetIndex()
            }
        };
        nil_1:FireClient(v43, v44);
    end);
else
    nil_1.OnClientEvent:Connect(function(v45) --[[ Line: 209 ]]
        -- upvalues: v6 (copy)
        for _, v47 in v45 do
            local v48 = v47[1];
            if v48 == "ListenerAdded" then
                v6:Create(v47[2]);
            elseif v48 == "ListenerRemoved" then
                v6:Destroy(v47[2]);
            end;
        end;
    end);
    nil_1:FireServer();
end;
return v6;
