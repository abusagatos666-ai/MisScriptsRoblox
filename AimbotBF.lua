-- [[ JD_PVP - XENO OPTIMIZED ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local RunService = game:GetService("RunService")

-- 1. LIMPIEZA AUTOMÁTICA (Específica para Xeno)
local function Cleanup()
    for _, v in pairs(game:GetService("CoreGui"):GetChildren()) do
        if v.Name == "JD_PVP_XENO" then
            v:Destroy()
        end
    end
end
Cleanup()

_G.JD_ENABLED = false

-- 2. INTERFAZ JD_PVP
local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
gui.Name = "JD_PVP_XENO"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 180, 0, 100)
main.Position = UDim2.new(0.1, 0, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)

-- Nombre oficial: JD_PVP
local title = Instance.new("TextLabel", main)
title.Text = "JD_PVP"
title.Size = UDim2.new(1, 0, 0, 30)
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18

-- Botón X (Cerrar)
local close = Instance.new("TextButton", main)
close.Size = UDim2.new(0, 25, 0, 25)
close.Position = UDim2.new(0, 5, 0, 5)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
close.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", close)

-- Botón Toggle
local toggle = Instance.new("TextButton", main)
toggle.Size = UDim2.new(0, 150, 0, 45)
toggle.Position = UDim2.new(0.5, -75, 0, 45)
toggle.Text = "AIMBOT: OFF"
toggle.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", toggle)

-- 3. LÓGICA DE APUNTADO
local function getClosest()
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

-- 4. FUNCIONES DE BOTONES
close.MouseButton1Click:Connect(function()
    _G.JD_ENABLED = false
    gui:Destroy()
end)

toggle.MouseButton1Click:Connect(function()
    _G.JD_ENABLED = not _G.JD_ENABLED
    toggle.Text = _G.JD_ENABLED and "AIMBOT: ON" or "AIMBOT: OFF"
    toggle.BackgroundColor3 = _G.JD_ENABLED and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(55, 55, 55)
end)

-- 5. SILENT AIM (Redirección de Hit/Target para Xeno)
-- Usamos un método que no da error "nil value" en PC
local target = nil
RunService.Heartbeat:Connect(function()
    if _G.JD_ENABLED then
        target = getClosest()
    end
end)

local mt = getrawmetatable(game)
local oldIndex = mt.__index
setreadonly(mt, false)

mt.__index = newcclosure(function(t, k)
    if _G.JD_ENABLED and t == Mouse and (k == "Hit" or k == "Target") then
        if target then
            return (k == "Hit" and target.CFrame or target.Parent)
        end
    end
    return oldIndex(t, k)
end)

setreadonly(mt, true)
