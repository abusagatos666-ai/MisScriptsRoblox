-- [[ JD_PVP - MOVIMIENTO Y AIMBOT ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- LIMPIEZA
for _, v in pairs(game.CoreGui:GetChildren()) do
    if v.Name == "JD_PVP_MOVE" then v:Destroy() end
end

_G.JD_STATUS = false
_G.SPEED_STATUS = false
_G.FLY_STATUS = false
_G.JD_KEY = Enum.KeyCode.Q

-- INTERFAZ
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "JD_PVP_MOVE"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 200, 0, 180)
main.Position = UDim2.new(0.1, 0, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)

local title = Instance.new("TextLabel", main)
title.Text = "JD_PVP"
title.Size = UDim2.new(1, 0, 0, 30)
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1

-- BOTÓN VELOCIDAD (Speed)
local btnSpeed = Instance.new("TextButton", main)
btnSpeed.Size = UDim2.new(0, 160, 0, 30)
btnSpeed.Position = UDim2.new(0.5, -80, 0, 40)
btnSpeed.Text = "VELOCIDAD: OFF"
btnSpeed.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
btnSpeed.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", btnSpeed)

-- BOTÓN VUELO (Sky High)
local btnFly = Instance.new("TextButton", main)
btnFly.Size = UDim2.new(0, 160, 0, 30)
btnFly.Position = UDim2.new(0.5, -80, 0, 80)
btnFly.Text = "SUBIR ALTO: OFF"
btnFly.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
btnFly.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", btnFly)

-- BOTÓN AIMBOT ESTADO
local btnAim = Instance.new("TextButton", main)
btnAim.Size = UDim2.new(0, 160, 0, 30)
btnAim.Position = UDim2.new(0.5, -80, 0, 120)
btnAim.Text = "AIMBOT [Q]: OFF"
btnAim.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
btnAim.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", btnAim)

-- LÓGICA DE MOVIMIENTO
btnSpeed.MouseButton1Click:Connect(function()
    _G.SPEED_STATUS = not _G.SPEED_STATUS
    btnSpeed.Text = _G.SPEED_STATUS and "VELOCIDAD: ON" or "VELOCIDAD: OFF"
    btnSpeed.BackgroundColor3 = _G.SPEED_STATUS and Color3.fromRGB(0, 120, 200) or Color3.fromRGB(50, 50, 50)
end)

btnFly.MouseButton1Click:Connect(function()
    _G.FLY_STATUS = not _G.FLY_STATUS
    btnFly.Text = _G.FLY_STATUS and "SUBIR ALTO: ON" or "SUBIR ALTO: OFF"
    btnFly.BackgroundColor3 = _G.FLY_STATUS and Color3.fromRGB(200, 150, 0) or Color3.fromRGB(50, 50, 50)
end)

-- SISTEMA DE TECLA PARA AIMBOT
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == _G.JD_KEY then
        _G.JD_STATUS = not _G.JD_STATUS
        btnAim.Text = _G.JD_STATUS and "AIMBOT [Q]: ON" or "AIMBOT [Q]: OFF"
        btnAim.BackgroundColor3 = _G.JD_STATUS and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(40, 40, 40)
    end
end)

-- LOOP PRINCIPAL (Aquí ocurre la magia)
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        -- Velocidad Rápida
        if _G.SPEED_STATUS then
            char.Humanoid.WalkSpeed = 60 -- Valor seguro pero rápido
        else
            char.Humanoid.WalkSpeed = 16
        end
        
        -- Subir Alto (Sky Jump / Fly)
        if _G.FLY_STATUS then
            char.HumanoidRootPart.Velocity = Vector3.new(0, 100, 0) -- Te impulsa hacia arriba rápido
        end
        
        -- Aimbot (Cámara)
        if _G.JD_STATUS then
            local target = nil
            local dist = 600
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    if p.Character.Humanoid.Health > 0 then
                        local m = (char.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                        if m < dist then dist = m target = p.Character.HumanoidRootPart end
                    end
                end
            end
            if target then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
            end
        end
    end
end)

-- BOTÓN CERRAR
local close = Instance.new("TextButton", main)
close.Size = UDim2.new(0, 20, 0, 20)
close.Text = "X"
close.Position = UDim2.new(0, 5, 0, 5)
close.BackgroundColor3 = Color3.fromRGB(200,0,0)
close.MouseButton1Click:Connect(function() gui:Destroy() _G.JD_STATUS = false end)
