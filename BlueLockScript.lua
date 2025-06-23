-- Referências principais
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

-- Remove scripts de kick e ban
local banScript = ReplicatedStorage:FindFirstChild("CmdrConfig")
if banScript and banScript:FindFirstChild("Commands") then
    local commands = banScript:FindFirstChild("Commands")
    if commands:FindFirstChild("banServer") then
        commands.banServer:Destroy()
    end
end

local cmdrPkg = ReplicatedStorage:FindFirstChild("Packages")
if cmdrPkg then
    local cmdr = cmdrPkg:FindFirstChild("Cmdr")
    if cmdr and cmdr:FindFirstChild("Server") then
        local srv = cmdr:FindFirstChild("Server")
        if srv:FindFirstChild("Commands") then
            local cmds = srv.Commands
            if cmds:FindFirstChild("Admin") and cmds.Admin:FindFirstChild("KickServer") then
                cmds.Admin.KickServer:Destroy()
            end
        end
    end
end

local clientCmdr = ReplicatedStorage:FindFirstChild("CmdrClient")
if clientCmdr and clientCmdr:FindFirstChild("Packages") then
    local pkg = clientCmdr:FindFirstChild("Packages")
    if pkg:FindFirstChild("Kick") then
        pkg.Kick:Destroy()
    end
end

local knit = ReplicatedStorage:FindFirstChild("Knit")
if knit then
    local services = knit:FindFirstChild("Services")
    if services then
        local ltm = services:FindFirstChild("LTMService")
        if ltm then
            if ltm:FindFirstChild("RE") and ltm.RE:FindFirstChild("PlayerKicked") then
                ltm.RE.PlayerKicked:Destroy()
            end
            if ltm:FindFirstChild("RF") and ltm.RF:FindFirstChild("KickPlayer") then
                ltm.RF.KickPlayer:Destroy()
            end
        end
    end
end

-- Criar GUI principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Shyon Hub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 400)
MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 6)

local title = Instance.new("TextLabel", MainFrame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Blue Lock Script"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16

local contentList = Instance.new("Frame", MainFrame)
contentList.Size = UDim2.new(1, -20, 1, -80)
contentList.Position = UDim2.new(0, 10, 0, 35)
contentList.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", contentList)
layout.Padding = UDim.new(0, 10)
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- Função para criar entradas (Style e Flow)
local function createInputSection(titleText, statName, needsReo)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 50)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Instance.new("UICorner", frame)
    frame.Parent = contentList

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.6, 0, 0.5, 0)
    label.Position = UDim2.new(0.05, 0, 0.1, 0)
    label.Text = titleText
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left

    local textBox = Instance.new("TextBox", frame)
    textBox.Size = UDim2.new(0.6, 0, 0.4, 0)
    textBox.Position = UDim2.new(0.05, 0, 0.55, 0)
    textBox.PlaceholderText = "Digite o nome"
    textBox.Text = ""
    textBox.TextSize = 12
    textBox.Font = Enum.Font.Gotham
    textBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    textBox.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", textBox)

    local toggle = Instance.new("TextButton", frame)
    toggle.Size = UDim2.new(0.25, 0, 0.6, 0)
    toggle.Position = UDim2.new(0.7, 0, 0.2, 0)
    toggle.Text = "Ativar"
    toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    toggle.TextColor3 = Color3.new(1, 1, 1)
    toggle.Font = Enum.Font.GothamBold
    toggle.TextSize = 13
    Instance.new("UICorner", toggle)

    toggle.MouseButton1Click:Connect(function()
        local stats = LocalPlayer:FindFirstChild("PlayerStats")
        if stats and stats:FindFirstChild(statName) then
            local valueObj = stats[statName]
            if valueObj and valueObj:IsA("StringValue") then
                valueObj.Value = textBox.Text
            end
            if needsReo then
                local msg = Instance.new("TextLabel", ScreenGui)
                msg.Text = "Necessita de REO Para Funcionar"
                msg.Size = UDim2.new(0, 300, 0, 40)
                msg.Position = UDim2.new(0.5, -150, 0.05, 0)
                msg.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                msg.TextColor3 = Color3.new(1, 1, 1)
                msg.Font = Enum.Font.GothamBold
                msg.TextSize = 14
                Instance.new("UICorner", msg)
                task.delay(5, function()
                    msg:Destroy()
                end)
            end
        end
    end)
