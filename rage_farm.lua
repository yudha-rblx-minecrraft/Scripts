-- ==========================================
-- Script Name: Titan Hub (V13 - AESTHETIC PURPLE EDITION)
-- Created by: Yudha and Helper: Gemini ai
-- ==========================================

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")

local LP = Players.LocalPlayer
local guiName = "YudhaTitanHub_V13"
local cfgFile = "TitanHub_Cfg_V13.json"

pcall(function() 
    if LP.PlayerGui:FindFirstChild(guiName) then LP.PlayerGui[guiName]:Destroy() end 
    if CoreGui:FindFirstChild(guiName) then CoreGui[guiName]:Destroy() end 
end)

local cfg = { Tgt = "", ChatMsg = "Yudha Hub is OP!", FS = 75, WS = 16, JP = 50, Off = 0, MagnetRadius = 30, FarmDelay = 1.5 }
local State = { 
    AutoFarm = false, Magnet = false, AutoInteract = false,
    Fly = false, InfJ = false, Noclip = false, ClickTP = false,
    GodMode = false, Invis = false, GoTo = false, Orbit = false, Fling = false, Freeze = false,
    ESP = false, Fullbright = false, NoFog = false, AntiAFK = true, ChatSpam = false 
}

pcall(function() 
    if isfile and isfile(cfgFile) then 
        local success, data = pcall(function() return HttpService:JSONDecode(readfile(cfgFile)) end)
        if success and type(data) == "table" then for k,v in pairs(data) do cfg[k] = v end end
    end 
end)
local function saveCfg() pcall(function() if writefile then writefile(cfgFile, HttpService:JSONEncode(cfg)) end end) end

-- THEME COLORS (PURPLE AESTHETIC)
local Colors = {
    MainBg = Color3.fromRGB(15, 15, 20),
    SideBg = Color3.fromRGB(22, 22, 28),
    SectionBg = Color3.fromRGB(28, 28, 35),
    Accent = Color3.fromRGB(138, 43, 226), -- Purple
    TextMain = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(150, 150, 160)
}

-- ROOT GUI
local SG = Instance.new("ScreenGui")
SG.Name = guiName
SG.ResetOnSpawn = false
local parentSuccess = pcall(function() SG.Parent = CoreGui end)
if not parentSuccess or not SG.Parent then SG.Parent = LP:WaitForChild("PlayerGui") end

-- MAIN WINDOW
local Main = Instance.new("Frame", SG)
Main.Size, Main.Position, Main.BackgroundColor3 = UDim2.new(0, 600, 0, 420), UDim2.new(0.5, -300, 0.5, -210), Colors.MainBg
Main.Active, Main.Draggable, Main.ClipsDescendants = true, true, true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", Main).Color = Colors.Accent
Instance.new("UIStroke", Main).Thickness = 1.5

-- TOP BAR
local TopBar = Instance.new("Frame", Main)
TopBar.Size, TopBar.BackgroundColor3 = UDim2.new(1, 0, 0, 45), Colors.SideBg
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", TopBar)
Title.Size, Title.Position, Title.BackgroundTransparency = UDim2.new(0, 200, 1, 0), UDim2.new(0, 20, 0, 0), 1
Title.Text, Title.TextColor3, Title.Font, Title.TextSize, Title.TextXAlignment = "Yudha Hub | Gemini AI", Colors.Accent, Enum.Font.GothamBlack, 15, Enum.TextXAlignment.Left

local SearchFake = Instance.new("Frame", TopBar)
SearchFake.Size, SearchFake.Position, SearchFake.BackgroundColor3 = UDim2.new(0, 200, 0, 25), UDim2.new(0.5, -50, 0.5, -12), Colors.MainBg
Instance.new("UICorner", SearchFake).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", SearchFake).Color = Colors.SectionBg
local SearchTxt = Instance.new("TextLabel", SearchFake)
SearchTxt.Size, SearchTxt.BackgroundTransparency, SearchTxt.Text, SearchTxt.TextColor3, SearchTxt.Font, SearchTxt.TextSize = UDim2.new(1, 0, 1, 0), 1, "🔍 Search...", Colors.TextDark, Enum.Font.Gotham, 11

local MinBtn = Instance.new("TextButton", TopBar)
MinBtn.Size, MinBtn.Position, MinBtn.BackgroundColor3, MinBtn.Text, MinBtn.TextColor3, MinBtn.Font, MinBtn.TextSize = UDim2.new(0, 30, 0, 30), UDim2.new(1, -45, 0.5, -15), Colors.MainBg, "-", Colors.TextMain, Enum.Font.GothamBold, 18
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 8)

-- SIDEBAR
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size, Sidebar.Position, Sidebar.BackgroundColor3 = UDim2.new(0, 150, 1, -45), UDim2.new(0, 0, 0, 45), Colors.SideBg
local SideLayout = Instance.new("UIListLayout", Sidebar)
SideLayout.Padding, SideLayout.HorizontalAlignment = UDim.new(0, 8), Enum.HorizontalAlignment.Center
Instance.new("UIPadding", Sidebar).PaddingTop = UDim.new(0, 15)

