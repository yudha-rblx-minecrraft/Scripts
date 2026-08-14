-- ==========================================
-- Script Name: TITAN HUB V14 - FIXED & STABLE EDITION
-- Created by: Yudha & Gemini AI
-- BAGIAN 1: SETUP & UI INTERFACE
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
local guiName = "TitanHub_V14_Fixed"
local cfgFile = "TitanHub_Cfg_V14.json"

pcall(function() 
    if LP.PlayerGui:FindFirstChild(guiName) then LP.PlayerGui[guiName]:Destroy() end 
    if CoreGui:FindFirstChild(guiName) then CoreGui[guiName]:Destroy() end 
end)

local cfg = { Tgt = "", ChatMsg = "Titan Hub is OP!", FS = 75, WS = 16, JP = 50, Off = 0, MagnetRadius = 30, FarmDelay = 1.5 }
local State = { 
    AutoFarm = false, Magnet = false, AutoInteract = false, Fly = false, InfJ = false, 
    Noclip = false, ClickTP = false, GodMode = false, Invis = false, GoTo = false, 
    Orbit = false, Fling = false, Freeze = false, ESP = false, Fullbright = false, 
    NoFog = false, AntiAFK = true, ChatSpam = false 
}

pcall(function() 
    if isfile and isfile(cfgFile) then 
        local success, data = pcall(function() return HttpService:JSONDecode(readfile(cfgFile)) end)
        if success and type(data) == "table" then for k,v in pairs(data) do cfg[k] = v end end
    end 
end)
local function saveCfg() pcall(function() if writefile then writefile(cfgFile, HttpService:JSONEncode(cfg)) end end) end

local Colors = {
    MainBg = Color3.fromRGB(15, 15, 20),
    SideBg = Color3.fromRGB(22, 22, 28),
    SectionBg = Color3.fromRGB(28, 28, 35),
    Accent = Color3.fromRGB(138, 43, 226),
    TextMain = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(150, 150, 160)
}

local SG = Instance.new("ScreenGui")
SG.Name = guiName
SG.ResetOnSpawn = false
pcall(function() SG.Parent = CoreGui end)
if not SG.Parent then SG.Parent = LP:WaitForChild("PlayerGui") end

local Main = Instance.new("Frame", SG)
Main.Size, Main.Position, Main.BackgroundColor3 = UDim2.new(0, 600, 0, 420), UDim2.new(0.5, -300, 0.5, -210), Colors.MainBg
Main.Active, Main.Draggable, Main.ClipsDescendants = true, true, true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", Main).Color = Colors.Accent
Instance.new("UIStroke", Main).Thickness = 1.5

local TopBar = Instance.new("Frame", Main)
TopBar.Size, TopBar.BackgroundColor3 = UDim2.new(1, 0, 0, 45), Colors.SideBg
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", TopBar)
Title.Size, Title.Position, Title.BackgroundTransparency = UDim2.new(0, 250, 1, 0), UDim2.new(0, 15, 0, 0), 1
Title.Text, Title.TextColor3, Title.Font, Title.TextSize, Title.TextXAlignment = "⚡ Yudha Hub | Gemini AI (V14)", Colors.Accent, Enum.Font.GothamBlack, 13, Enum.TextXAlignment.Left

local OpenBtn = Instance.new("TextButton", SG)
OpenBtn.Size, OpenBtn.Position, OpenBtn.BackgroundColor3, OpenBtn.Visible, OpenBtn.Active, OpenBtn.Draggable = UDim2.new(0, 120, 0, 40), UDim2.new(0.02, 0, 0.4, 0), Colors.SideBg, false, true, true
OpenBtn.Text, OpenBtn.TextColor3, OpenBtn.Font, OpenBtn.TextSize = "⚡ Open Titan", Colors.Accent, Enum.Font.GothamBlack, 12
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", OpenBtn).Color = Colors.Accent

