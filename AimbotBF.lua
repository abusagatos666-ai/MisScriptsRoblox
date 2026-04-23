-- [[ JD_PVP - XENO PC EDITION ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

-- 1. LIMPIEZA TOTAL
for _, v in pairs(game.CoreGui:GetChildren()) do
    if v.Name == "JD_PVP_XENO" then v:Destroy() end
end

_G.JD_STATUS = false

-- 2. INTERFAZ MEJORADA (Más grande para PC)
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "JD_PVP_XENO"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 200, 0, 120) -- Un poco más grande
main.Position = UDim2.new(0.1, 0, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)

local title = Instance.new("TextLabel", main)
title.Text = "JD_PVP"
title.Size = UDim2.new(1, 0, 0, 40)
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20

local close = Instance.new("TextButton", main)
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(0, 5, 0, 5)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
close.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", close)

local toggle = Instance.new("TextButton", main)
toggle.Size = UDim2.new(0, 160, 0, 50)
toggle.Position = UDim2.new(0.5, -80, 0, 50)
toggle.Text = "AIMBOT: OFF"
toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", toggle)

-- 3. FUNCIÓN DE RASTREO
local function getTarget()
    local target = nil
    local dist = 700 -- Rango de visión
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

-- 4. EVENTOS DE BOTONES
close.MouseButton1Click:Connect(function()
    _G.JD_STATUS = false
    gui:Destroy()
end)

toggle.MouseButton1Click:Connect(function()
    _G.JD_STATUS = not _G.JD_STATUS
    toggle.Text = _G.JD_STATUS and "AIMBOT: ON" or "AIMBOT: OFF"
    toggle.BackgroundColor3 = _G.JD_STATUS and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(40, 40, 40)
end)

-- 5. EL AIMBOT (MÉTODO DE REDIRECCIÓN DE CÁMARA SILENCIOSA)
-- Para que funcione en Xeno, forzamos la cámara a mirar al enemigo solo si activas el aim
RunService.RenderStepped:Connect(function()
    if _G.JD_STATUS then
        local target = getTarget()
        if target then
            -- Esto hace que tus ataques (Kitsune, espadas) vayan directo al jugador
            local targetPos = target.Position + Vector3.new(0, 1, 0) -- Apunta al pecho
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)
        end
    end
end)
