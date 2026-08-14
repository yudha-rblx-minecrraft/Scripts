-- ==========================================
-- Script Name: The Storage GUI (V12.4 - ORI AUTOFARM RESTORED)
-- Created by: Yudha & Gemini AI
-- BAGIAN 1: SETUP, CORE SERVICES & UI FRAMEWORK
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
local guiName = "YudhaTitanHub_V12_4"
local cfgFile = "TitanHub_Cfg_V12.json"

pcall(function() 
    if LP.PlayerGui:FindFirstChild(guiName) then LP.PlayerGui[guiName]:Destroy() end 
    if CoreGui:FindFirstChild(guiName) then CoreGui[guiName]:Destroy() end 
end)

local cfg = { Tgt = "", ChatMsg = "Yudha Hub is OP!", FS = 75, WS = 16, JP = 50, Off = 0, MagnetRadius = 30 }
local State = { 
    AutoFarm = false, Magnet = false, AutoInteract = false,
    Fly = false, InfJ = false, Noclip = false, ClickTP = false,
    GodMode = false, Invis = false, GoTo = false, Orbit = false, Fling = false, Freeze = false,
    ESP = false, Fullbright = false, NoFog = false,
    AntiAFK = true, ChatSpam = false 
}

pcall(function() 
    if isfile and isfile(cfgFile) then 
        local success, data = pcall(function() return HttpService:JSONDecode(readfile(cfgFile)) end)
        if success and type(data) == "table" then
            for k,v in pairs(data) do cfg[k] = v end 
        end
    end 
end)

local function saveCfg() 
    pcall(function() 
        if writefile then writefile(cfgFile, HttpService:JSONEncode(cfg)) end 
    end) 
end

local SG = Instance.new("ScreenGui")
SG.Name = guiName
SG.ResetOnSpawn = false
local parentSuccess = pcall(function() SG.Parent = CoreGui end)
if not parentSuccess or not SG.Parent then SG.Parent = LP:WaitForChild("PlayerGui") end

local NotifFrame = Instance.new("Frame", SG)
NotifFrame.Size, NotifFrame.Position, NotifFrame.BackgroundTransparency = UDim2.new(0, 250, 1, 0), UDim2.new(1, -260, 0, 0), 1
local NotifLayout = Instance.new("UIListLayout", NotifFrame)
NotifLayout.SortOrder, NotifLayout.VerticalAlignment, NotifLayout.Padding = Enum.SortOrder.LayoutOrder, Enum.VerticalAlignment.Bottom, UDim.new(0, 10)

local function SendNotification(title, text, duration)
    task.spawn(function()
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
        
        task.wait(duration)
        if f and f.Parent then
            local fadeOut = TweenService:Create(f, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(1, 300, 0, 0)})
            fadeOut:Play()
            fadeOut.Completed:Wait()
            f:Destroy()
        end
    end)
end

local Main = Instance.new("Frame", SG)
Main.Size, Main.Position, Main.BackgroundColor3 = UDim2.new(0, 550, 0, 400), UDim2.new(0.5, -275, 0.2, 0), Color3.fromRGB(20, 20, 25)
Main.Active, Main.Draggable, Main.ClipsDescendants = true, true, true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(0, 170, 255)

local TopBar = Instance.new("Frame", Main)
TopBar.Size, TopBar.BackgroundColor3 = UDim2.new(1, 0, 0, 40), Color3.fromRGB(15, 15, 20)
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)
local Title = Instance.new("TextLabel", TopBar)
Title.Size, Title.Position, Title.BackgroundTransparency = UDim2.new(1, -20, 1, 0), UDim2.new(0, 15, 0, 0), 1
Title.Text, Title.TextColor3, Title.Font, Title.TextSize, Title.TextXAlignment = "⚡ TITAN HUB V12.4 | ORI AUTOFARM RESTORED", Color3.new(1,1,1), Enum.Font.GothamBlack, 14, Enum.TextXAlignment.Left

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
-- ==========================================
-- BAGIAN 2: UI GENERATORS & TAB ASSIGNMENTS
-- ==========================================

