-- [[ JD_PVP - NO ERRORS EDITION ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- 1. LIMPIEZA DE INTERFAZ
for _, v in pairs(game.CoreGui:GetChildren()) do
    if v.Name == "JD_PVP_GUI" then v:Destroy() end
end

_G.JD_STATUS = false

-- 2. INTERFAZ JD_PVP
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "JD_PVP_GUI"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 160, 0, 90)
Main.Position = UDim2.new(0.1, 0, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.Active = true 
Main.Draggable = true
Instance.new("UICorner", Main)

local Title = Instance.new("TextLabel", Main)
Title.Text = "JD_PVP"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.SourceSansBold

local CloseBtn = Instance.new("TextButton", Main)
CloseBtn.Size = UDim2.new(0, 22, 0, 22)
CloseBtn.Position = UDim2.new(0, 2, 0, 2)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", CloseBtn)

local Toggle = Instance.new("TextButton", Main)
Toggle.Size = UDim2.new(0, 130, 0, 35)
Toggle.Position = UDim2.new(0.5, -65, 0, 40)
Toggle.Text = "AIMBOT: OFF"
Toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Toggle.TextColor3 = Color3.new(1, 1, 1)
Toggle.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", Toggle)

-- 3. BÚSQUEDA DE OBJETIVO (PVP)
local function getClosestPlayer()
    local target = nil
    local dist = 500
    -- Usamos pcall para evitar CUALQUIER error de consola
    pcall(function()
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
    end)
    return target
end

-- 4. CONTROL DE BOTONES
CloseBtn.MouseButton1Click:Connect(function()
    _G.JD_STATUS = false
    ScreenGui:Destroy()
end)

Toggle.MouseButton1Click:Connect(function()
    _G.JD_STATUS = not _G.JD_STATUS
    Toggle.Text = _G.JD_STATUS and "AIMBOT: ON" or "AIMBOT: OFF"
    Toggle.BackgroundColor3 = _G.JD_STATUS and Color3.fromRGB(0, 160, 0) or Color3.fromRGB(50, 50, 50)
end)

-- 5. AIMBOT SIN MOVER CÁMARA (SISTEMA DE PREDICCIÓN)
-- Este método redirige la "mirada" de tus ataques internamente
RunService.Stepped:Connect(function()
    if _G.JD_STATUS then
        local enemy = getClosestPlayer()
        if enemy then
            -- En lugar de hackear el mouse, forzamos al personaje a mirar ligeramente al objetivo
            -- Esto hace que el Acidum Rifle y habilidades peguen sin girar tu cámara principal
            local lookAt = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position, enemy.Position)
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position, Vector3.new(enemy.Position.X, LocalPlayer.Character.HumanoidRootPart.Position.Y, enemy.Position.Z))
        end
    end
end)