-- CONTENT AREA
local ContentArea = Instance.new("Frame", Main)
ContentArea.Size, ContentArea.Position, ContentArea.BackgroundTransparency = UDim2.new(1, -160, 1, -55), UDim2.new(0, 155, 0, 50), 1
-- ==========================================
-- BAGIAN 2: UI GENERATORS (Purple Aesthetics)
-- ==========================================

local Tabs = {}
local function CreateTab(name, icon)
    local TabBtn = Instance.new("TextButton", Sidebar)
    TabBtn.Size, TabBtn.BackgroundColor3, TabBtn.Text, TabBtn.TextColor3, TabBtn.Font, TabBtn.TextSize = UDim2.new(0.85, 0, 0, 35), Colors.MainBg, icon.."  "..name, Colors.TextDark, Enum.Font.GothamBold, 12
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)
    
    local Scroll = Instance.new("ScrollingFrame", ContentArea)
    Scroll.Size, Scroll.BackgroundTransparency, Scroll.ScrollBarThickness, Scroll.Visible = UDim2.new(1, 0, 1, 0), 1, 3, false
    Scroll.CanvasSize = UDim2.new(0, 0, 0, 1000)
    Scroll.ScrollBarImageColor3 = Colors.Accent
    local Layout = Instance.new("UIListLayout", Scroll)
    Layout.Padding, Layout.HorizontalAlignment = UDim.new(0, 10), Enum.HorizontalAlignment.Center
    Instance.new("UIPadding", Scroll).PaddingTop = UDim.new(0, 5)

    TabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Btn.BackgroundColor3 = Colors.MainBg
            t.Btn.TextColor3 = Colors.TextDark
            t.Page.Visible = false
        end
        TabBtn.BackgroundColor3 = Colors.Accent
        TabBtn.TextColor3 = Colors.TextMain
        Scroll.Visible = true
    end)
    
    table.insert(Tabs, {Btn = TabBtn, Page = Scroll})
    return Scroll
end

local function AddSection(parent, title)
    local Sec = Instance.new("Frame", parent)
    Sec.Size, Sec.BackgroundColor3 = UDim2.new(0.95, 0, 0, 30), Colors.SideBg
    Instance.new("UICorner", Sec).CornerRadius = UDim.new(0, 6)
    local Txt = Instance.new("TextLabel", Sec)
    Txt.Size, Txt.Position, Txt.BackgroundTransparency, Txt.Text, Txt.TextColor3, Txt.Font, Txt.TextSize, Txt.TextXAlignment = UDim2.new(1, -20, 1, 0), UDim2.new(0, 10, 0, 0), 1, title, Colors.Accent, Enum.Font.GothamBold, 12, Enum.TextXAlignment.Left
end

local function AddToggle(parent, txt, stateKey, cb)
    local btn = Instance.new("TextButton", parent)
    btn.Size, btn.BackgroundColor3, btn.Text = UDim2.new(0.95, 0, 0, 45), Colors.SectionBg, ""
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    local lbl = Instance.new("TextLabel", btn)
    lbl.Size, lbl.Position, lbl.BackgroundTransparency, lbl.Text, lbl.TextColor3, lbl.Font, lbl.TextSize, lbl.TextXAlignment = UDim2.new(0.7, 0, 1, 0), UDim2.new(0, 15, 0, 0), 1, txt, Colors.TextMain, Enum.Font.GothamMedium, 12, Enum.TextXAlignment.Left
    
    local switchBg = Instance.new("Frame", btn)
    switchBg.Size, switchBg.Position, switchBg.BackgroundColor3 = UDim2.new(0, 42, 0, 22), UDim2.new(1, -55, 0.5, -11), State[stateKey] and Colors.Accent or Colors.MainBg
    Instance.new("UICorner", switchBg).CornerRadius = UDim.new(1, 0)
    Instance.new("UIStroke", switchBg).Color = Colors.SideBg
    
    local switchDot = Instance.new("Frame", switchBg)
    switchDot.Size, switchDot.Position, switchDot.BackgroundColor3 = UDim2.new(0, 16, 0, 16), State[stateKey] and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8), Colors.TextMain
    Instance.new("UICorner", switchDot).CornerRadius = UDim.new(1, 0)
    
    btn.MouseButton1Click:Connect(function()
        State[stateKey] = not State[stateKey]
        local s = State[stateKey]
        TweenService:Create(switchBg, TweenInfo.new(0.2), {BackgroundColor3 = s and Colors.Accent or Colors.MainBg}):Play()
        TweenService:Create(switchDot, TweenInfo.new(0.2), {Position = s and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)}):Play()
        if cb then pcall(function() cb(s) end) end
    end)
end

