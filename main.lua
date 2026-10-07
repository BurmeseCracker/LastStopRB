local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local CurrentCamera = Workspace.CurrentCamera

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local parentContainer = CoreGui

-- Clean existing UI & ESP
if CoreGui:FindFirstChild("LastStopHub") then CoreGui.LastStopHub:Destroy() end
if playerGui:FindFirstChild("LastStopHub") then playerGui.LastStopHub:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LastStopHub"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999999999
screenGui.Parent = parentContainer

--------------------------------------------------------------------------------
-- MAIN MENU FRAME (Optimized for Mobile Dragging & Sizing)
--------------------------------------------------------------------------------
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 240, 0, 380)
mainFrame.Position = UDim2.new(0.5, -120, 0.4, -190)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true -- Built-in mobile/PC dragging support
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(0.8, 0, 0, 30)
titleLabel.Position = UDim2.new(0.05, 0, 0, 5)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Last Stop v1 (Mobile Fix)"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 14
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = mainFrame

local exitButton = Instance.new("TextButton")
exitButton.Name = "ExitButton"
exitButton.Size = UDim2.new(0, 28, 0, 28)
exitButton.Position = UDim2.new(1, -33, 0, 5)
exitButton.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
exitButton.Text = "X"
exitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
exitButton.TextSize = 14
exitButton.Font = Enum.Font.SourceSansBold
exitButton.Parent = mainFrame

Instance.new("UICorner", exitButton).CornerRadius = UDim.new(0, 4)
exitButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Mobile Friendly UI Buttons
local tpButton = Instance.new("TextButton")
tpButton.Size = UDim2.new(0.9, 0, 0, 35)
tpButton.Position = UDim2.new(0.05, 0, 0.12, 0)
tpButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
tpButton.Text = "Teleport to Bus"
tpButton.TextColor3 = Color3.fromRGB(200, 200, 200)
tpButton.TextSize = 13
tpButton.Font = Enum.Font.SourceSansBold
tpButton.Parent = mainFrame
Instance.new("UICorner", tpButton).CornerRadius = UDim.new(0, 6)

local autoPickupBtn = Instance.new("TextButton")
autoPickupBtn.Size = UDim2.new(0.9, 0, 0, 35)
autoPickupBtn.Position = UDim2.new(0.05, 0, 0.30, 0)
autoPickupBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
autoPickupBtn.Text = "Auto PickUP: OFF"
autoPickupBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
autoPickupBtn.TextSize = 13
autoPickupBtn.Font = Enum.Font.SourceSansBold
autoPickupBtn.Parent = mainFrame
Instance.new("UICorner", autoPickupBtn).CornerRadius = UDim.new(0, 6)

local npcEspBtn = Instance.new("TextButton")
npcEspBtn.Size = UDim2.new(0.9, 0, 0, 35)
npcEspBtn.Position = UDim2.new(0.05, 0, 0.48, 0)
npcEspBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
npcEspBtn.Text = "Entities ESP: OFF"
npcEspBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
npcEspBtn.TextSize = 13
npcEspBtn.Font = Enum.Font.SourceSansBold
npcEspBtn.Parent = mainFrame
Instance.new("UICorner", npcEspBtn).CornerRadius = UDim.new(0, 6)

local tpBackBanditBtn = Instance.new("TextButton")
tpBackBanditBtn.Size = UDim2.new(0.9, 0, 0, 35)
tpBackBanditBtn.Position = UDim2.new(0.05, 0, 0.66, 0)
tpBackBanditBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
tpBackBanditBtn.Text = "Tp to Bandit"
tpBackBanditBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
tpBackBanditBtn.TextSize = 13
tpBackBanditBtn.Font =Enum.Font.SourceSansBold
tpBackBanditBtn.Parent = mainFrame
Instance.new("UICorner", tpBackBanditBtn).CornerRadius = UDim.new(0, 6)

local autoHitBtn = Instance.new("TextButton")
autoHitBtn.Size = UDim2.new(0.9, 0, 0, 35)
autoHitBtn.Position = UDim2.new(0.05, 0, 0.84, 0)
autoHitBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
autoHitBtn.Text = "Auto Hit: OFF"
autoHitBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
autoHitBtn.TextSize = 13
autoHitBtn.Font = Enum.Font.SourceSansBold
autoHitBtn.Parent = mainFrame
Instance.new("UICorner", autoHitBtn).CornerRadius = UDim.new(0, 6)

