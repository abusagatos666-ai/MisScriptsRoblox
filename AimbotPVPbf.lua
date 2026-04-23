-- [[ JD_PVP V17 - XENO EXTREME ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- LIMPIEZA
for _, v in pairs(game.CoreGui:GetChildren()) do
    if v.Name == "JD_PVP_EXTREME" then v:Destroy() end
end

_G.JD_STATUS = false
_G.SPEED_STATUS = false
_G.JUMP_STATUS = false
_G.JD_KEY = Enum.KeyCode.Q

-- INTERFAZ
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "JD_PVP_EXTREME"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 200, 0, 170)
main.Position = UDim2.new(0.1, 0, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)

local title = Instance.new("TextLabel", main)
title.Text = "JD_PVP EXTREME"
title.Size = UDim2.new(1, 0, 0, 35)
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold

-- BOTONES
local function createBtn(name, pos, text)
    local btn = Instance.new("TextButton", main)
    btn.Name = name
    btn.Size = UDim2.new(0, 180, 0, 35)
    btn.Position = UDim2.new(0.5, -90, 0, pos)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    Instance.new("UICorner", btn)
    return btn
end

local btnSpeed = createBtn("Speed", 40, "VELOCIDAD: OFF")
local btnJump = createBtn("Jump", 80, "SUPER SALTO: OFF")
local btnAim = createBtn("Aim", 120, "AIMBOT [Q]: OFF")

-- LOGICA DE ESTADOS
btnSpeed.MouseButton1Click:Connect(function()
    _G.SPEED_STATUS = not _G.SPEED_STATUS
    btnSpeed.Text = _G.SPEED_STATUS and "VELOCIDAD: ON" or "VELOCIDAD: OFF"
    btnSpeed.BackgroundColor3 = _G.SPEED_STATUS and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(45, 45, 45)
end)

btnJump.MouseButton1Click:Connect(function()
    _G.JUMP_STATUS = not _G.JUMP_STATUS
    btnJump.Text = _G.JUMP_STATUS and "SUPER SALTO: ON" or "SUPER SALTO: OFF"
    btnJump.BackgroundColor3 = _G.JUMP_STATUS and Color3.fromRGB(180, 0, 255) or Color3.fromRGB(45, 45, 45)
end)

btnAim.MouseButton1Click:Connect(function()
    _G.JD_STATUS = not _G.JD_STATUS
    btnAim.Text = _G.JD_STATUS and "AIMBOT [Q]: ON" or "AIMBOT [Q]: OFF"
    btnAim.BackgroundColor3 = _G.JD_STATUS and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(45, 45, 45)
end)

-- TECLA Q PARA EL AIMBOT
UserInputService.InputBegan:Connect(function(input, proc)
    if not proc and input.KeyCode == _G.JD_KEY then
        _G.JD_STATUS = not _G.JD_STATUS
        btnAim.Text = _G.JD_STATUS and "AIMBOT [Q]: ON" or "AIMBOT [Q]: OFF"
        btnAim.BackgroundColor3 = _G.JD_STATUS and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(45, 45, 45)
    end
end)

-- BUCLE DE CONTROL (Heartbeat es mejor para Xeno)
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart") then
        
        -- 1. Velocidad (Muy rápida)
        if _G.SPEED_STATUS then
            char.Humanoid.WalkSpeed = 120 -- Velocidad extrema
        else
            char.Humanoid.WalkSpeed = 16
        end

        -- 2. Super Salto (5 veces más rápido/alto)
        if _G.JUMP_STATUS then
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                char.HumanoidRootPart.Velocity = Vector3.new(char.HumanoidRootPart.Velocity.X, 250, char.HumanoidRootPart.Velocity.Z)
            end
        end

        -- 3. Aimbot (Corrección de activación)
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
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position + Vector3.new(0, 1, 0))
            end
        end
    end
end)

-- BOTON CERRAR
local close = Instance.new("TextButton", main)
close.Size = UDim2.new(0, 20, 0, 20)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
close.TextColor3 = Color3.new(1,1,1)
close.MouseButton1Click:Connect(function() gui:Destroy() _G.JD_STATUS = false end)