local Tabs = {}
local function CreateTab(name, icon)
    local TabBtn = Instance.new("TextButton", Sidebar)
    TabBtn.Size, TabBtn.BackgroundColor3, TabBtn.Text, TabBtn.TextColor3, TabBtn.Font, TabBtn.TextSize = UDim2.new(0.9, 0, 0, 35), Color3.fromRGB(25, 25, 30), icon.." "..name, Color3.fromRGB(150, 150, 150), Enum.Font.GothamBold, 12
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)
    
    local Scroll = Instance.new("ScrollingFrame", ContentArea)
    Scroll.Size, Scroll.BackgroundTransparency, Scroll.ScrollBarThickness, Scroll.Visible = UDim2.new(1, 0, 1, 0), 1, 2, false
    Scroll.CanvasSize = UDim2.new(0, 0, 0, 1100)
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
    btn.Size, btn.BackgroundColor3, btn.Text = UDim2.new(0.95, 0, 0, 40), Color3.fromRGB(30, 30, 35), ""
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
        if cb then pcall(function() cb(s) end) end
    end)
end

local function AddInput(parent, ph, val, cb)
    local frame = Instance.new("Frame", parent)
    frame.Size, frame.BackgroundColor3 = UDim2.new(0.95, 0, 0, 40), Color3.fromRGB(30, 30, 35)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    
    local box = Instance.new("TextBox", frame)
    box.Size, box.Position, box.BackgroundTransparency, box.Text, box.PlaceholderText, box.TextColor3, box.Font, box.TextSize, box.TextXAlignment = UDim2.new(1, -20, 1, 0), UDim2.new(0, 10, 0, 0), 1, tostring(val or ""), ph, Color3.new(1,1,1), Enum.Font.Gotham, 12, Enum.TextXAlignment.Left
    box:GetPropertyChangedSignal("Text"):Connect(function() pcall(function() cb(box.Text) end) end)
end

local function AddButton(parent, txt, col, cb)
    local btn = Instance.new("TextButton", parent)
    btn.Size, btn.BackgroundColor3, btn.Text, btn.TextColor3, btn.Font, btn.TextSize = UDim2.new(0.95, 0, 0, 35), col or Color3.fromRGB(0, 120, 255), txt, Color3.new(1,1,1), Enum.Font.GothamBold, 12
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(function() pcall(cb) end)
end

local TabFarm = CreateTab("Auto Farm", "📡")
local TabMove = CreateTab("Movement", "🏃")
local TabCombat = CreateTab("Combat & Troll", "⚔️")
local TabVisual = CreateTab("Visuals", "👁️")
local TabMisc = CreateTab("Server / Misc", "⚙️")

Tabs[1].Btn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
Tabs[1].Btn.TextColor3 = Color3.new(1,1,1)
Tabs[1].Page.Visible = true

AddToggle(TabFarm, "ORI Auto Farm (Restored)", "AutoFarm")
AddToggle(TabFarm, "Aura Magnet Loot (Safe)", "Magnet")
AddInput(TabFarm, "Magnet Target Radius (Default 30)", cfg.MagnetRadius, function(v) cfg.MagnetRadius = tonumber(v) or 30 end)

AddToggle(TabMove, "Toggle Smart Fly", "Fly")
AddInput(TabMove, "Fly Speed Multiplier", cfg.FS, function(v) cfg.FS = tonumber(v) or 75 end)
AddInput(TabMove, "Walk Speed Custom", cfg.WS, function(v) cfg.WS = tonumber(v) or 16 end)
AddInput(TabMove, "Jump Power Custom", cfg.JP, function(v) cfg.JP = tonumber(v) or 50 end)
AddToggle(TabMove, "Infinite Jump Request", "InfJ")
AddToggle(TabMove, "Noclip / Wallhack", "Noclip")
AddToggle(TabMove, "Enable Click Teleport Tool", "ClickTP", function(s)
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
        local t = LP.Backpack:FindFirstChild("Titan Teleport") or (LP.Character and LP.Character:FindFirstChild("Titan Teleport"))
        if t then t:Destroy() end
    end
end)

