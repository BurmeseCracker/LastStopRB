local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer

-- Clean existing UI & ESP
if CoreGui:FindFirstChild("LastStopHub") then CoreGui.LastStopHub:Destroy() end
if player:FindFirstChild("PlayerGui") and player.PlayerGui:FindFirstChild("LastStopHub") then player.PlayerGui.LastStopHub:Destroy() end

local parentContainer
local success = pcall(function() parentContainer = CoreGui end)
if not success or not parentContainer then parentContainer = player:WaitForChild("PlayerGui") end

-- Remote Helpers
local replicaInsertRE = ReplicatedStorage:WaitForChild("ClientSource", 5) 
    and ReplicatedStorage.ClientSource:WaitForChild("ReplicaRemoteEvents", 5) 
    and ReplicatedStorage.ClientSource.ReplicaRemoteEvents:FindFirstChild("Replica_ReplicaArrayInsert")

local equipItemRF = ReplicatedStorage:WaitForChild("ClientSource", 5) 
    and ReplicatedStorage.ClientSource:WaitForChild("Mutual", 5) 
    and ReplicatedStorage.ClientSource.Mutual:WaitForChild("Packages", 5) 
    and ReplicatedStorage.ClientSource.Mutual.Packages:WaitForChild("Knit", 5) 
    and ReplicatedStorage.ClientSource.Mutual.Packages.Knit:WaitForChild("Services", 5) 
    and ReplicatedStorage.ClientSource.Mutual.Packages.Knit.Services:WaitForChild("ItemService", 5) 
    and ReplicatedStorage.ClientSource.Mutual.Packages.Knit.Services.ItemService:WaitForChild("RF", 5) 
    and ReplicatedStorage.ClientSource.Mutual.Packages.Knit.Services.ItemService.RF:FindFirstChild("EquipItem")

-- Color Mapping
local ITEM_COLORS = {
    ["Medic"]       = {Color = Color3.fromRGB(255, 60, 60),   Hex = "#FF3C3C"},
    ["Medical"]     = {Color = Color3.fromRGB(255, 60, 60),   Hex = "#FF3C3C"},
    ["Bandage"]     = {Color = Color3.fromRGB(255, 60, 60),   Hex = "#FF3C3C"},
    ["Medkit"]      = {Color = Color3.fromRGB(255, 60, 60),   Hex = "#FF3C3C"},
    ["Weapon"]      = {Color = Color3.fromRGB(50, 220, 100),  Hex = "#32DC64"},
    ["Weapons"]     = {Color = Color3.fromRGB(50, 220, 100),  Hex = "#32DC64"},
    ["Firearm"]     = {Color = Color3.fromRGB(50, 220, 100),  Hex = "#32DC64"},
    ["Gun"]         = {Color = Color3.fromRGB(50, 220, 100),  Hex = "#32DC64"},
    ["Ammo"]        = {Color = Color3.fromRGB(50, 220, 100),  Hex = "#32DC64"},
    ["Junk"]        = {Color = Color3.fromRGB(204, 204, 204), Hex = "#CCCCCC"},
    ["Rope"]        = {Color = Color3.fromRGB(204, 204, 204), Hex = "#CCCCCC"},
    ["Scrap"]       = {Color = Color3.fromRGB(204, 204, 204), Hex = "#CCCCCC"},
    ["Wood"]        = {Color = Color3.fromRGB(204, 204, 204), Hex = "#CCCCCC"},
    ["Pipe"]        = {Color = Color3.fromRGB(204, 204, 204), Hex = "#CCCCCC"},
    ["Coal"]        = {Color = Color3.fromRGB(204, 204, 204), Hex = "#CCCCCC"},
    ["Charm"]       = {Color = Color3.fromRGB(255, 215, 0),   Hex = "#FFD700"},
    ["Charms"]      = {Color = Color3.fromRGB(255, 215, 0),   Hex = "#FFD700"},
    ["Rare"]        = {Color = Color3.fromRGB(255, 215, 0),   Hex = "#FFD700"},
    ["Key"]         = {Color = Color3.fromRGB(255, 215, 0),   Hex = "#FFD700"},
    ["Food"]        = {Color = Color3.fromRGB(100, 200, 255), Hex = "#64C8FF"},
    ["Drink"]       = {Color = Color3.fromRGB(100, 200, 255), Hex = "#64C8FF"},
    ["Consumable"]  = {Color = Color3.fromRGB(100, 200, 255), Hex = "#64C8FF"},
    ["Default"]     = {Color = Color3.fromRGB(204, 204, 204), Hex = "#CCCCCC"}
}

