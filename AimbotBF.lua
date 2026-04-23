-- [[ JD_PVP FINAL STABLE ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local RunService = game:GetService("RunService")

_G.JD_ENABLED = false

-- 1. LIMPIEZA DE MENÚS ANTERIORES (Para que no salgan 3 como en tu foto)
if game.CoreGui:FindFirstChild("JD_PVP_GUI") then
    game.CoreGui.JD_PVP_GUI:Destroy()
end

-- 2. CREACIÓN DE INTERFAZ JD_PVP
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "JD_PVP_GUI"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 180, 0, 100)
main.Position = UDim2.new(0.1, 0, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.Active = true
main.Draggable = true -- Para que lo muevas donde quieras

-- Botón X (Superior Izquierda)
local close = Instance.new("TextButton", main)
close.Size = UDim2.new(0, 25, 0, 25)
close.Position = UDim2.new(0, 5, 0, 5)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
close.TextColor3 = Color3.new(1, 1, 1)

-- Título JD_PVP
local title = Instance.new("TextLabel", main)
title.Text = "JD_PVP"
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 5)
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold

-- Botón de Activación
local toggle = Instance.new("TextButton", main)
toggle.Size = UDim2.new(0, 150, 0, 45)
toggle.Position = UDim2.new(0, 15, 0, 45)
toggle.Text = "SILENT AIM: OFF"
toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggle.TextColor3 = Color3.new(1, 1, 1)

-- 3. LÓGICA DE APUNTADO (SILENT AIM)
local function getTarget()
    local closest = nil
    local dist = 500
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            -- Verificación segura de salud para evitar errores en consola
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local mag = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                if mag < dist then
                    dist = mag
                    closest = p.Character.HumanoidRootPart
                end
            end
        end
    end
    return closest
end

-- 4. CONEXIÓN DE BOTONES
close.MouseButton1Click:Connect(function()
    gui:Destroy()
    _G.JD_ENABLED = false
end)

toggle.MouseButton1Click:Connect(function()
    _G.JD_ENABLED = not _G.JD_ENABLED
    toggle.Text = _G.JD_ENABLED and "SILENT AIM: ON" or "SILENT AIM: OFF"
    toggle.BackgroundColor3 = _G.JD_ENABLED and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 60)
end)

-- 5. REDIRECCIÓN DE HABILIDADES (Solo cuando está en ON)
local target = nil
RunService.Stepped:Connect(function()
    if _G.JD_ENABLED then
        target = getTarget()
    end
end)

-- El "Silent Aim" que no mueve la cámara
local oldIndex
oldIndex = hookmetamethod(game, "__index", function(self, index)
    if _G.JD_ENABLED and self == Mouse and (index == "Hit" or index == "Target") and target then
        return (index == "Hit" and target.CFrame or target.Parent)
    end
    return oldIndex(self, index)
end)
