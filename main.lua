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
mainFrame.Size = UDim2.new(0, 220, 0, 260)
mainFrame.Position = UDim2.new(0.35, -110, 0.5, -130)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- Simple Drag Function
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

-- Toggle 1: Teleport to Bus [F1]
local tpButton = Instance.new("TextButton")
tpButton.Name = "TpButton"
tpButton.Size = UDim2.new(0.9, 0, 0, 35)
tpButton.Position = UDim2.new(0.05, 0, 0.16, 0)
tpButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
tpButton.Text = "Teleport to Bus [F1]: OFF"
tpButton.TextColor3 = Color3.fromRGB(200, 200, 200)
tpButton.TextSize = 12
tpButton.Font = Enum.Font.SourceSansBold
tpButton.Parent = mainFrame

local tpCorner = Instance.new("UICorner")
tpCorner.CornerRadius = UDim.new(0, 6)
tpCorner.Parent = tpButton

-- Toggle 2: Auto PickUP [F3]
local autoPickupBtn = Instance.new("TextButton")
autoPickupBtn.Name = "AutoPickupBtn"
autoPickupBtn.Size = UDim2.new(0.9, 0, 0, 35)
autoPickupBtn.Position = UDim2.new(0.05, 0, 0.38, 0)
autoPickupBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
autoPickupBtn.Text = "Auto PickUP [F3]: OFF"
autoPickupBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
autoPickupBtn.TextSize = 12
autoPickupBtn.Font = Enum.Font.SourceSansBold
autoPickupBtn.Parent = mainFrame

local pickupCorner = Instance.new("UICorner")
pickupCorner.CornerRadius = UDim.new(0, 6)
pickupCorner.Parent = autoPickupBtn

-- Toggle 3: Entities ESP [F4]
local npcEspBtn = Instance.new("TextButton")
npcEspBtn.Name = "NpcEspBtn"
npcEspBtn.Size = UDim2.new(0.9, 0, 0, 35)
npcEspBtn.Position = UDim2.new(0.05, 0, 0.60, 0)
npcEspBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
npcEspBtn.Text = "Entities ESP [F4]: OFF"
npcEspBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
npcEspBtn.TextSize = 12
npcEspBtn.Font = Enum.Font.SourceSansBold
npcEspBtn.Parent = mainFrame

local npcCorner = Instance.new("UICorner")
npcCorner.CornerRadius = UDim.new(0, 6)
npcCorner.Parent = npcEspBtn

--------------------------------------------------------------------------------
-- LOGIC & SYSTEMS
--------------------------------------------------------------------------------
local function getBusBase()
    return Workspace:FindFirstChild("ITEM_CONTAINER")
        and Workspace.ITEM_CONTAINER:FindFirstChild("Bus")
        and Workspace.ITEM_CONTAINER.Bus:FindFirstChild("Base")
end

local tpToggle = false
local function toggleTeleport()
    tpToggle = not tpToggle
    if tpToggle then
        tpButton.Text = "Teleport to Bus [F1]: ON"
        tpButton.BackgroundColor3 = Color3.fromRGB(0, 170, 80)
        tpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        local busBase = getBusBase()
        if busBase and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
            player.Character.HumanoidRootPart.CFrame = busBase.CFrame * CFrame.new(0, 3, 0)
        end
    else
        tpButton.Text = "Teleport to Bus [F1]: OFF"
        tpButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        tpButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end
tpButton.MouseButton1Click:Connect(toggleTeleport)

-- Priority-based Category Caching
local prioritizedCategories = {"Valuable", "Resources", "Fuel", "Junk", "Junks", "Weapon", "Medic", "Armor", "Ammo", "Food"}
local categoryMaps = {}

local function buildCategoryCaches()
    categoryMaps = {}
    local success, categoriesFolder = pcall(function()
        return ReplicatedStorage.Assets.Mutual.Item.Category
    end)
    if not success or not categoriesFolder then return end

    for _, catName in ipairs(prioritizedCategories) do
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
            categoryMaps[catName] = {names = templateNames, meshes = meshIds}
        end
    end
end

local function getItemCategory(itemFolder)
    if not next(categoryMaps) then
        buildCategoryCaches()
    end

    local itemName = string.lower(itemFolder.Name)
    for _, catName in ipairs(prioritizedCategories) do
        local data = categoryMaps[catName]
        if data then
            if data.names[itemName] then
                return catName
            end
            for _, desc in ipairs(itemFolder:GetDescendants()) do
                if (desc:IsA("MeshPart") or desc:IsA("SpecialMesh")) and desc.MeshId and data.meshes[desc.MeshId] then
                    return catName
                end
            end
        end
    end
    return nil
end

-- Ultra-Fast Prioritized Auto PickUp Loop (100 Studs Range)
local autoPickupActive = false
local processedItems = {}

