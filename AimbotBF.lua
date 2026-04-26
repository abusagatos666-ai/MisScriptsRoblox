-- [[ SEA FARM V1 - FIXED FOR XENO ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- 1. LIMPIEZA TOTAL
local function cleanup()
    local pGui = LocalPlayer:WaitForChild("PlayerGui")
    if pGui:FindFirstChild("SeaFarm_Xeno") then pGui.SeaFarm_Xeno:Destroy() end
    if workspace:FindFirstChild("SeaFarm_Platform") then
        workspace.SeaFarm_Platform:Destroy()
    end
end
cleanup()

-- 2. INTERFAZ
local gui = Instance.new("ScreenGui")
gui.Name = "SeaFarm_Xeno"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 200, 0, 150)
main.Position = UDim2.new(0.1, 0, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "SEA FARM [XENO]"
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 18

-- 3. LÓGICA AGUA (AUTO-ACTIVADO)
local plat = Instance.new("Part", workspace)
plat.Name = "SeaFarm_Platform"
plat.Size = Vector3.new(25, 1, 25)
plat.Anchored = true
plat.Transparency = 1

local function updateWater()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        local ray = Ray.new(hrp.Position, Vector3.new(0, -6, 0))
        local hit, pos, mat = workspace:FindPartOnRayWithIgnoreList(ray, {char, plat})
        
        if hit and mat == Enum.Material.Water then
            plat.CFrame = CFrame.new(hrp.Position.X, pos.Y, hrp.Position.Z)
            plat.CanCollide = true
        else
            plat.CanCollide = false
        end
    end
end
RunService.Heartbeat:Connect(updateWater)

-- 4. TELEPORT
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

local btnTP = Instance.new("TextButton", main)
btnTP.Size = UDim2.new(0, 170, 0, 40)
btnTP.Position = UDim2.new(0.5, -85, 0, 50)
btnTP.Text = "TP A JUGADOR (T)"
btnTP.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
btnTP.TextColor3 = Color3.new(1, 1, 1)
btnTP.Font = Enum.Font.GothamBold
Instance.new("UICorner", btnTP)

btnTP.MouseButton1Click:Connect(teleport)
UIS.InputBegan:Connect(function(input, proc)
    if not proc and input.KeyCode == Enum.KeyCode.T then
        teleport()
    end
end)

-- BOTÓN CERRAR
local close = Instance.new("TextButton", main)
close.Size = UDim2.new(0, 25, 0, 25)
close.Position = UDim2.new(1, -30, 0, 5)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
close.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", close)
close.MouseButton1Click:Connect(cleanup)

print("SEA FARM cargado sin errores.")
