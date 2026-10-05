local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

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
-- MAIN MENU FRAME
--------------------------------------------------------------------------------
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 220, 0, 400)
mainFrame.Position = UDim2.new(0.35, -110, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

local function enableDrag(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end
enableDrag(mainFrame)

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(0.8, 0, 0, 30)
titleLabel.Position = UDim2.new(0.05, 0, 0, 5)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Last Stop v1"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 14
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = mainFrame

local exitButton = Instance.new("TextButton")
exitButton.Name = "ExitButton"
exitButton.Size = UDim2.new(0, 24, 0, 24)
exitButton.Position = UDim2.new(1, -29, 0, 5)
exitButton.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
exitButton.Text = "X"
exitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
exitButton.TextSize = 14
exitButton.Font = Enum.Font.SourceSansBold
exitButton.Parent = mainFrame

local exitCorner = Instance.new("UICorner")
exitCorner.CornerRadius = UDim.new(0, 4)
exitCorner.Parent = exitButton

-- UI Buttons
local tpButton = Instance.new("TextButton")
tpButton.Size = UDim2.new(0.9, 0, 0, 30)
tpButton.Position = UDim2.new(0.05, 0, 0.10, 0)
tpButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
tpButton.Text = "Teleport to Bus [F1]: OFF"
tpButton.TextColor3 = Color3.fromRGB(200, 200, 200)
tpButton.TextSize = 12
tpButton.Font = Enum.Font.SourceSansBold
tpButton.Parent = mainFrame
Instance.new("UICorner", tpButton).CornerRadius = UDim.new(0, 6)

local autoPickupBtn = Instance.new("TextButton")
autoPickupBtn.Size = UDim2.new(0.9, 0, 0, 30)
autoPickupBtn.Position = UDim2.new(0.05, 0, 0.24, 0)
autoPickupBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
autoPickupBtn.Text = "Auto PickUP [F3]: OFF"
autoPickupBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
autoPickupBtn.TextSize = 12
autoPickupBtn.Font = Enum.Font.SourceSansBold
autoPickupBtn.Parent = mainFrame
Instance.new("UICorner", autoPickupBtn).CornerRadius = UDim.new(0, 6)

local npcEspBtn = Instance.new("TextButton")
npcEspBtn.Size = UDim2.new(0.9, 0, 0, 30)
npcEspBtn.Position = UDim2.new(0.05, 0, 0.38, 0)
npcEspBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
npcEspBtn.Text = "Entities ESP [F4]: OFF"
npcEspBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
npcEspBtn.TextSize = 12
npcEspBtn.Font = Enum.Font.SourceSansBold
npcEspBtn.Parent = mainFrame
Instance.new("UICorner", npcEspBtn).CornerRadius = UDim.new(0, 6)

local tpBackBanditBtn = Instance.new("TextButton")
tpBackBanditBtn.Size = UDim2.new(0.9, 0, 0, 30)
tpBackBanditBtn.Position = UDim2.new(0.05, 0, 0.52, 0)
tpBackBanditBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
tpBackBanditBtn.Text = "Tp Back Bandit [F5]: OFF"
tpBackBanditBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
tpBackBanditBtn.TextSize = 12
tpBackBanditBtn.Font = Enum.Font.SourceSansBold
tpBackBanditBtn.Parent = mainFrame
Instance.new("UICorner", tpBackBanditBtn).CornerRadius = UDim.new(0, 6)

local chestStoreBtn = Instance.new("TextButton")
chestStoreBtn.Size = UDim2.new(0.9, 0, 0, 30)
chestStoreBtn.Position = UDim2.new(0.05, 0, 0.66, 0)
chestStoreBtn.BackgroundColor3 = Color3.fromRGB(60, 40, 120)
chestStoreBtn.Text = "Chest Store [F6]"
chestStoreBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
chestStoreBtn.TextSize = 12
chestStoreBtn.Font = Enum.Font.SourceSansBold
chestStoreBtn.Parent = mainFrame
Instance.new("UICorner", chestStoreBtn).CornerRadius = UDim.new(0, 6)

local autoStoreBtn = Instance.new("TextButton")
autoStoreBtn.Size = UDim2.new(0.9, 0, 0, 30)
autoStoreBtn.Position = UDim2.new(0.05, 0, 0.80, 0)
autoStoreBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
autoStoreBtn.Text = "Auto Store [F7]: OFF"
autoStoreBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
autoStoreBtn.TextSize = 12
autoStoreBtn.Font = Enum.Font.SourceSansBold
autoStoreBtn.Parent = mainFrame
Instance.new("UICorner", autoStoreBtn).CornerRadius = UDim.new(0, 6)

--------------------------------------------------------------------------------
-- SHARED UTILITIES (Bus checking)
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

--------------------------------------------------------------------------------
-- ENTITY UTILITIES (ESP & Teleport Back Bandit helpers)
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
-- SEPARATED SYSTEM 1: AUTO PICKUP MODULE
--------------------------------------------------------------------------------
local AutoPickupModule = {}
AutoPickupModule.Active = false
AutoPickupModule.PermanentlyIgnored = {}
AutoPickupModule.PrioritizedCategories = {"Valuable", "Resources", "Fuel", "Junk", "Weapon", "Medic", "Armor", "Ammo", "Food"}
AutoPickupModule.CategoryMaps = {}

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
        for _, chunkNode in ipairs(chunkFolder:GetChildren()) do
            for _, name in ipairs(subAreaNames) do
                local subFolder = chunkNode:FindFirstChild(name)
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
    end
    return true
end

-- Checks if an item position is within 100 studs of ANY SellArea across all chunks
local function isNearAnySellArea(itemPos)
    local chunksContainer = Workspace:FindFirstChild("CHUNKS_CONTAINER")
    if not chunksContainer then return false end

    for _, chunk in ipairs(chunksContainer:GetChildren()) do
        for _, descendant in ipairs(chunk:GetDescendants()) do
            if descendant.Name == "SellArea" and descendant:IsA("BasePart") then
                if (itemPos - descendant.Position).Magnitude <= 100 then
                    return true
                end
            end
        end
    end
    return false
end

function AutoPickupModule.Start()
    if AutoPickupModule.Active then return end
    AutoPickupModule.Active = true
    
    autoPickupBtn.Text = "Auto PickUP [F3]: ON"
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
                        
                        if not AutoPickupModule.PermanentlyIgnored[itemFolder] then
                            local cat = AutoPickupModule.GetCategory(itemFolder)
                            if cat then
                                local targetPart = itemFolder:FindFirstChild("Main", true) or itemFolder:FindFirstChildOfClass("BasePart")
                                if targetPart and targetPart:IsA("BasePart") then
                                    local skipItem = false
                                    
                                    -- Check if item is near bus
                                    if busBase and (targetPart.Position - busBase.Position).Magnitude <= 20 then
                                        skipItem = true
                                        AutoPickupModule.PermanentlyIgnored[itemFolder] = true
                                    end
                                    
                                    -- Check if item is near ANY SellArea within 100 studs
                                    if not skipItem and isNearAnySellArea(targetPart.Position) then
                                        skipItem = true
                                        AutoPickupModule.PermanentlyIgnored[itemFolder] = true
                                    end
                                    
                                    if not skipItem and not AutoPickupModule.IsInsideChunk(targetPart.Position) then
                                        skipItem = true
                                        AutoPickupModule.PermanentlyIgnored[itemFolder] = true
                                    end
                                    
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
                        task.wait(1)

                        if replicaInsertRE then task.spawn(function() replicaInsertRE:FireServer(data.folder) end) end
                        if equipItemRF then task.spawn(function() equipItemRF:InvokeServer(data.folder) end) end
                    end
                end
            end

            teleportToBus()
            task.wait(2.5)
        end
    end)
end

function AutoPickupModule.Stop()
    AutoPickupModule.Active = false
    autoPickupBtn.Text = "Auto PickUP [F3]: OFF"
    autoPickupBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    autoPickupBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
end

autoPickupBtn.MouseButton1Click:Connect(function()
    if AutoPickupModule.Active then AutoPickupModule.Stop() else AutoPickupModule.Start() end
end)


--------------------------------------------------------------------------------
-- SEPARATED SYSTEM 2: AUTO STORE MODULE
--------------------------------------------------------------------------------
local InventoryController = {
    AutoStoreRunning = false,
    AutoStoreSlots = {},
    Grid = nil,
}

local StoreItemRemote = ReplicatedStorage:WaitForChild("ClientSource")
    :WaitForChild("Mutual")
    :WaitForChild("Packages")
    :WaitForChild("Knit")
    :WaitForChild("Services")
    :WaitForChild("ItemService")
    :WaitForChild("RF")
    :WaitForChild("StoreItem")

local function UpdateAutoStoreUI()
    if InventoryController.AutoStoreRunning then
        autoStoreBtn.Text = "Auto Store [F7]: ON"
        autoStoreBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 80)
        autoStoreBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        autoStoreBtn.Text = "Auto Store [F7]: OFF"
        autoStoreBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        autoStoreBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end