local function getItemColor(itemName, categoryName)
    if ITEM_COLORS[itemName] then return ITEM_COLORS[itemName] end
    if categoryName and ITEM_COLORS[categoryName] then return ITEM_COLORS[categoryName] end
    
    local lowerName = string.lower(itemName)
    if string.find(lowerName, "band") or string.find(lowerName, "med") or string.find(lowerName, "heal") then return ITEM_COLORS["Medic"] end
    if string.find(lowerName, "gun") or string.find(lowerName, "weapon") or string.find(lowerName, "ammo") or string.find(lowerName, "rifle") or string.find(lowerName, "pistol") then return ITEM_COLORS["Weapon"] end
    if string.find(lowerName, "charm") or string.find(lowerName, "rare") or string.find(lowerName, "key") then return ITEM_COLORS["Charm"] end
    if string.find(lowerName, "food") or string.find(lowerName, "drink") or string.find(lowerName, "water") or string.find(lowerName, "apple") or string.find(lowerName, "can") then return ITEM_COLORS["Food"] end
    return ITEM_COLORS["Default"]
end

local function isAllowedJunk(itemName)
    local lower = string.lower(itemName)
    return string.find(lower, "wood") 
        or string.find(lower, "scrap") 
        or string.find(lower, "pipe") 
        or string.find(lower, "coal")
end

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

-- ScreenGui Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LastStopHub"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999999999
screenGui.Parent = parentContainer

--------------------------------------------------------------------------------
-- 1. MAIN MENU FRAME
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

enableDrag(mainFrame)

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(0.8, 0, 0, 30)
titleLabel.Position = UDim2.new(0.05, 0, 0, 5)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Last Stop v1"
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
-- 2. LOG CONSOLE FRAME
--------------------------------------------------------------------------------
local scannerFrame = Instance.new("Frame")
scannerFrame.Name = "ItemScannerFrame"
scannerFrame.Size = UDim2.new(0, 320, 0, 230)
scannerFrame.Position = UDim2.new(0.55, -160, 0.5, -115)
scannerFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
scannerFrame.BorderSizePixel = 0
scannerFrame.Active = true
scannerFrame.Visible = false
scannerFrame.Parent = screenGui

local sCorner = Instance.new("UICorner")
sCorner.CornerRadius = UDim.new(0, 8)
sCorner.Parent = scannerFrame

enableDrag(scannerFrame)

local sTitleLabel = Instance.new("TextLabel")
sTitleLabel.Name = "Title"
sTitleLabel.Size = UDim2.new(0.9, 0, 0, 30)
sTitleLabel.Position = UDim2.new(0.04, 0, 0, 5)
sTitleLabel.BackgroundTransparency = 1
sTitleLabel.Text = "Auto PickUP Logs"
sTitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
sTitleLabel.TextSize = 14
sTitleLabel.Font = Enum.Font.SourceSansBold
sTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
sTitleLabel.Parent = scannerFrame

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "LogConsole"
scrollFrame.Size = UDim2.new(0.92, 0, 0, 180)
scrollFrame.Position = UDim2.new(0.04, 0, 0, 40)
scrollFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
scrollFrame.BorderSizePixel = 0
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.ScrollBarThickness = 8
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 120, 200)
scrollFrame.ScrollBarImageTransparency = 0.2
scrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
scrollFrame.Parent = scannerFrame

