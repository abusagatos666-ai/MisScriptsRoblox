-- Limpiar guis anteriores si existen
local oldGui = game:GetService("CoreGui"):FindFirstChild("UtilityMenu")
if oldGui then oldGui:Destroy() end

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer

-- Interfaz Principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UtilityMenu"
screenGui.Parent = CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 220)
mainFrame.Position = UDim2.new(0.1, 0, 0.4, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

Instance.new("UICorner", mainFrame).CornerRadius = RaycastParams.new().FilterType == Enum.RaycastFilterType.Exclude and UDim.new(0, 8) or UDim.new(0,8)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.Text = "MOD MENU"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = mainFrame

-- Función para crear botones rápido
local function crearBtn(txt, pos, color)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 180, 0, 35)
    b.Position = pos
    b.Text = txt
    b.BackgroundColor3 = color
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.Gotham
    b.TextSize = 13
    b.Parent = mainFrame
    Instance.new("UICorner", b)
    return b
end

local btnWater = crearBtn("Caminar Agua: OFF", UDim2.new(0, 10, 0, 45), Color3.fromRGB(45, 85, 155))
local btnESP = crearBtn("Ver Jugadores: OFF", UDim2.new(0, 10, 0, 90), Color3.fromRGB(155, 45, 45))
local btnTP = crearBtn("TP Jugador (Tecla T)", UDim2.new(0, 10, 0, 135), Color3.fromRGB(45, 155, 85))

-- 1. Lógica Agua
local waterOn = false
local plat = Instance.new("Part")
plat.Size = Vector3.new(10, 1, 10)
plat.Anchored = true
plat.Transparency = 1
plat.Parent = workspace

btnWater.MouseButton1Click:Connect(function()
    waterOn = not waterOn
    btnWater.Text = "Caminar Agua: " .. (waterOn and "ON" or "OFF")
end)

RunService.RenderStepped:Connect(function()
    if waterOn and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = localPlayer.Character.HumanoidRootPart
        local ray = Ray.new(hrp.Position, Vector3.new(0, -6, 0))
        local hit, pos, mat = workspace:FindPartOnRayWithIgnoreList(ray, {localPlayer.Character, plat})
        if hit and mat == Enum.Material.Water then
            plat.CFrame = CFrame.new(hrp.Position.X, pos.Y, hrp.Position.Z)
            plat.CanCollide = true
        else
            plat.CanCollide = false
        end
    else
        plat.CanCollide = false
    end
end)

-- 2. Lógica ESP (Nombres)
local espOn = false
btnESP.MouseButton1Click:Connect(function()
    espOn = not espOn
    btnESP.Text = "Ver Jugadores: " .. (espOn and "ON" or "OFF")
end)

local function updateESP()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= localPlayer and p.Character and p.Character:FindFirstChild("Head") then
            local head = p.Character.Head
            local gui = head:FindFirstChild("ESPTag")
            if not gui then
                gui = Instance.new("BillboardGui", head)
                gui.Name = "ESPTag"
                gui.Size = UDim2.new(0, 100, 0, 20)
                gui.AlwaysOnTop = true
                gui.StudsOffset = Vector3.new(0, 3, 0)
                local t = Instance.new("TextLabel", gui)
                t.Size = UDim2.new(1, 0, 1, 0)
                t.BackgroundTransparency = 1
                t.TextColor3 = Color3.new(1, 0, 0)
                t.TextStrokeTransparency = 0
                t.Text = p.Name
            end
            gui.Enabled = espOn
        end
    end
end
RunService.RenderStepped:Connect(updateESP)

-- 3. Lógica Teletransporte
local function tpToPlayer()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= localPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            localPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
            break
        end
    end
end

btnTP.MouseButton1Click:Connect(tpToPlayer)
UIS.InputBegan:Connect(function(i, p)
    if not p and i.KeyCode == Enum.KeyCode.T then tpToPlayer() end
end)
