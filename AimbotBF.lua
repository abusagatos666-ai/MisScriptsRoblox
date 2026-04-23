-- [[ JD_PVP V15 - XENO PC KEYBIND ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- 1. LIMPIEZA
for _, v in pairs(game.CoreGui:GetChildren()) do
    if v.Name == "JD_PVP_KEY" then v:Destroy() end
end

_G.JD_STATUS = false
_G.JD_KEY = Enum.KeyCode.Q -- <--- AQUÍ PUEDES CAMBIAR LA TECLA (Por defecto: Q)

-- 2. INTERFAZ
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "JD_PVP_KEY"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 200, 0, 130)
main.Position = UDim2.new(0.1, 0, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
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
close.Size = UDim2.new(0, 25, 0, 25)
close.Position = UDim2.new(0, 5, 0, 5)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
close.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", close)

local toggle = Instance.new("TextButton", main)
toggle.Size = UDim2.new(0, 160, 0, 40)
toggle.Position = UDim2.new(0.5, -80, 0, 45)
toggle.Text = "AIMBOT [Q]: OFF"
toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", toggle)

local info = Instance.new("TextLabel", main)
info.Size = UDim2.new(1, 0, 0, 25)
info.Position = UDim2.new(0, 0, 0, 90)
info.Text = "Presiona Q para Activar"
info.TextColor3 = Color3.fromRGB(150, 150, 150)
info.BackgroundTransparency = 1
info.TextSize = 12

-- 3. FUNCIÓN PARA BUSCAR ENEMIGO
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

-- 4. FUNCIÓN TOGGLE (Activar/Desactivar)
local function toggleAim()
    _G.JD_STATUS = not _G.JD_STATUS
    toggle.Text = _G.JD_STATUS and "AIMBOT [Q]: ON" or "AIMBOT [Q]: OFF"
    toggle.BackgroundColor3 = _G.JD_STATUS and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(50, 50, 50)
end

-- 5. DETECCIÓN DE TECLA Y BOTONES
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == _G.JD_KEY then
        toggleAim()
    end
end)

toggle.MouseButton1Click:Connect(toggleAim)

close.MouseButton1Click:Connect(function()
    _G.JD_STATUS = false
    gui:Destroy()
end)

-- 6. EL AIMBOT (Mueve la cámara al jugador)
RunService.RenderStepped:Connect(function()
    if _G.JD_STATUS then
        local t = getTarget()
        if t then
            -- Mueve la cámara suavemente hacia el enemigo
            local targetPos = t.Position + Vector3.new(0, 1.5, 0) -- Apunta un poco arriba del torso
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)
        end
    end
end)
