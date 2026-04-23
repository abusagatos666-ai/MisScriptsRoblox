-- [[ JD_PVP - VERSIÓN SIN ERRORES ROJOS ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local RunService = game:GetService("RunService")

-- 1. LIMPIEZA DE MENÚS (Para que no se repitan)
for _, v in pairs(game.CoreGui:GetChildren()) do
    if v.Name == "JD_PVP_STABLE" then v:Destroy() end
end

_G.JD_STATUS = false

-- 2. INTERFAZ JD_PVP
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "JD_PVP_STABLE"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 160, 0, 90)
Main.Position = UDim2.new(0.1, 0, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)

-- NOMBRE: JD_PVP
local Title = Instance.new("TextLabel", Main)
Title.Text = "JD_PVP"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16

-- BOTÓN X (Cerrar)
local CloseBtn = Instance.new("TextButton", Main)
CloseBtn.Size = UDim2.new(0, 22, 0, 22)
CloseBtn.Position = UDim2.new(0, 5, 0, 5)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", CloseBtn)

-- BOTÓN ACTIVAR
local Toggle = Instance.new("TextButton", Main)
Toggle.Size = UDim2.new(0, 130, 0, 35)
Toggle.Position = UDim2.new(0.5, -65, 0, 40)
Toggle.Text = "AIM: OFF"
Toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Toggle.TextColor3 = Color3.new(1, 1, 1)
Toggle.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", Toggle)

-- 3. LÓGICA DE BÚSQUEDA (Sin errores de Health)
local function getTarget()
    local closest = nil
    local dist = 500
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
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

-- 4. ACCIONES DE BOTONES
CloseBtn.MouseButton1Click:Connect(function()
    _G.JD_STATUS = false
    ScreenGui:Destroy()
end)

Toggle.MouseButton1Click:Connect(function()
    _G.JD_STATUS = not _G.JD_STATUS
    Toggle.Text = _G.JD_STATUS and "AIM: ON" or "AIM: OFF"
    Toggle.BackgroundColor3 = _G.JD_STATUS and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(50, 50, 50)
end)

-- 5. AIMBOT SIN MOVER CÁMARA (MÉTODO COMPATIBLE 100%)
-- Este método mueve el cursor del mouse internamente hacia el enemigo
RunService.RenderStepped:Connect(function()
    if _G.JD_STATUS then
        local target = getTarget()
        if target then
            -- Mover el mouse a la posición del enemigo (Solo para el juego)
            -- Esto hará que tus habilidades y M1 vayan al enemigo sin girar tu vista
            local pos = workspace.CurrentCamera:WorldToViewportPoint(target.Position)
            -- pcall evita que el script muera si el ejecutor no permite mouse_event
            pcall(function()
                if mousemoveabs then
                    mousemoveabs(pos.X, pos.Y)
                end
            end)
        end
    end
end)
