--[[
    GitHub Project: Sea Farm Utility
    Auto-Features: Auto Water Walk
    Manual-Features: Player Teleport (Button & Key T)
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local lp = Players.LocalPlayer

-- Limpiar versiones anteriores
local old = lp:WaitForChild("PlayerGui"):FindFirstChild("SeaFarmMenu")
if old then old:Destroy() end

-- --- INTERFAZ SEA FARM ---
local sg = Instance.new("ScreenGui")
sg.Name = "SeaFarmMenu"
sg.ResetOnSpawn = false
sg.Parent = lp:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 180, 0, 150)
frame.Position = UDim2.new(0.1, 0, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 40) -- Azul oscuro temático
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true 
frame.Parent = sg

local corner = Instance.new("UICorner", frame)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.Text = "SEA FARM"
title.TextColor3 = Color3.fromRGB(0, 255, 255) -- Color Cyan
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = frame

-- --- LÓGICA CAMINAR AGUA (AUTO-ACTIVADO) ---
local platform = Instance.new("Part")
platform.Name = "SeaFarmPlatform"
platform.Size = Vector3.new(15, 1, 15)
platform.Anchored = true
platform.Transparency = 1 -- Invisible
platform.Parent = workspace

-- Mensaje en consola para confirmar activación
print("[SEA FARM] Caminar sobre el agua activado automáticamente.")

RunService.Heartbeat:Connect(function()
    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = lp.Character.HumanoidRootPart
        -- Detectar agua debajo
        local ray = Ray.new(hrp.Position, Vector3.new(0, -6, 0))
        local hit, pos, mat = workspace:FindPartOnRayWithIgnoreList(ray, {lp.Character, platform})
        
        if hit and mat == Enum.Material.Water then
            platform.CFrame = CFrame.new(hrp.Position.X, pos.Y, hrp.Position.Z)
            platform.CanCollide = true
        else
            platform.CanCollide = false
        end
    end
end)

-- --- LÓGICA TELETRANSPORTE ---
local function tpToPlayer()
    local targets = Players:GetPlayers()
    for _, v in pairs(targets) do
        if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            -- Teletransportarse 3 studs detrás del jugador encontrado
            lp.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
            print("[SEA FARM] Teletransportado a: " .. v.Name)
            break 
        end
    end
end

-- Botón de TP en el menú
local btnTP = Instance.new("TextButton")
btnTP.Size = UDim2.new(0, 160, 0, 40)
btnTP.Position = UDim2.new(0, 10, 0, 50)
btnTP.Text = "TP a Jugador"
btnTP.BackgroundColor3 = Color3.fromRGB(0, 150, 150)
btnTP.TextColor3 = Color3.new(1, 1, 1)
btnTP.Font = Enum.Font.GothamMedium
btnTP.Parent = frame
Instance.new("UICorner", btnTP)

btnTP.MouseButton1Click:Connect(tpToPlayer)

-- Tecla T para TP rápido
UIS.InputBegan:Connect(function(input, processed)
    if
