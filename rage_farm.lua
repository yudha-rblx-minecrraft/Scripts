-- ==========================================
-- Script Name: The Storage Auto-Farm GUI (V9 - Ultimate Edition)
-- Created by: Yudha & Gemini AI
-- ==========================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local LP = Players.LocalPlayer
local guiName = "YudhaStorageCleanGui_V9"
local configFile = "StorageFarm_ConfigV9.json"

if LP.PlayerGui:FindFirstChild(guiName) then
    LP.PlayerGui[guiName]:Destroy()
end

-- Default Settings
local cfg = {
    R = 30, G = 30, B = 40,
    FS = 60, WS = 16, JP = 50,
    Off = 0, Tgt = "", MagnetDist = 25
}

if isfile and isfile(configFile) then
    pcall(function()
        local decoded = HttpService:JSONDecode(readfile(configFile))
        for k, v in pairs(decoded) do cfg[k] = v end
    end)
end

local function saveCfg()
    if writefile then
        pcall(function() writefile(configFile, HttpService:JSONEncode(cfg)) end)
    end
end

-- Toggles State
local Toggles = {
    GoTo = false, Orbit = false, Fling = false, Fly = false,
    InfJ = false, Noclip = false, Freeze = false, ESP = false,
    AutoFarm = false, GodMode = false, Fullbright = false, Magnet = false
}

-- UI Root
local SG = Instance.new("ScreenGui")
SG.Name = guiName
SG.ResetOnSpawn = false
SG.Parent = LP:WaitForChild("PlayerGui")

-- Main Frame
local Main = Instance.new("Frame", SG)
Main.Name = "MainFrame"
Main.Size = UDim2.new(0, 260, 0, 360)
Main.Position = UDim2.new(0.05, 0, 0.2, 0)
Main.BackgroundColor3 = Color3.fromRGB(cfg.R, cfg.G, cfg.B)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.ClipsDescendants = true

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Color3.fromRGB(80, 80, 120)
MainStroke.Thickness = 1.5

-- Title Bar
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, -60, 0, 40)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚡ THE STORAGE V9"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Header Buttons
local MinBtn = Instance.new("TextButton", Main)
MinBtn.Size = UDim2.new(0, 26, 0, 26)
MinBtn.Position = UDim2.new(1, -58, 0, 7)
MinBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.new(1, 1, 1)
MinBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)

local ClsBtn = Instance.new("TextButton", Main)
ClsBtn.Size = UDim2.new(0, 26, 0, 26)
ClsBtn.Position = UDim2.new(1, -29, 0, 7)
ClsBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ClsBtn.Text = "X"
ClsBtn.TextColor3 = Color3.new(1, 1, 1)
ClsBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", ClsBtn).CornerRadius = UDim.new(0, 6)

-- Floating Open Button
local OpenBtn = Instance.new("TextButton", SG)
OpenBtn.Size = UDim2.new(0, 100, 0, 32)
OpenBtn.Position = UDim2.new(0.02, 0, 0.4, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(cfg.R, cfg.G, cfg.B)
OpenBtn.Text = "⚡ Open Menu"
OpenBtn.TextColor3 = Color3.new(1, 1, 1)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 11
OpenBtn.Visible = false
OpenBtn.Active = true
OpenBtn.Draggable = true
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 8)
local OpenStroke = Instance.new("UIStroke", OpenBtn)
OpenStroke.Color = Color3.fromRGB(100, 100, 150)

MinBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    OpenBtn.Visible = true
end)

OpenBtn.MouseButton1Click:Connect(function()
    Main.Visible = true
    OpenBtn.Visible = false
end)

-- Scroll Area
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -10, 1, -45)
Scroll.Position = UDim2.new(0, 5, 0, 40)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 3
Scroll.CanvasSize = UDim2.new(0, 0, 0, 950)

local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0, 6)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- UI Builder Utilities
local function addToggle(name, cb)
    local btn = Instance.new("TextButton", Scroll)
    btn.Size = UDim2.new(0.95, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.Text = name .. " : OFF"
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        local targetColor = active and Color3.fromRGB(0, 180, 120) or Color3.fromRGB(40, 40, 50)
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
        btn.TextColor3 = active and Color3.new(1, 1, 1) or Color3.fromRGB(200, 200, 200)
        btn.Text = name .. (active and " : ON" or " : OFF")
        cb(active)
    end)