function InventoryController.StartAutoStore()
    if InventoryController.AutoStoreRunning then return end
    InventoryController.AutoStoreRunning = true
    UpdateAutoStoreUI()

    task.spawn(function()
        while InventoryController.AutoStoreRunning do
            local targetSlot = nil
            if InventoryController.Grid and InventoryController.Grid.GetSlots then
                InventoryController.AutoStoreSlots = InventoryController.Grid:GetSlots()
            end

            for _, slot in ipairs(InventoryController.AutoStoreSlots) do
                if not InventoryController.AutoStoreRunning then break end
                if slot and slot:GetAttribute("HasItem") then
                    targetSlot = slot
                    break
                end
            end

            if not targetSlot then
                InventoryController.StopAutoStore()
                break
            end

            local itemUUID = targetSlot:GetAttribute("ItemUUID") or targetSlot.Name
            local success, response = pcall(function()
                return StoreItemRemote:InvokeServer(itemUUID)
            end)

            if success and response then
                targetSlot:SetAttribute("HasItem", false)
            else
                task.wait(1)
            end

            task.wait(0.3)
        end
        InventoryController.AutoStoreRunning = false
        UpdateAutoStoreUI()
    end)
end

function InventoryController.StopAutoStore()
    InventoryController.AutoStoreRunning = false
    UpdateAutoStoreUI()
