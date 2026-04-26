--[[
    GitHub Project: Blox-Style Admin Utility
    Features: Water Walk, Global ESP, Player Teleport
]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer

-- --- CONFIGURACIÓN DE LA INTERFAZ ---
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UtilityMenu"
screenGui.Parent = (RunService:IsStudio() and localPlayer:WaitForChild("PlayerGui") or CoreGui)

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 250)
mainFrame.Position = UDim2.new(0, 50, 0.5, -125)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true -- Para que puedas mover el menú
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner", mainFrame)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "ADMIN PANEL"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = mainFrame

-- --- ESTILO DE BOTONES ---
local function crearBoton(texto, posicion, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 180, 0, 40)
    btn.Position = posicion
    btn.Text = texto
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Parent = mainFrame
    Instance.new("UICorner", btn)
    return btn
end

local btnWater = crearBoton("Water Walk: OFF", UDim2.new(0, 10, 0, 50), Color3.fromRGB(50, 50, 200))
local btnESP = crearBoton("Global ESP: OFF", UDim2.new(0, 10, 0, 100), Color3.fromRGB(200, 50, 50))
local btnTP = crearBoton("TP a Jugador (T)", UDim2.new(0, 10, 0, 150), Color3.fromRGB(50, 150, 50))

-- --- LÓGICA DE LAS FUNCIONES ---

-- 1. Water Walk
local waterEnabled = false
local platform = Instance.new("Part")
platform.Size = Vector3.new(8, 1, 8)
platform.Anchored = true
platform.Transparency = 1
platform.Parent = workspace

btnWater.MouseButton1Click:Connect(function()
    waterEnabled = not waterEnabled
    btnWater.Text = "Water Walk: " .. (waterEnabled and "ON" or "OFF")
end)

RunService.Heartbeat:Connect(function()
    if waterEnabled and localPlayer.Character then
        local hrp = localPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local ray = Ray.new(hrp.Position, Vector3.new(0, -6, 0))
            local hit, pos, mat = workspace:FindPartOnRayWithIgnoreList(ray, {localPlayer.Character, platform})
            if hit and mat == Enum.Material.Water then
                platform.CFrame = CFrame.new(hrp.Position.X, pos.Y, hrp.Position.Z)
                platform.CanCollide = true
            else
                platform.CanCollide = false
            end
        end
    else
        platform.CanCollide = false
    end
end)

-- 2. ESP
local espEnabled = false
btnESP.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    btnESP.Text = "Global ESP: " .. (espEnabled and "ON" or "OFF")
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("Head") then
            local gui = p.Character.Head:FindFirstChild("GlobalName")
            if gui then gui.Enabled = espEnabled end
        end
    end
end)

-- Función para aplicar el nombre (ESP)
local function applyESP(p)
    p.CharacterAdded:Connect(function(char)
        local head = char:WaitForChild("Head")
        local bgui = Instance.new("BillboardGui", head)
        bgui.Name = "GlobalName"
        bgui.Size = UDim2.new(0, 100, 0, 50)
        bgui.AlwaysOnTop = true
        bgui.Enabled = espEnabled
        bgui.StudsOffset = Vector3.new(0, 3, 0)
        local tl = Instance.new("TextLabel", bgui)
        tl.Size = UDim2.new(1, 0, 1, 0)
        tl.Text = p.Name
        tl.BackgroundTransparency = 1
        tl.TextColor3 = Color3.new(1, 1, 1)
        tl.TextStrokeTransparency = 0
    end)
end
for _, p in pairs(Players:GetPlayers()) do if p ~= localPlayer then applyESP(p) end end
Players.PlayerAdded:Connect(applyESP)

-- 3. Teleport a Jugadores
local function doTP()
    local allPlayers = Players:GetPlayers()
    for _, target in pairs(allPlayers) do
        if target ~= localPlayer and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            localPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
            break 
        end
    end
end

btnTP.MouseButton1Click:Connect(doTP)
UserInputService.InputBegan:Connect(function(input, proc)
    if not proc and input.KeyCode == Enum.KeyCode.T then doTP() end
end)
