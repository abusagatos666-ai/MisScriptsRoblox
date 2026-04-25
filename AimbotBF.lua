-- Limpiar ejecuciones previas
for _, v in pairs(game.CoreGui:GetChildren()) do
    if v.Name == "Orion" then v:Destroy() end
end

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "🌊 Marine Event Farm | Sea 3", HidePremium = false, SaveConfig = true, ConfigFolder = "MarineFarm"})

-- Variables
getgenv().AutoFarm = false
getgenv().AutoDrive = false

-- Pestaña Principal
local MainTab = Window:MakeTab({
	Name = "Auto Farm",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

MainTab:AddToggle({
	Name = "Auto-Matar Eventos Marinos",
	Default = false,
	Callback = function(Value)
		getgenv().AutoFarm = Value
        if Value then
            spawn(function()
                while getgenv().AutoFarm do
                    task.wait(0.5)
                    pcall(function()
                        for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
                            if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                                -- Teleport seguro (40 studs arriba)
                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 40, 0)
                                -- Ataque
                                game:GetService("VirtualUser"):CaptureController()
                                game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0))
                            end
                        end
                    end)
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
            spawn(function()
                while getgenv().AutoDrive do
                    task.wait(0.1)
                    local boat = game.Workspace.Boats:FindFirstChild(game.Players.LocalPlayer.Name .. "Boat")
                    if boat and boat:FindFirstChild("VehicleSeat") then
                        boat.VehicleSeat.Throttle = 1
                        boat.VehicleSeat.Steer = 0.05
                    end
                end
            end)
        end
	end    
})

OrionLib:Init()
