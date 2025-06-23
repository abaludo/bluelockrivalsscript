-- Referências principais
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")

-- Remove o script de ban do servidor
local banScript = game:GetService("ReplicatedStorage"):FindFirstChild("CmdrConfig")
if banScript and banScript:FindFirstChild("Commands") then
    local commands = banScript:FindFirstChild("Commands")
    if commands:FindFirstChild("banServer") then
        commands.banServer:Destroy()
    end
end

-- GUI principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BlueLockScriptGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Frame principal
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 350)
MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 6)

-- Título
local title = Instance.new("TextLabel", MainFrame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Blue Lock Script"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16

-- Lista de elementos
local contentList = Instance.new("Frame", MainFrame)
contentList.Size = UDim2.new(1, -20, 1, -40)
contentList.Position = UDim2.new(0, 10, 0, 35)
contentList.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", contentList)
layout.Padding = UDim.new(0, 10)
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- Função para criar entradas
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

-- Categoria Estilo
createInputSection("Estilo:", "Style", true)

-- Categoria Flow
createInputSection("Fluxo:", "Flow", false)

-- Misc: Stamina infinita
-- (o restante do código continua igual)