AddToggle(TabCombat, "Real God Mode (State Lock)", "GodMode")
AddToggle(TabCombat, "Ghost / Invisibility Mode", "Invis", function(s)
    if LP.Character then
        for _, p in ipairs(LP.Character:GetDescendants()) do
            if (p:IsA("BasePart") and p.Name ~= "HumanoidRootPart") or p:IsA("Decal") then
                p.Transparency = s and 1 or 0
            end
        end
        local head = LP.Character:FindFirstChild("Head")
        if head and head:FindFirstChildOfClass("BillboardGui") then head:FindFirstChildOfClass("BillboardGui").Enabled = not s end
    end
end)
AddInput(TabCombat, "Target User/Display Name", cfg.Tgt, function(v) cfg.Tgt = v end)
AddInput(TabCombat, "Y-Axis Offset (Height)", cfg.Off, function(v) cfg.Off = tonumber(v) or 0 end)
AddToggle(TabCombat, "Loop Teleport to Target", "GoTo")
AddToggle(TabCombat, "Orbit Target Player", "Orbit")
AddToggle(TabCombat, "Fling Target (Extrem Troll)", "Fling")
AddToggle(TabCombat, "Freeze Local Character", "Freeze")

AddToggle(TabVisual, "Enable Advanced ESP", "ESP")
AddToggle(TabVisual, "Fullbright / Night Vision", "Fullbright")
AddToggle(TabVisual, "Remove World Fog", "NoFog")

AddToggle(TabMisc, "Anti-AFK (Bypass Roblox Kick)", "AntiAFK")
AddInput(TabMisc, "Auto Spam Message", cfg.ChatMsg, function(v) cfg.ChatMsg = v end)
AddToggle(TabMisc, "Enable Chat Spammer", "ChatSpam")

AddButton(TabMisc, "Rejoin Current Server", Color3.fromRGB(0, 150, 100), function()
    SendNotification("Rejoining", "Connecting to current server...", 3)
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LP)
end)

AddButton(TabMisc, "Server Hop (Find Smaller Server)", Color3.fromRGB(150, 0, 150), function()
    SendNotification("Server Hop", "Searching for a new public server...", 5)
    local success, result = pcall(function() return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")).data end)
    if success and result then
        for _, v in pairs(result) do
            if v.playing < v.maxPlayers and v.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id, LP)
                break
            end
        end
    end
end)

AddButton(TabMisc, "💾 Save Titan Configuration", Color3.fromRGB(0, 120, 255), function()
    saveCfg()
    SendNotification("Config Saved", "All configurations secured locally.", 3)
end)

AddButton(TabMisc, "❌ Close & Uninject Completely", Color3.fromRGB(200, 40, 40), function()
    for k in pairs(State) do State[k] = false end
    SG:Destroy()
end)
-- ==========================================
-- BAGIAN 3: TITAN ENGINE & ORIGINAL AUTOFARM
-- ==========================================

local currentCamera = Workspace.CurrentCamera

local function getRoot(h)
    if not h then return nil end
    if h:IsA("BasePart") then return h end
    if h:IsA("Model") then return h.PrimaryPart or h:FindFirstChildWhichIsA("BasePart") end
    return h:FindFirstChildWhichIsA("BasePart", true)
end

local function aimAt(h)
    if not currentCamera then return end 
    local origType = currentCamera.CameraType
    currentCamera.CameraType = Enum.CameraType.Scriptable
    currentCamera.CFrame = CFrame.new(currentCamera.CFrame.Position, h)
    task.wait(0.05)
    currentCamera.CameraType = Enum.CameraType.Custom
end

local function isPositionSafe(h, i)
    i = i or 15
    local j = Workspace:FindFirstChild("Mobs")
    if not j then return true end
    for k, l in ipairs(j:GetChildren()) do
        local m = getRoot(l)
        if m then
            local n = (m.Position - h).Magnitude
            if n <= i then return false end
        end
    end
    return true
end

