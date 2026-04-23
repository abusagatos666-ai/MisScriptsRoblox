-- [[ JD_PVP V13 - SILENT SNAP ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local RunService = game:GetService("RunService")

-- 1. LIMPIEZA AUTOMÁTICA (Evita que se duplique el menú)
for _, v in pairs(game.CoreGui:GetChildren()) do
    if v.Name == "JD_PVP_GUI" then v:Destroy() end
end

_G.JD_STATUS = false

-- 2. INTERFAZ JD_PVP
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "JD_PVP_GUI"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 180, 0, 100)
main.Position = UDim2.new(0.1, 0, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)

local close = Instance.new("TextButton", main)
close.Size = UDim2.new(0, 25, 0, 25)
close.Position = UDim2.new(0, 5, 0, 5)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
close.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", close)

local title = Instance.new("TextLabel", main)
title.Text = "JD_PVP"
title.Size = UDim2.new(1, 0, 0, 30)
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold

local toggle = Instance.new("TextButton", main)
toggle.Size = UDim2.new(0, 150, 0, 45)
toggle.Position = UDim2.new(0.5, -75, 0, 45)
toggle.Text = "SNAP AIM: OFF"
toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggle.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", toggle)

-- 3. FUNCIÓN DE BÚSQUEDA SEGURA
local function getTarget()
    local target = nil
    local dist = 600
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local mag = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                if mag < dist then
                    dist = mag
                    target = p.Character.HumanoidRootPart
                end
            end
        end
    end
    return target
end

-- 4. CONTROL DE BOTONES
close.MouseButton1Click:Connect(function()
    _G.JD_STATUS = false
    gui:Destroy()
end)

toggle.MouseButton1Click:Connect(function()
    _G.JD_STATUS = not _G.JD_STATUS
    toggle.Text = _G.JD_STATUS and "SNAP AIM: ON" or "SNAP AIM: OFF"
    toggle.BackgroundColor3 = _G.JD_STATUS and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(50, 50, 50)
end)

-- 5. LÓGICA DE REDIRECCIÓN (Sin mover cámara)
local oldIndex
oldIndex = hookmetamethod(game, "__index", function(self, index)
    -- Si el script está en ON y el juego pregunta por la posición del mouse (Hit)
    if _G.JD_STATUS and self == Mouse and (index == "Hit" or index == "Target") then
        local enemy = getTarget()
        if enemy then
            -- El cursor "salta" internamente al enemigo solo en el cálculo del ataque
            return (index == "Hit" and enemy.CFrame or enemy.Parent)
        end
    end
    return oldIndex(self, index)
end)

print("JD_PVP V13 cargado. Silent Aim activo para M1 y Habilidades.")
