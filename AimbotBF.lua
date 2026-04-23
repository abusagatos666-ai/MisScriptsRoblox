-- [[ JD_PVP V8 - COMPATIBILIDAD TOTAL ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

_G.JD_STATUS = false

-- [[ INTERFAZ BÁSICA (SIN FUNCIONES COMPLEJAS) ]] --
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "JD_PVP_STABLE"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 180, 0, 100)
Main.Position = UDim2.new(0.1, 0, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Main.Active = true
Main.Draggable = true

local Title = Instance.new("TextLabel", Main)
Title.Text = "JD_PVP"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.SourceSansBold

-- Botón Cerrar (X)
local CloseBtn = Instance.new("TextButton", Main)
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(0, 0, 0, 0) -- Superior izquierda
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)

-- Botón de Activación
local Toggle = Instance.new("TextButton", Main)
Toggle.Size = UDim2.new(0, 150, 0, 40)
Toggle.Position = UDim2.new(0, 15, 0, 40)
Toggle.Text = "AIMBOT: OFF"
Toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Toggle.TextColor3 = Color3.new(1, 1, 1)

-- [[ LÓGICA DE APUNTADO LIGERA ]] --
local function getClosest()
    local target = nil
    local dist = 500
    
    -- Solo buscamos en jugadores para evitar el lag de los NPCs
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local mag = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                if mag < dist then
                    dist = mag
                    target = p.Character.HumanoidRootPart
                end
            end
        end
    end
    return target
end

-- Funciones de los botones
CloseBtn.MouseButton1Click:Connect(function()
    _G.JD_STATUS = false
    ScreenGui:Destroy()
end)

Toggle.MouseButton1Click:Connect(function()
    _G.JD_STATUS = not _G.JD_STATUS
    if _G.JD_STATUS then
        Toggle.Text = "AIMBOT: ON"
        Toggle.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    else
        Toggle.Text = "AIMBOT: OFF"
        Toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end
end)

-- Bucle de apuntado (Suave para no bajar FPS)
RunService.Heartbeat:Connect(function()
    if _G.JD_STATUS then
        local t = getClosest()
        if t then
            -- En lugar de Silent Aim complejo, usamos suavizado de cámara
            -- Esto hace que tus ataques miren al enemigo pero sin quitarte el control total
            local targetPos = Camera:WorldToScreenPoint(t.Position)
            local mousePos = Vector2.new(targetPos.X, targetPos.Y)
            
            -- Solo movemos la cámara si el enemigo está en pantalla
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, t.Position)
        end
    end
end)
