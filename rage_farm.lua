-- ==========================================
-- Script Name: The Storage GUI (V12.1 - TITAN EDITION)
-- BAGIAN 1: SETUP & UI LIBRARY
-- ==========================================

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")

local LP = Players.LocalPlayer
local guiName = "YudhaTitanHub_V12"
local cfgFile = "TitanHub_Cfg.json"

pcall(function() if LP.PlayerGui:FindFirstChild(guiName) then LP.PlayerGui[guiName]:Destroy() end end)
pcall(function() if CoreGui:FindFirstChild(guiName) then CoreGui[guiName]:Destroy() end end)

local cfg = { Tgt = "", ChatMsg = "Yudha Hub V12 is OP!", FS = 75, WS = 16, JP = 50, Off = 0, MagnetRadius = 30 }
local State = { 
    AutoFarm = false, Magnet = false, AutoInteract = false,
    Fly = false, InfJ = false, Noclip = false, ClickTP = false,
    GodMode = false, Invis = false, GoTo = false, Orbit = false, Fling = false, Freeze = false,
    ESP = false, Fullbright = false, NoFog = false,
    AntiAFK = true, ChatSpam = false 
}

pcall(function() if isfile and isfile(cfgFile) then for k,v in pairs(HttpService:JSONDecode(readfile(cfgFile))) do cfg[k]=v end end end)
local function saveCfg() pcall(function() if writefile then writefile(cfgFile, HttpService:JSONEncode(cfg)) end end) end

local SG = Instance.new("ScreenGui")
SG.Name = guiName
SG.ResetOnSpawn = false
pcall(function() SG.Parent = CoreGui end)
if not SG.Parent then SG.Parent = LP:WaitForChild("PlayerGui") end

local NotifFrame = Instance.new("Frame", SG)
NotifFrame.Size, NotifFrame.Position, NotifFrame.BackgroundTransparency = UDim2.new(0, 250, 1, 0), UDim2.new(1, -260, 0, 0), 1
local NotifLayout = Instance.new("UIListLayout", NotifFrame)
NotifLayout.SortOrder, NotifLayout.VerticalAlignment, NotifLayout.Padding = Enum.SortOrder.LayoutOrder, Enum.VerticalAlignment.Bottom, UDim.new(0, 10)

local function SendNotification(title, text, duration)
    duration = duration or 3
    local f = Instance.new("Frame", NotifFrame)
    f.Size, f.BackgroundColor3 = UDim2.new(1, 0, 0, 60), Color3.fromRGB(30, 30, 35)
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", f).Color = Color3.fromRGB(0, 170, 255)
    
    local t = Instance.new("TextLabel", f)
    t.Size, t.Position, t.BackgroundTransparency = UDim2.new(1, -10, 0, 25), UDim2.new(0, 10, 0, 5), 1
    t.Text, t.TextColor3, t.Font, t.TextSize, t.TextXAlignment = title, Color3.fromRGB(0, 170, 255), Enum.Font.GothamBold, 14, Enum.TextXAlignment.Left
    
    local d = Instance.new("TextLabel", f)
    d.Size, d.Position, d.BackgroundTransparency = UDim2.new(1, -10, 0, 25), UDim2.new(0, 10, 0, 30), 1
    d.Text, d.TextColor3, d.Font, d.TextSize, d.TextXAlignment = text, Color3.new(1,1,1), Enum.Font.Gotham, 12, Enum.TextXAlignment.Left
    
    f.Position = UDim2.new(1, 300, 0, 0)
    TweenService:Create(f, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Position = UDim2.new(0, 0, 0, 0)}):Play()
    
    task.delay(duration, function()
        TweenService:Create(f, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(1, 300, 0, 0)}):Play()
        task.wait(0.5)
        f:Destroy()
    end)
end

local Main = Instance.new("Frame", SG)
Main.Size, Main.Position, Main.BackgroundColor3 = UDim2.new(0, 550, 0, 400), UDim2.new(0.5, -275, 0.2, 0), Color3.fromRGB(20, 20, 25)
Main.Active, Main.Draggable, Main.ClipsDescendants = true, true, true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color, MainStroke.Thickness = Color3.fromRGB(0, 170, 255), 2

local TopBar = Instance.new("Frame", Main)
TopBar.Size, TopBar.BackgroundColor3 = UDim2.new(1, 0, 0, 40), Color3.fromRGB(15, 15, 20)
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)
local Title = Instance.new("TextLabel", TopBar)
Title.Size, Title.Position, Title.BackgroundTransparency = UDim2.new(1, -20, 1, 0), UDim2.new(0, 15, 0, 0), 1
Title.Text, Title.TextColor3, Title.Font, Title.TextSize, Title.TextXAlignment = "⚡ TITAN HUB V12.1 | Fixed Magnet", Color3.new(1,1,1), Enum.Font.GothamBlack, 14, Enum.TextXAlignment.Left