local MinBtn = Instance.new("TextButton", TopBar)
MinBtn.Size, MinBtn.Position, MinBtn.BackgroundColor3, MinBtn.Text, MinBtn.TextColor3, MinBtn.Font, MinBtn.TextSize = UDim2.new(0, 30, 0, 30), UDim2.new(1, -40, 0.5, -15), Colors.MainBg, "-", Colors.TextMain, Enum.Font.GothamBold, 18
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 8)

MinBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    OpenBtn.Visible = true
end)
-- ==========================================
-- BAGIAN 2: REVISED UI GENERATOR (FORCE LOAD)
-- ==========================================

local Tabs = {}
local function CreateTab(name, icon)
    -- Tombol Sidebar
    local TabBtn = Instance.new("TextButton", Sidebar)
    TabBtn.Size, TabBtn.BackgroundColor3, TabBtn.Text = UDim2.new(0.85, 0, 0, 35), Colors.MainBg, icon.."  "..name
    TabBtn.TextColor3, TabBtn.Font, TabBtn.TextSize = Colors.TextDark, Enum.Font.GothamBold, 12
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)
    
    -- Halaman Konten
    local Scroll = Instance.new("ScrollingFrame", ContentArea)
    Scroll.Size, Scroll.BackgroundTransparency, Scroll.ScrollBarThickness, Scroll.Visible = UDim2.new(1, 0, 1, 0), 1, 3, false
    Scroll.CanvasSize = UDim2.new(0, 0, 0, 1000)
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

-- Force Inisialisasi Tab
local TabFarm = CreateTab("Farming", "⚔️")
local TabMove = CreateTab("Movement", "🏃")

-- Inisialisasi Tampilan Awal (Paksa Muncul)
task.spawn(function()
    task.wait(0.5) -- Tunggu sebentar agar UI ter-parenting dengan benar
    if Tabs[1] then
        Tabs[1].Btn.BackgroundColor3 = Colors.Accent
        Tabs[1].Btn.TextColor3 = Colors.TextMain
        Tabs[1].Page.Visible = true
    end
end)

-- Komponen UI (Toggle & Slider)
local function AddToggle(parent, txt, stateKey, cb)
    local btn = Instance.new("TextButton", parent)
    btn.Size, btn.BackgroundColor3, btn.Text = UDim2.new(0.95, 0, 0, 45), Colors.SectionBg, ""
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local lbl = Instance.new("TextLabel", btn)
    lbl.Size, lbl.Position, lbl.Text = UDim2.new(0.7, 0, 1, 0), UDim2.new(0, 15, 0, 0), txt
    lbl.BackgroundTransparency, lbl.TextColor3, lbl.Font = 1, Colors.TextMain, Enum.Font.GothamMedium
    
    btn.MouseButton1Click:Connect(function()
        State[stateKey] = not State[stateKey]
        btn.BackgroundColor3 = State[stateKey] and Colors.Accent or Colors.SectionBg
        if cb then pcall(function() cb(State[stateKey]) end) end
    end)
end

-- Tambahkan komponen ke Tab
AddToggle(TabFarm, "Auto Farm (ORI Stable)", "AutoFarm")
AddToggle(TabFarm, "Aura Magnet Loot", "Magnet")
AddToggle(TabMove, "Toggle Fly", "Fly")
AddToggle(TabMove, "Infinite Jump", "InfJ")

-- ==========================================
-- BAGIAN 3: TITAN ENGINE & LOGIC
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
            if (m.Position - h).Magnitude <= i then return false end
        end
    end
    return true
end

RunService.Heartbeat:Connect(function()
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

UserInputService.JumpRequest:Connect(function()
    if State.InfJ and LP.Character then
        local hum = LP.Character:FindFirstChildWhichIsA("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

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
                                    prompt.HoldDuration = 0
                                    prompt.MaxActivationDistance = 9e9
                                    fireproximityprompt(prompt)
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
