--  THIS SCRIPT IS NOT MEANT TO HARM ANY GAME, IT IS MADE TO IMPROVE THE UI FOR
-- https://www.roblox.com/games/6763429099/Flex-Your-Time-or-Steal-Time#
-- BECAUSE THE CURRENT UI IS SHIT

local Players = game:GetService("Players")
local Rep = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()

local PlayerGui = Player:WaitForChild("PlayerGui")
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

local function setupNametag(player, character)
    
    local NameGui = Instance.new("BillboardGui")
    NameGui.Name = "NameGui"
    NameGui.StudsOffset = Vector3.new(0, 1.5, 0)
    NameGui.MaxDistance = 50
    NameGui.ZIndexBehavior = "Global"
    NameGui.Size = UDim2.new(7, 0, 0.9, 0)
    
    local Time = Instance.new("Frame")
    Time.Size = UDim2.new(1, 0, 0.375, 0)
    Time.BackgroundTransparency = 1
    Time.Name = "Time"
    Time.Parent = NameGui 
    
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
    
    local Username = Instance.new("Frame")
    Username.Size = UDim2.new(1, 0, 0.3, 0)
    Username.Position = UDim2.new(0, 0, 0.375, 0)
    Username.BackgroundTransparency = 1
    Username.Name = "Username"
    Username.Parent = NameGui
    
    local Main_U = Instance.new("TextLabel")
    Main_U.Size = UDim2.new(1, 0, 1, 0)
    Main_U.Name = "Main"
    Main_U.Text = "@"..player.Name
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
    Shadow_U.Text = "@"..player.Name
    Shadow_U.Font = Enum.Font.Gotham
    Shadow_U.TextColor3 = Color3.fromRGB(0, 0, 0)
    Shadow_U.TextScaled = true
    Shadow_U.BackgroundTransparency = 1
    Shadow_U.Position = UDim2.new(0, -2, 0, -2)
    Shadow_U.Parent = Username
    
    local Health = Instance.new("Frame")
    Health.Size = UDim2.new(0.3, 0, 0.135, 0)
    Health.BackgroundTransparency = 1
    Health.AnchorPoint = Vector2.new(0.5, 0)
    Health.Position = UDim2.new(0.5, 0, 0.75, 0)
    Health.Name = "Health"
    Health.Parent = NameGui

    local Slider = Instance.new("Frame")
    Slider.BackgroundTransparency = 0
    Slider.Size = UDim2.new(character.Humanoid.Health/character.Humanoid.MaxHealth, 0, 1, 0)
    Slider.Name = "Slider"
    Slider.BackgroundColor3 = Color3.fromHSV((character.Humanoid.Health/character.Humanoid.MaxHealth)*.28, .9, .9)
    Slider.Parent = Health
    
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Transparency = 0.2
    UIStroke.Thickness = 1.51
    UIStroke.Parent = Health
    UIStroke.ApplyStrokeMode = "Border"

   -- if player.DisplayName == player.Name then
   --     Main_U.Text = player.Name
   --     Shadow_U.Text = player.Name
   -- end

    if character.HumanoidRootPart:FindFirstChild("OverheadGUI") then
        character.HumanoidRootPart:FindFirstChild("OverheadGUI").PlayerToHideFrom = Player
    end

    for _,v in pairs(character.Head:GetChildren()) do
        if v:IsA("BillboardGui") then
            v:Destroy()
        end
    end
    
    character.Humanoid.NameDisplayDistance = 0
    character.Humanoid.HealthDisplayDistance = 0

    character:WaitForChild("Humanoid").HealthChanged:Connect(function()
        if Slider then
            Slider:TweenSize(
                UDim2.new(character.Humanoid.Health/character.Humanoid.MaxHealth, 0, 1, 0), 
                Enum.EasingDirection.In,   
                Enum.EasingStyle.Linear, 
                (character.Humanoid.Health/character.Humanoid.MaxHealth) * 0.5,      
                true    
            )
        end
        --Slider.Size = UDim2.new(character.Humanoid.Health/character.Humanoid.MaxHealth, 0, 1, 0)
        Slider.BackgroundColor3 = Color3.fromHSV((character.Humanoid.Health/character.Humanoid.MaxHealth)*.28, .9, .9)
    end)

    player.leaderstats.Time:GetPropertyChangedSignal("Value"):Connect(function()
        Main_T.Text = comma_value(player.leaderstats.Time.Value)
        Shadow_T.Text = comma_value(player.leaderstats.Time.Value)
    end)

    NameGui.Parent = character.Head