--------------------------------------------------------------------------------
-- SHARED UTILITIES
--------------------------------------------------------------------------------
local function getBusBase()
    return Workspace:FindFirstChild("ITEM_CONTAINER")
        and Workspace.ITEM_CONTAINER:FindFirstChild("Bus")
        and Workspace.ITEM_CONTAINER.Bus:FindFirstChild("Base")
end

local function teleportToBus()
    local busBase = getBusBase()
    if busBase and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local root = player.Character.HumanoidRootPart
        root.AssemblyLinearVelocity = Vector3.zero
        root.CFrame = busBase.CFrame * CFrame.new(0, 6, 0)
    end
end

tpButton.MouseButton1Click:Connect(teleportToBus)

--------------------------------------------------------------------------------
-- ENTITY UTILITIES
--------------------------------------------------------------------------------
local validEntities = {
    ["bandit"] = true,
    ["alien"] = true,
    ["bigzombie"] = true,
    ["bloater"] = true,
    ["mummy"] = true,
    ["parasite"] = true,
    ["shark"] = true,
    ["skeleton"] = true,
    ["tinyzombie"] = true,
    ["vampire"] = true,
    ["zombie"] = true,
}

local function getEntityMatchedName(entityFolder)
    local healthBar = entityFolder:FindFirstChild("HealthBar")
    if healthBar then
        local nameLabel = healthBar:FindFirstChild("EntityNameLabel")
        if nameLabel and nameLabel:IsA("TextLabel") then
            local textValue = string.lower(tostring(nameLabel.Text))
            local contentTextValue = string.lower(tostring(nameLabel.ContentText))
            local localizedTextValue = string.lower(tostring(nameLabel.LocalizedText))
            
            if validEntities[textValue] then return textValue
            elseif validEntities[contentTextValue] then return contentTextValue
            elseif validEntities[localizedTextValue] then return localizedTextValue
            end
        end
    end
    return nil
end

local function getParticleEmitterColor(entityFolder)
    for _, desc in ipairs(entityFolder:GetDescendants()) do
        if desc:IsA("ParticleEmitter") then
            local colorSeq = desc.Color
            if colorSeq and colorSeq.Keypoints and #colorSeq.Keypoints > 0 then
                return colorSeq.Keypoints[1].Value
            end
        end
    end
    return nil
end

--------------------------------------------------------------------------------
-- AUTO PICKUP MODULE
--------------------------------------------------------------------------------
local AutoPickupModule = {}
AutoPickupModule.Active = false
AutoPickupModule.PermanentlyIgnored = {}
AutoPickupModule.PrioritizedCategories = {"Valuable", "Resources", "Fuel", "Junk", "Weapon", "Medic", "Armor", "Ammo", "Food"}
AutoPickupModule.CategoryMaps = {}

local ignoredItemNames = {
    ["candle"] = true,
    ["empty can"] = true,
}

function AutoPickupModule.BuildCaches()
    AutoPickupModule.CategoryMaps = {}
    local success, categoriesFolder = pcall(function()
        return ReplicatedStorage.Assets.Mutual.Item.Category
    end)
    if not success or not categoriesFolder then return end

    for _, catName in ipairs(AutoPickupModule.PrioritizedCategories) do
        local catFolder = categoriesFolder:FindFirstChild(catName)
        if catFolder then
            local templateNames = {}
            local meshIds = {}
            for _, itemTemplate in ipairs(catFolder:GetChildren()) do
                templateNames[string.lower(itemTemplate.Name)] = true
                for _, desc in ipairs(itemTemplate:GetDescendants()) do
                    if (desc:IsA("MeshPart") or desc:IsA("SpecialMesh")) and desc.MeshId and desc.MeshId ~= "" then
                        meshIds[desc.MeshId] = true
                    end
                end
            end
            AutoPickupModule.CategoryMaps[catName] = {names = templateNames, meshes = meshIds}
        end
    end
end