end

autoStoreBtn.MouseButton1Click:Connect(function()
    if InventoryController.AutoStoreRunning then InventoryController.StopAutoStore() else InventoryController.StartAutoStore() end
end)


--------------------------------------------------------------------------------
-- ENTITIES ESP SYSTEM [F4]
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
                        local espColor = getParticleEmitterColor(entityFolder)
                        
                        if not espColor then
                            local lowerFolderString = string.lower(entityFolder.Name .. tostring(entityFolder:GetFullName()))
                            
                            if matchedName == "bandit" then
                                espColor = Color3.fromRGB(255, 40, 40)
                            elseif matchedName == "shark" then
                                espColor = Color3.fromRGB(0, 255, 255)
                            elseif matchedName == "vampire" or string.find(lowerFolderString, "vampire") then
                                espColor = Color3.fromRGB(170, 0, 255)
                            elseif string.find(lowerFolderString, "radioactive") or string.find(lowerFolderString, "acidcough") then
                                espColor = Color3.fromRGB(40, 255, 40)
                            elseif string.find(lowerFolderString, "flame") then
                                espColor = Color3.fromRGB(255, 140, 0)
                            elseif string.find(lowerFolderString, "stalker") or string.find(lowerFolderString, "frost") or string.find(lowerFolderString, "parasitic") then
                                espColor = Color3.fromRGB(170, 0, 255)
                            else
                                espColor = Color3.fromRGB(100, 110, 60)
                            end
                        end

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

