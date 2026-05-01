-- [[ JD_PVP V18 - VERSIÓN FINAL REPARADA ]] --
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
_G.JUMP_STATUS = false
_G.TARGET_SPEED = 24.5 -- Velocidad balanceada para evitar reportes
_G.JD_KEY = Enum.KeyCode.G 

-- 2. INTERFAZ (Nombre y Botón X restaurados)
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "JD_PVP_G"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 200, 0, 160) -- Tamaño original
main.Position = UDim2.new(0.1, 0, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)

local title = Instance.new("TextLabel", main)
title.Text = "JD_PVP V18 - KEY [G]" -- Nombre original restaurado
title.Size = UDim2.new(1, 0, 0, 35)
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold

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

local btnJump = createBtn(50, "SUPER SALTO: OFF")
local btnAim = createBtn(100, "AIMBOT [G]: OFF")

-- Botón de cerrar (X) restaurado
local close = Instance.new("TextButton", main)
close.Size = UDim2.new(0, 25, 0, 25)
close.Position = UDim2.new(1, -30, 0, 5)
close.Text = "X"
close.TextColor3 = Color3.new(1, 1, 1)
close.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
Instance.new("UICorner", close)

close.MouseButton1Click:Connect(function() 
    gui:Destroy() 
    _G.JD_STATUS = false 
    _G.JUMP_STATUS = false
end)

-- 3. DETECCIÓN
UserInputService.InputBegan:Connect(function(input, proc)
    if not proc and input.KeyCode == _G.JD_KEY then
        _G.JD_STATUS = not _G.JD_STATUS
        btnAim.Text = _G.JD_STATUS and "AIMBOT [G]: ON" or "AIMBOT [G]: OFF"
        btnAim.BackgroundColor3 = _G.JD_STATUS and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(40, 40, 40)
    end
end)

btnJump.MouseButton1Click:Connect(function()
    _G.JUMP_STATUS = not _G.JUMP_STATUS
    btnJump.Text = _G.JUMP_STATUS and "SUPER SALTO: ON" or "SUPER SALTO: OFF"
    btnJump.BackgroundColor3 = _G.JUMP_STATUS and Color3.fromRGB(150, 0, 255) or Color3.fromRGB(40, 40, 40)
end)

-- 4. BUCLE DE MOVIMIENTO Y FUNCIONES
RunService.PreRender:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
        
        -- Movimiento Bypass Seguro
        if char.Humanoid.MoveDirection.Magnitude > 0 then
            char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + (char.Humanoid.MoveDirection * (_G.TARGET_SPEED / 45))
        end

        -- Super Salto original
        if _G.JUMP_STATUS and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            char.HumanoidRootPart.Velocity = Vector3.new(char.HumanoidRootPart.Velocity.X, 400, char.HumanoidRootPart.Velocity.Z)
        end

        -- Aimbot con G
        if _G.JD_STATUS then
            local target = nil
            local dist = 700
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character.Humanoid.Health > 0 then
                    local m = (char.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                    if m < dist then dist = m target = p.Character.HumanoidRootPart end
                end
            end
            if target then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position + Vector3.new(0, 1, 0))
            end
        end
    end
end