function AutoPickupModule.GetCategory(itemFolder)
    if not next(AutoPickupModule.CategoryMaps) then
        AutoPickupModule.BuildCaches()
    end

    local itemName = string.lower(itemFolder.Name)
    for _, catName in ipairs(AutoPickupModule.PrioritizedCategories) do
        local data = AutoPickupModule.CategoryMaps[catName]
        if data then
            if data.names[itemName] then return catName end
            for _, desc in ipairs(itemFolder:GetDescendants()) do
                if (desc:IsA("MeshPart") or desc:IsA("SpecialMesh")) and desc.MeshId and data.meshes[desc.MeshId] then
                    return catName
                end
            end
        end
    end
    return nil
end

function AutoPickupModule.IsInsideChunk(itemPos)
    local chunksContainer = Workspace:FindFirstChild("CHUNKS_CONTAINER")
    if not chunksContainer then return true end

    local subAreaNames = {"PathPoints", "Area", "LootSpawnAreas", "SpawnAreas"}
    local maxDist = 80
    
    for _, chunkFolder in ipairs(chunksContainer:GetChildren()) do
        for _, name in ipairs(subAreaNames) do
            local subFolder = chunkFolder:FindFirstChild(name)
            if subFolder then
                for _, desc in ipairs(subFolder:GetDescendants()) do
                    if desc:IsA("BasePart") then
                        local dist = (itemPos - desc.Position).Magnitude
                        local boxSize = math.max(desc.Size.X, desc.Size.Y, desc.Size.Z) + maxDist
                        if dist <= boxSize then return true end
                    end
                end
            end
        end
    end
    return true
end

local function isNearAnySellArea(itemPos)
    local chunksContainer = Workspace:FindFirstChild("CHUNKS_CONTAINER")
    if not chunksContainer then return false end

    for _, chunk in ipairs(chunksContainer:GetChildren()) do
        for _, descendant in ipairs(chunk:GetDescendants()) do
            if descendant.Name == "SellArea" and descendant:IsA("BasePart") then
                if (itemPos - descendant.Position).Magnitude <= 100 then return true end
            end
        end
    end
    return false
end

function AutoPickupModule.Start()
    if AutoPickupModule.Active then return end
    AutoPickupModule.Active = true
    
    autoPickupBtn.Text = "Auto PickUP: ON"
    autoPickupBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 80)
    autoPickupBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

    task.spawn(function()
        AutoPickupModule.BuildCaches()
        local replicaInsertRE = ReplicatedStorage:FindFirstChild("ClientSource") and ReplicatedStorage.ClientSource:FindFirstChild("ReplicaRemoteEvents") and ReplicatedStorage.ClientSource.ReplicaRemoteEvents:FindFirstChild("Replica_ReplicaArrayInsert")
        local itemServiceRF = ReplicatedStorage:FindFirstChild("ClientSource") and ReplicatedStorage.ClientSource:FindFirstChild("Mutual") and ReplicatedStorage.ClientSource.Mutual:FindFirstChild("Packages") and ReplicatedStorage.ClientSource.Mutual.Packages:FindFirstChild("Knit") and ReplicatedStorage.ClientSource.Mutual.Packages.Knit:FindFirstChild("Services") and ReplicatedStorage.ClientSource.Mutual.Packages.Knit.Services:FindFirstChild("ItemService") and ReplicatedStorage.ClientSource.Mutual.Packages.Knit.Services.ItemService:FindFirstChild("RF")
        local equipItemRF = itemServiceRF and itemServiceRF:FindFirstChild("EquipItem")

        while AutoPickupModule.Active do
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local root = char.HumanoidRootPart
                local busBase = getBusBase()
                local itemContainer = Workspace:FindFirstChild("ITEM_CONTAINER")
                
                if itemContainer then
                    local children = itemContainer:GetChildren()
                    local sortedItems = {}
                    
                    for i = 1, #children do
                        local itemFolder = children[i]
                        local itemNameLower = string.lower(itemFolder.Name)
                        
                        if not ignoredItemNames[itemNameLower] and not AutoPickupModule.PermanentlyIgnored[itemFolder] then
                            local cat = AutoPickupModule.GetCategory(itemFolder)
                            if cat then
                                local targetPart = itemFolder:FindFirstChild("Main", true) or itemFolder:FindFirstChildOfClass("BasePart")
                                if targetPart and targetPart:IsA("BasePart") then
                                    local skipItem = false
                                    if busBase and (targetPart.Position - busBase.Position).Magnitude <= 20 then skipItem = true AutoPickupModule.PermanentlyIgnored[itemFolder] = true end
                                    if not skipItem and isNearAnySellArea(targetPart.Position) then skipItem = true AutoPickupModule.PermanentlyIgnored[itemFolder] = true end
                                    if not skipItem and not AutoPickupModule.IsInsideChunk(targetPart.Position) then skipItem = true AutoPickupModule.PermanentlyIgnored[itemFolder] = true end
                                    
                                    if not skipItem then
                                        table.insert(sortedItems, {folder = itemFolder, part = targetPart, cat = cat})
                                    end
                                end
                            end
                        end
                    end

                    table.sort(sortedItems, function(a, b)
                        local priorityA, priorityB = 99, 99
                        for idx, cName in ipairs(AutoPickupModule.PrioritizedCategories) do
                            if a.cat == cName then priorityA = idx end
                            if b.cat == cName then priorityB = idx end
                        end
                        return priorityA < priorityB
                    end)

                    for _, data in ipairs(sortedItems) do
                        if not AutoPickupModule.Active then break end
                        AutoPickupModule.PermanentlyIgnored[data.folder] = true
                        root.AssemblyLinearVelocity = Vector3.zero
                        root.CFrame = data.part.CFrame * CFrame.new(0, 2, 0)
                        task.wait(0.5)

                        if replicaInsertRE then task.spawn(function() replicaInsertRE:FireServer(data.folder) end) end
                        if equipItemRF then task.spawn(function() equipItemRF:InvokeServer(data.folder) end) end
                    end
                end
            end
            task.wait(1)
        end
    end)