local scrollCorner = Instance.new("UICorner")
scrollCorner.CornerRadius = UDim.new(0, 4)
scrollCorner.Parent = scrollFrame

local logText = Instance.new("TextLabel")
logText.Name = "LogText"
logText.Size = UDim2.new(1, -16, 0, 0)
logText.Position = UDim2.new(0, 5, 0, 5)
logText.BackgroundTransparency = 1
logText.RichText = true
logText.Text = "<font color='#78DC78'>[LOGS INITIALIZED]</font>\nToggle Auto PickUP ON to start."
logText.TextColor3 = Color3.fromRGB(255, 255, 255)
logText.TextSize = 11
logText.Font = Enum.Font.Code
logText.TextXAlignment = Enum.TextXAlignment.Left
logText.TextYAlignment = Enum.TextYAlignment.Top
logText.TextWrapped = true
logText.AutomaticSize = Enum.AutomaticSize.Y
logText.Parent = scrollFrame

--------------------------------------------------------------------------------
-- LOGIC & SYSTEMS
--------------------------------------------------------------------------------
local maxLogs = 100
local logHistory = {}
local function logMessage(msg)
    table.insert(logHistory, string.format("[%s] %s", os.date("%X"), msg))
    if #logHistory > maxLogs then table.remove(logHistory, 1) end
    logText.Text = table.concat(logHistory, "\n")
    task.defer(function() scrollFrame.CanvasPosition = Vector2.new(0, scrollFrame.AbsoluteCanvasSize.Y) end)
end

-- Teleport Logic
local tpToggle = false
local function teleportToBus()
    local busBase = Workspace:FindFirstChild("ITEM_CONTAINER")
        and Workspace.ITEM_CONTAINER:FindFirstChild("Bus")
        and Workspace.ITEM_CONTAINER.Bus:FindFirstChild("Base")
        
    if busBase and player.Character then
        local root = player.Character:FindFirstChild("HumanoidRootPart")
        if root then
            root.AssemblyLinearVelocity = Vector3.zero
            root.CFrame = busBase.CFrame * CFrame.new(0, 3, 0)
        end
    end
end

tpButton.MouseButton1Click:Connect(function()
    tpToggle = not tpToggle
    if tpToggle then
        tpButton.Text = "Teleport to Bus: ON"
        tpButton.BackgroundColor3 = Color3.fromRGB(0, 170, 80)
        tpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        teleportToBus()
    else
        tpButton.Text = "Teleport to Bus: OFF"
        tpButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        tpButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end)

-- ESP System
local trackedESP = {}

local function createOrUpdateESP(targetPart, colorData)
    if not targetPart then return end
    if not targetPart:FindFirstChild("ItemScannerESP") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "ItemScannerESP"
        highlight.Adornee = targetPart.Parent:IsA("Model") and targetPart.Parent or targetPart
        highlight.FillColor = colorData.Color
        highlight.FillTransparency = 0.4
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.OutlineTransparency = 0
        highlight.Parent = targetPart
        trackedESP[targetPart] = highlight
        return true
    end
    return false
end

local function removeAllESPColors()
    for part, highlight in pairs(trackedESP) do
        if highlight then highlight:Destroy() end
    end
    table.clear(trackedESP)
end

-- Asset Caching
local function getMeshId(obj)
    return (obj:IsA("MeshPart") or obj:IsA("SpecialMesh")) and obj.MeshId or nil
end

local function getItemDataFromAssetPath(descendant, itemAssetsRoot)
    local current = descendant
    local highestModelParent = nil
    local categoryName = "Junk"

    while current and current ~= itemAssetsRoot do
        if current.Name == "Model" and current.Parent and current.Parent ~= itemAssetsRoot then
            highestModelParent = current.Parent.Name
            if current.Parent.Parent and current.Parent.Parent ~= itemAssetsRoot then categoryName = current.Parent.Parent.Name end
        end
        current = current.Parent
    end

    return highestModelParent or (descendant.Parent and descendant.Parent.Name) or "Unknown", categoryName
