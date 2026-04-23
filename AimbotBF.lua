-- [[ JD_PVP V12 - SEGURIDAD TOTAL ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- 1. LIMPIEZA INMEDIATA
local function CleanOld()
    for _, v in pairs(game.CoreGui:GetChildren()) do
        if v.Name == "JD_PVP_GUI" then v:Destroy() end
    end
end
pcall(CleanOld)

_G.JD_STATUS = false

-- 2. INTERFAZ (ESTRUCTURA BÁSICA PARA EVITAR ERRORES)
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "JD_PVP_GUI"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 180, 0, 100)
Main.Position = UDim2.new(0.5, -90, 0.4, 0) -- Centrado
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)

local CloseBtn = Instance.new("TextButton", Main)
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(0, 0, 0, 0)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", CloseBtn)

local Toggle = Instance.new("TextButton", Main)
Toggle.Size = UDim2.new(0, 140, 0, 40)
Toggle.Position = UDim2.new(0.5, -70, 0, 40)
Toggle.Text = "M1 RIFLE: OFF"
Toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Toggle.TextColor3 = Color3.new(1, 1, 1)
Toggle.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", Toggle)

-- 3. LÓGICA DE BÚSQUEDA (SIN LAG)
local function GetClosest()
    local target = nil
    local dist = 500
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

-- 4. FUNCIONAMIENTO DE BOTONES
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    _G.JD_STATUS = false
end)

Toggle.MouseButton1Click:Connect(function()
    _G.JD_STATUS = not _G.JD_STATUS
    Toggle.Text = _G.JD_STATUS and "M1 RIFLE: ON" or "M1 RIFLE: OFF"
    Toggle.BackgroundColor3 = _G.JD_STATUS and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 60)
end)

-- 5. REDIRECCIÓN M1 (MÉTODO COMPATIBLE)
local oldIndex
oldIndex = hookmetamethod(game, "__index", function(self, index)
    if _G.JD_STATUS and self == Mouse and (index == "Hit" or index == "Target") then
        local target = GetClosest()
        if target then
            return (index == "Hit" and target.CFrame or target.Parent)
        end
    end
    return oldIndex(self, index)
end)

print("JD_PVP cargado con éxito. ¡A darle con el Acidum!")
