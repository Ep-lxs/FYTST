-- THIS IS NOT HARMFUL AGAINST ANY GAMES OR ANYBODY, THIS WAS MADE TO IMPROVE IN-GAME UI FOR
-- https://www.roblox.com/games/6763429099/Flex-Your-Time-or-Steal-Time

local Players = game:GetService("Players")
local Rep = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()

local Overhead = Rep.OverheadGUI.OverheadGUI

local function comma_value(amount)
    local formatted = amount
    while true do  
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if (k==0) then
            break
        end
    end
    return formatted
end

local function setup(player, character)
    if not character or player then return end

    local NameGui = Instance.new("BillboardGui")
    NameGui.Name = "NameGui"
    NameGui.StudsOffset = Vector3.new(0, 2.5, 0)
    NameGui.Size = UDim2.new(8, 0, 3, 0)
    NameGui.Parent = character.Head

    local Username = Instance.new("Frame")
    Username.Size = Overhead.NameLevel.Size
    Username.AnchorPoint = Vector2.new(0, 1)
    Username.Position = UDim2.new(0, 0, 1, 0)
    Username.BackgroundTransparency = 1
    Username.Name = "Username"
    
    local Main_U = Instance.new("TextLabel")
    Main_U.Size = UDim2.new(1, 0, 1, 0)
    Main_U.Name = "Main"
    Main_U.Text = player.DisplayName.." (@"..player.Name..")"
    Main_U.Font = Enum.Font.Gotham
    Main_U.TextColor3 = Color3.fromRGB(255, 255, 255)
    Main_U.Font = Enum.Font.Gotham
    Main_U.ZIndex = 2
    Main_U.TextScaled = true
    Main_U.BackgroundTransparency = 1
    Main_U.Parent = Username

    local Shadow_U = Instance.new("TextLabel")
    Shadow_U.Size = UDim2.new(1, 0, 1, 0)
    Shadow_U.Name = "Shadow"
    Shadow_U.Text = player.DisplayName.." (@"..player.Name..")"
    Shadow_U.Font = Enum.Font.Gotham
    Shadow_U.TextColor3 = Color3.fromRGB(0, 0, 0)
    Shadow_U.TextScaled = true
    Shadow_U.BackgroundTransparency = 1
    Shadow_U.Position = UDim2.new(0, -2, 0, -2)
    Shadow_U.Parent = Username

    local Health = Instance.new("Frame")
    Health.Size = Overhead.Health.Size
    Health.BackgroundTransparency = 1
    Health.Position = Overhead.Health.Position
    Health.Name = "Health"

    local Main_H = Instance.new("TextLabel")
    Main_H.BackgroundTransparency = 1
    Main_H.Size = UDim2.new(1, 0, 1, 0)
    Main_H.Name = "Main"
    Main_H.Text = math.floor(character.Humanoid.Health).."/"..character.Humanoid.MaxHealth
    Main_H.TextScaled = true
    Main_H.Font = Enum.Font.Gotham
    Main_H.TextColor3 = Color3.fromHSV((character.Humanoid.Health/character.Humanoid.MaxHealth)*.3, 1, 1)
    Main_H.ZIndex = 2
    Main_H.Parent = Health

    local Shadow_H = Instance.new("TextLabel")
    Shadow_H.Size = UDim2.new(1, 0, 1, 0)
    Shadow_H.Name = "Shadow"
    Shadow_H.BackgroundTransparency = 1
    Shadow_H.TextScaled = true
    Shadow_H.Text = math.floor(character.Humanoid.Health).."/"..character.Humanoid.MaxHealth
    Shadow_H.Font = Enum.Font.Gotham
    Shadow_H.TextColor3 = Color3.fromRGB(0, 0, 0)
    Shadow_H.Position = UDim2.new(0, -2, 0, -2)
    Shadow_H.Parent = Health

    local Time = Instance.new("Frame")
    Time.Size = Overhead.Time.Size
    Time.BackgroundTransparency = 1
    Time.Position = Overhead.Time.Position
    Time.Name = "Time"

    local Main_T = Instance.new("TextLabel")
    Main_T.BackgroundTransparency = 1
    Main_T.Size = UDim2.new(1, 0, 1, 0)
    Main_T.Name = "Main"
    Main_T.Text = comma_value(player.leaderstats.Time.Value)
    Main_T.TextScaled = true
    Main_T.Font = Enum.Font.Gotham
    Main_T.TextColor3 = Color3.fromRGB(255, 255, 255)
    Main_T.ZIndex = 2
    Main_T.Parent = Time

    local Shadow_T = Instance.new("TextLabel")
    Shadow_T.Size = UDim2.new(1, 0, 1, 0)
    Shadow_T.Name = "Shadow"
    Shadow_T.BackgroundTransparency = 1
    Shadow_T.TextScaled = true
    Shadow_T.Text = comma_value(player.leaderstats.Time.Value)
    Shadow_T.Font = Enum.Font.Gotham
    Shadow_T.TextColor3 = Color3.fromRGB(0, 0, 0)
    Shadow_T.Position = UDim2.new(0, -2, 0, -2)
    Shadow_T.Parent = Time

    for _,obj in pairs(character.HumanoidRootPart.OverheadGUI:GetChildren()) do
        obj:Destroy()
    end

    if player.DisplayName == player.Name then
        Main_U.Text = player.Name
        Shadow_U.Text = player.Name
    end

    character.Humanoid.NameDisplayDistance = 0
    character.Humanoid.HealthDisplayDistance = 0
    Username.Parent = NameGui
    Health.Parent = NameGui
    Time.Parent = NameGui

    character:WaitForChild("Humanoid").HealthChanged:Connect(function()
        Main_H.Text = math.floor(character.Humanoid.Health).."/"..character.Humanoid.MaxHealth
        Shadow_H.Text = math.floor(character.Humanoid.Health).."/"..character.Humanoid.MaxHealth
        Main_H.TextColor3 = Color3.fromHSV((character.Humanoid.Health/character.Humanoid.MaxHealth)*.3, 1, 1)
    end)

    player.leaderstats.Time:GetPropertyChangedSignal("Value"):Connect(function()
        Main_T.Text = comma_value(player.leaderstats.Time.Value)
        Shadow_T.Text = comma_value(player.leaderstats.Time.Value)
    end)

    if character:FindFirstChild("HumanoidRootPart"):FindFirstChildOfClass("BillboardGui") then
        character:FindFirstChild("HumanoidRootPart"):FindFirstChildOfClass("BillboardGui"):Destroy()
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        setup(player, character)
    end)
end)

for _,player in pairs(Players:GetPlayers()) do
    player.CharacterAdded:Connect(function(character)
        setup(player, character)
    end)
    player.CharacterAdded:Wait()
    setup(player, player.Character)
end
