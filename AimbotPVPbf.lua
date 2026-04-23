-- [[ JD_PVP V18 - CONFIGURACIÓN EXTREMA ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- 1. LIMPIEZA
for _, v in pairs(game.CoreGui:GetChildren()) do
    if v.Name == "JD_PVP_G" then v:Destroy() end
end

_G.JD_STATUS = false
_G.SPEED_STATUS = false
_G.JUMP_STATUS = false
_G.JD_KEY = Enum.KeyCode.G -- TECLA G ASIGNADA

-- 2. INTERFAZ
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "JD_PVP_G"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 200, 0, 160)
main.Position = UDim2.new(0.1, 0, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)

local title = Instance.new("TextLabel", main)
title.Text = "JD_PVP - KEY [G]"
title.Size = UDim2.new(1, 0, 0, 35)
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold

-- Función para botones rápida
local function createBtn(pos, text)
    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.new(0, 180, 0, 35)
    btn.Position = UDim2.new(0.5, -90, 0, pos)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    Instance.new("UICorner", btn)
    return btn
end

local btnSpeed = createBtn(40, "VELOCIDAD (150): OFF")
local btnJump = createBtn(80, "SUPER SALTO: OFF")
local btnAim = createBtn(120, "AIMBOT [G]: OFF")

-- 3. DETECCIÓN DE TECLA G (Fija y Directa)
UserInputService.InputBegan:Connect(function(input, proc)
    if not proc and input.KeyCode == _G.JD_KEY then
        _G.JD_STATUS = not _G.JD_STATUS
        btnAim.Text = _G.JD_STATUS and "AIMBOT [G]: ON" or "AIMBOT [G]: OFF"
        btnAim.BackgroundColor3 = _G.JD_STATUS and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(40, 40, 40)
    end
end)

-- Botones de la interfaz
btnSpeed.MouseButton1Click:Connect(function()
    _G.SPEED_STATUS = not _G.SPEED_STATUS
    btnSpeed.Text = _G.SPEED_STATUS and "VELOCIDAD: ON" or "VELOCIDAD: OFF"
    btnSpeed.BackgroundColor3 = _G.SPEED_STATUS and Color3.fromRGB(0, 100, 255) or Color3.fromRGB(40, 40, 40)
end)

btnJump.MouseButton1Click:Connect(function()
    _G.JUMP_STATUS = not _G.JUMP_STATUS
    btnJump.Text = _G.JUMP_STATUS and "SUPER SALTO: ON" or "SUPER SALTO: OFF"
    btnJump.BackgroundColor3 = _G.JUMP_STATUS and Color3.fromRGB(150, 0, 255) or Color3.fromRGB(40, 40, 40)
end)

-- 4. BUCLE PRINCIPAL
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart") then
        
        -- Velocidad a 150
        if _G.SPEED_STATUS then
            char.Humanoid.WalkSpeed = 150
        else
            char.Humanoid.WalkSpeed = 16
        end

        -- Super Salto Extremo (150 metros en 1 seg)
        if _G.JUMP_STATUS and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            -- Aplicamos una fuerza constante hacia arriba
            char.HumanoidRootPart.Velocity = Vector3.new(char.HumanoidRootPart.Velocity.X, 400, char.HumanoidRootPart.Velocity.Z)
        end

        -- Aimbot con la tecla G
        if _G.JD_STATUS then
            local target = nil
            local dist = 700
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

-- CERRAR
local close = Instance.new("TextButton", main)
close.Size = UDim2.new(0, 20, 0, 20)
close.Position = UDim2.new(0, 5, 0, 5)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
close.MouseButton1Click:Connect(function() gui:Destroy() _G.JD_STATUS = false end)
