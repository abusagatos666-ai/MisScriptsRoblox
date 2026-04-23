-- [[ JD_PVP - VERSIÓN DEFINITIVA ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local RunService = game:GetService("RunService")

-- 1. LIMPIEZA FORZADA (Para que no se amontonen los menús)
for _, v in pairs(game.CoreGui:GetChildren()) do
    if v.Name == "JD_PVP_GUI" then
        v:Destroy()
    end
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
main.Draggable = true -- Puedes moverlo
Instance.new("UICorner", main)

-- EL NOMBRE QUE PEDISTE: JD_PVP
local title = Instance.new("TextLabel", main)
title.Text = "JD_PVP"
title.Size = UDim2.new(1, 0, 0, 30)
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18

-- EL BOTÓN X QUE SÍ FUNCIONA
local close = Instance.new("TextButton", main)
close.Size = UDim2.new(0, 25, 0, 25)
close.Position = UDim2.new(0, 5, 0, 5)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
close.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", close)

local toggle = Instance.new("TextButton", main)
toggle.Size = UDim2.new(0, 150, 0, 45)
toggle.Position = UDim2.new(0.5, -75, 0, 45)
toggle.Text = "AIMBOT: OFF"
toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", toggle)

-- 3. BÚSQUEDA DE OBJETIVO (SOLO JUGADORES)
local function getTarget()
    local target = nil
    local dist = 600
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            -- Verificación de salud para evitar errores en consola
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

-- 4. CONEXIÓN DE BOTONES
close.MouseButton1Click:Connect(function()
    _G.JD_STATUS = false
    gui:Destroy()
end)

toggle.MouseButton1Click:Connect(function()
    _G.JD_STATUS = not _G.JD_STATUS
    toggle.Text = _G.JD_STATUS and "AIMBOT: ON" or "AIMBOT: OFF"
    toggle.BackgroundColor3 = _G.JD_STATUS and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(50, 50, 50)
end)

-- 5. SILENT AIM (REDIRECCIÓN DE ATAQUES)
-- Este método es el más estable y no debería darte errores
local target = nil
RunService.RenderStepped:Connect(function()
    if _G.JD_STATUS then
        target = getTarget()
    else
        target = nil
    end
end)

local mt = getrawmetatable(game)
setreadonly(mt, false)
local old = mt.__index

mt.__index = newcclosure(function(t, k)
    if _G.JD_STATUS and t == Mouse and (k == "Hit" or k == "Target") and target then
        return (k == "Hit" and target.CFrame or target.Parent)
    end
    return old(t, k)
end)
setreadonly(mt, true)