local function AddSlider(parent, txt, min, max, val, key, cb)
    local frame = Instance.new("Frame", parent)
    frame.Size, frame.BackgroundColor3 = UDim2.new(0.95, 0, 0, 55), Colors.SectionBg
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    
    local lbl = Instance.new("TextLabel", frame)
    lbl.Size, lbl.Position, lbl.BackgroundTransparency, lbl.Text, lbl.TextColor3, lbl.Font, lbl.TextSize, lbl.TextXAlignment = UDim2.new(1, -20, 0, 25), UDim2.new(0, 15, 0, 5), 1, txt .. " : " .. val, Colors.TextMain, Enum.Font.GothamMedium, 12, Enum.TextXAlignment.Left
    
    local SliderBg = Instance.new("TextButton", frame)
    SliderBg.Size, SliderBg.Position, SliderBg.BackgroundColor3, SliderBg.Text = UDim2.new(1, -30, 0, 8), UDim2.new(0, 15, 0, 35), Colors.MainBg, ""
    Instance.new("UICorner", SliderBg).CornerRadius = UDim.new(1, 0)
    
    local SliderFill = Instance.new("Frame", SliderBg)
    SliderFill.Size, SliderFill.BackgroundColor3 = UDim2.new((val-min)/(max-min), 0, 1, 0), Colors.Accent
    Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(1, 0)
    
    local dragging = false
    SliderBg.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end end)
    UserInputService.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    
    UserInputService.InputChanged:Connect(function(inp)
        if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation().X
            local rel = math.clamp((mousePos - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
            local newVal = math.floor(min + (max - min) * rel)
            SliderFill.Size = UDim2.new(rel, 0, 1, 0)
            lbl.Text = txt .. " : " .. newVal
            cfg[key] = newVal
            if cb then pcall(function() cb(newVal) end) end
        end
    end)
end

local TabFarm = CreateTab("Farming", "⚔️")
local TabMove = CreateTab("Movement", "🏃")
local TabCombat = CreateTab("Player", "🛡️")
local TabMisc = CreateTab("Settings", "⚙️")

Tabs[1].Btn.BackgroundColor3 = Colors.Accent
Tabs[1].Btn.TextColor3 = Colors.TextMain
Tabs[1].Page.Visible = true

AddSection(TabFarm, "Loot & Auto Farm")
AddToggle(TabFarm, "Enable Auto Farm (Ori Logic)", "AutoFarm")
AddSlider(TabFarm, "Farm Loop Delay", 1, 5, cfg.FarmDelay, "FarmDelay")
AddToggle(TabFarm, "Aura Magnet Loot", "Magnet")
AddSlider(TabFarm, "Magnet Radius", 10, 100, cfg.MagnetRadius, "MagnetRadius")

AddSection(TabMove, "Mobility Options")
AddToggle(TabMove, "Toggle Fly", "Fly")
AddSlider(TabMove, "Fly Speed", 20, 200, cfg.FS, "FS")
AddSlider(TabMove, "Walk Speed", 16, 200, cfg.WS, "WS")
AddSlider(TabMove, "Jump Power", 50, 300, cfg.JP, "JP")
AddToggle(TabMove, "Infinite Jump", "InfJ")
AddToggle(TabMove, "Noclip (Walk through walls)", "Noclip")

AddSection(TabCombat, "Player Mods")
AddToggle(TabCombat, "God Mode (Invincible)", "GodMode")
AddToggle(TabCombat, "Ghost Mode", "Invis")
AddToggle(TabCombat, "Freeze Character", "Freeze")
AddToggle(TabCombat, "Fullbright", "Fullbright")
AddToggle(TabCombat, "ESP Outline", "ESP")

AddSection(TabMisc, "System Settings")
AddToggle(TabMisc, "Anti-AFK", "AntiAFK")
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

local function fireProx(prompt)
    pcall(function()
        if prompt and prompt:IsA("ProximityPrompt") and prompt.Enabled then
            prompt.HoldDuration = 0
            prompt.MaxActivationDistance = 9e9
            fireproximityprompt(prompt)
        end
    end)
end

RunService.Heartbeat:Connect(function(dt)
    if not LP.Character then return end
    local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
    local hum = LP.Character:FindFirstChildWhichIsA("Humanoid")
    if not hrp then return end

    pcall(function()
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

RunService.Stepped:Connect(function()
    local e = LP.Character
    if not e then return end
    
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

UserInputService.JumpRequest:Connect(function()
    if State.InfJ and LP.Character then
        local hum = LP.Character:FindFirstChildWhichIsA("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

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

-- ORI AUTO FARM & MAGNET (RESTORED & LINKED TO SLIDERS)
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
                                    task.wait(cfg.FarmDelay or 1.5)
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
                                    fireProx(prompt)
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
    if State.AntiAFK then pcall(function() game:GetService("VirtualUser"):ClickButton2(Vector2.new()) end) end
end)
