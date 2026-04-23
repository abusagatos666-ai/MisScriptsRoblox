-- [[ JD_PVP - VERSIÓN FINAL SIN ERRORES ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- 1. ELIMINAR CUALQUIER RESIDUO (Limpieza total de la pantalla)
for _, v in pairs(game.CoreGui:GetChildren()) do
    if v:IsA("ScreenGui") and (v.Name == "JD_PVP_GUI" or v.Name == "JD_PVP_STABLE") then
        v:Destroy()
    end
end

_G.JD_STATUS = false

-- 2. INTERFAZ JD_PVP (Hecha para no dar error)
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "JD_PVP_GUI"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 180, 0, 100)
Main.Position = UDim2.new(0.1, 0, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)

-- Botón X (Superior Izquierda)
local CloseBtn = Instance.new("TextButton", Main)
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(0, 5, 0, 5)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", CloseBtn)

-- Título
local Title = Instance.new("TextLabel", Main)
Title.Text = "JD_PVP"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18

-- Botón ON/OFF
local Toggle = Instance.new("TextButton", Main)
Toggle.Size = UDim2.new(0, 150, 0, 45)
Toggle.Position = UDim2.new(0.5, -75, 0, 45)
Toggle.Text = "SILENT AIM: OFF"
Toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Toggle.TextColor3 = Color3.new(1, 1, 1)
Toggle.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", Toggle)

-- 3. LÓGICA DE APUNTADO (OPTIMIZADA AL 100%)
local function getTarget()
    local closest = nil
    local dist = 500
    
    -- Solo busca jugadores (PVP) para no gastar FPS
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            -- Verificación de salud segura
            if hum and hum.Health > 0 then
                local mag = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                if mag < dist then
                    dist = mag
                    closest = p.Character.HumanoidRootPart
                end
            end
        end
    end
    return closest
end

-- 4. FUNCIONES DE BOTONES (Sin bloqueos)
CloseBtn.MouseButton1Click:Connect(function()
    _G.JD_STATUS = false
    ScreenGui:Destroy()
end)

Toggle.MouseButton1Click:Connect(function()
    _G.JD_STATUS = not _G.JD_STATUS
    Toggle.Text = _G.JD_STATUS and "SILENT AIM: ON" or "SILENT AIM: OFF"
    Toggle.BackgroundColor3 = _G.JD_STATUS and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(50, 50, 50)
end)

-- 5. SILENT AIM (Redirección de proyectiles sin mover cámara)
-- Este método no causa errores en consola
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if _G.JD_STATUS and (method == "FireServer" or method == "InvokeServer") then
        local target = getTarget()
        if target then
            for i, arg in pairs(args) do
                if typeof(arg) == "Vector3" then
                    args[i] = target.Position
                elseif typeof(arg) == "CFrame" then
                    args[i] = target.CFrame
                end
            end
        end
    end
    return oldNamecall(self, unpack(args))
end)

print("JD_PVP V10 cargado correctamente.")
