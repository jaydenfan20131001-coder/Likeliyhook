local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- ==================== KEY SYSTEM (ORIGINAL - UNTOUCHED) ====================
local correctKey = "Presurefixhd"

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DeathHubKey"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 340, 0, 260)
frame.Position = UDim2.new(0.5, -170, 0.5, -130)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
frame.Parent = screenGui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 55)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.Text = "DEATH HUB"
title.TextColor3 = Color3.fromRGB(255, 55, 55)
title.Font = Enum.Font.GothamBlack
title.TextSize = 28
title.Parent = frame
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 12)

local note = Instance.new("TextLabel")
note.Size = UDim2.new(0.9, 0, 0, 30)
note.Position = UDim2.new(0.05, 0, 0.28, 0)
note.BackgroundTransparency = 1
note.Text = "Key only from owner"
note.TextColor3 = Color3.fromRGB(180, 180, 180)
note.Font = Enum.Font.Gotham
note.TextSize = 16
note.Parent = frame

local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(0.85, 0, 0, 48)
textBox.Position = UDim2.new(0.075, 0, 0.42, 0)
textBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
textBox.PlaceholderText = "Enter Key"
textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
textBox.Font = Enum.Font.GothamBlack
textBox.TextSize = 18
textBox.Parent = frame
Instance.new("UICorner", textBox).CornerRadius = UDim.new(0, 8)

local enterBtn = Instance.new("TextButton")
enterBtn.Size = UDim2.new(0.85, 0, 0, 45)
enterBtn.Position = UDim2.new(0.075, 0, 0.65, 0)
enterBtn.BackgroundColor3 = Color3.fromRGB(220, 40, 40)
enterBtn.Text = "ENTER"
enterBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
enterBtn.Font = Enum.Font.GothamBlack
enterBtn.TextSize = 20
enterBtn.Parent = frame
Instance.new("UICorner", enterBtn).CornerRadius = UDim.new(0, 8)

-- Draggable
local dragging = false
local dragStart, startPos
title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

