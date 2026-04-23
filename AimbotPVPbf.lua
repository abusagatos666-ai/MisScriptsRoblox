-- Definición de variables principales
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = game:GetService("Workspace").CurrentCamera

local target = nil
local aimbotEnabled = false

-- Función para encontrar al enemigo más cercano (NPC o Jugador)
local function getClosestEntity()
    local closest = nil
    local maxDistance = math.huge -- Infinito inicialmente

    -- Buscamos en el Workspace (donde están los NPCs y Jugadores)
    for _, obj in pairs(game.Workspace.Enemies:GetChildren()) do -- En Blox Fruits los NPCs suelen estar en 'Enemies'
        if obj:FindFirstChild("HumanoidRootPart") and obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 then
            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - obj.HumanoidRootPart.Position).Magnitude
            if distance < maxDistance then
                closest = obj
                maxDistance = distance
            end
        end
    end
    return closest
end

-- Bucle que mueve la cámara hacia el objetivo
RunService.RenderStepped:Connect(function()
    if aimbotEnabled and target and target:FindFirstChild("HumanoidRootPart") then
        -- Suavizamos el movimiento de la cámara hacia la cabeza o torso del enemigo
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.HumanoidRootPart.Position)
    end
end)

-- Control de encendido/apagado con la tecla "Q"
Mouse.KeyDown:Connect(function(key)
    if key == "q" then
        aimbotEnabled = not aimbotEnabled
        if aimbotEnabled then
            target = getClosestEntity()
            print("Aimbot Activado en: " .. (target and target.Name or "Nada"))
        else
            target = nil
            print("Aimbot Desactivado")
        end
    end
end)