end

local assetMeshCache = nil
local function buildAssetCache()
    assetMeshCache = {}
    local itemAssets = ReplicatedStorage:FindFirstChild("Assets")
    if itemAssets then
        itemAssets = itemAssets:FindFirstChild("Mutual")
        if itemAssets then itemAssets = itemAssets:FindFirstChild("Item") end
    end
    if not itemAssets then return end

    for _, descendant in ipairs(itemAssets:GetDescendants()) do
        local meshId = getMeshId(descendant)
        if meshId and meshId ~= "" then
            local realItemName, categoryName = getItemDataFromAssetPath(descendant, itemAssets)
            assetMeshCache[meshId] = {Name = realItemName, Category = categoryName}
        end
    end
end

local function identifyItemData(itemFolder)
    if not assetMeshCache then buildAssetCache() end
    for _, child in ipairs(itemFolder:GetDescendants()) do
        local meshId = getMeshId(child)
        if meshId and assetMeshCache and assetMeshCache[meshId] then
            return assetMeshCache[meshId].Name, assetMeshCache[meshId].Category
        end
    end
    return "Unknown Item", "Junk"
end

local function isBusItem(itemFolder)
    if itemFolder.Name == "Bus" or string.find(string.lower(itemFolder.Name), "bus") then
        return true
    end
    local ancestor = itemFolder.Parent
    while ancestor do
        if ancestor.Name == "Bus" or string.find(string.lower(ancestor.Name), "bus") then
            return true
        end
        ancestor = ancestor.Parent
    end
    return false
end

-- Auto PickUP Scan Loop
local autoPickupActive = false
local function startAutoPickupLoop()
    task.spawn(function()
        logMessage("<font color='#78DC78'>[AUTO PICKUP STARTED]</font>")
        
        while autoPickupActive do
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local root = char.HumanoidRootPart
                local itemContainer = Workspace:FindFirstChild("ITEM_CONTAINER")

                if itemContainer then
                    for _, itemFolder in ipairs(itemContainer:GetChildren()) do
                        if not isBusItem(itemFolder) then
                            local targetPart = itemFolder:FindFirstChild("Main", true) or itemFolder:FindFirstChildOfClass("BasePart")
                            if targetPart and targetPart:IsA("BasePart") then
                                local dist = (root.Position - targetPart.Position).Magnitude
                                
                                -- Range threshold: 10 studs
                                if dist <= 10 then
                                    local itemName, categoryName = identifyItemData(itemFolder)
                                    
                                    if not (categoryName == "Junk" or itemName == "Junk") or isAllowedJunk(itemName) then
                                        local colorData = getItemColor(itemName, categoryName)
                                        local isNew = createOrUpdateESP(targetPart, colorData)
                                        
                                        if isNew then
                                            logMessage(string.format("Picked: <font color='%s'><b>%s</b></font> (%.1f studs)", colorData.Hex, itemName, dist))
                                            
                                            -- Fire ReplicaArrayInsert RemoteEvent
                                            if replicaInsertRE then 
                                                pcall(function() replicaInsertRE:FireServer(itemFolder) end) 
                                            end
                                            
                                            -- Invoke EquipItem RemoteFunction
                                            if equipItemRF then 
                                                pcall(function() equipItemRF:InvokeServer(itemFolder) end) 
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            task.wait(0.5)
        end
    end)
end

-- Toggle Handler
autoPickupBtn.MouseButton1Click:Connect(function()
    autoPickupActive = not autoPickupActive
    scannerFrame.Visible = autoPickupActive

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
        logMessage("<font color='#FF5555'>[AUTO PICKUP STOPPED]</font>")
    end
end)

exitButton.MouseButton1Click:Connect(function()
    autoPickupActive = false
    removeAllESPColors()
    screenGui:Destroy()
end)