end

function AutoPickupModule.Stop()
    AutoPickupModule.Active = false
    autoPickupBtn.Text = "Auto PickUP: OFF"
    autoPickupBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    autoPickupBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    teleportToBus()
end

autoPickupBtn.MouseButton1Click:Connect(function()
    if AutoPickupModule.Active then AutoPickupModule.Stop() else AutoPickupModule.Start() end
end)

--------------------------------------------------------------------------------
-- ENTITIES ESP MODULE
--------------------------------------------------------------------------------
local npcEspActive = false
local npcESPTracked = {}

local function removeNpcESP()
    for _, highlight in pairs(npcESPTracked) do
        if highlight then highlight:Destroy() end
    end
    table.clear(npcESPTracked)
end

local function startNpcEspLoop()
    task.spawn(function()
        while npcEspActive do
            local currentActiveNpcs = {}
            local entityContainer = Workspace:FindFirstChild("ENTITY_CONTAINER")
            
            if entityContainer then
                local children = entityContainer:GetChildren()
                for i = 1, #children do
                    local entityFolder = children[i]
                    if not npcEspActive then break end
                    local matchedName = getEntityMatchedName(entityFolder)

                    if matchedName then
                        currentActiveNpcs[entityFolder] = true
                        local espColor = getParticleEmitterColor(entityFolder) or Color3.fromRGB(255, 40, 40)

                        if not npcESPTracked[entityFolder] then
                            local highlight = Instance.new("Highlight")
                            highlight.Name = "EntityCustomESP"
                            highlight.Adornee = entityFolder
                            highlight.FillColor = espColor
                            highlight.FillTransparency = 0.4
                            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                            highlight.OutlineTransparency = 0
                            highlight.Parent = entityFolder
                            npcESPTracked[entityFolder] = highlight
                        else
                            npcESPTracked[entityFolder].FillColor = espColor
                        end
                    end
                end
            end

            for targetObj, highlight in pairs(npcESPTracked) do
                if not currentActiveNpcs[targetObj] or not targetObj.Parent then
                    if highlight then highlight:Destroy() end
                    npcESPTracked[targetObj] = nil
                end
            end
            task.wait(0.5)
        end
        removeNpcESP()
    end)
end

npcEspBtn.MouseButton1Click:Connect(function()
    npcEspActive = not npcEspActive
    if npcEspActive then
        npcEspBtn.Text = "Entities ESP: ON"
        npcEspBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 80)
        npcEspBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        startNpcEspLoop()
    else
        npcEspBtn.Text = "Entities ESP: OFF"
        npcEspBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        npcEspBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        removeNpcESP()
    end