local MinBtn = Instance.new("TextButton", TopBar)
MinBtn.Size, MinBtn.Position, MinBtn.BackgroundColor3, MinBtn.Text, MinBtn.TextColor3, MinBtn.Font = UDim2.new(0, 30, 0, 30), UDim2.new(1, -40, 0, 5), Color3.fromRGB(30,30,40), "-", Color3.new(1,1,1), Enum.Font.GothamBold
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)

local OpenBtn = Instance.new("TextButton", SG)
OpenBtn.Size, OpenBtn.Position, OpenBtn.BackgroundColor3, OpenBtn.Visible, OpenBtn.Active, OpenBtn.Draggable = UDim2.new(0, 120, 0, 40), UDim2.new(0.02, 0, 0.4, 0), Color3.fromRGB(20,20,25), false, true, true
OpenBtn.Text, OpenBtn.TextColor3, OpenBtn.Font, OpenBtn.TextSize = "⚡ Open Titan", Color3.fromRGB(0, 170, 255), Enum.Font.GothamBlack, 12
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", OpenBtn).Color = Color3.fromRGB(0, 170, 255)

MinBtn.MouseButton1Click:Connect(function() Main.Visible, OpenBtn.Visible = false, true end)
OpenBtn.MouseButton1Click:Connect(function() Main.Visible, OpenBtn.Visible = true, false end)

local Sidebar = Instance.new("Frame", Main)
Sidebar.Size, Sidebar.Position, Sidebar.BackgroundColor3 = UDim2.new(0, 140, 1, -40), UDim2.new(0, 0, 0, 40), Color3.fromRGB(25, 25, 30)
local SidebarLayout = Instance.new("UIListLayout", Sidebar)
SidebarLayout.Padding, SidebarLayout.HorizontalAlignment = UDim.new(0, 5), Enum.HorizontalAlignment.Center
Instance.new("UIPadding", Sidebar).PaddingTop = UDim.new(0, 10)

local ContentArea = Instance.new("Frame", Main)
ContentArea.Size, ContentArea.Position, ContentArea.BackgroundTransparency = UDim2.new(1, -150, 1, -50), UDim2.new(0, 145, 0, 45), 1

local Tabs = {}
local function CreateTab(name, icon)
    local TabBtn = Instance.new("TextButton", Sidebar)
    TabBtn.Size, TabBtn.BackgroundColor3, TabBtn.Text, TabBtn.TextColor3, TabBtn.Font, TabBtn.TextSize = UDim2.new(0.9, 0, 0, 35), Color3.fromRGB(25, 25, 30), icon.." "..name, Color3.fromRGB(150, 150, 150), Enum.Font.GothamBold, 12
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)
    
    local Scroll = Instance.new("ScrollingFrame", ContentArea)
    Scroll.Size, Scroll.BackgroundTransparency, Scroll.ScrollBarThickness, Scroll.Visible = UDim2.new(1, 0, 1, 0), 1, 2, false
    Scroll.CanvasSize = UDim2.new(0, 0, 0, 900)
    local Layout = Instance.new("UIListLayout", Scroll)
    Layout.Padding, Layout.HorizontalAlignment = UDim.new(0, 8), Enum.HorizontalAlignment.Center
    Instance.new("UIPadding", Scroll).PaddingTop = UDim.new(0, 5)

    TabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
            t.Btn.TextColor3 = Color3.fromRGB(150, 150, 150)
            t.Page.Visible = false
        end
        TabBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        TabBtn.TextColor3 = Color3.new(1,1,1)
        Scroll.Visible = true
    end)
    
    table.insert(Tabs, {Btn = TabBtn, Page = Scroll})
    return Scroll
end