end

-- Style e Flow
createInputSection("Estilo:", "Style", true)
createInputSection("Fluxo:", "Flow", false)

-- Função para criar botões misc (Despertar e FlowBuffs)
local function createMiscButton(labelText, valueName)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    frame.Parent = contentList
    Instance.new("UICorner", frame)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Position = UDim2.new(0.05, 0, 0, 0)
    label.Text = labelText
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left

    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0.25, 0, 0.6, 0)
    btn.Position = UDim2.new(0.7, 0, 0.2, 0)
    btn.Text = "Ativar"
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(function()
        local stats = LocalPlayer:FindFirstChild("PlayerStats")
        if stats and stats:FindFirstChild(valueName) then
            local val = stats[valueName]
            if val and val:IsA("BoolValue") then
                val.Value = not val.Value
            end
        end
    end)
end

createMiscButton("Despertar", "InAwakening")
createMiscButton("FlowBuffs", "InFlow")

-- Mensagem de instrução abaixo da lista
local instructions = Instance.new("TextLabel", MainFrame)
instructions.Size = UDim2.new(1, -20, 0, 30)
instructions.Position = UDim2.new(0, 10, 1, -40)
instructions.BackgroundTransparency = 1
instructions.TextColor3 = Color3.new(1, 1, 1)
instructions.Font = Enum.Font.Gotham
instructions.TextSize = 12
instructions.TextXAlignment = Enum.TextXAlignment.Center
instructions.Text = "(M) Para abrir/fechar GUI | (P) Para iniciar/pausar Auto Farm"

-- Variáveis controle
local guiVisible = true
local autoFarmActive = false
local espActive = false

-- Função de Auto Farm
local function autoFarm()
    if autoFarmActive then return end
    autoFarmActive = true

    local CFGui = PlayerGui:WaitForChild("PickTeam"):WaitForChild("Home"):WaitForChild("CF")
    local cfButton = CFGui:FindFirstChildWhichIsA("TextButton") or CFGui:FindFirstChildWhichIsA("ImageButton")

    local mouse = game.Players.LocalPlayer:GetMouse()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    -- Posições
    local footballPos = Vector3.new(38, 11, -50)
    local goalPos = Vector3.new(-245, 14, -49)

    -- Função para clicar botão CF repetidamente para entrar no time azul
    local function enterCF()
        if cfButton then
            for i = 1, 10 do
                cfButton:Activate()
                task.wait(0.1)
            end
        end
    end

    -- Função para teleportar para bola e pegar
    local function teleportToBall()
        local ball = Workspace:FindFirstChild("Football")
        if ball then
            humanoidRootPart.CFrame = CFrame.new(ball.Position + Vector3.new(0, 3, 0))
        end
    end

    -- Função para verificar se tem bola
    local function hasBall()
        local valuesFolder = LocalPlayer:FindFirstChild("values") or LocalPlayer.Character:FindFirstChild("values")
        if valuesFolder then
            local hasBallValue = valuesFolder:FindFirstChild("HasBall")
            return hasBallValue and hasBallValue.Value
        end
        return false
    end

    -- Loop de auto farm infinito
    while autoFarmActive do
        enterCF()
        task.wait(0.2)

        if hasBall() then
            -- Teleporta várias vezes para o gol e chuta
            for _ = 1, 20 do
                humanoidRootPart.CFrame = CFrame.new(goalPos)
                mouse1press()
                task.wait(0.1)
                mouse1release()
                task.wait(0.05)
            end
        else
            -- Teleporta para bola para pegar
            teleportToBall()
        end

        task.wait(0.5)
    end
end

-- Botão AutoFarm na interface
local autoFarmFrame = Instance.new("Frame")
autoFarmFrame.Size = UDim2.new(1, 0, 0, 40)
autoFarmFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
autoFarmFrame.Parent = contentList
Instance.new("UICorner", autoFarmFrame)

local autoFarmLabel = Instance.new("TextLabel", autoFarmFrame)
autoFarmLabel.Size = UDim2.new(0.6, 0, 1, 0)
autoFarmLabel.Position = UDim2.new(0.05, 0, 0, 0)
autoFarmLabel.Text = "Auto Farm"
autoFarmLabel.TextColor3 = Color3.new(1, 1, 1)
autoFarmLabel.Font = Enum.Font.GothamBold
autoFarmLabel.TextSize = 14
autoFarmLabel.BackgroundTransparency = 1
autoFarmLabel.TextXAlignment = Enum.TextXAlignment.Left

