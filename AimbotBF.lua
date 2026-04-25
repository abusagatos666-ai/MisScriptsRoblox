-- Limpiar menús previos
if game.CoreGui:FindFirstChild("Orion") then
    game.CoreGui.Orion:Destroy()
end

-- Carga de Librería (Con respaldo para evitar el error de 'nil value')
local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()

local Window = OrionLib:MakeWindow({
    Name = "Marine Farm | Sea 3", 
    HidePremium = true, 
    SaveConfig = false, 
    IntroText = "Iniciando Caza..."
})

-- Variables de Control
getgenv().AutoSeaEvents = false
getgenv().AutoSail = false

local SeaTab = Window:MakeTab({
    Name = "Eventos de Mar",
    Icon = "rbxassetid://4483345998"
})

-- FUNCIÓN DE ATAQUE AUTOMÁTICO
task.spawn(function()
    while true do
        task.wait(0.1)
        if getgenv().AutoSeaEvents then
            pcall(function()
                -- Buscamos enemigos marinos (Sea Beasts, TerrorSharks, Barcos)
                for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        -- Te posiciona 45 metros arriba del enemigo (Seguridad total)
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 45, 0)
                        
                        -- Simula el ataque
                        game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0), game.Workspace.CurrentCamera.CFrame)
                    end
                end
            end)
        end
    end
end)

-- FUNCIÓN DE NAVEGACIÓN AUTOMÁTICA
task.spawn(function()
    while true do
        task.wait(0.5)
        if getgenv().AutoSail then
            local char = game.Players.LocalPlayer.Character
            local myHumanoid = char:FindFirstChild("Humanoid")
            
            for _, boat in pairs(game.Workspace.Boats:GetChildren()) do
                if boat:FindFirstChild("VehicleSeat") and boat.VehicleSeat.Occupant == myHumanoid then
                    boat.VehicleSeat.Throttle = 1
                    boat.VehicleSeat.Steer = 0.05 -- Giro suave para patrullar zonas
                end
            end
        end
    end
end)

-- INTERFAZ
SeaTab:AddToggle({
    Name = "Auto-Matar Enemigos Marinos",
    Default = false,
    Callback = function(Value)
        getgenv().AutoSeaEvents = Value
    end
})

SeaTab:AddToggle({
    Name = "Auto-Manejar Barco (Patrullar)",
    Default = false,
    Callback = function(Value)
        getgenv().AutoSail = Value
    end
})

OrionLib:Init()