local function AddToggle(parent, txt, stateKey, cb)
    local btn = Instance.new("TextButton", parent)
    btn.Size, btn.BackgroundColor3, btn.Text = UDim2.new(0.95, 0, 0, 35), Color3.fromRGB(30, 30, 35), ""
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    local lbl = Instance.new("TextLabel", btn)
    lbl.Size, lbl.Position, lbl.BackgroundTransparency, lbl.Text, lbl.TextColor3, lbl.Font, lbl.TextSize, lbl.TextXAlignment = UDim2.new(0.7, 0, 1, 0), UDim2.new(0, 10, 0, 0), 1, txt, Color3.new(1,1,1), Enum.Font.GothamMedium, 12, Enum.TextXAlignment.Left
    
    local switchBg = Instance.new("Frame", btn)
    switchBg.Size, switchBg.Position, switchBg.BackgroundColor3 = UDim2.new(0, 40, 0, 20), UDim2.new(1, -50, 0.5, -10), State[stateKey] and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(50, 50, 60)
    Instance.new("UICorner", switchBg).CornerRadius = UDim.new(1, 0)
    
    local switchDot = Instance.new("Frame", switchBg)
    switchDot.Size, switchDot.Position, switchDot.BackgroundColor3 = UDim2.new(0, 16, 0, 16), State[stateKey] and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8), Color3.new(1,1,1)
    Instance.new("UICorner", switchDot).CornerRadius = UDim.new(1, 0)
    
    btn.MouseButton1Click:Connect(function()
        State[stateKey] = not State[stateKey]
        local s = State[stateKey]
        TweenService:Create(switchBg, TweenInfo.new(0.2), {BackgroundColor3 = s and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(50, 50, 60)}):Play()
        TweenService:Create(switchDot, TweenInfo.new(0.2), {Position = s and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
        if cb then cb(s) end
        SendNotification("Toggle Updated", txt .. " is now " .. (s and "ON" or "OFF"), 2)
    end)
end

local function AddInput(parent, ph, val, cb)
    local frame = Instance.new("Frame", parent)
    frame.Size, frame.BackgroundColor3 = UDim2.new(0.95, 0, 0, 35), Color3.fromRGB(30, 30, 35)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    
    local box = Instance.new("TextBox", frame)
    box.Size, box.Position, box.BackgroundTransparency, box.Text, box.PlaceholderText, box.TextColor3, box.Font, box.TextSize, box.TextXAlignment = UDim2.new(1, -20, 1, 0), UDim2.new(0, 10, 0, 0), 1, tostring(val or ""), ph, Color3.new(1,1,1), Enum.Font.Gotham, 12, Enum.TextXAlignment.Left
    box:GetPropertyChangedSignal("Text"):Connect(function() cb(box.Text) end)
end

local function AddButton(parent, txt, col, cb)
    local btn = Instance.new("TextButton", parent)
    btn.Size, btn.BackgroundColor3, btn.Text, btn.TextColor3, btn.Font, btn.TextSize = UDim2.new(0.95, 0, 0, 35), col or Color3.fromRGB(0, 120, 255), txt, Color3.new(1,1,1), Enum.Font.GothamBold, 12
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(cb)
end
-- ==========================================
-- BAGIAN 2: PENGATURAN MENU TABS
-- ==========================================

local TabFarm = CreateTab("Auto Farm", "📡")
local TabMove = CreateTab("Movement", "🏃")
local TabCombat = CreateTab("Combat & Troll", "⚔️")
local TabVisual = CreateTab("Visuals", "👁️")
local TabMisc = CreateTab("Server / Misc", "⚙️")

Tabs[1].Btn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
Tabs[1].Btn.TextColor3 = Color3.new(1,1,1)
Tabs[1].Page.Visible = true

AddToggle(TabFarm, "Ultra Auto Farm (Instant)", "AutoFarm")
AddToggle(TabFarm, "Aura Magnet Loot (Blink Collect)", "Magnet")
AddInput(TabFarm, "Magnet Radius (Default 30)", cfg.MagnetRadius, function(v) cfg.MagnetRadius = tonumber(v) or 30 end)
AddToggle(TabFarm, "Auto Interact (Spam ProxPrompt)", "AutoInteract")

AddToggle(TabMove, "Toggle Fly", "Fly")
AddInput(TabMove, "Fly Speed", cfg.FS, function(v) cfg.FS = tonumber(v) or 75 end)
AddInput(TabMove, "Walk Speed", cfg.WS, function(v) cfg.WS = tonumber(v) or 16 end)
AddInput(TabMove, "Jump Power", cfg.JP, function(v) cfg.JP = tonumber(v) or 50 end)
AddToggle(TabMove, "Infinite Jump", "InfJ")
AddToggle(TabMove, "Noclip (Wallhack)", "Noclip")
AddToggle(TabMove, "Click Teleport Tool", "ClickTP", function(s)
    if s then
        local tool = Instance.new("Tool", LP.Backpack)
        tool.Name = "Titan Teleport"
        tool.RequiresHandle = false
        tool.Activated:Connect(function()
            local mouse = LP:GetMouse()
            if mouse.Hit and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                LP.Character.HumanoidRootPart.CFrame = mouse.Hit + Vector3.new(0, 3, 0)
            end
        end)
    else
        local t = LP.Backpack:FindFirstChild("Titan Teleport") or LP.Character:FindFirstChild("Titan Teleport")
        if t then t:Destroy() end
    end
end)

AddToggle(TabCombat, "Real God Mode (Anti-Damage)", "GodMode")
AddToggle(TabCombat, "Ghost Mode (Invisibility)", "Invis", function(s)
    if LP.Character then
        for _, p in ipairs(LP.Character:GetDescendants()) do
            if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
                p.Transparency = s and 1 or 0
            elseif p:IsA("Decal") then
                p.Transparency = s and 1 or 0
            end
        end
        local head = LP.Character:FindFirstChild("Head")
        if head and head:FindFirstChildOfClass("BillboardGui") then
            head:FindFirstChildOfClass("BillboardGui").Enabled = not s
        end
    end
end)
AddInput(TabCombat, "Target Username", cfg.Tgt, function(v) cfg.Tgt = v end)
AddInput(TabCombat, "Y Offset (Height)", cfg.Off, function(v) cfg.Off = tonumber(v) or 0 end)
AddToggle(TabCombat, "Loop Teleport to Target", "GoTo")
AddToggle(TabCombat, "Orbit Target", "Orbit")
AddToggle(TabCombat, "Fling Target (Orbit Troll)", "Fling")
AddToggle(TabCombat, "Freeze Character", "Freeze")

AddToggle(TabVisual, "ESP Overlay", "ESP")
AddToggle(TabVisual, "Fullbright (Night Vision)", "Fullbright")
AddToggle(TabVisual, "Remove Fog", "NoFog")

AddToggle(TabMisc, "Anti-AFK (Bypass Kick)", "AntiAFK")
AddInput(TabMisc, "Spam Message", cfg.ChatMsg, function(v) cfg.ChatMsg = v end)
AddToggle(TabMisc, "Chat Spammer", "ChatSpam")
AddButton(TabMisc, "Rejoin Current Server", Color3.fromRGB(0, 150, 100), function()
    SendNotification("Rejoining", "Please wait...", 3)
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LP)
end)
AddButton(TabMisc, "Server Hop (Find New Server)", Color3.fromRGB(150, 0, 150), function()
    SendNotification("Server Hop", "Finding a different server...", 5)
    local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")).data
    for _, v in pairs(servers) do
        if v.playing < v.maxPlayers and v.id ~= game.JobId then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id, LP)
            break
        end
    end
end)
AddButton(TabMisc, "💾 Save Titan Configuration", Color3.fromRGB(0, 120, 255), function()
    saveCfg()
    SendNotification("Config Saved", "Your settings have been saved successfully.", 3)
end)
AddButton(TabMisc, "❌ Close & Uninject", Color3.fromRGB(200, 40, 40), function()
    for k in pairs(State) do State[k] = false end
    SG:Destroy()
end)
-- ==========================================
-- BAGIAN 3: TITAN ENGINE (CORE LOGIC)
-- ==========================================