-- ==================== ENTER KEY LOGIC ====================
enterBtn.MouseButton1Click:Connect(function()
    if textBox.Text == correctKey then
        screenGui:Destroy()

        local function SecureFetch(url)
            local success, result = pcall(function() return game:HttpGet(url, true) end)
            if not success then success, result = pcall(function() return request({Url = url, Method = "GET"}).Body end) end
            return success and result or nil
        end

        local Rayfield = loadstring(SecureFetch("https://sirius.menu/rayfield"))()
        if not Rayfield then warn("Rayfield failed") return end

        local Window = Rayfield:CreateWindow({
            Name = "DEATH HUB V4.7",
            LoadingTitle = "Death Hub",
            LoadingSubtitle = "Full Advanced Build",
            ConfigurationSaving = { Enabled = true, FileName = "DeathHub_V47" },
            Discord = { Enabled = true, Invite = "Hhrpe3X559" }
        })

        Rayfield:Notify({Title = "Death Hub V4.7", Content = "All Systems Restored", Duration = 5})

        -- ==================== CONFIG ====================
        local config = {
            voidActive = false, fakeDesyncActive = false, meowDesyncActive = false,
            orbitActive = false, antiAimEnabled = false,
            pitchMode = "Disabled", yawMode = "Disabled", underground = false,
            entropyFactor = 80, phaseShift = 180,
            bypassStrength = 75, syncAccuracy = 95,
            iterationCount = 32,
            voidStabilizer = false, positionResolver = false,
            predictiveSync = false, failsafeRecovery = false, positionRestore = false,
            orbitSpeed = 12, orbitRadius = 18,
            darkTextureActive = false,
            resolutionScreenerActive = false
        }

        local connections = {}
        local lastVoid = 0
        local orbitAngle = 0
        local fakePosition = nil
        local lastGoodPosition = nil
        local velocity = Vector3.new()

        local nuclearPos = CFrame.new(2829929192991309029221, 8928912913891838389274918243, 8292892280802820)

        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local HRP = Character:WaitForChild("HumanoidRootPart")

        LocalPlayer.CharacterAdded:Connect(function(new)
            Character = new
            HRP = new:WaitForChild("HumanoidRootPart")
            fakePosition = nil
            lastGoodPosition = nil
        end)

        -- ==================== DARK TEXTURE FUNCTION (from dark.txt) ====================
        local function isMapPart(part)
            if not part:IsA("BasePart") then return false end
            if part:FindFirstAncestorOfClass("Tool") then return false end
            local parentModel = part:FindFirstAncestorOfClass("Model")
            if parentModel and parentModel:FindFirstChildOfClass("Humanoid") then return false end
            if part:FindFirstChildWhichIsA("SpecialMesh") or part:FindFirstChildWhichIsA("MeshPart") then return false end
            if part.Size.Magnitude < 5 then return false end
            if part.Material == Enum.Material.Grass or (part.Name:lower():find("tree")) then return false end
            if not part.Anchored then return false end
            return true
        end

        local function applyCharcoal()
            for _, part in pairs(workspace:GetDescendants()) do
                if isMapPart(part) then
                    part.Color = Color3.fromRGB(50, 50, 50)
                    part.Material = Enum.Material.SmoothPlastic
                end
            end
        end

        local function toggleDarkTexture(state)
            config.darkTextureActive = state
            if state then
                applyCharcoal()
                -- Re-apply on new parts spawning
                connections.darkTexture = workspace.DescendantAdded:Connect(function(part)
                    if isMapPart(part) then
                        part.Color = Color3.fromRGB(50, 50, 50)
                        part.Material = Enum.Material.SmoothPlastic
                    end
                end)
            else
                if connections.darkTexture then
                    connections.darkTexture:Disconnect()
                end
            end
        end

        -- ==================== RESOLUTION SCREENER ====================
        getgenv().Resolution = getgenv().Resolution or {}
        getgenv().Resolution[".gg/scripters"] = 0.81

        local Camera = workspace.CurrentCamera
        local resolutionConnection

        local function toggleResolutionScreener(state)
            config.resolutionScreenerActive = state
            if state then
                if not getgenv().gg_scripters then
                    resolutionConnection = RunService.RenderStepped:Connect(function()
                        Camera.CFrame = Camera.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, getgenv().Resolution[".gg/scripters"], 0, 0, 0, 1)
                    end)
                    getgenv().gg_scripters = "Aori0001"
                end
            else
                if resolutionConnection then
                    resolutionConnection:Disconnect()
                    resolutionConnection = nil
                end
            end
        end

        -- ==================== VOID + DESYNC (Xtra Void Improved) ====================
        local function UpdateDesync()
            for _, v in pairs(connections) do 
                if v ~= connections.orbit then pcall(function() v:Disconnect() end) end 
            end

            connections.desync = RunService.Heartbeat:Connect(function()
                if not HRP then return end
                local now = tick()
                lastGoodPosition = lastGoodPosition or HRP.CFrame

                if config.voidActive and now - lastVoid >= 0.012 then
                    lastVoid = now
                    fakePosition = HRP.CFrame

                    local intensity = config.entropyFactor / 100
                    for i = 1, math.floor(config.iterationCount / 10) do
                        local offset = Vector3.new(
                            math.random(-99999999 * intensity, 99999999 * intensity),
                            math.random(40000000 * intensity, 160000000 * intensity),
                            math.random(-99999999 * intensity, 99999999 * intensity)
                        )
                        HRP.CFrame = HRP.CFrame + offset
                    end

                    task.delay(0.009, function()
                        if HRP and fakePosition then
                            local final = fakePosition * CFrame.Angles(math.rad(config.phaseShift * (math.random() - 0.5)), 0, 0)
                            if config.voidStabilizer then
                                final = final:Lerp(HRP.CFrame, config.syncAccuracy/100)
                            end
                            if config.predictiveSync then
                                final = final + (velocity * 0.08)
                            end
                            HRP.CFrame = final
                        end
                    end)
                end

                if config.fakeDesyncActive then
                    if not fakePosition then fakePosition = HRP.CFrame end
                    HRP.CFrame = nuclearPos
                    task.delay(0.0001, function()
                        if HRP and fakePosition then
                            HRP.CFrame = fakePosition * CFrame.new(math.random(-9,9), math.random(-5,7), math.random(-9,9))
                        end
                    end)
                end

                if config.meowDesyncActive then
                    if not fakePosition then fakePosition = HRP.CFrame end
                    local flick = Vector3.new(math.random(-30000000,30000000), math.random(40000000,90000000), math.random(-30000000,30000000))
                    HRP.CFrame = fakePosition * CFrame.Angles(math.rad(math.random(-120,120)), math.rad(math.random(-400,400)), math.rad(math.random(-120,120))) + flick
                    task.delay(0.025, function() if HRP and fakePosition then HRP.CFrame = fakePosition end end)
                end

                if config.failsafeRecovery and fakePosition and (HRP.Position - fakePosition.Position).Magnitude > 400 then
                    HRP.CFrame = fakePosition
                end
                if config.positionRestore and lastGoodPosition then
                    HRP.CFrame = lastGoodPosition
                end

                velocity = HRP.AssemblyLinearVelocity
            end)
        end

        -- ==================== ANTI-AIM (Original) ====================
        connections.antiAim = RunService.RenderStepped:Connect(function()
            if not config.antiAimEnabled or not HRP then return end
            local rootCFrame = HRP.CFrame

            if config.pitchMode == "Up" then 
                HRP.CFrame = rootCFrame * CFrame.Angles(math.rad(-89), 0, 0) 
            elseif config.pitchMode == "Down" then 
                HRP.CFrame = rootCFrame * CFrame.Angles(math.rad(89), 0, 0) 
            elseif config.pitchMode == "Random" then 
                HRP.CFrame = rootCFrame * CFrame.Angles(math.rad(math.random(-89,89)), 0, 0) 
            end

            if config.yawMode == "Spin" then 
                HRP.CFrame = rootCFrame * CFrame.Angles(0, math.rad(tick() * 1200 % 360), 0) 
            elseif config.yawMode == "Random" then 
                HRP.CFrame = rootCFrame * CFrame.Angles(0, math.rad(math.random(-180,180)), 0) 
            elseif config.yawMode == "Jitter" then 
                HRP.CFrame = rootCFrame * CFrame.Angles(0, math.rad(math.random(-60,60)), 0) 
            end

            if config.underground then
                HRP.CFrame = HRP.CFrame * CFrame.new(0, -8, 0)
            end
        end)

        -- ==================== ORBIT (Original) ====================
        connections.orbit = RunService.Heartbeat:Connect(function(dt)
            if not config.orbitActive or not HRP then return end
            orbitAngle = orbitAngle + config.orbitSpeed * dt * 6
            local rootPos = HRP.Position
            local offset = Vector3.new(math.cos(orbitAngle) * config.orbitRadius, 12 + math.sin(orbitAngle * 2) * 4, math.sin(orbitAngle) * config.orbitRadius)
            HRP.CFrame = CFrame.new(rootPos + offset, rootPos)
        end)

        -- ==================== UI (Extra Slots Added) ====================
        local VoidTab = Window:CreateTab("Void", 4483362458)
        local XtraVoidTab = Window:CreateTab("Xtra Void", 0xFFFFFF)
        local AntiAimTab = Window:CreateTab("Anti Aim", 6026568198)
        local OrbitTab = Window:CreateTab("Orbit", 6031097228)
        local VisualsTab = Window:CreateTab("Visuals", 0x00FF00)  -- New Extra Tab

        -- Void Tab (Original)
        VoidTab:CreateSection("Void Systems")
        VoidTab:CreateToggle({Name = "Void Protocol", CurrentValue = false, Callback = function(v) config.voidActive = v; UpdateDesync() end})
        VoidTab:CreateToggle({Name = "Nuclear Fake Desync", CurrentValue = false, Callback = function(v) config.fakeDesyncActive = v; UpdateDesync() end})
        VoidTab:CreateToggle({Name = "Meow Desync", CurrentValue = false, Callback = function(v) config.meowDesyncActive = v; UpdateDesync() end})
        VoidTab:CreateSlider({Name = "Entropy Factor", Range = {0, 100}, Increment = 1, CurrentValue = config.entropyFactor, Callback = function(v) config.entropyFactor = v end})
        VoidTab:CreateSlider({Name = "Phase Shift", Range = {0, 360}, Increment = 1, CurrentValue = config.phaseShift, Callback = function(v) config.phaseShift = v end})

        -- Xtra Void Tab (Improved)
        XtraVoidTab:CreateSection("Advanced")
        XtraVoidTab:CreateToggle({Name = "Void Stabilizer", CurrentValue = false, Callback = function(v) config.voidStabilizer = v end})
        XtraVoidTab:CreateToggle({Name = "Position Resolver", CurrentValue = false, Callback = function(v) config.positionResolver = v end})
        XtraVoidTab:CreateToggle({Name = "Predictive Sync", CurrentValue = false, Callback = function(v) config.predictiveSync = v end})
        XtraVoidTab:CreateSlider({Name = "Bypass Strength", Range = {0, 100}, Increment = 1, CurrentValue = config.bypassStrength, Callback = function(v) config.bypassStrength = v end})
        XtraVoidTab:CreateSlider({Name = "Sync Accuracy", Range = {0, 100}, Increment = 1, CurrentValue = config.syncAccuracy, Callback = function(v) config.syncAccuracy = v end})
        XtraVoidTab:CreateSlider({Name = "Iteration Count", Range = {8, 128}, Increment = 4, CurrentValue = config.iterationCount, Callback = function(v) config.iterationCount = v end})

        XtraVoidTab:CreateSection("Recovery")
        XtraVoidTab:CreateToggle({Name = "Failsafe Recovery", CurrentValue = false, Callback = function(v) config.failsafeRecovery = v end})
        XtraVoidTab:CreateToggle({Name = "Position Restore", CurrentValue = false, Callback = function(v) config.positionRestore = v end})

        -- Anti Aim & Orbit (Original)
        AntiAimTab:CreateSection("Anti Aim")
        AntiAimTab:CreateToggle({Name = "Enabled", CurrentValue = false, Callback = function(v) config.antiAimEnabled = v end})
        AntiAimTab:CreateDropdown({Name = "Pitch", Options = {"Disabled", "Up", "Down", "Random"}, CurrentOption = {"Disabled"}, Callback = function(opt) config.pitchMode = opt[1] end})
        AntiAimTab:CreateDropdown({Name = "Yaw", Options = {"Disabled", "Spin", "Random", "Jitter"}, CurrentOption = {"Disabled"}, Callback = function(opt) config.yawMode = opt[1] end})
        AntiAimTab:CreateToggle({Name = "Underground", CurrentValue = false, Callback = function(v) config.underground = v end})

        OrbitTab:CreateSection("Orbit")
        OrbitTab:CreateToggle({Name = "Enable Orbit", CurrentValue = false, Callback = function(v) config.orbitActive = v end})
        OrbitTab:CreateSlider({Name = "Orbit Speed", Range = {1, 30}, Increment = 1, CurrentValue = 12, Callback = function(v) config.orbitSpeed = v end})
        OrbitTab:CreateSlider({Name = "Orbit Radius", Range = {5, 70}, Increment = 1, CurrentValue = 18, Callback = function(v) config.orbitRadius = v end})

        -- ==================== NEW EXTRA SLOTS ====================
        VisualsTab:CreateSection("Dark Texture")
        VisualsTab:CreateToggle({
            Name = "Dark Charcoal Texture",
            CurrentValue = false,
            Callback = function(v)
                toggleDarkTexture(v)
            end
        })

        VisualsTab:CreateSection("Resolution Screener")
        VisualsTab:CreateToggle({
            Name = "Resolution Screener (.gg/scripters)",
            CurrentValue = false,
            Callback = function(v)
                toggleResolutionScreener(v)
            end
        })

        Rayfield:Notify({Title = "Success", Content = "Xtra Void Improved + Dark Texture + Resolution Screener Added", Duration = 6})
    else
        game.StarterGui:SetCore("SendNotification", {Title = "Wrong Key", Text = "Key only from owner", Duration = 5})
    end
end)