local function getTgt()
    local s = string.lower(string.gsub(cfg.Tgt, "^%s*(.-)%s*$", "%1"))
    if s == "" then return nil end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            if string.lower(p.Name):find(s, 1, true) or string.lower(p.DisplayName):find(s, 1, true) then return p end
        end
    end
    return nil
end

local orbAng = 0
RunService.Heartbeat:Connect(function(dt)
    if not LP.Character then return end
    local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
    local hum = LP.Character:FindFirstChildWhichIsA("Humanoid")
    if not hrp then return end

    pcall(function()
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
                hrp.AssemblyLinearVelocity = mv.Magnitude > 0 and (currentCamera.CFrame:VectorToWorldSpace(Vector3.new(mv.X, 0, mv.Z))).Unit * cfg.FS or Vector3.zero
            elseif not State.Fly then 
                hum.WalkSpeed = cfg.WS
                hum.UseJumpPower = true
                hum.JumpPower = cfg.JP 
            end
        end
    end)
end)

-- Noclip & Freeze Override (ORI Logic Restored)
RunService.Stepped:Connect(function()
    local e = LP.Character
    if not e then return end
    local f = e:FindFirstChild("HumanoidRootPart")
    
    pcall(function()
        if State.Noclip then
            for h, i in ipairs(e:GetDescendants()) do
                if i:IsA("BasePart") then i.CanCollide = false end
            end
        end
        if State.GodMode then
            local hum = e:FindFirstChildWhichIsA("Humanoid")
            if hum then
                hum.Health = hum.MaxHealth
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            end
        end
    end)
end)

RunService.RenderStepped:Connect(function()
    local e = LP.Character
    if not e then return end
    local f = e:FindFirstChild("HumanoidRootPart")
    
    if State.Freeze and f and f.Parent then
        f.AssemblyLinearVelocity = Vector3.new(0,0,0)
        f.AssemblyAngularVelocity = Vector3.new(0,0,0)
    end
end)

