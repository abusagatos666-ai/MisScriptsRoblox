-- [[ JD_PVP - TOTAL FIX ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

_G.JD_PVP_STATUS = false

-- [[ INTERFAZ MEJORADA ]] --
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "JD_PVP_STABLE"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 180, 0, 100)
Main.Position = UDim2.new(0.1, 0, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)

-- Botón Cerrar (X)
local CloseBtn = Instance.new("TextButton", Main)
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(0, 5, 0, 5)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", CloseBtn)

local Title = Instance.new("TextLabel", Main)
Title.Text = "JD_PVP"
Title.Size = UDim2.new(1, 0, 0, 35)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18

local Toggle = Instance.new("TextButton", Main)
Toggle.Size = UDim2.new(0, 150, 0, 40)
Toggle.Position = UDim2.new(0.5, -75, 0, 45)
Toggle.Text = "AIMBOT: OFF"
Toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Toggle.TextColor3 = Color3.new(1, 1, 1)
Toggle.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", Toggle)

-- [[ LÓGICA DE APUNTADO REAL ]] --

local function getTarget()
    local closest = nil
    local dist = 600 -- Rango de píxeles/distancia

    -- Revisar todos los personajes de jugadores
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local mag = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                if mag < dist then
                    dist = mag
                    closest = p.Character.HumanoidRootPart
                end
            end
        end
    end

    -- Revisar NPCs (Solo si no encontró jugadores cerca)
    if not closest then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                if v ~= LocalPlayer.Character and v.Humanoid.Health > 0 then
                    local mag = (LocalPlayer.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
                    if mag < dist then
                        dist = mag
                        closest = v.HumanoidRootPart
                    end
                end
            end
        end
    end
    return closest
end

-- Configuración de botones
CloseBtn.MouseButton1Click:Connect(function()
    _G.JD_PVP_STATUS = false
    ScreenGui:Destroy()
end)

Toggle.MouseButton1Click:Connect(function()
    _G.JD_PVP_STATUS = not _G.JD_PVP_STATUS
    Toggle.Text = _G.JD_PVP_STATUS and "AIMBOT: ON" or "AIMBOT: OFF"
    Toggle.BackgroundColor3 = _G.JD_PVP_STATUS and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(50, 50, 50)
end)

-- Ejecución sin errores
RunService.RenderStepped:Connect(function()
    if _G.JD_PVP_STATUS then
        -- pcall evita que cualquier error salga en la consola
        pcall(function()
            local target = getTarget()
            if target then
                -- Forzar la cámara a mirar al objetivo (CFrame)
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
            end
        end)
    end
end)
