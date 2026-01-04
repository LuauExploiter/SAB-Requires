local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Packages = ReplicatedStorage:WaitForChild("Packages");
local Trove = require(Packages.Trove);
local Observers = require(Packages.Observers);
local Trove_1 = require(Packages.Trove);
local Datas = ReplicatedStorage:WaitForChild("Datas");
local Animals = require(Datas.Animals);
local Game = require(Datas.Game);
local Rebirth = require(Datas.Rebirth);
local Rarities = require(Datas.Rarities);
local Mutations = require(Datas.Mutations);
local Traits = require(Datas.Traits);
local Animations = ReplicatedStorage:WaitForChild("Animations").Animals;
local MutationSurfaces = ReplicatedStorage:WaitForChild("MutationSurfaces");
local Models = ReplicatedStorage:WaitForChild("Models");
local Animals_1 = Models.Animals;
local Traits_1 = Models.Traits;
local Vfx = ReplicatedStorage:WaitForChild("Vfx").Traits;
local Vfx_1 = ReplicatedStorage:WaitForChild("Vfx");
local v20 = {};
local Unit = Vector3.new(-1, 0.25, -1, 0).Unit;
local function v40(v22, v23) --[[ Line: 40 ]] --[[ Name: GetBoundingBox ]]
    local v24 = 1e999;
    local v25 = 1e999;
    local v26 = 1e999;
    local v27 = -1e999;
    local v28 = -1e999;
    local v29 = -1e999;
    for Rebirth, v31 in v22:GetDescendants() do
        if v31:IsA("BasePart") and v31.Transparency < 1 and not v23[v31] then
            local CFrame = v31.CFrame;
            local Size = v31.Size * 0.5;
            for v34 = -1, 1, 2 do
                for v35 = -1, 1, 2 do
                    for v36 = -1, 1, 2 do
                        local v36 = CFrame:PointToWorldSpace((Vector3.new(Size.X * v34, Size.Y * v35, Size.Z * v36)));
                        v24 = math.min(v24, v36.X);
                        v25 = math.min(v25, v36.Y);
                        v26 = math.min(v26, v36.Z);
                        v27 = math.max(v27, v36.X);
                        v28 = math.max(v28, v36.Y);
                        v29 = math.max(v29, v36.Z);
                    end;
                end;
            end;
        end;
    end;
    local v26 = Vector3.new(v27 - v24, v28 - v25, v29 - v26);
    local v29 = Vector3.new((v24 + v27) / 2, (v25 + v28) / 2, (v26 + v29) / 2);
    return CFrame.new(v29), v26;
end;
local function v55(v41, v42, v43, v44, v45, v46) --[[ Line: 76 ]] --[[ Name: FitCam ]]
    -- upvalues: v40 (copy), Unit (copy)
    v45 = v45 or 0.8;
    v46 = v46 or 0.5;
    local v47 = {};
    if v42 == "Los Noobinis" then
        v47[v43["Cube.003"]] = true;
    end;
    local FakeRootPart = v43:FindFirstChild("FakeRootPart");
    if FakeRootPart then
        v47[FakeRootPart] = true;
    end;
    if v42 == "Tacorita Bicicleta" then
        local RootPart = v43:FindFirstChild("RootPart");
        if RootPart then
            v47[RootPart] = true;
        end;
    end;
    local Rebirth, v51 = v40(v43, v47);
    if v42 == "Tacorita Bicicleta" then
        v45 = v45 + 0.2;
    elseif v42 == "25" then
        v45 = v45 - 0.6;
    elseif v42 == "Los Jolly Combinasionas" then
        v45 = v45 - 0.4;
    elseif v42 == "Money Money Reindeer" then
        v45 = v45 + 0.2;
    end;
    local GetPivot = if not (v42 ~= "Tacorita Bicicleta" and v42 ~= "W or L" and v42 ~= "25" and v42 ~= "Cocoa Assassino") or v42 == "Los Jolly Combinasionas" then v43:GetPivot() + Vector3.new(0, v51.Y * 0.5, 0) else v43.PrimaryPart and v43.PrimaryPart.CFrame or v43:GetPivot();
    local Z = math.max(v51.X, v51.Y, v51.Z);
    local v45 = Z * 0.5 / math.tan((math.rad(v44 * 0.5))) * v45;
    v41.CFrame = CFrame.new((GetPivot * CFrame.new(Unit * (v45 + Z * v46))).Position, GetPivot.Position);
end;
v20.GetSellValue = function(Rebirth, v57) --[[ Line: 124 ]] --[[ Name: GetSellValue ]]
    -- upvalues: v20 (copy), Game (copy)
    return (math.ceil(v20:GetPrice(v57) * Game.Animal.SellModifier));
end;
local function Rebirth(v58, v59) --[[ Line: 128 ]] --[[ Name: ShouldIgnoreColor ]]
    local v59 = v58:GetAttribute((("%*IgnoreColor"):format(v59)));
    if v59 == false then
        return false;
    else
        return v58:GetAttribute("IgnoreColor") or v59;
    end;
