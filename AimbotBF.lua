-- [[ SEA FARM V1 - CONFIGURACIÓN ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- 1. LIMPIEZA
for _, v in pairs(game.CoreGui:GetChildren()) do
    if v.Name == "SeaFarm_G" then v:Destroy() end
end

-- 2. INTERFAZ
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "SeaFarm_G"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 200, 0, 150)
main.Position = UDim2.new(0.1, 0, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 30) -- Color azul oscuro para Sea Farm
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)

local title = Instance.new("TextLabel", main)
title.Text = "SEA FARM - TP [T]"
title.Size = UDim2.new(1, 0, 0, 35)
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18

-- Función para botones rápida (Igual a la tuya)
local function createBtn(pos, text)
    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.new(0, 180, 0, 40)
    btn.Position = UDim2.new(0.5, -90, 0, pos)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    Instance.new("UICorner", btn)
    return btn
end

local btnTP = createBtn(50, "TP A JUGADOR")
local infoLabel = Instance.new("TextLabel", main)
infoLabel.Size = UDim2.new(1, 0, 0, 30)
infoLabel.Position = UDim2.new(0, 0, 0, 100)
infoLabel.Text = "AGUA: AUTO-ACTIVADO"
infoLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
infoLabel.BackgroundTransparency = 1
infoLabel.Font = Enum.Font.SourceSansBold

-- 3. LÓGICA CAMINAR AGUA (SE ACTIVA AL EJECUTAR)
local plat = Instance.new("Part", workspace)
plat.Name = "SeaFarm_WaterPlatform"
plat.Size = Vector3.new(25, 1, 25)
plat.Anchored = true
plat.Transparency = 1 -- Invisible para que no moleste

-- 4. FUNCIÓN TELEPORT (Basada en tu lógica de búsqueda)
local function teleportToPlayer()
    local target = nil
    local shortestDist = math.huge
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
            if dist < shortestDist then
                shortestDist = dist
                target = p.Character.HumanoidRootPart
            end
        end
    end
    
    if target then
        LocalPlayer.Character.HumanoidRootPart.CFrame = target.CFrame * CFrame.new(0, 0, 3)
    end
end

-- Botón TP
btnTP.MouseButton1Click:Connect(function()
    teleportToPlayer()
end)

-- Tecla T asignada para TP
UserInputService.InputBegan:Connect(function(input, proc)
    if not proc and input.KeyCode == Enum.KeyCode.T then
        teleportToPlayer()