end)

--------------------------------------------------------------------------------
-- TELEPORT TO BANDIT MODULE
--------------------------------------------------------------------------------
local function teleportToBandit()
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local entityContainer = Workspace:FindFirstChild("ENTITY_CONTAINER")

    if root and entityContainer then
        local nearestBanditPart = nil
        local shortestDist = math.huge

        for _, entityFolder in ipairs(entityContainer:GetChildren()) do
            local matchedName = getEntityMatchedName(entityFolder)
            if matchedName == "bandit" then
                local humanoid = entityFolder:FindFirstChildOfClass("Humanoid")
                local targetPart = entityFolder:FindFirstChild("HumanoidRootPart") or entityFolder:FindFirstChild("Torso")
                if humanoid and targetPart and humanoid.Health > 0 then
                    local dist = (root.Position - targetPart.Position).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        nearestBanditPart = targetPart
                    end
                end
            end
        end

        if nearestBanditPart then
            root.AssemblyLinearVelocity = Vector3.zero
            root.CFrame = nearestBanditPart.CFrame * CFrame.new(0, -3, 0)
        end
    end
end

tpBackBanditBtn.MouseButton1Click:Connect(teleportToBandit)

--------------------------------------------------------------------------------
-- AUTO HIT MODULE (Mobile Safe Remotes)
--------------------------------------------------------------------------------
local clientSource = ReplicatedStorage:FindFirstChild("ClientSource")
local replicaSignal = clientSource 
    and clientSource:FindFirstChild("ReplicaRemoteEvents") 
    and clientSource.ReplicaRemoteEvents:FindFirstChild("Replica_ReplicaSignal")

local remotes = {
    replicaSignal,
    clientSource and clientSource.Mutual.Packages.Knit.Services.DamageService.RE.DamageDealt,
    clientSource and clientSource.Mutual.Packages.Knit.Services.ItemService.RF.EquipItem,
}

local autoHitEnabled = false
local attackOrderTicker = 1
local lastHitTick = 0

local function findNearbyTarget(character)
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return nil end
    
    local entityContainer = Workspace:FindFirstChild("ENTITY_CONTAINER")
    if entityContainer then
        for _, obj in ipairs(entityContainer:GetChildren()) do
            local humanoid = obj:FindFirstChildOfClass("Humanoid")
            local targetRoot = obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart
            if humanoid and humanoid.Health > 0 and targetRoot then
                if (targetRoot.Position - rootPart.Position).Magnitude <= 18 then
                    return targetRoot
                end
            end
        end
    end
    return nil
end

autoHitBtn.MouseButton1Click:Connect(function()
    autoHitEnabled = not autoHitEnabled
    if autoHitEnabled then
        autoHitBtn.Text = "Auto Hit: ON"
        autoHitBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 80)
        autoHitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        autoHitBtn.Text = "Auto Hit: OFF"
        autoHitBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        autoHitBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end)

RunService.Heartbeat:Connect(function()
    if autoHitEnabled and (tick() - lastHitTick >= 0.1) then
        lastHitTick = tick()
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local lookVector = CurrentCamera.CFrame.LookVector
            local targetPart = findNearbyTarget(character)
            local hitPos = targetPart and targetPart.Position or (character.HumanoidRootPart.Position + (lookVector * 5))
            local hitTarget = targetPart or character.HumanoidRootPart
            
            task.spawn(function()
                pcall(function()
                    for _, remote in ipairs(remotes) do
                        if remote then
                            pcall(function()
                                if remote:IsA("RemoteEvent") then
                                    remote:FireServer("Melee", "Attack", lookVector, attackOrderTicker)
                                    remote:FireServer("Melee", "Hit", hitTarget, hitPos, Vector3.new(0, 1, 0), Enum.Material.SmoothPlastic)
                                elseif remote:IsA("RemoteFunction") then
                                    remote:InvokeServer("Melee", "Attack", lookVector, attackOrderTicker)
                                end
                            end)
                        end
                    end
                    attackOrderTicker = (attackOrderTicker % 3) + 1
                end)
            end)
        end
    end
end)