-- Inf Jump Fixed (Proper Global Binding)
UserInputService.JumpRequest:Connect(function()
    if State.InfJ and LP.Character then
        local hum = LP.Character:FindFirstChildWhichIsA("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- Visual Overrides
task.spawn(function()
    while task.wait(1.5) do
        pcall(function()
            if State.Fullbright then
                Lighting.Brightness = 2
                Lighting.ClockTime = 14
                Lighting.GlobalShadows = false
            end
            if State.NoFog then Lighting.FogEnd = 100000 end
        end)
    end
end)

-- ORI AUTO FARM (RESTORED)
task.spawn(function()
    while task.wait(0.5) do
        if State.AutoFarm then
            local e = LP.Character
            local f = e and e:FindFirstChild("HumanoidRootPart")
            if not f then continue end

            local h = Workspace:FindFirstChild("Storages")
            if h then
                for i, j in ipairs(h:GetChildren()) do
                    if not State.AutoFarm then break end
                    local k = j:FindFirstChild("Contents")
                    local l = k and k:FindFirstChild("Objects")

                    if not l or #l:GetChildren() == 0 then
                        local m = j:FindFirstChild("Room") or (j.Name == "Room" and j)
                        if m then
                            local n = m:FindFirstChild("Door")
                            local o = getRoot(n)

                            if o then
                                local p = o.Position
                                if isPositionSafe(p, 15) then
                                    f.CFrame = o.CFrame + (o.CFrame.LookVector * 0.5) + Vector3.new(0, 3, 0)
                                    f.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                                    task.wait(0.2)
                                    aimAt(p)

                                    local q = n:FindFirstChildWhichIsA("ProximityPrompt", true)
                                    if q then
                                        q.MaxActivationDistance = 9e9
                                        fireproximityprompt(q)
                                    end
                                    task.wait(1.5)
                                end
                            end
                        end
                    end

                    pcall(function()
                        if not State.AutoFarm then return end
                        local m = j:FindFirstChild("Contents")
                        local n = m and m:FindFirstChild("Loot")

                        if n then
                            for o, p in ipairs(n:GetChildren()) do
                                if not State.AutoFarm then break end
                                local q = getRoot(p)
                                if q then
                                    local r = q.Position
                                    if isPositionSafe(r, 15) then
                                        f.CFrame = q.CFrame + Vector3.new(0, 3, 0)
                                        f.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                                        task.wait(0.05)
                                        aimAt(r)

                                        local s = p:FindFirstChildWhichIsA("ProximityPrompt", true)
                                        if s then
                                            s.MaxActivationDistance = 9e9
                                            fireproximityprompt(s)
                                        end

                                        local t = tick()
                                        while State.AutoFarm and p.Parent and q.Parent and (tick() - t < 3) do
                                            task.wait(0.05)
                                        end
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

-- Magnet Loot Separate Loop
task.spawn(function()
    while task.wait(1.5) do
        if State.Magnet then
            local e = LP.Character
            local f = e and e:FindFirstChild("HumanoidRootPart")
            local storages = Workspace:FindFirstChild("Storages")
            
            if f and storages then
                pcall(function()
                    local originCF = f.CFrame
                    local collected = false
                    
                    for _, st in ipairs(storages:GetChildren()) do
                        local lootFolder = st:FindFirstChild("Contents") and st.Contents:FindFirstChild("Loot")
                        if lootFolder then
                            for _, loot in ipairs(lootFolder:GetChildren()) do
                                local part = loot:IsA("BasePart") and loot or loot:FindFirstChildWhichIsA("BasePart", true)
                                local prompt = loot:FindFirstChildWhichIsA("ProximityPrompt", true)
                                
                                if part and prompt and prompt.Enabled and (part.Position - originCF.Position).Magnitude <= cfg.MagnetRadius then
                                    f.CFrame = part.CFrame + Vector3.new(0, 1.5, 0)
                                    f.AssemblyLinearVelocity = Vector3.zero
                                    if prompt then
                                        prompt.HoldDuration = 0
                                        prompt.MaxActivationDistance = 9e9
                                        fireproximityprompt(prompt)
                                    end
                                    collected = true
                                    task.wait(0.3)
                                end
                            end
                        end
                    end
                    if collected and f.Parent then
                        f.CFrame = originCF
                        f.AssemblyLinearVelocity = Vector3.zero
                    end
                end)
            end
        end
    end
end)

LP.Idled:Connect(function()
    if State.AntiAFK then
        pcall(function()
            local VirtualUser = game:GetService("VirtualUser")
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end
end)

task.spawn(function()
    while task.wait(3.5) do
        if State.ChatSpam then
            pcall(function()
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
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
    while task.wait(2.5) do
        pcall(function()
            if State.ESP then
                local function addESP(obj, color)
                    if not obj or not obj.Parent then return end
                    if not espCache[obj] and not obj:FindFirstChildOfClass("Highlight") then
                        local h = Instance.new("Highlight")
                        h.FillColor, h.OutlineColor, h.FillTransparency, h.Adornee, h.Parent = color, Color3.new(1,1,1), 0.5, obj, obj
                        espCache[obj] = h
                    end
                end
                
                for _, p in ipairs(Players:GetPlayers()) do if p ~= LP and p.Character then addESP(p.Character, Color3.fromRGB(0, 255, 0)) end end
                local m = Workspace:FindFirstChild("Mobs") if m then for _, v in ipairs(m:GetChildren()) do addESP(v, Color3.fromRGB(255, 0, 0)) end end
                local st = Workspace:FindFirstChild("Storages") if st then for _, v in ipairs(st:GetChildren()) do addESP(v, Color3.fromRGB(255, 255, 0)) end end
                
                for obj, h in pairs(espCache) do 
                    if not obj or not obj.Parent then 
                        if h then h:Destroy() end 
                        espCache[obj] = nil 
                    end 
                end
            else
                for obj, h in pairs(espCache) do if h then h:Destroy() end end
                table.clear(espCache)
            end
        end)
    end
end)

SendNotification("Titan Hub Fully Loaded!", "ORI AutoFarm logic has been successfully restored.", 5)
