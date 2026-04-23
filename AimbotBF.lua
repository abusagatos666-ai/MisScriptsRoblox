-- [[ VARIABLES DE SERVICIOS ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- [[ ESTADO DEL SCRIPT ]] --
_G.AimbotEnabled = false

-- [[ INTERFAZ SIMPLE ]] --
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleBtn = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "PVP_Menu_Simple"

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.1, 0, 0.4, 0)
MainFrame.Size = UDim2.new(0, 180, 0, 100)
MainFrame.Active = true
MainFrame.Draggable = true -- Puedes mover el menú con el ratón

Title.Parent = MainFrame
Title.Text = "PVP SECTION"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.TextSize = 18

ToggleBtn.Parent = MainFrame
ToggleBtn.Name = "ToggleAimbot"
ToggleBtn.Text = "Enable Aimbot: OFF"
ToggleBtn.Size = UDim2.new(0, 150, 0, 40)
ToggleBtn.Position = UDim2.new(0.5, -75, 0.5, -5)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

-- [[ LÓGICA DE BÚSQUEDA ]] --
local function getClosestEntity()
    local closest = nil
    local shortestDistance = math.huge

    -- Busca en todo el Workspace (Jugadores y NPCs)
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") then
            if v.Humanoid.Health > 0 and v ~= LocalPlayer.Character then
                local screenPoint = Camera:WorldToViewportPoint(v.HumanoidRootPart.Position)
                local distance = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(screenPoint.X, screenPoint.Y)).Magnitude
                
                if distance < shortestDistance then
                    closest = v
                    shortestDistance = distance
                end
            end
        end
    end
    return closest
end

-- [[ ACTIVACIÓN ]] --
ToggleBtn.MouseButton1Click:Connect(function()
    _G.AimbotEnabled = not _G.AimbotEnabled
    if _G.AimbotEnabled then
        ToggleBtn.Text = "Enable Aimbot: ON"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
    else
        ToggleBtn.Text = "Enable Aimbot: OFF"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    end
end)

-- [[ REDIRECCIÓN DE ATAQUES (EL "TRUCO") ]] --
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    -- Si el Aimbot está ON y estamos atacando o usando habilidades
    if _G.AimbotEnabled and (method == "FireServer" or method == "InvokeServer") then
        local target = getClosestEntity()
        if target then
            -- Intentamos redirigir la posición del ataque hacia el enemigo
            for i, arg in pairs(args) do
                if typeof(arg) == "Vector3" then
                    args[i] = target.HumanoidRootPart.Position
                end
            end
        end
    end
    return oldNamecall(self, unpack(args))
end)

-- Bucle de cámara para ayudar al auto-apuntado visual
RunService.RenderStepped:Connect(function()
    if _G.AimbotEnabled then
        local target = getClosestEntity()
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.HumanoidRootPart.Position)
        end
    end
end)
