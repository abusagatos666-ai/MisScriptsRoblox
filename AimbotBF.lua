-- [[ JD_PVP V6 - FPS OPTIMIZED ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local RunService = game:GetService("RunService")

_G.JD_STATUS = false

-- [[ INTERFAZ LIGERA ]] --
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 180, 0, 100)
Main.Position = UDim2.new(0.1, 0, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)

local CloseBtn = Instance.new("TextButton", Main)
CloseBtn.Size = UDim2.new(0, 22, 0, 22)
CloseBtn.Position = UDim2.new(0, 5, 0, 5)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", CloseBtn)

local Toggle = Instance.new("TextButton", Main)
Toggle.Size = UDim2.new(0, 150, 0, 40)
Toggle.Position = UDim2.new(0.5, -75, 0, 45)
Toggle.Text = "SILENT AIM: OFF"
Toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Toggle.TextColor3 = Color3.new(1, 1, 1)
Toggle.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", Toggle)

-- [[ LÓGICA OPTIMIZADA (BAJO CONSUMO) ]] --
local target = nil

-- Solo busca al enemigo 2 veces por segundo (ahorra FPS)
task.spawn(function()
    while task.wait(0.5) do
        if _G.JD_STATUS then
            local closest = nil
            local dist = 500
            
            -- Buscamos solo en Personajes de Jugadores (PVP)
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local mag = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                    if mag < dist then
                        dist = mag
                        closest = p.Character.HumanoidRootPart
                    end
                end
            end
            target = closest
        end
    end
end)

-- [[ EL TRUCO DEL SILENT AIM ]] --
-- Engañamos al juego sobre la posición del ratón
local mt = getrawmetatable(game)
local oldIndex = mt.__index
setreadonly(mt, false)

mt.__index = newcclosure(function(t, k)
    if _G.JD_STATUS and t == Mouse and target then
        if k == "Hit" then
            return target.CFrame
        elseif k == "Target" then
            return target.Parent
        end
    end
    return oldIndex(t, k)
end)
setreadonly(mt, true)

-- Acciones
CloseBtn.MouseButton1Click:Connect(function()
    _G.JD_STATUS = false
    ScreenGui:Destroy()
end)

Toggle.MouseButton1Click:Connect(function()
    _G.JD_STATUS = not _G.JD_STATUS
    Toggle.Text = _G.JD_STATUS and "SILENT AIM: ON" or "SILENT AIM: OFF"
    Toggle.BackgroundColor3 = _G.JD_STATUS and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(50, 50, 50)
end)

print("JD_PVP V6 cargado - FPS estables.")