end;
v20.ApplyMutation = function(Rebirth, v63, v64, v65, v66) --[[ Line: 138 ]] --[[ Name: ApplyMutation ]]
    -- upvalues: Trove_1 (copy), Mutations (copy), MutationSurfaces (copy), ReplicatedStorage (copy), Vfx_1 (copy)
    local new = Trove_1.new();
    if v66 then
        new:Add(v63.Destroying:Connect(function() --[[ Line: 141 ]]
            -- upvalues: new (copy)
            new:Destroy();
        end));
    else
        new:Add(v63.AncestryChanged:Connect(function(Rebirth, v69) --[[ Line: 145 ]]
            -- upvalues: new (copy)
            if v69 then
                return;
            else
                new:Destroy();
                return;
            end;
        end));
    end;
    local v70 = Mutations[v65];
    local v64 = MutationSurfaces:FindFirstChild(v64);
    local Palette = tonumber(v63:GetAttribute((("%*Palette"):format(v65))) or v63:GetAttribute("Palette") or 1) or 1;
    if not v70 or not v70.Palettes[Palette] then
        Palette = 1;
    end;
    local v73 = {};
    if v65 == "Rainbow" then
        new:Add(function() --[[ Line: 164 ]]
            -- upvalues: v63 (copy)
            v63:RemoveTag("RainbowModel");
        end);
        for Rebirth, v75 in v63:GetDescendants() do
            if v75:IsA("BasePart") and not v75:GetAttribute("IgnoreRainbowColor") then
                local SurfaceAppearance = v75:FindFirstChildOfClass("SurfaceAppearance");
                if SurfaceAppearance then
                    new:Add(function() --[[ Line: 175 ]]
                        -- upvalues: v75 (copy), SurfaceAppearance (copy)
                        local SurfaceAppearance_1 = v75:FindFirstChildOfClass("SurfaceAppearance");
                        if SurfaceAppearance_1 then
                            SurfaceAppearance_1:Destroy();
                        end;
                        SurfaceAppearance:Clone().Parent = v75;
                    end);
                else
                    local Color = v75.Color;
                    new:Add(function() --[[ Line: 185 ]]
                        -- upvalues: v75 (copy), Color (copy)
                        v75.Color = Color;
                    end);
                    local MaterialVariant = v75.MaterialVariant;
                    if MaterialVariant == "Strawberry Stud Light" or MaterialVariant == "Strawberry Stud Dark" then
                        v75.MaterialVariant = "";
                        new:Add(function() --[[ Line: 192 ]]
                            -- upvalues: v75 (copy), MaterialVariant (copy)
                            v75.MaterialVariant = MaterialVariant;
                        end);
                    end;
                end;
            end;
        end;
        v63:AddTag("RainbowModel");
    else
        for Rebirth, v81 in v63:GetDescendants() do
            if v81:IsA("BasePart") then
                local v65 = v81:GetAttribute((("%*IgnoreColor"):format(v65)));
                if not (v65 ~= false and (v81:GetAttribute("IgnoreColor") or v65)) then
                    local v70 = v70.Palettes[Palette];
                    v65 = v70.Palettes[Palette];
                    local Color_1 = tonumber(v81:GetAttribute((("%*Color"):format(v65))) or v81:GetAttribute("Color") or 1) or 1;
                    local clamp = v65[Color_1] or v70[Color_1] or v65[math.clamp(Color_1, 1, #v65)];
                    if v81:GetAttribute("Neon") then
                        local Color_2 = v81.Color;
                        v81.Material = Enum.Material.Neon;
                        local l_Color_1 = Color_2 --[[ copy: 19 -> 23 ]];
                        new:Add(function() --[[ Line: 215 ]]
                            -- upvalues: v81 (copy), l_Color_1 (copy)
                            v81.Material = l_Color_1;
                        end);
                    end;
                    local SurfaceAppearance_2 = v81:FindFirstChildOfClass("SurfaceAppearance");
                    if SurfaceAppearance_2 then
                        SurfaceAppearance_2:Destroy();
                        if v64 then
                            local l_l_MutationSurfaces_0_FirstChild_0 = new:Clone(v64);
                            l_l_MutationSurfaces_0_FirstChild_0.Color = clamp;
                            l_l_MutationSurfaces_0_FirstChild_0.Parent = v81;
                        end;
                        new:Add(function() --[[ Line: 230 ]]
                            -- upvalues: v81 (copy), SurfaceAppearance_2 (copy)
                            local SurfaceAppearance_3 = v81:FindFirstChildOfClass("SurfaceAppearance");
                            if SurfaceAppearance_3 then
                                SurfaceAppearance_3:Destroy();
                            end;
                            SurfaceAppearance_2:Clone().Parent = v81;
                        end);
                    else
                        local MaterialVariant_1 = v81.MaterialVariant;
                        if MaterialVariant_1 == "Strawberry Stud Light" or MaterialVariant_1 == "Strawberry Stud Dark" then
                            v73[v81] = true;
                            v81.MaterialVariant = ("%* Strawberry Stud Light"):format(v65);
                            new:Add(function() --[[ Line: 243 ]]
                                -- upvalues: v81 (copy), MaterialVariant_1 (copy)
                                v81.MaterialVariant = MaterialVariant_1;
                            end);
                            if MaterialVariant_1 == "Strawberry Stud Light" then
                                continue;
                            end;
                        end;
                        local Color_3 = v81.Color;
                        v81.Color = clamp;
                        new:Add(function() --[[ Line: 255 ]]
                            -- upvalues: v81 (copy), Color_3 (copy)
                            v81.Color = Color_3;
                        end);
                    end;
                end;
            end;
        end;
    end;
    if v65 == "Lava" then
        for Rebirth, v94 in v63:GetDescendants() do
            if v94:IsA("BasePart") and not v73[v94] then
                local v65_1 = v94:GetAttribute((("%*IgnoreColor"):format(v65)));
                if not (v65_1 ~= false and (v94:GetAttribute("IgnoreColor") or v65_1)) and (v94:GetAttribute((("%*Color"):format(v65))) or v94:GetAttribute("Color")) == 1 then
                    v65_1 = v94.Material;
                    v94.Material = Enum.Material.Neon;
                    new:Add(function() --[[ Line: 272 ]]
                        -- upvalues: v94 (copy), v65_1 (copy)
                        v94.Material = v65_1;
                    end);
                end;
            end;
        end;
    elseif v65 == "Galaxy" then
        for Rebirth, v97 in v63:GetDescendants() do
            if v97:IsA("BasePart") and not v73[v97] then
                local v65_2 = v97:GetAttribute((("%*IgnoreColor"):format(v65)));
                if not (v65_2 ~= false and (v97:GetAttribute("IgnoreColor") or v65_2)) then
                    if (v97:GetAttribute((("%*Color"):format(v65))) or v97:GetAttribute("Color")) == 1 then
                        v65_2 = v97.Material;
                        v97.Material = Enum.Material.Neon;
                        local l_v97_Attribute_0 = v65_2 --[[ copy: 16 -> 24 ]];
                        new:Add(function() --[[ Line: 287 ]]
                            -- upvalues: v97 (copy), l_v97_Attribute_0 (copy)
                            v97.Material = l_v97_Attribute_0;
                        end);
                    end;
                    v65_2 = v97.MaterialVariant;
                    v97.MaterialVariant = "Galaxy Stud";
                    new:Add(function() --[[ Line: 294 ]]
                        -- upvalues: v97 (copy), v65_2 (copy)
                        v97.MaterialVariant = v65_2;
                    end);
                end;
            end;
        end;
    elseif v65 == "YinYang" then
        for Rebirth, v101 in v63:GetDescendants() do
            if v101:IsA("BasePart") and not v73[v101] then
                local v65_3 = v101:GetAttribute((("%*IgnoreColor"):format(v65)));
                if not (v65_3 ~= false and (v101:GetAttribute("IgnoreColor") or v65_3)) then
                    local Color_4 = v101:GetAttribute((("%*Color"):format(v65))) or v101:GetAttribute("Color") or 1;
                    v65_3 = true;
                    if Color_4 ~= 3 then
                        v65_3 = Color_4 == 4;
                    end;
                    if v65_3 then
                        local Material = v101.Material;
                        v101.Material = Enum.Material.Neon;
                        new:Add(function() --[[ Line: 309 ]]
                            -- upvalues: v101 (copy), Material (copy)
                            v101.Material = Material;
                        end);
                    end;
                end;
            end;
        end;
    elseif v65 == "Radioactive" then
        for Rebirth, v106 in v63:GetDescendants() do
            if v106:IsA("BasePart") and not v73[v106] then
                local v65_4 = v106:GetAttribute((("%*IgnoreColor"):format(v65)));
                if not (v65_4 ~= false and (v106:GetAttribute("IgnoreColor") or v65_4)) then
                    local MaterialVariant_2 = v106.MaterialVariant;
                    v65_4 = v106.Material;
                    local Color_5 = v106:GetAttribute((("%*Color"):format(v65))) or v106:GetAttribute("Color") or 1;
                    if Color_5 == 2 and Palette == 1 or Color_5 == 2 and Palette == 4 or (not (Color_5 ~= 2) or Color_5 == 6) and Palette == 5 then
                        v106.Material = Enum.Material.Neon;
                        new:Add(function() --[[ Line: 327 ]]
                            -- upvalues: v106 (copy), v65_4 (copy)
                            v106.Material = v65_4;
                        end);
                    end;
                    local v65_5 = v106:GetAttribute((("%*Stud"):format(v65)));
                    if v65_5 ~= false and (v106.MaterialVariant == "Custom Stud" or v65_5 == true) and not v106:GetAttribute((("%*Ignore"):format(v65))) then
                        if v106:GetAttribute((("%*MaterialMode"):format(v65))) == 2 or v63:GetAttribute((("%*MaterialMode"):format(v65))) == 2 then
                            if v106:GetAttribute((("%*Material"):format(v65))) == 2 or v63:GetAttribute((("%*Material"):format(v65))) == 2 then
                                v106.Material = Enum.Material.SmoothPlastic;
                                v106.MaterialVariant = "Radioactive Stud";
                                new:Add(function() --[[ Line: 339 ]]
                                    -- upvalues: v106 (copy), MaterialVariant_2 (copy), v65_4 (copy)
                                    v106.MaterialVariant = MaterialVariant_2;
                                    v106.Material = v65_4;
                                end);
                            else
                                v106.Material = Enum.Material.SmoothPlastic;
                                v106.MaterialVariant = "Radioactive Stud2";
                                new:Add(function() --[[ Line: 346 ]]
                                    -- upvalues: v106 (copy), MaterialVariant_2 (copy), v65_4 (copy)
                                    v106.MaterialVariant = MaterialVariant_2;
                                    v106.Material = v65_4;
                                end);
                            end;
                        elseif Color_5 ~= 2 and Color_5 ~= 6 then
                            if v106:GetAttribute((("%*Material"):format(v65))) == 2 or v63:GetAttribute((("%*Material"):format(v65))) == 2 then
                                v106.Material = Enum.Material.SmoothPlastic;
                                v106.MaterialVariant = "Radioactive Stud";
                                new:Add(function() --[[ Line: 355 ]]
                                    -- upvalues: v106 (copy), MaterialVariant_2 (copy), v65_4 (copy)
                                    v106.MaterialVariant = MaterialVariant_2;
                                    v106.Material = v65_4;
                                end);
                            else
                                v106.Material = Enum.Material.SmoothPlastic;
                                v106.MaterialVariant = "Radioactive Stud2";
                                new:Add(function() --[[ Line: 362 ]]
                                    -- upvalues: v106 (copy), MaterialVariant_2 (copy), v65_4 (copy)
                                    v106.MaterialVariant = MaterialVariant_2;
                                    v106.Material = v65_4;
                                end);
                            end;
                        end;
                    elseif v65_5 == false then
                        v106.MaterialVariant = "";
                        new:Add(function() --[[ Line: 370 ]]
                            -- upvalues: v106 (copy), MaterialVariant_2 (copy)
                            v106.MaterialVariant = MaterialVariant_2;
                        end);
                    end;
                end;
            end;
        end;
    elseif v65 == "Cursed" then
        local Zombie = v63:FindFirstChild("_Trait.Zombie");
        if Zombie then
            Zombie:Destroy();
        end;
        for Rebirth, v113 in v63:GetDescendants() do
            if v113:IsA("BasePart") and not v73[v113] then
                local v65_6 = v113:GetAttribute((("%*IgnoreColor"):format(v65)));
                if not (v65_6 ~= false and (v113:GetAttribute("IgnoreColor") or v65_6)) then
                    local MaterialVariant_3 = v113.MaterialVariant;
                    v65_6 = v113.Material;
                    local Color_6 = v113.Color;
                    local Color_7 = v113:GetAttribute((("%*Color"):format(v65))) or v113:GetAttribute("Color") or 1;
                    if Color_7 == 2 and Palette == 1 or Color_7 == 2 and Palette == 4 or (not (Color_7 ~= 2) or Color_7 == 6) and Palette == 5 then
                        v113.Material = Enum.Material.Neon;
                        new:Add(function() --[[ Line: 395 ]]
                            -- upvalues: v113 (copy), v65_6 (copy)
                            v113.Material = v65_6;
                        end);
                    end;
                    local v65_7 = v113:GetAttribute((("%*Stud"):format(v65)));
                    if v65_7 ~= false and (v113.MaterialVariant == "Custom Stud" or v65_7 == true) and not v113:GetAttribute((("%*Ignore"):format(v65))) then
                        if Color_7 ~= 2 and Color_7 ~= 6 or v65_7 == true then
                            v113.Material = Enum.Material.SmoothPlastic;
                            v113.MaterialVariant = "Cursed Stud";
                            v113.Color = Color3.fromRGB(255, 23, 23);
                            new:Add(function() --[[ Line: 407 ]]
                                -- upvalues: v113 (copy), MaterialVariant_3 (copy), v65_6 (copy), Color_6 (copy)
                                v113.MaterialVariant = MaterialVariant_3;
                                v113.Material = v65_6;
                                v113.Color = Color_6;
                            end);
                        end;
                    elseif v65_7 == false then
                        v113.MaterialVariant = "";
                        new:Add(function() --[[ Line: 415 ]]
                            -- upvalues: v113 (copy), MaterialVariant_3 (copy)
                            v113.MaterialVariant = MaterialVariant_3;
                        end);
                    end;
                    local SurfaceAppearance_4 = v113:FindFirstChildOfClass("SurfaceAppearance");
                    if SurfaceAppearance_4 then
                        if not v113:GetAttribute((("%*IgnoreSurfaceColor"):format(v65))) then
                            SurfaceAppearance_4.Color = Color3.fromRGB(255, 23, 23);
                        end;
                        if v113:GetAttribute("IgnoreSurface") then
                            SurfaceAppearance_4:Destroy();
                        end;
                    end;
                end;
            end;
        end;
        local v64_1 = ReplicatedStorage.Models.TraitsPerAnimal.Zombie:FindFirstChild(v64);
        if v64_1 then
            local l_FirstChild_0 = new:Clone(v64_1);
            l_FirstChild_0.Name = "_Trait.Zombie";
            l_FirstChild_0.Parent = v63;
            local v122 = {};
            for Rebirth, v124 in l_FirstChild_0:GetChildren() do
                v124.Color = Color3.fromRGB(255, 23, 23);
                local Attachment = v124:FindFirstChildOfClass("Attachment");
                local true_1 = v122[Attachment.Name] or v63:FindFirstChild(Attachment.Name, true);
                if not true_1 then
                    v124:Destroy();
                else
                    v122[Attachment.Name] = true_1;
                    local RigidConstraint = Instance.new("RigidConstraint");
                    RigidConstraint.Attachment0 = Attachment;
                    RigidConstraint.Attachment1 = true_1;
                    RigidConstraint.Parent = Attachment;
                end;
            end;
        end;
    end;
    local v65_8 = Vfx_1:FindFirstChild(v65);
    local VfxInstance = v63:FindFirstChild("VfxInstance");
    if v65_8 and VfxInstance then
        for Rebirth, v131 in v65_8:GetChildren() do
            new:Clone(v131).Parent = VfxInstance;
        end;
    end;
    return new:WrapClean();
end;
v20.ApplyTraits = function(Rebirth, v133, v134, v135) --[[ Line: 472 ]] --[[ Name: ApplyTraits ]]
    -- upvalues: Trove_1 (copy), Models (copy), Traits (copy), ReplicatedStorage (copy), Observers (copy), Traits_1 (copy), Vfx (copy)
    local new_1 = Trove_1.new();
    local v137 = {};
    for Rebirth, v139 in v135 do
        v137[v139] = true;
    end;
    local v134 = v137.Skibidi and Models.TraitsPerAnimal.Skibidi:FindFirstChild(v134);
    for Rebirth, v142 in v135 do
        local function v154() --[[ Line: 483 ]] --[[ Name: loadSpecificAnimalModel ]]
            -- upvalues: Traits (ref), v142 (copy), Models (ref), v134 (copy), v133 (copy), new_1 (copy), ReplicatedStorage (ref), Observers (ref)
            if not Traits[v142] then
                return;
            else
                local v142 = Models.TraitsPerAnimal:FindFirstChild(v142);
                if not v142 then
                    return;
                else
                    local v134_1 = v142:FindFirstChild(v134);
                    if not v134_1 then
                        return;
                    elseif v133:FindFirstChild((("_Trait.%*"):format(v142))) then
                        return;
                    else
                        local l_l_FirstChild_1_FirstChild_0 = new_1:Clone(v134_1);
                        l_l_FirstChild_1_FirstChild_0.Name = ("_Trait.%*"):format(v142);
                        for Rebirth, v147 in l_l_FirstChild_1_FirstChild_0:GetChildren() do
                            local Attachment_1 = v147:FindFirstChildOfClass("Attachment");
                            if Attachment_1 then
                                local true_2 = v133:FindFirstChild(Attachment_1.Name, true);
                                if true_2 then
                                    local RigidConstraint_1 = Instance.new("RigidConstraint");
                                    RigidConstraint_1.Attachment0 = Attachment_1;
                                    RigidConstraint_1.Attachment1 = true_2;
                                    RigidConstraint_1.Parent = v147;
                                end;
                            end;
                        end;
                        l_l_FirstChild_1_FirstChild_0.Parent = v133;
                        if v142 == "Jackolantern Pet" or v142 == "Reindeer Pet" then
                            local Animator = l_l_FirstChild_1_FirstChild_0:FindFirstChildWhichIsA("Animator", true);
                            if Animator then
                                Animator:SetAttribute("Animation", (("Animations.Traits.%*"):format(v142)));
                                Animator:AddTag("ClientLoadAnimation");
                                local Walk = Animator:LoadAnimation(ReplicatedStorage.Animations.Traits[v142].Walk);
                                new_1:Add(function() --[[ Line: 515 ]]
                                    -- upvalues: Walk (copy)
                                    Walk:Stop(0);
                                    Walk:Destroy();
                                end);
                                new_1:Add(Observers.observeAttribute(v133, "Walking", function(v153) --[[ Line: 520 ]]
                                    -- upvalues: Walk (copy)
                                    if v153 then
                                        if not Walk.IsPlaying then
                                            Walk:Play();
                                        end;
                                    elseif Walk.IsPlaying then
                                        Walk:Stop();
                                    end;
                                    return nil;
                                end));
                            end;
                        end;
                        return;
                    end;
                end;
            end;
        end;
        local function v170() --[[ Line: 537 ]] --[[ Name: loadModels ]]
            -- upvalues: Traits (ref), v142 (copy), Traits_1 (ref), new_1 (copy), v133 (copy), v137 (copy), v134 (copy)
            local v155 = Traits[v142];
            if not v155 then
                return;
            else
                local v142_1 = Traits_1:FindFirstChild(v142);
                if not v142_1 then
                    return;
                else
                    local l_l_Traits_0_FirstChild_0 = new_1:Clone(v142_1);
                    l_l_Traits_0_FirstChild_0.Name = ("_Trait.%*"):format(v142);
                    for Rebirth, v159 in l_l_Traits_0_FirstChild_0:GetChildren() do
                        local false_1 = false;
                        for Rebirth, v162 in v159:GetChildren() do
                            if v162:IsA("Attachment") then
                                local true_3 = v133:FindFirstChild(v162.Name, true);
                                if true_3 then
                                    false_1 = true;
                                    local new_2 = Vector3.new(0, 0, 0, 0);
                                    if (v142 == "10B" or v142 == "26") and v137["10B"] then
                                        new_2 = new_2 + Vector3.new(0, -1.4589999914169312, 0, 0);
                                    end;
                                    if (v142 == "Taco" or v142 == "10B" or v142 == "26") and v137["RIP Gravestone"] then
                                        new_2 = new_2 + Vector3.new(0, -3.5820000171661377, 0, 0);
                                    end;
                                    if (v142 == "Taco" or v142 == "10B" or v142 == "26" or v142 == "RIP Gravestone") and v137["Matteo Hat"] then
                                        new_2 = new_2 + Vector3.new(0, -1.3300000429153442, 0, 0);
                                    end;
                                    if (v142 == "Taco" or v142 == "10B" or v142 == "26" or v142 == "Matteo Hat" or v142 == "RIP Gravestone") and v137["Santa Hat"] then
                                        new_2 = new_2 + Vector3.new(0, -1.534000039100647, 0, 0);
                                    end;
                                    if (v142 == "Taco" or v142 == "10B" or v142 == "26" or v142 == "Matteo Hat" or v142 == "RIP Gravestone" or v142 == "Santa Hat") and v137["Witch Hat"] then
                                        new_2 = new_2 + Vector3.new(0, -2.450000047683716, 0, 0);
                                    end;
                                    if (v142 == "Taco" or v142 == "10B" or v142 == "26" or v142 == "Matteo Hat" or v142 == "RIP Gravestone" or v142 == "Santa Hat" or v142 == "Witch Hat") and v137.Sombrero then
                                        new_2 = new_2 + Vector3.new(0, -2.7279999256134033, 0, 0);
                                    end;
                                    if (v142 == "Taco" or v142 == "10B" or v142 == "26" or v142 == "Matteo Hat" or v142 == "RIP Gravestone" or v142 == "Santa Hat" or v142 == "Witch Hat" or v142 == "Sombrero") and v137.Skibidi then
                                        local Name = v162.Name;
                                        if not string.find(Name, "Forward") then
                                            local Second = string.find(Name, "Second");
                                            Name = string.find(Name, "Third") and "ThirdForwardHatAttachment" or Second and "SecondForwardHatAttachment" or "ForwardHatAttachment";
                                        end;
                                        local true_4 = v134:FindFirstChild(Name, true);
                                        if true_4 then
                                            new_2 = new_2 + Vector3.new(0, -(true_4.Parent.Size.Y * 0.5) + true_4.Position.Y, 0);
                                        end;
                                    end;
                                    if new_2 ~= Vector3.new(0, 0, 0, 0) then
                                        if v142 == "26" then
                                            new_2 = Vector3.new(0, 0, new_2.Y);
                                        end;
                                        v162.Position = v162.Position + new_2;
                                    end;
                                    local RigidConstraint_2 = Instance.new("RigidConstraint");
                                    RigidConstraint_2.Attachment0 = v162;
                                    RigidConstraint_2.Attachment1 = true_3;
                                    RigidConstraint_2.Parent = v159;
                                    if v155.Modify then
                                        v155.Modify(v159, v162, true_3);
                                    end;
                                end;
                            end;
                        end;
                        if not false_1 then
                            v159:Destroy();
                        end;
                    end;
                    l_l_Traits_0_FirstChild_0.Parent = v133;
                    if v137.Lightning then
                        local Animator_1 = l_l_Traits_0_FirstChild_0:FindFirstChildWhichIsA("Animator", true);
                        if Animator_1 then
                            Animator_1:SetAttribute("Animation", "Animations.Traits.Lightning");
                            Animator_1:AddTag("ClientLoadAnimation");
                        end;
                    end;
                    return;
                end;
            end;
        end;
        local function v178() --[[ Line: 641 ]] --[[ Name: loadVfx ]]
            -- upvalues: Traits (ref), v142 (copy), Vfx (ref), v133 (copy), new_1 (copy)
            local v171 = Traits[v142];
            if not v171 then
                return;
            else
                local v142_2 = Vfx:FindFirstChild(v142);
                if v142_2 then
                    for Rebirth, v174 in v142_2:GetChildren() do
                        local Name_1 = v133:FindFirstChild(v174.Name);
                        if Name_1 then
                            local v174 = new_1:Clone(v174);
                            v174.Massless = true;
                            v174.CanCollide = false;
                            v174.CanQuery = false;
                            v174.CanTouch = false;
                            v174.Transparency = 1;
                            v174.CFrame = Name_1.CFrame;
                            local v176 = Instance.new("WeldConstraint", v174);
                            v176.Part0 = Name_1;
                            v176.Part1 = v174;
                            v174.Parent = v133;
                            v174.Name = ("Rebirth%*"):format(v174.Name);
                            if v171.ModifyVFX then
                                v171.ModifyVFX(v174, Name_1);
                            end;
                        end;
                    end;
                end;
                return;
            end;
        end;
        if v142 ~= "Strawberry" or v134 ~= "Strawberry Elephant" then
            v154();
            v170();
            v178();
            if v142 == "Strawberry" then
                for Rebirth, v180 in v133:GetDescendants() do
                    if v180:IsA("BasePart") then
                        local MaterialVariant_4 = v180.MaterialVariant;
                        local Color_8 = v180.Color;
                        if v180:HasTag("Strawberry") then
                            v180.Color = Color3.fromRGB(255, 255, 255);
                            v180.Material = Enum.Material.SmoothPlastic;
                            v180.MaterialVariant = "Strawberry Stud Light";
                            new_1:Add(function() --[[ Line: 695 ]]
                                -- upvalues: v180 (copy), MaterialVariant_4 (copy), Color_8 (copy)
                                v180.MaterialVariant = MaterialVariant_4;
                                v180.Color = Color_8;
                            end);
                        end;
                        if v180:HasTag("Strawberry2") then
                            v180.Color = Color3.fromRGB(193, 193, 193);
                            v180.Material = Enum.Material.SmoothPlastic;
                            v180.MaterialVariant = "Strawberry Stud Light";
                            new_1:Add(function() --[[ Line: 705 ]]
                                -- upvalues: v180 (copy), MaterialVariant_4 (copy), Color_8 (copy)
                                v180.MaterialVariant = MaterialVariant_4;
                                v180.Color = Color_8;
                            end);
                        end;
                        if v180:HasTag("Strawberry3") then
                            v180.Color = Color3.fromRGB(147, 147, 147);
                            v180.Material = Enum.Material.SmoothPlastic;
                            v180.MaterialVariant = "Strawberry Stud Light";
                            new_1:Add(function() --[[ Line: 715 ]]
                                -- upvalues: v180 (copy), MaterialVariant_4 (copy), Color_8 (copy)
                                v180.MaterialVariant = MaterialVariant_4;
                                v180.Color = Color_8;
                            end);
                        end;
                    end;
                end;
            end;
        end;
    end;
    return new_1:WrapClean();
end;
v20.GetAnimatedModel = function(Rebirth, v184, v185) --[[ Line: 727 ]] --[[ Name: GetAnimatedModel ]]
    -- upvalues: Animals_1 (copy), Animations (copy)
    local v184 = Animals_1:FindFirstChild(v184);
    if not v184 then
        warn((("Animal not found %* in model folder"):format(v184)));
        return nil;
    else
        local Clone = v184:Clone();
        if Clone.PrimaryPart then
            Clone.PrimaryPart.Anchored = true;
        end;
        Clone.Parent = workspace;
        local v184_1 = Animations:FindFirstChild(v184);
        local v185 = v184_1 and v184_1:FindFirstChild(v185);
        local AnimationController = Clone:FindFirstChild("AnimationController") or Instance.new("AnimationController", Clone);
        local Animator_2 = AnimationController:FindFirstChild("Animator") or Instance.new("Animator", AnimationController);
        if v185 and Animator_2 then
            local v189 = Animator_2:LoadAnimation(v185);
            v189.Looped = true;
            v189:Play();
        end;
        for Rebirth, v194 in Clone:GetDescendants() do
            if v194:IsA("BasePart") then
                v194.Massless = true;
                v194.CanCollide = false;
                v194.CanQuery = false;
                v194.CanTouch = false;
                v194.Anchored = false;
            end;
        end;
        return Clone;
    end;
end;
v20.AttachOnViewportWithOptimizations = function(Rebirth, v196, v197, Rebirth, v199, Rebirth) --[[ Line: 771 ]] --[[ Name: AttachOnViewportWithOptimizations ]]
    -- upvalues: Trove_1 (copy), Animals_1 (copy), v20 (copy), Observers (copy), Animations (copy), v55 (copy)
    local new_3 = Trove_1.new();
    local v196 = Animals_1:FindFirstChild(v196);
    if not v196 then
        warn((("Animal not found %* in model folder"):format(v196)));
        return new_3;
    else
        local l_l_Animals_1_FirstChild_1 = new_3:Clone(v196);
        local WorldModel = new_3:Add(Instance.new("WorldModel"));
        l_l_Animals_1_FirstChild_1.Parent = WorldModel;
        local true_5 = true;
        new_3:Add(function() --[[ Line: 785 ]]
            -- upvalues: true_5 (ref)
            true_5 = false;
        end);
        new_3:Add(v197.Destroying:Connect(function() --[[ Line: 789 ]]
            -- upvalues: new_3 (copy)
            new_3:Destroy();
        end));
        if v199 and v199 ~= "Default" then
            new_3:Add(v20:ApplyMutation(l_l_Animals_1_FirstChild_1, v196, v199));
        end;
        local function v206() --[[ Line: 797 ]] --[[ Name: unparent ]]
            -- upvalues: true_5 (ref), WorldModel (copy)
            if true_5 then
                WorldModel.Parent = nil;
            end;
        end;
        local function v217(v207) --[[ Line: 803 ]] --[[ Name: updateAncestry ]]
            -- upvalues: v206 (copy), Observers (ref), true_5 (ref), WorldModel (copy), v197 (copy), Animations (ref), v196 (copy), l_l_Animals_1_FirstChild_1 (copy)
            if not v207 then
                return v206;
            else
                local LayerCollector = v207:FindFirstAncestorWhichIsA("LayerCollector");
                if not LayerCollector then
                    return v206;
                else
                    local GuiObject = LayerCollector:FindFirstChildWhichIsA("GuiObject");
                    if not GuiObject then
                        return v206;
                    else
                        return Observers.observeProperty(LayerCollector, "Enabled", function(v210) --[[ Line: 818 ]]
                            -- upvalues: v206 (ref), Observers (ref), GuiObject (copy), true_5 (ref), WorldModel (ref), v197 (ref), Animations (ref), v196 (ref), l_l_Animals_1_FirstChild_1 (ref)
                            if not v210 then
                                return v206;
                            else
                                return Observers.observeProperty(GuiObject, "Visible", function(v211) --[[ Line: 823 ]]
                                    -- upvalues: v206 (ref), true_5 (ref), WorldModel (ref), v197 (ref), Animations (ref), v196 (ref), l_l_Animals_1_FirstChild_1 (ref)
                                    if not v211 then
                                        return v206;
                                    else
                                        if true_5 then
                                            WorldModel.Parent = v197;
                                        end;
                                        task.spawn(function() --[[ Line: 834 ]]
                                            -- upvalues: true_5 (ref), Animations (ref), v196 (ref), l_l_Animals_1_FirstChild_1 (ref)
                                            if not true_5 then
                                                return;
                                            else
                                                local v196_1 = Animations:FindFirstChild(v196);
                                                local Idle = v196_1 and v196_1:FindFirstChild("Idle");
                                                local AnimationController_1 = l_l_Animals_1_FirstChild_1:FindFirstChild("AnimationController") or Instance.new("AnimationController", l_l_Animals_1_FirstChild_1);
                                                local Animator_3 = AnimationController_1:FindFirstChild("Animator") or Instance.new("Animator", AnimationController_1);
                                                if Idle and Animator_3 then
                                                    local v213 = Animator_3:LoadAnimation(Idle);
                                                    v213.Looped = true;
                                                    v213:Play(0);
                                                end;
                                                return;
                                            end;
                                        end);
                                        return v206;
                                    end;
                                end);
                            end;
                        end);
                    end;
                end;
            end;
        end;
        local nil_1 = nil;
        local function Rebirth(v219) --[[ Line: 858 ]] --[[ Name: requestUpdateAncestry ]]
            -- upvalues: nil_1 (ref), v217 (copy)
            if type(nil_1) == "function" then
                nil_1();
            end;
            nil_1 = v217(v219);
        end;
        new_3:Add(v197.AncestryChanged:Connect(function(Rebirth, v222) --[[ Line: 866 ]]
            -- upvalues: nil_1 (ref), v217 (copy)
            if type(nil_1) == "function" then
                nil_1();
            end;
            nil_1 = v217(v222);
        end));
        if v197.Parent then
            local v197 = v197.Parent;
            if type(nil_1) == "function" then
                nil_1();
            end;
            nil_1 = v217(v197);
        end;
        local Camera = new_3:Add(Instance.new("Camera"));
        Camera.FieldOfView = 50;
        Camera.Parent = v197;
        v197.CurrentCamera = Camera;
        v55(Camera, v196, l_l_Animals_1_FirstChild_1, Camera.FieldOfView, 0.75, 0.7);
        return new_3, l_l_Animals_1_FirstChild_1;
    end;
end;
v20.AttachOnViewport = function(Rebirth, v226, v227, Rebirth, v229, Rebirth) --[[ Line: 885 ]] --[[ Name: AttachOnViewport ]]
    -- upvalues: v20 (copy), Trove_1 (copy), Animals_1 (copy), Animations (copy), v55 (copy)
    return v20:AttachOnViewportWithOptimizations(v226, v227, nil, v229);
end;
v20.GetListOfRarity = function(Rebirth, v232) --[[ Line: 962 ]] --[[ Name: GetListOfRarity ]]
    -- upvalues: Animals (copy)
    local v233 = {};
    for v234, v235 in Animals do
        if v235.Rarity == v232 then
            table.insert(v233, v234);
        end;
    end;
    return v233;
end;
v20.GetList = function(Rebirth, v237, v238) --[[ Line: 973 ]] --[[ Name: GetList ]]
    -- upvalues: Animals (copy), Rarities (copy)
    local v239 = {};
    for v240, v241 in Animals do
        if not v241.IsEnabled or v241.IsEnabled() then
            table.insert(v239, v240);
        end;
    end;
    if v237 == "Rarity" then
        table.sort(v239, function(v242, v243) --[[ Line: 984 ]]
            -- upvalues: Animals (ref), Rarities (ref), v238 (copy)
            local v244 = Animals[v242];
            local v245 = Animals[v243];
            local Rarity = v244 and v244.Rarity;
            local Rarity_1 = v245 and v245.Rarity;
            local or_1 = Rarity and Rarities[Rarity] and Rarities[Rarity].Weight or 0;
            local or_2 = Rarity_1 and Rarities[Rarity_1] and Rarities[Rarity_1].Weight or 0;
            if v238 then
                return or_1 < or_2;
            else
                return or_2 < or_1;
            end;
        end);
        return v239;
    elseif v237 == "Price" then
        table.sort(v239, function(v250, v251) --[[ Line: 1000 ]]
            -- upvalues: Animals (ref), v238 (copy)
            local v252 = Animals[v250];
            local v253 = Animals[v251];
            local or_3 = v252 and v252.Price or 0;
            local or_4 = v253 and v253.Price or 0;
            if v238 then
                return or_3 < or_4;
            else
                return or_4 < or_3;
            end;
        end);
        return v239;
    else
        if v237 == "Generation" then
            table.sort(v239, function(v256, v257) --[[ Line: 1013 ]]
                -- upvalues: Animals (ref), v238 (copy)
                local v258 = Animals[v256];
                local v259 = Animals[v257];
                local or_5 = v258 and v258.Generation or 0;
                local or_6 = v259 and v259.Generation or 0;
                if v238 then
                    return or_5 < or_6;
                else
                    return or_6 < or_5;
                end;
            end);
        end;
        return v239;
    end;
end;
v20.GetGeneration = function(Rebirth, v263, v264, v265, v266) --[[ Line: 1031 ]] --[[ Name: GetGeneration ]]
    -- upvalues: Animals (copy), Game (copy), Mutations (copy), Traits (copy), ReplicatedStorage (copy)
    local v267 = 0;
    local v268 = Animals[v263];
    if not v268 then
        return v267;
    else
        v267 = if v268.Generation then v267 + v268.Generation else v267 + v268.Price * Game.Game.AnimalGanerationModifier;
        local v269 = 1;
        if v264 then
            v269 = v269 + Mutations[v264].Modifier;
        end;
        local false_2 = false;
        if v265 then
            for Rebirth, v272 in v265 do
                local v273 = Traits[v272];
                if v273 then
                    if v272 == "Sleepy" then
                        false_2 = true;
                    else
                        v269 = v269 + v273.MultiplierModifier;
                    end;
                end;
            end;
        end;
        v267 = v267 * v269;
        if false_2 then
            v267 = v267 * 0.5;
        end;
        if v266 then
            v267 = v267 * require(ReplicatedStorage.Shared.Game):GetPlayerCashMultiplayer(v266);
        end;
        return (math.round(v267));
    end;
end;
v20.GetPrice = function(Rebirth, v275, Rebirth) --[[ Line: 1082 ]] --[[ Name: GetPrice ]]
    -- upvalues: Animals (copy)
    return Animals[v275].Price;
end;
v20.GetRarityStringFormat = function(Rebirth, v278) --[[ Line: 1089 ]] --[[ Name: GetRarityStringFormat ]]
    -- upvalues: Rarities (copy)
    local v279 = Rarities[v278];
    if v278 == "OG" then
        return "<og>%s</og>";
    elseif v278 == "Festive" then
        return "<greenred>%s</greenred>";
    elseif v278 == "Admin" or v278 == "Taco" or v278 == "Spooky" then
        return "<yellowred>%s</yellowred>";
    elseif v278 == "Secret" then
        return "<zebra>%s</zebra>";
    elseif v278 == "Brainrot God" then
        return "<rainbow>%s</rainbow>";
    elseif v279 then
        return (("<font color=\"#%*\">%%s</font>"):format((v279.Color:ToHex())));
    else
        return "%s";
    end;
end;
return v20;