end

function setupWorkspace()
    local SurfaceGui = workspace.Description.SurfaceGui
    SurfaceGui.AlwaysOnTop = false
    SurfaceGui.TextLabel.Font = Enum.Font.GothamSemibold
    SurfaceGui.TextLabel.TextColor3 = Color3.fromRGB(235, 235, 235)
    SurfaceGui.Parent.Size = Vector3.new(30, 3.3, 0.09)

    local SurfaceGui_2 = workspace.GameLikes.SurfaceGui
    SurfaceGui_2.AlwaysOnTop = false
    SurfaceGui_2.TextLabel.Font = Enum.Font.GothamSemibold
    SurfaceGui_2.TextLabel.TextColor3 = Color3.fromRGB(235, 235, 235)
end

function setupUI()
    local Killfeed = PlayerGui:FindFirstChild("Kill Feed")
    Killfeed.FeedManager.killMessage.Font = Enum.Font.Gotham
    Killfeed.FeedManager.killMessage.TextColor3 = Color3.fromRGB(235, 235, 235)
    Killfeed.FeedManager.killMessage.TextStrokeTransparency = 1
    Killfeed.FeedManager.killMessage.TextXAlignment = Enum.TextXAlignment.Right

    Killfeed.Feed.AnchorPoint = Vector2.new(1, 1)
    Killfeed.Feed.Position = UDim2.new(1, 0, 1, 0)
    Killfeed.Feed.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    if not Killfeed:FindFirstChild("UIPadding") then
        local UIPadding = Instance.new("UIPadding")
        UIPadding.PaddingRight = UDim.new(0.002, 0)
        UIPadding.PaddingBottom = UDim.new(0.005, 0)
        UIPadding.Parent = Killfeed 
    end

    local ServerRegion = PlayerGui.Server.TextLabel
    ServerRegion.Position = UDim2.new(0.002, 0, 1, 0)
    ServerRegion.AnchorPoint = Vector2.new(0, 1)
    ServerRegion.Font = Enum.Font.Gotham
    ServerRegion.TextStrokeTransparency = 1
    ServerRegion.TextColor3 = Color3.fromRGB(235, 235, 235)

    local Main = PlayerGui.Main

    for _,obj in pairs(Main:GetChildren()) do
        if obj:IsA("ImageLabel") then
            obj.Frame.TextLabel.Font = Enum.Font.Gotham
            obj.Frame.TextLabel.TextColor3 = Color3.fromRGB(235, 235, 235)
            obj.Icon.ImageColor3 = Color3.fromRGB(235, 235, 235)
            if not obj.Frame.TextLabel:FindFirstChild("UITextSizeConstraint") then
                local UITextSizeConstraint = Instance.new("UITextSizeConstraint")
                UITextSizeConstraint.MaxTextSize = 34
                UITextSizeConstraint.Parent = obj.Frame.TextLabel  
            end
        end
    end

end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        wait(1)
        setupNametag(player, character)
    end)
end)

for _,player in pairs(Players:GetPlayers()) do
    local character = player.Character or player.CharacterAdded:Wait()
    setupNametag(player, character)

    player.CharacterAdded:Connect(function(character)
        delay(1, function()
            setupNametag(player, character)
            if player.Name == Player.Name then
                setupUI()
            end
        end)
    end)
end

setupWorkspace()
setupUI()
