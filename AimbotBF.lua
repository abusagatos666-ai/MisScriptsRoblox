-- [[ JD_PVP V7 - STABLE & NO LAG ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local RunService = game:GetService("RunService")

_G.JD_STATUS = false

-- [[ INTERFAZ MÍNIMA ]] --
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 160, 0, 90)
Main.Position = UDim2.new(0.1, 0, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)

local CloseBtn = Instance.new("TextButton", Main)
CloseBtn.Size = UDim2.new(0, 20, 0, 20)
CloseBtn.Position = UDim2.new(0, 5, 0, 5)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", CloseBtn)

local Toggle = Instance.new("TextButton", Main)
Toggle.Size = UDim2.new(0, 140, 0, 40)
Toggle.Position = UDim2.new(0.5, -70, 0, 40)
Toggle.Text = "SILENT: OFF"
Toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Toggle.TextColor3 = Color3.new(1, 1, 1)
Toggle.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", Toggle)

-- [[ LÓGICA DE APUNTADO LIGERA ]] --
local target = nil

-- Función para buscar al enemigo más cercano (Solo jugadores y NPCs vivos)
local function updateTarget()
    local closest = nil
    local dist = 500
    
    -- Usamos pcall para que si algo falla, no salga en consola
    pcall(function()
        for _, v in pairs(workspace:GetChildren()) do
            local hum = v:FindFirstChildOfClass("Humanoid")
            local root = v:FindFirstChild("HumanoidRootPart")
            if hum and root and hum.Health > 0 and v ~= LocalPlayer.Character then
                local mag = (LocalPlayer.Character.HumanoidRootPart.Position - root.Position).Magnitude
                if mag < dist then
                    dist = mag
                    closest = root
                end
            end
        end
    end)
    return closest
end

-- [[ EL SECRETO DEL SILENT AIM SIN LAG ]] --
-- En lugar de hookmetamethod, usamos un bucle suave
RunService.Stepped:Connect(function()
    if _G.JD_STATUS then
        target = updateTarget()
    else
        target = nil
    end
end)

-- Redirección de habilidades
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if _G.JD_STATUS and target and (method == "FireServer" or method == "InvokeServer") then
        for i, v in pairs(args) do
            if typeof(v) == "Vector3" then
                -- Si el juego pide una dirección, le damos la del enemigo
                args[i] = target.Position
            end
        end
    end
    return oldNamecall(self, unpack(args))
end)

-- Botones
CloseBtn.MouseButton1Click:Connect(function()
    _G.JD_STATUS = false
    ScreenGui:Destroy()
end)

Toggle.MouseButton1Click:Connect(function()
    _G.JD_STATUS = not _G.JD_STATUS
    Toggle.Text = _G.JD_STATUS and "SILENT: ON" or "SILENT: OFF"
    Toggle.BackgroundColor3 = _G.JD_STATUS and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(50, 50, 50)
end)
