local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local moviendo = false
local autoKill = false
local targetEvent = ""
local conexion = nil
local combateConexion = nil

-- --- INTERFAZ VISUAL (DISEÑO FIEL A TU IMAGEN) ---
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
screenGui.Name = "SeaFarm_Ultimate_Fixed"

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 250, 0, 140) 
mainFrame.Position = UDim2.new(0.5, -125, 0.4, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.BorderSizePixel = 2
mainFrame.Draggable = true 
mainFrame.Active = true

local title = Instance.new("TextLabel", mainFrame)
title.Text = "  SEA FARM"
title.Size = UDim2.new(1, -40, 0, 35)
title.TextColor3 = Color3.new(0, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", mainFrame)
closeBtn.Text = "X"
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

local btnNav = Instance.new("TextButton", mainFrame)
btnNav.Text = "AUTO NAVEGACIÓN: OFF"
btnNav.Size = UDim2.new(0.9, 0, 0, 40)
btnNav.Position = UDim2.new(0.05, 0, 0.3, 0)
btnNav.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
btnNav.TextColor3 = Color3.new(1, 1, 1)
btnNav.Font = Enum.Font.GothamBold

local btnEventos = Instance.new("TextButton", mainFrame)
btnEventos.Text = "AUTO SEA EVENT ▼"
btnEventos.Size = UDim2.new(0.9, 0, 0, 40)
btnEventos.Position = UDim2.new(0.05, 0, 0.65, 0)
btnEventos.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
btnEventos.TextColor3 = Color3.new(1, 1, 1)
btnEventos.Font = Enum.Font.GothamBold

-- --- SCROLLING FRAME CON TODOS LOS EVENTOS ---
local scroll = Instance.new("ScrollingFrame", mainFrame)
scroll.Size = UDim2.new(0, 225, 0, 0) 
scroll.Position = UDim2.new(0.05, 0, 1, 5)
scroll.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
scroll.Visible = false
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 6
scroll.CanvasSize = UDim2.new(0, 0, 4, 0) -- Espacio para muchos botones
local listLayout = Instance.new("UIListLayout", scroll)

btnEventos.MouseButton1Click:Connect(function()
    scroll.Visible = not scroll.Visible
    if scroll.Visible then
        scroll.Size = UDim2.new(0, 225, 0, 150)
        btnEventos.Text = "AUTO SEA EVENT ▲"
    else
        scroll.Size = UDim2.new(0, 225, 0, 0)
        btnEventos.Text = "AUTO SEA EVENT ▼"
    end
end)

local function crearBtnEvento(txt, target)
    local b = Instance.new("TextButton", scroll)
    b.Text = "Auto " .. txt
    b.Size = UDim2.new(1, 0, 0, 30)
    b.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.BorderSizePixel = 0
    b.Font = Enum.Font.Gotham
    
    b.MouseButton1Click:Connect(function()
        if b.BackgroundColor3 == Color3.fromRGB(35, 35, 35) then
            -- Activar
            b.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            targetEvent = target
            autoKill = true
        else
            -- Desactivar
            b.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            autoKill = false
        end
    end)
end

-- --- LISTA COMPLETA DE TODOS LOS EVENTOS MARINOS ---
crearBtnEvento("Barco Embrujado", "Ship")
crearBtnEvento("Terrrorshark", "Terror")
crearBtnEvento("Pirañas", "Piranha")
crearBtnEvento("Sea Beast", "Sea Beast")
crearBtnEvento("Shark (Normal)", "Shark")
crearBtnEvento("Rumbling Waters", "Sea Beast") -- Activa detección masiva de SB
crearBtnEvento("Flying Fish", "Fish")
crearBtnEvento("Kitsune Island", "Kitsune") -- Para el evento de luna llena
crearBtnEvento("Mirage Island", "Mirage")
crearBtnEvento("Frozen Outpost", "Outpost")

-- --- LÓGICA DE COMBATE (Z, X, C, V, F + CLICK) ---
local function atacar(objetivoPos)
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    -- Apuntar personaje
    root.CFrame = CFrame.lookAt(root.Position, Vector3.new(objetivoPos.X, root.Position.Y, objetivoPos.Z))
    
    -- Lanzar habilidades y click
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    task.wait(0.05)
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
    
    local keys = {"Z", "X", "C", "V", "F"}
    for _, k in pairs(keys) do
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[k], false, game)
        task.wait(0.1)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[k], false, game)
    end
end

combateConexion = RunService.Heartbeat:Connect(function()
    if not autoKill or targetEvent == "" then return end
    
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    -- Busqueda de la entidad activa seleccionada
    for _, v in pairs(workspace:GetChildren()) do
        if v:IsA("Model") and v.Name:find(targetEvent) then
            local targetPart = v:FindFirstChild("HumanoidRootPart") or v:FindFirstChildWhichIsA("BasePart")
            if targetPart and (root.Position - targetPart.Position).Magnitude < 1500 then
                atacar(targetPart.Position)
                break
            end
        end
    end
end)

-- --- LÓGICA DE NAVEGACIÓN ---
btnNav.MouseButton1Click:Connect(function()
    if moviendo then
        moviendo = false
        btnNav.Text = "AUTO NAVEGACIÓN: OFF"
        if conexion then conexion:Disconnect() end
    else
        local seat = player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.SeatPart
        if not seat then 
            btnNav.Text = "SIÉNTATE PRIMERO"
            task.wait(1)
            btnNav.Text = "AUTO NAVEGACIÓN: OFF"
            return 
        end
        
        moviendo = true
        btnNav.Text = "NAVEGACIÓN: ON"
        conexion = RunService.Heartbeat:Connect(function(dt)
            if not moviendo or not seat or not seat.Parent then if conexion then conexion:Disconnect() end return end
            
            -- Avance adelante atravesando todo
            seat.CFrame = seat.CFrame * CFrame.new(0, 0, -350 * dt)
            for _, p in pairs(seat.Parent:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end)
    end
end)