local function getTgt()
    local s = string.lower(string.gsub(cfg.Tgt, "^%s*(.-)%s*$", "%1"))
    if s == "" then return nil end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and (string.lower(p.Name):find(s, 1, true) or string.lower(p.DisplayName):find(s, 1, true)) then return p end
    end
end

local function fireProx(prompt)
    if prompt and prompt.Enabled then
        prompt.HoldDuration = 0
        prompt.MaxActivationDistance = 9e9
        pcall(function() fireproximityprompt(prompt) end)
    end
end

local orbAng = 0
RunService.Heartbeat:Connect(function()
    local c = LP.Character
    local hrp = c and c:FindFirstChild("HumanoidRootPart")
    local hum = c and c:FindFirstChildWhichIsA("Humanoid")

    if State.GoTo then
        local t = getTgt()
        if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") and hrp then
            hrp.CFrame = t.Character.HumanoidRootPart.CFrame * CFrame.new(0, cfg.Off, 0)
            hrp.AssemblyLinearVelocity = Vector3.zero
        end
    elseif State.Orbit then
        local t = getTgt()
        if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") and hrp then
            orbAng = orbAng + (State.Fling and 2.5 or 0.15)
            local pos = t.Character.HumanoidRootPart.Position + Vector3.new(math.cos(orbAng) * 6, cfg.Off, math.sin(orbAng) * 6)
            hrp.CFrame = CFrame.new(pos, t.Character.HumanoidRootPart.Position)
            hrp.AssemblyLinearVelocity = State.Fling and Vector3.new(50000, 50000, 50000) or Vector3.zero
        end
    end

    if State.Fly and hrp and hum then
        hum.Sit = false
        if hum:GetState() ~= Enum.HumanoidStateType.Running then hum:ChangeState(Enum.HumanoidStateType.Running) end
        local mv = hum.MoveVector
        hrp.AssemblyLinearVelocity = mv.Magnitude > 0 and (Workspace.CurrentCamera.CFrame:VectorToWorldSpace(Vector3.new(mv.X, 0, mv.Z))).Unit * cfg.FS or Vector3.zero
    end

    if State.Freeze and hrp then
        hrp.AssemblyLinearVelocity, hrp.AssemblyAngularVelocity = Vector3.zero, Vector3.zero
    end
    if hum and not State.Fly then 
        hum.WalkSpeed, hum.UseJumpPower, hum.JumpPower = cfg.WS, true, cfg.JP 
    end

    if State.Fullbright then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
    end
    if State.NoFog then Lighting.FogEnd = 100000 end
end)

