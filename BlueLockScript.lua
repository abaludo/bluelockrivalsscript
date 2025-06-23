-- Referências principais
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")

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
local miscFrame = Instance.new("Frame")
miscFrame.Size = UDim2.new(1, 0, 0, 40)
miscFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
miscFrame.Parent = contentList
Instance.new("UICorner", miscFrame)

local miscLabel = Instance.new("TextLabel", miscFrame)
miscLabel.Size = UDim2.new(0.6, 0, 1, 0)
miscLabel.Position = UDim2.new(0.05, 0, 0, 0)
miscLabel.Text = "Stamina Infinita"
miscLabel.TextColor3 = Color3.new(1, 1, 1)
miscLabel.Font = Enum.Font.GothamBold
miscLabel.TextSize = 14
miscLabel.BackgroundTransparency = 1
miscLabel.TextXAlignment = Enum.TextXAlignment.Left

local staminaToggle = Instance.new("TextButton", miscFrame)
staminaToggle.Size = UDim2.new(0.25, 0, 0.6, 0)
staminaToggle.Position = UDim2.new(0.7, 0, 0.2, 0)
staminaToggle.Text = "Ativar"
staminaToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
staminaToggle.TextColor3 = Color3.new(1, 1, 1)
staminaToggle.Font = Enum.Font.GothamBold
staminaToggle.TextSize = 13
Instance.new("UICorner", staminaToggle)

local infinite = false
staminaToggle.MouseButton1Click:Connect(function()
    infinite = not infinite
    staminaToggle.Text = infinite and "Ativado" or "Ativar"
    while infinite do
        local stats = LocalPlayer:FindFirstChild("PlayerStats")
        if stats and stats:FindFirstChild("Stamina") then
            local val = stats.Stamina
            if val and val:IsA("NumberValue") then
                val.Value = 10000
            end
        end
        task.wait(0.1)
    end
end)

-- Misc: Despertar (InAwakening) e FlowBuffs (InFlow)
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

-- Tecla M para abrir/fechar GUI
local guiVisible = true
UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.M then
        guiVisible = not guiVisible
        MainFrame.Visible = guiVisible
    end
end)
