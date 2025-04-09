local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "😊 Tutorial script",
    Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
    LoadingTitle = "Example Hub",
    LoadingSubtitle = "by endsleepy",
    Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes
 
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface
 
    ConfigurationSaving = {
       Enabled = false,
       FolderName = nil, -- Create a custom folder for your hub/game
       FileName = "Youtube Tutorial"
    },
 
    Discord = {
       Enabled = true, -- Prompt the user to join your Discord server if their executor supports it
       Invite = "discord.gg/solacew", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
       RememberJoins = false -- Set this to false to make them join the discord every time they load it up
    },
 
    KeySystem = true, -- Set this to true to use our key system
    KeySettings = {
       Title = "Tutorial | Key",
       Subtitle = "Key System",
       Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
       FileName = "Examplehubkey", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
       SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
       GrabKeyFromSite = true, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
       Key = {"https://pastebin.com/raw/nSyFQgYi"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
    }
 })

 local MainTab = Window:CreateTab("HOME ", nil) -- Title, Image
 local Section = MainTab:CreateSection("Main")
 Rayfield:Notify({
   Title = "You excuted the script!!",
   Content = "💖",
   Duration = 5.5,
   Image = nil,
})

local Button = MainTab:CreateButton({
   Name = "Button Example | Princess Tycoon Script",
   Callback = function()
      getgenv().Key = "E"

getgenv().Prediction = 0.129574

getgenv().ResolveKey = "M"

getgenv().Smoothing = 0.0051

getgenv().JumpSmoothness = 0.092

getgenv().Diameter = - 0.8



local resolver = false



local client = game.Players.LocalPlayer

local camera = game.Workspace.CurrentCamera

local Resolvedvelocity

local target, aiming



local getClosestBodyPartToCursor = function()

    local closestDist = 600

    local closestPlr = nil

    local closestPart = true

    for _, v in pairs(game.Players:GetPlayers()) do

        if v ~= client and v.Character and v.Character:FindFirstChild("Humanoid") then

            local character = v.Character

            for _, part in pairs(character:GetDescendants()) do

                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then

                    local screenPos, Visible = camera:WorldToViewportPoint(part.Position)

                    if Visible then

                        local distToMouse = (Vector2.new(client:GetMouse().X, client:GetMouse().Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude

                        if distToMouse < closestDist then

                            closestPlr = v

                            closestPart = part

                            closestDist = distToMouse

                        end

                    end

                end

            end

        end

    end

    return closestPlr, closestPart, closestDist

end



local UserInputService = game:GetService("UserInputService")



UserInputService.InputBegan:Connect(function(input, processed)

    if not processed then

        if input.KeyCode == Enum.KeyCode[getgenv().ResolveKey:upper()] then

            resolver = not resolver

            game.StarterGui:SetCore("SendNotification", {

                Title = tostring(resolver),

                Text = "resolve",

                Duration = 0.05

            })

           

            if not resolver then

                aiming = false

                target = nil

            end

        end

    end

end)



local Smoothness = 5

local Stored = {}

local Value = 1



local recalculatedVelocity = function(player)

    local Tick = tick()



    Stored[Value] = {

        pos = player.Position,

        time = Tick,

    }



    Value = Value + 1

    if Value > Smoothness then

        Value = 1

    end



    local Pos = Vector3.new()

    local Time = 0



    for i = 1, Smoothness do

        local Data = Stored[i]

        if Data then

            Pos = Pos + Data.pos

            Time = Time + Data.time

        end

    end



    if Stored[Value] then

        local velocity = (player.Position - Stored[Value].pos) / (Tick - Stored[Value].time)

        return velocity

    end

end



local aimingMethod = function(player)

    if not player or not player.Character then

        return

    end



    local velocity = Resolvedvelocity or player.Character.HumanoidRootPart.Velocity

    local isJumping = player.Character.HumanoidRootPart.Velocity.Y > 0 and

                                (player.Character.Humanoid:GetState() == Enum.HumanoidStateType.Freefall or

                                player.Character.Humanoid:GetState() == Enum.HumanoidStateType.Jumping)



    local Position = isJumping and (player.Character.LowerTorso.Position + Vector3.new(0, getgenv().Diameter, 0)) or player.Character.HumanoidRootPart.Position



    local current = player.Character.HumanoidRootPart.Position



    local result = current:Lerp(Position, getgenv().JumpSmoothness)



    return result + velocity * getgenv().Prediction

end



game:GetService("RunService").RenderStepped:Connect(function ()

    if resolver and target ~= nil then

        Resolvedvelocity = recalculatedVelocity(target.Character.HumanoidRootPart)

    else

        Resolvedvelocity = nil

    end

end)



UserInputService.InputBegan:Connect(function(input)

    if input.KeyCode == Enum.KeyCode[getgenv().Key:upper()] then

        aiming = not aiming

        if aiming then

            target = getClosestBodyPartToCursor()

        else

            target = nil

        end

    end

end)



local function onToolActivated()

    if target then

        local position = aimingMethod(target)

        game.ReplicatedStorage.MainEvent:FireServer("UpdateMousePos", position)

    end

end



local function onCharacterAdded(character)

    character.DescendantAdded:Connect(function(descendant)

        if descendant:IsA("Tool") then

            descendant.Activated:Connect(onToolActivated)

        end

    end)

end



game.Players.LocalPlayer.CharacterAdded:Connect(onCharacterAdded)



if game.Players.LocalPlayer.Character then

    onCharacterAdded(game.Players.LocalPlayer.Character)

end



local function easing(t)

    return 1 - (1 - t) * (1 - t) * (1 - t)

end



game:GetService("RunService").Heartbeat:Connect(function()

    if aiming and target ~= nil then

        local position = aimingMethod(target)



        local lookAt = CFrame.new(camera.CFrame.Position, position)

        local new = camera.CFrame:Lerp(lookAt, easing(getgenv().Smoothing))

       

        camera.CFrame = new

    end

end)
   end,
})

local Slider = MainTab:CreateSlider({
   Name = "Walk Speed",
   Range = {0, 300},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "Slider1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
         game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = (Value)
   end,
})