RunService.Stepped:Connect(function()
    local c = LP.Character
    if not c then return end
    
    if State.GodMode then
        local hum = c:FindFirstChildWhichIsA("Humanoid")
        if hum then
            hum.Health = hum.MaxHealth
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        end
        for _, p in ipairs(c:GetChildren()) do if p:IsA("BasePart") then p.CanTouch = false end end
    else
        for _, p in ipairs(c:GetChildren()) do if p:IsA("BasePart") then p.CanTouch = true end end
    end

    if State.Noclip then
        for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.01)
        if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LP.Character.HumanoidRootPart
            local storages = Workspace:FindFirstChild("Storages")
            
            if State.AutoFarm and storages then
                for _, st in ipairs(storages:GetChildren()) do
                    if not State.AutoFarm then break end
                    local room = st:FindFirstChild("Room") or (st.Name == "Room" and st)
                    if room then
                        local door = room:FindFirstChild("Door")
                        local prompt = door and door:FindFirstChildWhichIsA("ProximityPrompt", true)
                        local doorRoot = door and (door:IsA("BasePart") and door or door:FindFirstChildWhichIsA("BasePart", true))
                        if doorRoot and prompt and prompt.Enabled then
                            hrp.CFrame = doorRoot.CFrame + Vector3.new(0, 3, 0)
                            hrp.AssemblyLinearVelocity = Vector3.zero
                            fireProx(prompt)
                            task.wait(0.05)
                        end
                    end
                    local contents = st:FindFirstChild("Contents")
                    local lootFolder = contents and contents:FindFirstChild("Loot")
                    if lootFolder then
                        for _, loot in ipairs(lootFolder:GetChildren()) do
                            if not State.AutoFarm then break end
                            local prompt = loot:FindFirstChildWhichIsA("ProximityPrompt", true)
                            local lootRoot = loot:IsA("BasePart") and loot or loot:FindFirstChildWhichIsA("BasePart", true)
                            if lootRoot and prompt and prompt.Enabled then
                                hrp.CFrame = lootRoot.CFrame + Vector3.new(0, 1.5, 0)
                                hrp.AssemblyLinearVelocity = Vector3.zero
                                fireProx(prompt)
                                task.wait(0.05) 
                            end
                        end
                    end
                end
            end
            
            if State.Magnet and storages then
                local originCF = hrp.CFrame
                local collected = false
                
                for _, st in ipairs(storages:GetChildren()) do
                    local lootFolder = st:FindFirstChild("Contents") and st.Contents:FindFirstChild("Loot")
                    if lootFolder then
                        for _, loot in ipairs(lootFolder:GetChildren()) do
                            local part = loot:IsA("BasePart") and loot or loot:FindFirstChildWhichIsA("BasePart", true)
                            local prompt = loot:FindFirstChildWhichIsA("ProximityPrompt", true)
                            
                            if part and prompt and prompt.Enabled and (part.Position - originCF.Position).Magnitude <= cfg.MagnetRadius then
                                hrp.CFrame = part.CFrame + Vector3.new(0, 1.5, 0)
                                hrp.AssemblyLinearVelocity = Vector3.zero
                                fireProx(prompt)
                                collected = true
                                task.wait(0.03)
                            end
                        end
                    end
                end
                
                if collected then
                    hrp.CFrame = originCF
                    hrp.AssemblyLinearVelocity = Vector3.zero
                end
            end
            
            if State.AutoInteract then
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("ProximityPrompt") and obj.Enabled then
                        local part = obj.Parent
                        if part and part:IsA("BasePart") and (part.Position - hrp.Position).Magnitude <= 20 then
                            fireProx(obj)
                        end
                    end
                end
            end
            
        end
-- ==========================================
-- BAGIAN 3: TITAN ENGINE (AUTOFARM FIXED 0.5s DELAY)
-- ==========================================

local function getTgt()
    local s = string.lower(string.gsub(cfg.Tgt, "^%s*(.-)%s*$", "%1"))
    if s == "" then return nil end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and (string.lower(p.Name):find(s, 1, true) or string.lower(p.DisplayName):find(s, 1, true)) then return p end
    end
end

local function fireProx(prompt)
    if prompt and prompt.Enabled then
        prompt.HoldDuration = 0
        prompt.MaxActivationDistance = 9e9
        pcall(function() fireproximityprompt(prompt) end)
    end
end

local orbAng = 0
RunService.Heartbeat:Connect(function()
    local c = LP.Character
    local hrp = c and c:FindFirstChild("HumanoidRootPart")
    local hum = c and c:FindFirstChildWhichIsA("Humanoid")

    if not hrp then return end

    if State.GoTo then
        local t = getTgt()
        if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then
            hrp.CFrame = t.Character.HumanoidRootPart.CFrame * CFrame.new(0, cfg.Off, 0)
            hrp.AssemblyLinearVelocity = Vector3.zero
        end
    elseif State.Orbit then
        local t = getTgt()
        if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then
            orbAng = orbAng + (State.Fling and 2.5 or 0.15)
            local pos = t.Character.HumanoidRootPart.Position + Vector3.new(math.cos(orbAng) * 6, cfg.Off, math.sin(orbAng) * 6)
            hrp.CFrame = CFrame.new(pos, t.Character.HumanoidRootPart.Position)
            hrp.AssemblyLinearVelocity = State.Fling and Vector3.new(50000, 50000, 50000) or Vector3.zero
        end
    end

    if hum then
        if State.Fly then
            hum.Sit = false
            if hum:GetState() ~= Enum.HumanoidStateType.Running then hum:ChangeState(Enum.HumanoidStateType.Running) end
            local mv = hum.MoveVector
            hrp.AssemblyLinearVelocity = mv.Magnitude > 0 and (Workspace.CurrentCamera.CFrame:VectorToWorldSpace(Vector3.new(mv.X, 0, mv.Z))).Unit * cfg.FS or Vector3.zero
        elseif not State.Fly then 
            hum.WalkSpeed, hum.UseJumpPower, hum.JumpPower = cfg.WS, true, cfg.JP 
        end
    end

    if State.Freeze then
        hrp.AssemblyLinearVelocity, hrp.AssemblyAngularVelocity = Vector3.zero, Vector3.zero
    end
end)

