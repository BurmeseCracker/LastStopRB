local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Clean existing UI & ESP
if CoreGui:FindFirstChild("LastStopHub") then CoreGui.LastStopHub:Destroy() end
if playerGui:FindFirstChild("LastStopHub") then playerGui.LastStopHub:Destroy() end

local parentContainer = playerGui

-- ScreenGui Setup
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
mainFrame.Size = UDim2.new(0, 220, 0, 160)
mainFrame.Position = UDim2.new(0.35, -110, 0.5, -80)
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
titleLabel.Text = "Last Stop v1 (No Junk)"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 16
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

-- Main Toggle 1: Teleport to Bus
local tpButton = Instance.new("TextButton")
tpButton.Name = "TpButton"
tpButton.Size = UDim2.new(0.9, 0, 0, 45)
tpButton.Position = UDim2.new(0.05, 0, 0.25, 0)
tpButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
tpButton.Text = "Teleport to Bus: OFF"
tpButton.TextColor3 = Color3.fromRGB(200, 200, 200)
tpButton.TextSize = 14
tpButton.Font = Enum.Font.SourceSansBold
tpButton.Parent = mainFrame

local tpCorner = Instance.new("UICorner")
tpCorner.CornerRadius = UDim.new(0, 6)
tpCorner.Parent = tpButton

-- Main Toggle 2: Auto PickUP Toggle Button
local autoPickupBtn = Instance.new("TextButton")
autoPickupBtn.Name = "AutoPickupBtn"
autoPickupBtn.Size = UDim2.new(0.9, 0, 0, 45)
autoPickupBtn.Position = UDim2.new(0.05, 0, 0.60, 0)
autoPickupBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
autoPickupBtn.Text = "Auto PickUP: OFF"
autoPickupBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
autoPickupBtn.TextSize = 14
autoPickupBtn.Font = Enum.Font.SourceSansBold
autoPickupBtn.Parent = mainFrame

local pickupCorner = Instance.new("UICorner")
pickupCorner.CornerRadius = UDim.new(0, 6)
pickupCorner.Parent = autoPickupBtn

--------------------------------------------------------------------------------
-- LOGIC & SYSTEMS
--------------------------------------------------------------------------------
local function getBusBase()
    return Workspace:FindFirstChild("ITEM_CONTAINER")
        and Workspace.ITEM_CONTAINER:FindFirstChild("Bus")
        and Workspace.ITEM_CONTAINER.Bus:FindFirstChild("Base")
end

local tpToggle = false
tpButton.MouseButton1Click:Connect(function()
    tpToggle = not tpToggle
    if tpToggle then
        tpButton.Text = "Teleport to Bus: ON"
        tpButton.BackgroundColor3 = Color3.fromRGB(0, 170, 80)
        tpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        local busBase = getBusBase()
        if busBase and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
            player.Character.HumanoidRootPart.CFrame = busBase.CFrame * CFrame.new(0, 3, 0)
        end
    else
        tpButton.Text = "Teleport to Bus: OFF"
        tpButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        tpButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end)

local trackedESP = {}
local function removeAllESPColors()
    for part, highlight in pairs(trackedESP) do
        if highlight then highlight:Destroy() end
    end
    table.clear(trackedESP)
end

-- Caching categories (Junk excluded)
local allowedTemplateNames = {}
local allowedMeshIds = {}

local function buildCategoryCaches()
    allowedTemplateNames = {}
    allowedMeshIds = {}
    
    local success, categoriesFolder = pcall(function()
        return ReplicatedStorage.Assets.Mutual.Item.Category
    end)
    
    if not success or not categoriesFolder then return end
    
    local targetCategories = {"Weapon", "Valuable", "Medic", "Armor", "Ammo", "Food", "Resources"}
    
    for _, catName in ipairs(targetCategories) do
        local catFolder = categoriesFolder:FindFirstChild(catName)
        if catFolder then
            for _, itemTemplate in ipairs(catFolder:GetChildren()) do
                allowedTemplateNames[string.lower(itemTemplate.Name)] = true
                for _, desc in ipairs(itemTemplate:GetDescendants()) do
                    if (desc:IsA("MeshPart") or desc:IsA("SpecialMesh")) and desc.MeshId and desc.MeshId ~= "" then
                        allowedMeshIds[desc.MeshId] = true
                    end
                end
            end
        end
    end
end

local function isAllowedCategoryItem(itemFolder)
    if not next(allowedTemplateNames) and not next(allowedMeshIds) then
        buildCategoryCaches()
    end
    if allowedTemplateNames[string.lower(itemFolder.Name)] then
        return true
    end
    for _, desc in ipairs(itemFolder:GetDescendants()) do
        if (desc:IsA("MeshPart") or desc:IsA("SpecialMesh")) and desc.MeshId and allowedMeshIds[desc.MeshId] then
            return true
        end
    end
    return false
end

-- Auto PickUp Loop
local autoPickupActive = false
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
                    for _, itemFolder in ipairs(itemContainer:GetChildren()) do
                        if not autoPickupActive then break end 
                        if isAllowedCategoryItem(itemFolder) then
                            local targetPart = itemFolder:FindFirstChild("Main", true) or itemFolder:FindFirstChildOfClass("BasePart")
                            if targetPart and targetPart:IsA("BasePart") then
                                if (root.Position - targetPart.Position).Magnitude <= 10000 then
                                    if replicaInsertRE then task.spawn(function() replicaInsertRE:FireServer(itemFolder) end) end
                                    if equipItemRF then task.spawn(function() equipItemRF:InvokeServer(itemFolder) end) end
                                end
                            end
                        end
                    end
                end
            end
            task.wait(0.05)
        end
    end)
end

autoPickupBtn.MouseButton1Click:Connect(function()
    autoPickupActive = not autoPickupActive
    if autoPickupActive then
        autoPickupBtn.Text = "Auto PickUP: ON"
        autoPickupBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 80)
        autoPickupBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        startAutoPickupLoop()
    else
        autoPickupBtn.Text = "Auto PickUP: OFF"
        autoPickupBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        autoPickupBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        removeAllESPColors()
    end
end)

exitButton.MouseButton1Click:Connect(function()
    autoPickupActive = false
    removeAllESPColors()
    screenGui:Destroy()
end)