end

local function addBtn(name, col, cb)
    local btn = Instance.new("TextButton", Scroll)
    btn.Size = UDim2.new(0.95, 0, 0, 30)
    btn.BackgroundColor3 = col
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.Text = name
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(cb)
end

local function addInput(ph, val, cb)
    local box = Instance.new("TextBox", Scroll)
    box.Size = UDim2.new(0.95, 0, 0, 30)
    box.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    box.TextColor3 = Color3.new(1, 1, 1)
    box.PlaceholderText = ph
    box.Text = tostring(val or "")
    box.TextSize = 11
    box.Font = Enum.Font.Gotham
    box.ClearTextOnFocus = false
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)

    box:GetPropertyChangedSignal("Text"):Connect(function() cb(box.Text) end)
end

-- Target Finder Engine
local function getTgt()
    local str = string.lower(string.gsub(cfg.Tgt, "^%s*(.-)%s*$", "%1"))
    if str == "" then return nil end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and (string.lower(p.Name):find(str, 1, true) or string.lower(p.DisplayName):find(str, 1, true)) then
            return p
        end
    end
end

-- ==========================================
-- UI CONTROLS & ELEMENTS
-- ==========================================

addBtn("💾 Save Configuration", Color3.fromRGB(0, 120, 215), function() saveCfg() end)

addInput("RGB Red (0-255)", cfg.R, function(v)
    cfg.R = math.clamp(tonumber(v) or 30, 0, 255)
    Main.BackgroundColor3 = Color3.fromRGB(cfg.R, cfg.G, cfg.B)
    OpenBtn.BackgroundColor3 = Color3.fromRGB(cfg.R, cfg.G, cfg.B)
end)
addInput("RGB Green (0-255)", cfg.G, function(v)
    cfg.G = math.clamp(tonumber(v) or 30, 0, 255)
    Main.BackgroundColor3 = Color3.fromRGB(cfg.R, cfg.G, cfg.B)
    OpenBtn.BackgroundColor3 = Color3.fromRGB(cfg.R, cfg.G, cfg.B)
end)
addInput("RGB Blue (0-255)", cfg.B, function(v)
    cfg.B = math.clamp(tonumber(v) or 40, 0, 255)
    Main.BackgroundColor3 = Color3.fromRGB(cfg.R, cfg.G, cfg.B)
    OpenBtn.BackgroundColor3 = Color3.fromRGB(cfg.R, cfg.G, cfg.B)
end)

addInput("Target Username", cfg.Tgt, function(t) cfg.Tgt = t end)
addInput("GoTo/Orbit Y Offset", cfg.Off, function(v) cfg.Off = tonumber(v) or 0 end)

addToggle("Toggle Loop GoTo", function(s) Toggles.GoTo = s end)
addToggle("Toggle Orbit Target", function(s) Toggles.Orbit = s end)
addToggle("Toggle Fling Target (Troll)", function(s) Toggles.Fling = s end)

addToggle("Toggle Fly (Mobile/PC)", function(s) Toggles.Fly = s end)
addInput("Fly Speed", cfg.FS, function(v) cfg.FS = tonumber(v) or cfg.FS end)

addInput("Walk Speed", cfg.WS, function(v) cfg.WS = tonumber(v) or cfg.WS end)
addInput("Jump Power", cfg.JP, function(v) cfg.JP = tonumber(v) or cfg.JP end)
addToggle("Toggle Inf Jump", function(s) Toggles.InfJ = s end)

addToggle("Toggle God Mode (Health Lock)", function(s) Toggles.GodMode = s end)
addToggle("Toggle Fullbright (Night Vision)", function(s) Toggles.Fullbright = s end)
addToggle("Toggle Magnet Loot", function(s) Toggles.Magnet = s end)

addToggle("Toggle Noclip", function(s) Toggles.Noclip = s end)
addToggle("Toggle Freeze Position", function(s) Toggles.Freeze = s end)
addToggle("Toggle ESP (Player/Mob/Storage)", function(s) Toggles.ESP = s end)
addToggle("Toggle AutoFarm", function(s) Toggles.AutoFarm = s end)

-- ==========================================
-- CORE FUNCTIONALITIES
-- ==========================================

