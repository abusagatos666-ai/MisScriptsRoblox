-- Limpiamos cualquier interfaz previa para que no se trabe en Xeno
if game.CoreGui:FindFirstChild("Orion") then
    game.CoreGui.Orion:Destroy()
end

-- Cargamos la librería con un sistema de reintento
local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()

local Window = OrionLib:MakeWindow({
    Name = "Xeno Marine Hub 🌊", 
    HidePremium = true, 
    SaveConfig = false, 
    IntroText = "Ejecutando en Xeno..."
})

-- Variables de control
getgenv().AutoFarm = false
getgenv().AutoDrive = false

local Tab = Window:MakeTab({
    Name = "Sea Events",
    Icon = "rbxassetid://4483345998"
})

Tab:AddToggle({
    Name = "Auto-Farm Eventos Marinos",
    Default = false,
    Callback = function(Value)
        getgenv().AutoFarm = Value
        if Value then
            task.spawn(function()
                while getgenv().AutoFarm do
                    task.wait(0.5)
                    -- Buscamos enemigos en el mar
                    for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
                        if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") then
                            if v.Humanoid.Health > 0 then
                                -- Posicionamiento seguro sobre el enemigo
                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 45, 0)
                                -- Ataque automático (Simula click)
                                game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0), game.Workspace.CurrentCamera.CFrame)
                            end
                        end
                    end
                end
            end)
        end
    end
})

Tab:AddToggle({
    Name = "Auto-Manejar Barco",
    Default = false,
    Callback = function(Value)
        getgenv().AutoDrive = Value
        if Value then
            task.spawn(function()
                while getgenv().AutoDrive do
                    task.wait(0.2)
                    local character = game.Players.LocalPlayer.Character
                    local boat = nil
                    
                    -- Buscamos el barco que estamos ocupando
                    for _, b in pairs(game.Workspace.Boats:GetChildren()) do
                        if b:FindFirstChild("VehicleSeat") and b.VehicleSeat.Occupant == character:FindFirstChild("Humanoid") then
                            boat = b
                            break
                        end
                    end
                    
                    if boat then
                        boat.VehicleSeat.Throttle = 1
                        boat.VehicleSeat.Steer = 0.05
                    end
                end
            end)
        end
    end
})

-- Inicialización final obligatoria
OrionLib:Init()