local function toggleNpcEsp()
    npcEspActive = not npcEspActive
    if npcEspActive then
        npcEspBtn.Text = "Entities ESP [F4]: ON"
        npcEspBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 80)
        npcEspBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        startNpcEspLoop()
    else
        npcEspBtn.Text = "Entities ESP [F4]: OFF"
        npcEspBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        npcEspBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        removeNpcESP()
    end
end
npcEspBtn.MouseButton1Click:Connect(toggleNpcEsp)


--------------------------------------------------------------------------------
-- TELEPORT BACK BANDIT SYSTEM [F5]
--------------------------------------------------------------------------------
local tpBackBanditActive = false

local function toggleTpBackBandit()
    tpBackBanditActive = not tpBackBanditActive
    if tpBackBanditActive then
        tpBackBanditBtn.Text = "Tp Back Bandit [F5]: ON"
        tpBackBanditBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 80)
        tpBackBanditBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        
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
    else
        tpBackBanditBtn.Text = "Tp Back Bandit [F5]: OFF"
        tpBackBanditBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        tpBackBanditBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        
        teleportToBus()
    end
end
tpBackBanditBtn.MouseButton1Click:Connect(toggleTpBackBandit)


--------------------------------------------------------------------------------
-- OTHER FEATURES (Teleport, Chest Store, Hotkeys)
--------------------------------------------------------------------------------
local tpToggle = false
tpButton.MouseButton1Click:Connect(function()
    tpToggle = not tpToggle
    if tpToggle then
        tpButton.Text = "Teleport to Bus [F1]: ON"
        tpButton.BackgroundColor3 = Color3.fromRGB(0, 170, 80)
        tpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        teleportToBus()
    else
        tpButton.Text = "Teleport to Bus [F1]: OFF"
        tpButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        tpButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end)

local function runChestStore()
    local success, itemServiceStoreRF = pcall(function()
        return ReplicatedStorage.ClientSource.Mutual.Packages.Knit.Services.ItemService.RF.StoreItem
    end)
    local targetChest = nil
    local itemContainer = Workspace:FindFirstChild("ITEM_CONTAINER")
    if itemContainer then
        local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        local shortest = math.huge
        for _, child in ipairs(itemContainer:GetChildren()) do
            local chestPart = child:FindFirstChild("Chest") or (child.Name == "Chest" and child)
            if chestPart and root then
                local dist = (root.Position - chestPart.Position).Magnitude
                if dist < shortest then shortest = dist targetChest = child end
            end
        end
    end
    if success and itemServiceStoreRF and targetChest then
        pcall(function() itemServiceStoreRF:InvokeServer(targetChest) end)
    end
end
chestStoreBtn.MouseButton1Click:Connect(runChestStore)

-- Hotkey Listeners
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F1 then
        tpButton.MouseButton1Click:Fire()
    elseif input.KeyCode == Enum.KeyCode.F3 then
        if AutoPickupModule.Active then AutoPickupModule.Stop() else AutoPickupModule.Start() end
    elseif input.KeyCode == Enum.KeyCode.F4 then
        toggleNpcEsp()
    elseif input.KeyCode == Enum.KeyCode.F5 then
        toggleTpBackBandit()
    elseif input.KeyCode == Enum.KeyCode.F6 then
        runChestStore()
    elseif input.KeyCode == Enum.KeyCode.F7 then
        local isCtrlPressed = UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl)
        if isCtrlPressed then
            InventoryController.StopAutoStore()
        else
            if InventoryController.AutoStoreRunning then InventoryController.StopAutoStore() else InventoryController.StartAutoStore() end
        end
    end
end)

exitButton.MouseButton1Click:Connect(function()
    AutoPickupModule.Stop()
    InventoryController.StopAutoStore()
    if npcEspActive then toggleNpcEsp() end
    screenGui:Destroy()
end)