local function startAutoPickupLoop()
    task.spawn(function()
        buildCategoryCaches()
        local replicaInsertRE = ReplicatedStorage:FindFirstChild("ClientSource") and ReplicatedStorage.ClientSource:FindFirstChild("ReplicaRemoteEvents") and ReplicatedStorage.ClientSource.ReplicaRemoteEvents:FindFirstChild("Replica_ReplicaArrayInsert")
        local equipItemRF = ReplicatedStorage:FindFirstChild("ClientSource") and ReplicatedStorage.ClientSource:FindFirstChild("Mutual") and ReplicatedStorage.ClientSource.Mutual:FindFirstChild("Packages") and ReplicatedStorage.ClientSource.Mutual.Packages:FindFirstChild("Knit") and ReplicatedStorage.ClientSource.Mutual.Packages.Knit:FindFirstChild("Services") and ReplicatedStorage.ClientSource.Mutual.Packages.Knit.Services:FindFirstChild("ItemService") and ReplicatedStorage.ClientSource.Mutual.Packages.Knit.Services.ItemService:FindFirstChild("RF") and ReplicatedStorage.ClientSource.Mutual.Packages.Knit.Services.ItemService.RF:FindFirstChild("EquipItem")

        while autoPickupActive do
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local root = char.HumanoidRootPart
                local itemContainer = Workspace:FindFirstChild("ITEM_CONTAINER")
                if itemContainer then
                    local children = itemContainer:GetChildren()
                    
                    local sortedItems = {}
                    for i = 1, #children do
                        local itemFolder = children[i]
                        if not processedItems[itemFolder] then
                            local cat = getItemCategory(itemFolder)
                            if cat then
                                local targetPart = itemFolder:FindFirstChild("Main", true) or itemFolder:FindFirstChildOfClass("BasePart")
                                if targetPart and targetPart:IsA("BasePart") then
                                    if (root.Position - targetPart.Position).Magnitude <= 100 then
                                        table.insert(sortedItems, {folder = itemFolder, part = targetPart, cat = cat})
                                    end
                                end
                            end
                        end
                    end

                    table.sort(sortedItems, function(a, b)
                        local priorityA, priorityB = 99, 99
                        for idx, cName in ipairs(prioritizedCategories) do
                            if a.cat == cName then priorityA = idx end
                            if b.cat == cName then priorityB = idx end
                        end
                        return priorityA < priorityB
                    end)

                    for _, data in ipairs(sortedItems) do
                        if not autoPickupActive then break end
                        local itemFolder = data.folder
                        processedItems[itemFolder] = true
                        if replicaInsertRE then task.spawn(function() replicaInsertRE:FireServer(itemFolder) end) end
                        if equipItemRF then task.spawn(function() equipItemRF:InvokeServer(itemFolder) end) end
                    end
                end
            end

            table.clear(processedItems)
            task.wait(0.03)
        end
    end)
end

local function toggleAutoPickup()
    autoPickupActive = not autoPickupActive
    if autoPickupActive then
        autoPickupBtn.Text = "Auto PickUP [F3]: ON"
        autoPickupBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 80)
        autoPickupBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        startAutoPickupLoop()
    else
        autoPickupBtn.Text = "Auto PickUP [F3]: OFF"
        autoPickupBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        autoPickupBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        table.clear(processedItems)
    end
end
autoPickupBtn.MouseButton1Click:Connect(toggleAutoPickup)

-- Allowed Entity Names List
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

-- Entities ESP System with ParticleEmitter Color Auto-Detection
local npcEspActive = false
local npcESPTracked = {}

local function removeNpcESP()
    for _, highlight in pairs(npcESPTracked) do
        if highlight then highlight:Destroy() end
    end
    table.clear(npcESPTracked)
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
                    
                    local matchedName = nil
                    local healthBar = entityFolder:FindFirstChild("HealthBar")
                    if healthBar then
                        local nameLabel = healthBar:FindFirstChild("EntityNameLabel")
                        if nameLabel and nameLabel:IsA("TextLabel") then
                            local textValue = string.lower(tostring(nameLabel.Text))
                            local contentTextValue = string.lower(tostring(nameLabel.ContentText))
                            local localizedTextValue = string.lower(tostring(nameLabel.LocalizedText))
                            
                            if validEntities[textValue] then matchedName = textValue
                            elseif validEntities[contentTextValue] then matchedName = contentTextValue
                            elseif validEntities[localizedTextValue] then matchedName = localizedTextValue
                            end
                        end
                    end

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

-- Keybind Listener
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F1 then
        toggleTeleport()
    elseif input.KeyCode == Enum.KeyCode.F3 then
        toggleAutoPickup()
    elseif input.KeyCode == Enum.KeyCode.F4 then
        toggleNpcEsp()
    end
end)

exitButton.MouseButton1Click:Connect(function()
    autoPickupActive = false
    npcEspActive = false
    removeNpcESP()
    screenGui:Destroy()
end)
