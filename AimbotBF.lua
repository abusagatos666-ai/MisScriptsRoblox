local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "Marine Events Pro - Sea 3", HidePremium = false, SaveConfig = true, ConfigFolder = "MarineEvents"})

-- Variables de Control
getgenv().AutoFarmSea = false
getgenv().AutoDrive = false

-- Función para manejar el barco (Auto-Drive)
spawn(function()
    while wait() do
        if getgenv().AutoDrive then
            local boat = game.Workspace.Boats:FindFirstChild(game.Players.LocalPlayer.Name .. "Boat")
            if boat and boat:FindFirstChild("VehicleSeat") then
                boat.VehicleSeat.Throttle = 1
                -- Aquí se puede añadir lógica para girar en círculos en zonas de peligro
            end
        end
    end
end)

-- Pestaña Principal
local MainTab = Window:MakeTab({
	Name = "Eventos Marinos",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

MainTab:AddToggle({
	Name = "Auto-Farm Eventos (Sea Beast/Ship)",
	Default = false,
	Callback = function(Value)
		getgenv().AutoFarmSea = Value
        if Value then
            print("Buscando amenazas marinas...")
            -- Aquí se inserta la lógica de ataque (Aimbot a Sea Beasts)
        end
	end    
})

MainTab:AddToggle({
	Name = "Auto-Conducir Barco",
	Default = false,
	Callback = function(Value)
		getgenv().AutoDrive = Value
	end    
})

-- Pestaña de Configuración de Barco
local BoatTab = Window:MakeTab({
	Name = "Barco & Velocidad",
	Icon = "rbxassetid://4483362458",
	PremiumOnly = false
})

BoatTab:AddSlider({
	Name = "Velocidad del Barco",
	Min = 50,
	Max = 300,
	Default = 100,
	Color = Color3.fromRGB(255,255,255),
	Increment = 10,
	ValueName = "KM/H",
	Callback = function(Value)
		-- Ajusta la velocidad del asiento del barco
	end    
})

OrionLib:Init()