task.spawn(function()
    while true do
        task.wait(1)
        if State.Fullbright then
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.GlobalShadows = false
        end
        if State.NoFog then Lighting.FogEnd = 100000 end
    end
end)

RunService.Stepped:Connect(function()
    local c = LP.Character
    if not c then return end
    
    if State.GodMode then
        local hum = c:FindFirstChildWhichIsA("Humanoid")
        if hum then
            hum.Health = hum.MaxHealth
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        end
        for _, p in ipairs(c:GetChildren()) do if p:IsA("BasePart") then p.CanTouch = false end end
    else
        for _, p in ipairs(c:GetChildren()) do if p:IsA("BasePart") then p.CanTouch = true end end
    end

    if State.Noclip then
        for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
    end
end)

-- FIXED AUTOFARM (DELAY 0.5s AGAR TIDAK BUG)
task.spawn(function()
    while true do
        task.wait(0.5) -- Delay disesuaikan jadi 0.5 detik
        local c = LP.Character
        local hrp = c and c:FindFirstChild("HumanoidRootPart")
        local storages = Workspace:FindFirstChild("Storages")

        if hrp and storages then
            if State.AutoFarm then
                for _, st in ipairs(storages:GetChildren()) do
                    if not State.AutoFarm then break end
                    
                    local room = st:FindFirstChild("Room") or (st.Name == "Room" and st)
                    if room then
                        local door = room:FindFirstChild("Door")
                        local prompt = door and door:FindFirstChildWhichIsA("ProximityPrompt", true)
                        local doorRoot = door and (door:IsA("BasePart") and door or door:FindFirstChildWhichIsA("BasePart", true))
                        if doorRoot and prompt and prompt.Enabled then
                            hrp.CFrame = doorRoot.CFrame + Vector3.new(0, 3, 0)
                            hrp.AssemblyLinearVelocity = Vector3.zero
                            fireProx(prompt)
                            task.wait(0.3) -- Jeda agar pintu terbuka sempurna
                        end
                    end
                    
                    local contents = st:FindFirstChild("Contents")
                    local lootFolder = contents and contents:FindFirstChild("Loot")
                    if lootFolder then
                        for _, loot in ipairs(lootFolder:GetChildren()) do
                            if not State.AutoFarm then break end
                            local prompt = loot:FindFirstChildWhichIsA("ProximityPrompt", true)
                            local lootRoot = loot:IsA("BasePart") and loot or loot:FindFirstChildWhichIsA("BasePart", true)
                            if lootRoot and prompt and prompt.Enabled then
                                hrp.CFrame = lootRoot.CFrame + Vector3.new(0, 1.5, 0)
                                hrp.AssemblyLinearVelocity = Vector3.zero
                                fireProx(prompt)
                                task.wait(0.2) 
                            end
                        end
                    end
                end
            end
            
            if State.Magnet then
                local originCF = hrp.CFrame
                local collected = false
                
                for _, st in ipairs(storages:GetChildren()) do
                    local lootFolder = st:FindFirstChild("Contents") and st.Contents:FindFirstChild("Loot")
                    if lootFolder then
                        for _, loot in ipairs(lootFolder:GetChildren()) do
                            local part = loot:IsA("BasePart") and loot or loot:FindFirstChildWhichIsA("BasePart", true)
                            local prompt = loot:FindFirstChildWhichIsA("ProximityPrompt", true)
                            
                            if part and prompt and prompt.Enabled and (part.Position - originCF.Position).Magnitude <= cfg.MagnetRadius then
                                hrp.CFrame = part.CFrame + Vector3.new(0, 1.5, 0)
                                hrp.AssemblyLinearVelocity = Vector3.zero
                                fireProx(prompt)
                                collected = true
                                task.wait(0.2)
                            end
                        end
                    end
                end
                
                if collected then
                    hrp.CFrame = originCF
                    hrp.AssemblyLinearVelocity = Vector3.zero
                end
            end
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.5)
        local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if State.AutoInteract and hrp then
            local storages = Workspace:FindFirstChild("Storages")
            if storages then
                for _, prompt in ipairs(storages:GetDescendants()) do
                    if prompt:IsA("ProximityPrompt") and prompt.Enabled then
                        local part = prompt.Parent
                        if part and part:IsA("BasePart") and (part.Position - hrp.Position).Magnitude <= 15 then
                            fireProx(prompt)
                        end
                    end
                end
            end
        end
    end
