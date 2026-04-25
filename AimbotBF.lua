-- Limpieza de interfaces previas
if game.CoreGui:FindFirstChild("Orion") then
    game.CoreGui.Orion:Destroy()
end

-- Sistema de carga ultra-compatible
local function LoadLib()
    local success, res = pcall(function()
        return loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()
    end)
    if success and res then return res end
    
    -- Si el de arriba falla, intentamos con este link de respaldo
    return loadstring(game:HttpGet('https://raw.githubusercontent.com/juyzh123/Orion/main/source'))()
end

local OrionLib = LoadLib()

local Window = OrionLib:MakeWindow({
    Name = "Marine Hunter | Xeno", 
    HidePremium = true, 
    SaveConfig = false, 
    IntroText = "Conectando..."
})

-- VARIABLES
getgenv().AutoFarm = false
getgenv().AutoDrive = false

local MainTab = Window:MakeTab({
    Name = "Sea Events",
    Icon = "rbxassetid://4483345998"
})

MainTab:AddToggle({
    Name = "Auto-Farm (TerrorShark/SeaBeast)",
    Default = false,
    Callback = function(Value)
        getgenv().AutoFarm = Value
        if Value then
            task.spawn(function()
                while getgenv().AutoFarm do
                    task.wait(0.5)
                    for _, enemy in pairs(game.Workspace.Enemies:GetChildren()) do
                        if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 45, 0)
                            game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0), game.Workspace.CurrentCamera.CFrame)
                        end
                    end
                end
            end)
        end
    end
})

MainTab:AddToggle({
    Name = "Auto-Conducir Barco",
    Default = false,
    Callback = function(Value)
        getgenv().AutoDrive = Value
        if Value then
            task.spawn(function()
                while getgenv().AutoDrive do
                    task.wait(0.1)
                    local char = game.Players.LocalPlayer.Character
                    for _, b in pairs(game.Workspace.Boats:GetChildren()) do
                        if b:FindFirstChild("VehicleSeat") and b.VehicleSeat.Occupant == char:FindFirstChild("Humanoid") then
                            b.VehicleSeat.Throttle = 1
                            b.VehicleSeat.Steer = 0.05
                        end
                    end
                end
            end)
        end
    end
})

OrionLib:Init()