local autoFarmBtn = Instance.new("TextButton", autoFarmFrame)
autoFarmBtn.Size = UDim2.new(0.25, 0, 0.6, 0)
autoFarmBtn.Position = UDim2.new(0.7, 0, 0.2, 0)
autoFarmBtn.Text = "Ativar"
autoFarmBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
autoFarmBtn.TextColor3 = Color3.new(1, 1, 1)
autoFarmBtn.Font = Enum.Font.GothamBold
autoFarmBtn.TextSize = 13
Instance.new("UICorner", autoFarmBtn)

autoFarmBtn.MouseButton1Click:Connect(function()
    autoFarmActive = not autoFarmActive
    if autoFarmActive then
        autoFarmBtn.Text = "Ativado"
        task.spawn(autoFarm)
    else
        autoFarmBtn.Text = "Ativar"
    end
end)

-- ESP de jogadores em tempo real
function createESP()
    local function updateAllESP()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local char = player.Character
                if char and char:FindFirstChild("Head") and player:FindFirstChild("PlayerStats") then
                    local billboard = char:FindFirstChild("ESP")
                    if not billboard then
                        billboard = Instance.new("BillboardGui")
                        billboard.Name = "ESP"
                        billboard.Adornee = char.Head
                        billboard.Size = UDim2.new(0, 100, 0, 30)
                        billboard.StudsOffset = Vector3.new(0, 2, 0)
                        billboard.AlwaysOnTop = true
                        billboard.Parent = char

                        local label = Instance.new("TextLabel")
                        label.Size = UDim2.new(1, 0, 1, 0)
                        label.BackgroundTransparency = 1
                        label.TextColor3 = Color3.new(1, 1, 1)
                        label.TextStrokeTransparency = 0.5
                        label.Font = Enum.Font.GothamBold
                        label.TextSize = 12
                        label.Text = ""
                        label.Name = "ESPLabel"
                        label.Parent = billboard
                    end

                    local label = billboard:FindFirstChild("ESPLabel")
                    if label then
                        local stamina = player.PlayerStats:FindFirstChild("Stamina")
                        local style = player.PlayerStats:FindFirstChild("Style")
                        local text = ""
                        if stamina and stamina:IsA("NumberValue") then
                            text = text .. "STA: " .. math.floor(stamina.Value)
                        end
                        if style and style:IsA("StringValue") then
                            text = text .. " | Style: " .. style.Value
                        end
                        label.Text = text
                    end
                end
            end
        end
    end

    while true do
        if espActive then
            pcall(updateAllESP)
        end
        task.wait(1)
    end
end

-- Botão ESP na interface
local espFrame = Instance.new("Frame")
espFrame.Size = UDim2.new(1, 0, 0, 40)
espFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
espFrame.Parent = contentList
Instance.new("UICorner", espFrame)

local espLabel = Instance.new("TextLabel", espFrame)
espLabel.Size = UDim2.new(0.6, 0, 1, 0)
espLabel.Position = UDim2.new(0.05, 0, 0, 0)
espLabel.Text = "ESP Jogadores"
espLabel.TextColor3 = Color3.new(1, 1, 1)
espLabel.Font = Enum.Font.GothamBold
espLabel.TextSize = 14
espLabel.BackgroundTransparency = 1
espLabel.TextXAlignment = Enum.TextXAlignment.Left

local espBtn = Instance.new("TextButton", espFrame)
espBtn.Size = UDim2.new(0.25, 0, 0.6, 0)
espBtn.Position = UDim2.new(0.7, 0, 0.2, 0)
espBtn.Text = "Ativar"
espBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
espBtn.TextColor3 = Color3.new(1, 1, 1)
espBtn.Font = Enum.Font.GothamBold
espBtn.TextSize = 13
Instance.new("UICorner", espBtn)

espBtn.MouseButton1Click:Connect(function()
    espActive = not espActive
    espBtn.Text = espActive and "Ativado" or "Ativar"
end)

-- Teclas para abrir/fechar GUI e ativar AutoFarm
UserInputService.Input