-- Click Teleport Tool
addBtn("🎯 Get Click Teleport Tool", Color3.fromRGB(140, 60, 180), function()
    local mouse = LP:GetMouse()
    local tool = Instance.new("Tool")
    tool.Name = "Click Teleport"
    tool.RequiresHandle = false
    tool.Activated:Connect(function()
        if mouse.Hit and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            LP.Character.HumanoidRootPart.CFrame = mouse.Hit + Vector3.new(0, 3, 0)
        end
    end)
    tool.Parent = LP.Backpack
end)

-- Main Loop Mechanics
local orbAngle = 0
RunService.RenderStepped:Connect(function()
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildWhichIsA("Humanoid")

    -- GoTo Loop
    if Toggles.GoTo then
        local target = getTgt()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and hrp then
            hrp.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, cfg.Off, 0)
            hrp.AssemblyLinearVelocity = Vector3.zero
        end
    -- Orbit & Fling Loop
    elseif Toggles.Orbit or Toggles.Fling then
        local target = getTgt()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and hrp then
            orbAngle = orbAngle + (Toggles.Fling and 1.5 or 0.15)
            local offset = Vector3.new(math.cos(orbAngle) * 6, cfg.Off, math.sin(orbAngle) * 6)
            local targetPos = target.Character.HumanoidRootPart.Position
            
            hrp.CFrame = CFrame.new(targetPos + offset, targetPos)
            if Toggles.Fling then
                hrp.AssemblyLinearVelocity = Vector3.new(9999, 9999, 9999)
            else
                hrp.AssemblyLinearVelocity = Vector3.zero
            end
        end
    end

    -- Fly Loop
    if Toggles.Fly and hrp and hum then
        hum.Sit = false
        if hum:GetState() ~= Enum.HumanoidStateType.Running then hum:ChangeState(Enum.HumanoidStateType.Running) end
        local mv = hum.MoveVector
        if mv.Magnitude > 0 then
            hrp.AssemblyLinearVelocity = (Workspace.CurrentCamera.CFrame:VectorToWorldSpace(Vector3.new(mv.X, 0, mv.Z))).Unit * cfg.FS
        else
            hrp.AssemblyLinearVelocity = Vector3.zero
        end
    end

    -- Freeze Position
    if Toggles.Freeze and hrp then
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
    end

    -- God Mode
    if Toggles.GodMode and hum then
        hum.Health = hum.MaxHealth
    end
end)

