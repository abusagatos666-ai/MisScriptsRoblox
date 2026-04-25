local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "🌊 Marine Event Farm | Sea 3",
   LoadingTitle = "Cargando Script de GitHub...",
   LoadingSubtitle = "Auto-Farm & Boat Control",
   ConfigurationSaving = { Enabled = true, FolderName = "MarineHunter" }
})

-- VARIABLES GLOBALES
getgenv().AutoFarm = false
getgenv().AutoDrive = false
getgenv().TargetEnemies = {"Sea Beast", "TerrorShark", "Terrorshark", "Piranha", "Shark", "Ghost Ship"}

-- PESTAÑA PRINCIPAL
local MainTab = Window:CreateTab("Principal", 4483345998)

MainTab:CreateToggle({
   Name = "Auto-Farm de Eventos (Matar Todo)",
   CurrentValue = false,
   Callback = function(Value)
      getgenv().AutoFarm = Value
      if Value then
          spawn(function()
              while getgenv().AutoFarm do
                  task.wait(0.5)
                  pcall(function()
                      for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
                          if table.find(getgenv().TargetEnemies, v.Name) or v:FindFirstChild("Humanoid") then
                              local humanoid = v:FindFirstChild("Humanoid")
                              if humanoid and humanoid.Health > 0 then
                                  -- Teleport sobre el enemigo para seguridad
                                  game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 40, 0)
                                  
                                  -- Simular Click de Ataque
                                  game:GetService("VirtualUser"):CaptureController()
                                  game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0))
                              end
                          end
                      end
                  end)
              end
          end)
      end
   end,
})

MainTab:CreateToggle({
   Name = "Auto-Conducir Barco (Zonas de Peligro)",
   CurrentValue = false,
   Callback = function(Value)
      getgenv().AutoDrive = Value
      if Value then
          spawn(function()
              while getgenv().AutoDrive do
                  task.wait(0.1)
                  local boat = game.Workspace.Boats:FindFirstChild(game.Players.LocalPlayer.Name .. "Boat") 
                  -- Si no encuentra con nombre, busca el que estés ocupando
                  if not boat then
                      for _, b in pairs(game.Workspace.Boats:GetChildren()) do
                          if b:FindFirstChild("VehicleSeat") and b.VehicleSeat.Occupant == game.Players.LocalPlayer.Character.Humanoid then
                              boat = b
                          end
                      end
                  end

                  if boat and boat:FindFirstChild("VehicleSeat") then
                      boat.VehicleSeat.Throttle = 1
                      boat.VehicleSeat.Steer = 0.05 -- Giro suave para patrullar
                  end
              end
          end)
      end
   end,
})

-- PESTAÑA DE BARCO
local BoatTab = Window:CreateTab("Ajustes de Barco", 4483362458)

BoatTab:CreateButton({
   Name = "Teleport al Asiento del Barco",
   Callback = function()
       for _, b in pairs(game.Workspace.Boats:GetChildren()) do
           if b:FindFirstChild("VehicleSeat") then
               game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = b.VehicleSeat.CFrame
           end
       end
   end,
})

Rayfield:LoadConfiguration()