end)

LP.Idled:Connect(function()
    if State.AntiAFK then
        local VirtualUser = game:GetService("VirtualUser")
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

task.spawn(function()
    while true do
        task.wait(3)
        if State.ChatSpam then
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            pcall(function()
                if ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents") then
                    ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(cfg.ChatMsg, "All")
                elseif game:GetService("TextChatService").ChatInputBarConfiguration.TargetTextChannel then
                    game:GetService("TextChatService").ChatInputBarConfiguration.TargetTextChannel:SendAsync(cfg.ChatMsg)
                end
            end)
                        end-- ==========================================
-- BAGIAN 3: TITAN ENGINE (INSTANT INTERACT & STABLE)
-- ==========================================

local function getTgt()
    local s = string.lower(string.gsub(cfg.Tgt, "^%s*(.-)%s*$", "%1"))
    if s == "" then return nil end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and (string.lower(p.Name):find(s, 1, true) or string.lower(p.DisplayName):find(s, 1, true)) then return p end
    end
end

local function fireProx(prompt)
    if prompt and prompt.Enabled then
        prompt.HoldDuration = 0
        prompt.MaxActivationDistance = 9e9
        pcall(function() fireproximityprompt(prompt) end)
    end
end

local orbAng = 0
RunService.Heartbeat:Connect(function()
    local c = LP.Character
    local hrp = c and c:FindFirstChild("HumanoidRootPart")
    local hum = c and c:FindFirstChildWhichIsA("Humanoid")

    if not hrp then return end

    if State.GoTo then
        local t = getTgt()
        if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then
            hrp.CFrame = t.Character.HumanoidRootPart.CFrame * CFrame.new(0, cfg.Off, 0)
            hrp.AssemblyLinearVelocity = Vector3.zero
        end
    elseif State.Orbit then
        local t = getTgt()
        if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then
            orbAng = orbAng + (State.Fling and 2.5 or 0.15)
            local pos = t.Character.HumanoidRootPart.Position + Vector3.new(math.cos(orbAng) * 6, cfg.Off, math.sin(orbAng) * 6)
            hrp.CFrame = CFrame.new(pos, t.Character.HumanoidRootPart.Position)
            hrp.AssemblyLinearVelocity = State.Fling and Vector3.new(50000, 50000, 50000) or Vector3.zero
        end
    end

    if hum then
        if State.Fly then
            hum.Sit = false
            if hum:GetState() ~= Enum.HumanoidStateType.Running then hum:ChangeState(Enum.HumanoidStateType.Running) end
            local mv = hum.MoveVector
            hrp.AssemblyLinearVelocity = mv.Magnitude > 0 and (Workspace.CurrentCamera.CFrame:VectorToWorldSpace(Vector3.new(mv.X, 0, mv.Z))).Unit * cfg.FS or Vector3.zero
        elseif not State.Fly then 
            hum.WalkSpeed, hum.UseJumpPower, hum.JumpPower = cfg.WS, true, cfg.JP 
        end
    end

    if State.Freeze then
        hrp.AssemblyLinearVelocity, hrp.AssemblyAngularVelocity = Vector3.zero, Vector3.zero
    end
end)

task.spawn(function()
    while true do
        task.wait(1)
        if State.Fullbright then
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.GlobalShadows = false
        end
        if State.NoFog then Lighting.FogEnd = 100000 end
    end
end)

RunService.Stepped:Connect(function()
    local c = LP.Character
    if not c then return end
    
    if State.GodMode then
        local hum = c:FindFirstChildWhichIsA("Humanoid")
        if hum then
            hum.Health = hum.MaxHealth
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        end
        for _, p in ipairs(c:GetChildren()) do if p:IsA("BasePart") then p.CanTouch = false end end
    else
        for _, p in ipairs(c:GetChildren()) do if p:IsA("BasePart") then p.CanTouch = true end end
    end

    if State.Noclip then
        for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
    end
end)

-- AUTOFARM STABLE (DELAY 1.5s) & STABLE MAGNET
task.spawn(function()
    while true do
        task.wait(1.5)
        local c = LP.Character
        local hrp = c and c:FindFirstChild("HumanoidRootPart")
        local storages = Workspace:FindFirstChild("Storages")

        if hrp and storages then
            if State.AutoFarm then
                for _, st in ipairs(storages:GetChildren()) do
                    if not State.AutoFarm then break end
                    
                    local room = st:FindFirstChild("Room") or (st.Name == "Room" and st)
                    if room then
                        local door = room:FindFirstChild("Door")
                        local prompt = door and door:FindFirstChildWhichIsA("ProximityPrompt", true)
                        local doorRoot = door and (door:IsA("BasePart") and door or door:FindFirstChildWhichIsA("BasePart", true))
                        if doorRoot and prompt and prompt.Enabled then
                            hrp.CFrame = doorRoot.CFrame + Vector3.new(0, 3, 0)
                            hrp.AssemblyLinearVelocity = Vector3.zero
                            fireProx(prompt)
                            task.wait(0.5)
                        end
                    end
                    
                    local contents = st:FindFirstChild("Contents")
                    local lootFolder = contents and contents:FindFirstChild("Loot")
                    if lootFolder then
                        for _, loot in ipairs(lootFolder:GetChildren()) do
                            if not State.AutoFarm then break end
                            local prompt = loot:FindFirstChildWhichIsA("ProximityPrompt", true)
                            local lootRoot = loot:IsA("BasePart") and loot or loot:FindFirstChildWhichIsA("BasePart", true)
                            if lootRoot and prompt and prompt.Enabled then
                                hrp.CFrame = lootRoot.CFrame + Vector3.new(0, 1.5, 0)
                                hrp.AssemblyLinearVelocity = Vector3.zero
                                fireProx(prompt)
                                task.wait(0.5) 
                            end
                        end
                    end
                end
            end
            
            if State.Magnet then
                local originCF = hrp.CFrame
                local collected = false
                
                for _, st in ipairs(storages:GetChildren()) do
                    local lootFolder = st:FindFirstChild("Contents") and st.Contents:FindFirstChild("Loot")
                    if lootFolder then
                        for _, loot in ipairs(lootFolder:GetChildren()) do
                            local part = loot:IsA("BasePart") and loot or loot:FindFirstChildWhichIsA("BasePart", true)
                            local prompt = loot:FindFirstChildWhichIsA("ProximityPrompt", true)
                            
                            if part and prompt and prompt.Enabled and (part.Position - originCF.Position).Magnitude <= cfg.MagnetRadius then
                                hrp.CFrame = part.CFrame + Vector3.new(0, 1.5, 0)
                                hrp.AssemblyLinearVelocity = Vector3.zero
                                fireProx(prompt)
                                collected = true
                                task.wait(0.5)
                            end
                        end
                    end
                end
                
                if collected then
                    hrp.CFrame = originCF
                    hrp.AssemblyLinearVelocity = Vector3.zero
                end
            end
        end
    end
end)

-- OPTIMIZED INSTANT INTERACT (Tanpa Lag, Menghapus HoldDuration secara otomatis saat prompt muncul)
Workspace.DescendantAdded:Connect(function(obj)
    if State.AutoInteract and obj:IsA("ProximityPrompt") then
        obj.HoldDuration = 0
        obj.MaxActivationDistance = 9e9
    end
end)

task.spawn(function()
    while true do
        task.wait(0.5)
        if State.AutoInteract then
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("ProximityPrompt") then
                    obj.HoldDuration = 0
                    obj.MaxActivationDistance = 9e9
                end
            end
        end
    end
end)

LP.Idled:Connect(function()
    if State.AntiAFK then
        local VirtualUser = game:GetService("VirtualUser")
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

task.spawn(function()
    while true do
        task.wait(3)
        if State.ChatSpam then
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            pcall(function()
                if ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents") then
                    ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(cfg.ChatMsg, "All")
                elseif game:GetService("TextChatService").ChatInputBarConfiguration.TargetTextChannel then
                    game:GetService("TextChatService").ChatInputBarConfiguration.TargetTextChannel:SendAsync(cfg.ChatMsg)
                end
            end)
        end
    end
end)

local espCache = {}
task.spawn(function()
    while true do
        task.wait(2)
        if State.ESP then
            local function addESP(obj, color)
                if not obj then return end
                if not espCache[obj] and not obj:FindFirstChildOfClass("Highlight") then
                    local h = Instance.new("Highlight")
                    h.FillColor, h.OutlineColor, h.FillTransparency, h.Adornee, h.Parent = color, Color3.new(1,1,1), 0.5, obj, obj
                    espCache[obj] = h
                end
            end
            for _, p in ipairs(Players:GetPlayers()) do if p ~= LP and p.Character then addESP(p.Character, Color3.fromRGB(0, 255, 0)) end end
            local m = Workspace:FindFirstChild("Mobs") if m then for _, v in ipairs(m:GetChildren()) do addESP(v, Color3.fromRGB(255, 0, 0)) end end
            local st = Workspace:FindFirstChild("Storages") if st then for _, v in ipairs(st:GetChildren()) do addESP(v, Color3.fromRGB(255, 255, 0)) end end
            for obj, h in pairs(espCache) do if not obj or not obj.Parent then h:Destroy() espCache[obj] = nil end end
        else
            for obj, h in pairs(espCache) do if h then h:Destroy() end end
            table.clear(espCache)
        end
    end
end)

SendNotification("Titan Hub Injected!", "Instant Interact Optimized & Lag Free.", 5)
