-- [[ JD_PVP VERSION ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

_G.JD_PVP_STATUS = false

-- [[ INTERFAZ JD_PVP ]] --
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "JD_PVP_MENU"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 200, 0, 110)
Main.Position = UDim2.new(0.5, -100, 0.2, 0)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

local Corner = Instance.new("UICorner", Main)

-- Botón de Cerrar (X)
local CloseBtn = Instance.new("TextButton", Main)
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(0, 5, 0, 5)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", CloseBtn)

-- Título
local Title = Instance.new("TextLabel", Main)
Title.Text = "JD_PVP"
Title.Size = UDim2.new(1, 0, 0, 35)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20

-- Botón Toggle
local Toggle = Instance.new("TextButton", Main)
Toggle.Size = UDim2.new(0, 170, 0, 45)
Toggle.Position = UDim2.new(0, 15, 0, 45)
Toggle.Text = "AIMBOT: OFF"
Toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Toggle.TextColor3 = Color3.new(1, 1, 1)
Toggle.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", Toggle)

-- [[ LÓGICA FUNCIONAL ]] --

local function getClosestTarget()
    local target = nil
    local dist = 600 -- Rango de detección

    for _, v in pairs(workspace:GetDescendants()) do
        -- Filtro básico para evitar errores: buscamos modelos con HumanoidRootPart
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
            if v.Humanoid.Health > 0 and v ~= LocalPlayer.Character then
                local mag = (LocalPlayer.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
                if mag < dist then
                    dist = mag
                    target = v.HumanoidRootPart
                end
            end
        end
    end
    return target
end

-- Botón para cerrar todo
CloseBtn.MouseButton1Click:Connect(function()
    _G.JD_PVP_STATUS = false
    ScreenGui:Destroy()
end)

-- Botón para ON/OFF
Toggle.MouseButton1Click:Connect(function()
    _G.JD_PVP_STATUS = not _G.JD_PVP_STATUS
    if _G.JD_PVP_STATUS then
        Toggle.Text = "AIMBOT: ON"
        Toggle.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    else
        Toggle.Text = "AIMBOT: OFF"
        Toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end
end)

-- Bucle principal sin errores
RunService.RenderStepped:Connect(function()
    if _G.JD_PVP_STATUS then
        local target = getClosestTarget()
        if target then
            -- Solo movemos la cámara hacia el objetivo
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
        end
    end
end)

print("JD_PVP cargado con éxito.")