-- Noclip Execution
RunService.Stepped:Connect(function()
    if Toggles.Noclip and LP.Character then
        for _, p in ipairs(LP.Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end
end)

-- WalkSpeed & JumpPower Enforcement
task.spawn(function()
    while true do
        task.wait(0.2)
        local hum = LP.Character and LP.Character:FindFirstChildWhichIsA("Humanoid")
        if hum then
            hum.WalkSpeed = cfg.WS
            hum.UseJumpPower = true
            hum.JumpPower = cfg.JP
        end
    end
end)

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if Toggles.InfJ and LP.Character then
        local hum = LP.Character:FindFirstChildWhichIsA("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- Fullbright Nightvision
task.spawn(function()
    while true do
        task.wait(1)
        if Toggles.Fullbright then
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false
        end
    end
end)

-- Magnet Loot
task.spawn(function()
    while true do
        task.wait(0.5)
        if Toggles.Magnet and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LP.Character.HumanoidRootPart
            local storages = Workspace:FindFirstChild("Storages")
            if storages then
                for _, storage in ipairs(storages:GetChildren()) do
                    local lootFolder = storage:FindFirstChild("Contents") and storage.Contents:FindFirstChild("Loot")
                    if lootFolder then
                        for _, loot in ipairs(lootFolder:GetChildren()) do
                            local part = loot:IsA("BasePart") and loot or loot:FindFirstChildWhichIsA("BasePart")
                            if part and (part.Position - hrp.Position).Magnitude <= cfg.MagnetDist then
                                part.CFrame = hrp.CFrame
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- Anti-AFK Disconnect
LP.Idled:Connect(function()
    local VirtualUser = game:GetService("VirtualUser")
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- ESP System
local esps = {}
local function remESP()
    for _, h in ipairs(esps) do if h then h:Destroy() end end
    table.clear(esps)
end

task.spawn(function()
    while true do
        task.wait(1)
        if Toggles.ESP then
            local function mkH(o, col)
                if not o:FindFirstChildOfClass("Highlight") then
                    local h = Instance.new("Highlight", o)
                    h.FillColor = col
                    h.OutlineColor = Color3.new(1, 1, 1)
                    h.FillTransparency = 0.5
                    h.Adornee = o
                    table.insert(esps, h)
                end
            end
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP and p.Character then mkH(p.Character, Color3.fromRGB(0, 255, 0)) end
            end
            local m = Workspace:FindFirstChild("Mobs")
            if m then for _, v in ipairs(m:GetChildren()) do mkH(v, Color3.fromRGB(255, 0, 0)) end end
            local st = Workspace:FindFirstChild("Storages")
            if st then for _, v in ipairs(st:GetChildren()) do mkH(v, Color3.fromRGB(255, 255, 0)) end end
        else
            remESP()
        end
    end
end)

-- AutoFarm Core
local function getR(h)
    if not h then return nil end
    if h:IsA("BasePart") then return h end
    if h:IsA("Model") then return h.PrimaryPart or h:FindFirstChildWhichIsA("BasePart") end
    return h:FindFirstChildWhichIsA("BasePart", true)
end

local function aim(pos)
    local c = Workspace.CurrentCamera
    if c then
        c.CameraType = Enum.CameraType.Scriptable
        c.CFrame = CFrame.new(c.CFrame.Position, pos)
        task.wait(0.05)
        c.CameraType = Enum.CameraType.Custom
    end
end

local function isSafe(pos)
    local m = Workspace:FindFirstChild("Mobs")
    if not m then return true end
    for _, v in ipairs(m:GetChildren()) do
        local r = getR(v)
        if r and (r.Position - pos).Magnitude <= 15 then return false end
    end
    return true
end

task.spawn(function()
    while true do
        task.wait(0.5)
        if Toggles.AutoFarm and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LP.Character.HumanoidRootPart
            local st = Workspace:FindFirstChild("Storages")
            if st then
                for _, storage in ipairs(st:GetChildren()) do
                    if not Toggles.AutoFarm then break end
                    local cnt = storage:FindFirstChild("Contents")
                    local objs = cnt and cnt:FindFirstChild("Objects")
                    if not objs or #objs:GetChildren() == 0 then
                        local rm = storage:FindFirstChild("Room") or (storage.Name == "Room" and storage)
                        if rm then
                            local dr = rm:FindFirstChild("Door")
                            local drR = getR(dr)
                            if drR and isSafe(drR.Position) then
                                hrp.CFrame = drR.CFrame + (drR.CFrame.LookVector * 0.5) + Vector3.new(0, 3, 0)
                                hrp.AssemblyLinearVelocity = Vector3.zero
                                task.wait(0.2)
                                aim(drR.Position)
                                local pr = dr:FindFirstChildWhichIsA("ProximityPrompt", true)
                                if pr then pr.MaxActivationDistance = 9e9 fireproximityprompt(pr) end
                                task.wait(1.5)
                            end
                        end
                    end
                    pcall(function()
                        if not Toggles.AutoFarm then return end
                        local lts = cnt and cnt:FindFirstChild("Loot")
                        if lts then
                            for _, loot in ipairs(lts:GetChildren()) do
                                if not Toggles.AutoFarm then break end
                                local lR = getR(loot)
                                if lR and isSafe(lR.Position) then
                                    hrp.CFrame = lR.CFrame + Vector3.new(0, 3, 0)
                                    hrp.AssemblyLinearVelocity = Vector3.zero
                                    task.wait(0.05)
                                    aim(lR.Position)
                                    local pr = loot:FindFirstChildWhichIsA("ProximityPrompt", true)
                                    if pr then pr.MaxActivationDistance = 9e9 fireproximityprompt(pr) end
                                    local tm = tick()
                                    while Toggles.AutoFarm and loot.Parent and lR.Parent and (tick() - tm < 3) do
                                        task.wait(0.05)
                                    end
                                end
                            end
                        end
                    end)
                end
            end
        end
    end
end)

-- Exit Script Cleanup
ClsBtn.MouseButton1Click:Connect(function()
    for k in pairs(Toggles) do Toggles[k] = false end
    remESP()
    SG:Destroy()
end)
