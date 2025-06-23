-- Referências principais
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

-- Variáveis globais
local espActive = false
local autofarmActive = false

-- Remove scripts de kick e ban
local function removeSecurity()
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
end

removeSecurity()

-- GUI principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BlueLockScriptGui"
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

title.TextYAlignment = Enum.TextYAlignment.Center

local infoLabel = Instance.new("TextLabel", MainFrame)
infoLabel.Size = UDim2.new(1, 0, 0, 20)
infoLabel.Position = UDim2.new(0, 0, 1, -20)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "(M) Para abrir/fechar GUI | (P) Para iniciar Auto Farm"
infoLabel.TextColor3 = Color3.new(1, 1, 1)
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextSize = 12

local contentList = Instance.new("Frame", MainFrame)
contentList.Size = UDim2.new(1, -20, 1, -60)
contentList.Position = UDim2.new(0, 10, 0, 35)
contentList.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", contentList)
layout.Padding = UDim.new(0, 10)
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- Funções GUI (exemplo: estilo, fluxo, despertar, flowbuffs)
-- [Estas funções devem ser reinseridas aqui conforme sua versão anterior]

-- ESP
local function createESP()
    while true do
        if espActive then
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
        task.wait(1)
    end
end

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

task.spawn(createESP)

-- Auto Farm
local function autofarm()
    autofarmActive = not autofarmActive
    while autofarmActive do
        local football = Workspace:FindFirstChild("Football")
        if football then
            LocalPlayer.Character:PivotTo(football.CFrame + Vector3.new(0, 2, 0))
        end

        task.wait(0.5)

        local hasBall = false
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Values") then
            local v = char.Values:FindFirstChild("HasBall")
            if v and v:IsA("BoolValue") and v.Value then
                hasBall = true
            end
        end

        if hasBall then
            for i = 1, 5 do
                LocalPlayer.Character:PivotTo(CFrame.new(Vector3.new(-245, 14, -49)))
                task.wait(0.1)
                mouse1click()
                task.wait(0.1)
            end
        end

        task.wait(1)
    end
end

local autofarmFrame = Instance.new("Frame")
autofarmFrame.Size = UDim2.new(1, 0, 0, 40)
autofarmFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
autofarmFrame.Parent = contentList
Instance.new("UICorner", autofarmFrame)

local autofarmLabel = Instance.new("TextLabel", autofarmFrame)
autofarmLabel.Size = UDim2.new(0.6, 0, 1, 0)
autofarmLabel.Position = UDim2.new(0.05, 0, 0, 0)
autofarmLabel.Text = "Auto Farm"
autofarmLabel.TextColor3 = Color3.new(1, 1, 1)
autofarmLabel.Font = Enum.Font.GothamBold
autofarmLabel.TextSize = 14
autofarmLabel.BackgroundTransparency = 1
autofarmLabel.TextXAlignment = Enum.TextXAlignment.Left

local autofarmBtn = Instance.new("TextButton", autofarmFrame)
autofarmBtn.Size = UDim2.new(0.25, 0, 0.6, 0)
autofarmBtn.Position = UDim2.new(0.7, 0, 0.2, 0)
autofarmBtn.Text = "Ativar"
autofarmBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
autofarmBtn.TextColor3 = Color3.new(1, 1, 1)
autofarmBtn.Font = Enum.Font.GothamBold
autofarmBtn.TextSize = 13
Instance.new("UICorner", autofarmBtn)

autofarmBtn.MouseButton1Click:Connect(function()
    autofarm()
    autofarmBtn.Text = autofarmActive and "Ativado" or "Ativar"
end)

-- Teclas para abrir/fechar GUI e autofarm
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.M then
        MainFrame.Visible = not MainFrame.Visible
    elseif input.KeyCode == Enum.KeyCode.P then
        autofarm()
        autofarmBtn.Text = autofarmActive and "Ativado" or "Ativar"
    end
end)
