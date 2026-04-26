--[[
    Framework de Utilidades para Personajes en Roblox
    Funcionalidades: WaterWalk, PlayerESP, FastTeleport
]]

local UtilityLib = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer

-- 1. FUNCION: CAMINAR SOBRE EL AGUA
function UtilityLib.EnableWaterWalk()
    local char = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    
    local platform = Instance.new("Part")
    platform.Name = "WaterPlatform"
    platform.Size = Vector3.new(6, 1, 6)
    platform.Transparency = 1
    platform.Anchored = true
    platform.Parent = workspace

    RunService.Heartbeat:Connect(function()
        local ray = Ray.new(hrp.Position, Vector3.new(0, -5, 0))
        local hit, pos, mat = workspace:FindPartOnRayWithIgnoreList(ray, {char, platform})
        
        if hit and hit.ClassName == "Terrain" and mat == Enum.Material.Water then
            platform.CFrame = CFrame.new(hrp.Position.X, pos.Y, hrp.Position.Z)
            platform.CanCollide = true
        else
            platform.CanCollide = false
            platform.CFrame = CFrame.new(0, -1000, 0)
        end
    end)
end

-- 2. FUNCION: VER NOMBRES (ESP)
function UtilityLib.EnableGlobalESP()
    local function applyESP(player)
        if player == localPlayer then return end
        player.CharacterAdded:Connect(function(char)
            local head = char:WaitForChild("Head")
            local gui = Instance.new("BillboardGui", head)
            gui.Size = UDim2.new(0, 100, 0, 50)
            gui.AlwaysOnTop = true
            gui.StudsOffset = Vector3.new(0, 2, 0)
            
            local label = Instance.new("TextLabel", gui)
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = player.Name
            label.TextColor3 = Color3.fromRGB(255, 0, 0) -- Rojo para visibilidad
            label.TextStrokeTransparency = 0
        end)
    end

    for _, p in pairs(Players:GetPlayers()) do applyESP(p) end
    Players.PlayerAdded:Connect(applyESP)
end

-- 3. FUNCION: TELETRANSPORTE RÁPIDO (Tecla T)
function UtilityLib.EnableFastTP()
    UIS.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.T then
            local targets = Players:GetPlayers()
            for _, target in pairs(targets) do
                if target ~= localPlayer and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                    localPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                    break
                end
            end
        end
    end)
end

return UtilityLib
