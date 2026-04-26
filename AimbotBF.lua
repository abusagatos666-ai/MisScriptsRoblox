-- [[ SEA FARM V1 - OPTIMIZADO PARA XENO PC ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- 1. LIMPIEZA TOTAL
local function cleanup()
    local oldGui = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("SeaFarm_Xeno")
    if oldGui then oldGui:Destroy() end
    if workspace:FindFirstChild("SeaFarm_Platform") then
        workspace.SeaFarm_Platform:Destroy()
    end
end
cleanup()

-- 2. INTERFAZ (Usamos PlayerGui para Xeno)
local gui = Instance.new("ScreenGui")
gui.Name = "SeaFarm_Xeno"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Name = "MainFrame"
main.Size = UDim2.new(0, 200, 0, 150)
main.Position = UDim2.new(0.5, -100, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui

local corner = Instance.new("UICorner", main)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "SEA FARM [XENO]"
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = main

-- 3. LÓGICA AGUA (AUTO-EJECUCIÓN)
local plat = Instance.new("Part")
plat.Name = "SeaFarm_Platform"
plat.Size = Vector3.new(20, 1, 20)
plat.Anchored = true
plat.Transparency = 1
plat.Parent = workspace

local function updateWater()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = {char, plat}
        
        local result = workspace:Raycast(hrp.Position, Vector3.new(0, -6, 0), params)
        
        if result and result.Material == Enum.Material.Water then
            plat.CFrame = CFrame.new(hrp.Position.X, result.Position.Y, hrp.Position.Z)
            plat.CanCollide = true
        else
            plat.CanCollide = false
            plat.CFrame = CFrame.new(0, -1000, 0)
        end
    end
end

RunService.Heartbeat:Connect(updateWater)

-- 4. TELEPORT (BOTÓN Y TECLA T)
local function teleport()
    local target = nil
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            target = p.Character.HumanoidRootPart
            break
        end
    end
    if target then
        LocalPlayer.Character.HumanoidRootPart.CFrame = target.CFrame * CFrame.new(0, 0, 3)
    end
end

local btnTP = Instance.new("TextButton")
btnTP.Size = UDim2.new(0, 170, 0, 40)
btnTP.Position = UDim2.new(0, 15, 0, 50)
btnTP.Text = "TP A JUGADOR"
btnTP.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
btnTP.TextColor3 = Color3.new(1, 1, 1)
btnTP.Font = Enum.Font.GothamBold
btnTP.Parent = main
Instance.new("UICorner", btnTP)

btnTP.MouseButton1Click:Connect(teleport)

UIS.InputBegan:Connect(function(input, proc)
    if not proc and input.KeyCode == Enum.KeyCode.T then
        teleport()
    end
end)

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 30)
status.Position = UDim2.new(0, 0, 0, 100)
status.Text = "Water Walk: AUTO-ON"
status.TextColor3 = Color3.fromRGB(0, 255, 100)
status.BackgroundTransparency = 1
status.Font = Enum.Font.Gotham
status.Parent = main

-- CERRAR
local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 25, 0, 25)
close.Position = UDim2.new(1, -30, 0, 5)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
close.TextColor3 = Color3.new(1, 1, 1)
close.Parent = main
Instance.new("UICorner", close)

close.MouseButton1Click:Connect(function()
    cleanup()
end)

print("Sea Farm
