local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

_G.AimbotEnabled = false

-- [[ INTERFAZ MEJORADA ]] --
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 180, 0, 90)
MainFrame.Position = UDim2.new(0.1, 0, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Active = true
MainFrame.Draggable = true

local ToggleBtn = Instance.new("TextButton", MainFrame)
ToggleBtn.Size = UDim2.new(0, 160, 0, 40)
ToggleBtn.Position = UDim2.new(0, 10, 0, 40)
ToggleBtn.Text = "Aimbot: OFF"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
ToggleBtn.TextColor3 = Color3.new(1,1,1)

Instance.new("TextLabel", MainFrame).Text = "PVP SECTION V2"
MainFrame.TextLabel.Size = UDim2.new(1, 0, 0, 30)
MainFrame.TextLabel.TextColor3 = Color3.new(1,1,1)
MainFrame.TextLabel.BackgroundTransparency = 1

-- [[ FUNCIÓN DE BÚSQUEDA AGRESIVA ]] --
local function getTarget()
    local closest = nil
    local dist = math.huge

    -- Buscamos en enemigos y otros jugadores
    local potentialTargets = {}
    
    -- Añadir jugadores
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            table.insert(potentialTargets, p.Character)
        end
    end
    
    -- Añadir NPCs (Blox Fruits los pone en Workspace o en carpetas de enemigos)
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
            if v:FindFirstChild("HumanoidRootPart") and v ~= LocalPlayer.Character then
                table.insert(potentialTargets, v)
            end
        end
    end

    for _, t in pairs(potentialTargets) do
        local mag = (LocalPlayer.Character.HumanoidRootPart.Position - t.HumanoidRootPart.Position).Magnitude
        if mag < dist then
            dist = mag
            closest = t
        end
    end
    return closest
end

-- [[ LÓGICA DE ACTIVACIÓN ]] --
ToggleBtn.MouseButton1Click:Connect(function()
    _G.AimbotEnabled = not _G.AimbotEnabled
    ToggleBtn.Text = _G.AimbotEnabled and "Aimbot: ON" or "Aimbot: OFF"
    ToggleBtn.BackgroundColor3 = _G.AimbotEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
end)

-- [[ BUCLE DE SEGUIMIENTO ]] --
RunService.RenderStepped:Connect(function()
    if _G.AimbotEnabled then
        local enemy = getTarget()
        if enemy and enemy:FindFirstChild("HumanoidRootPart") then
            -- Esto forzará tu cámara a mirar al enemigo siempre
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, enemy.HumanoidRootPart.Position)
        end
    end
end)
