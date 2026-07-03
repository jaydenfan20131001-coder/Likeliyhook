-- =============================================
-- DEATHNESS UE V4.5 - VOID & ORBIT
-- =============================================

local function SecureFetch(url)
    local success, result = pcall(function()
        return game:HttpGet(url, true)
    end)
    if not success then
        success, result = pcall(function() return request({Url = url, Method = "GET"}).Body end)
    end
    return success and result or nil
end

local Rayfield = loadstring(SecureFetch("https://sirius.menu/rayfield"))()
if not Rayfield then warn("Rayfield failed") return end

local Window = Rayfield:CreateWindow({
    Name = "KEY SYSTEM | Deathness UE V4.5",
    LoadingTitle = "Deathness UE",
    LoadingSubtitle = "Private Key Required",
    KeySystem = true,
    KeySettings = {
        Title = "Deathness UE Private Key",
        Subtitle = "Enter Key",
        Note = "Key required EVERY time you load the script",
        FileName = "DeathnessKey",
        SaveKey = false,
        GrabKeyFromSite = false,
        Key = {"Presurefixhd"}
    }
})

Rayfield:Notify({
    Title = "Key System",
    Content = "Enter Presurefixhd",
    Duration = 6
})

task.spawn(function()
    repeat task.wait(0.5) until Window
    Rayfield:Destroy()

    local MainRayfield = loadstring(SecureFetch("https://sirius.menu/rayfield"))()
    local MainWindow = MainRayfield:CreateWindow({
        Name = "Deathness UE V4.5 - Void & Orbit",
        LoadingTitle = "Loading...",
        LoadingSubtitle = "Private Build"
    })

    local VoidTab   = MainWindow:CreateTab("Void", 4483362458)
    local OrbitTab  = MainWindow:CreateTab("Orbit", 6026568198)
    local AdvTab    = MainWindow:CreateTab("Advanced", 6031097228)

    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer

    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local HRP = Character:WaitForChild("HumanoidRootPart")

    LocalPlayer.CharacterAdded:Connect(function(new) 
        Character = new
        HRP = new:WaitForChild("HumanoidRootPart") 
    end)

    local config = {
        voidActive = false,
        fakeDesyncActive = false,
        meowDesyncActive = false,
        orbitActive = false,
        voidSpamTime = 0.07,
        fakePosition = nil,
        orbitSpeed = 10,
        orbitRadius = 20,
    }

    local connections = {}
    local lastVoid = 0
    local orbitAngle = 0

    -- Old Reliable Void & Desync
    local function UpdateDesync()
        for _, v in pairs(connections) do 
            if v ~= connections.orbit then v:Disconnect() end 
        end

        connections.desync = RunService.Heartbeat:Connect(function()
            if not HRP then return end
            local now = tick()

            if config.voidActive and now - lastVoid >= config.voidSpamTime then
                lastVoid = now
                config.fakePosition = HRP.CFrame
                local offset = Vector3.new(math.random(-30000000,30000000), math.random(18000000,55000000), math.random(-30000000,30000000))
                HRP.CFrame = HRP.CFrame + offset
                task.delay(0.05, function()
                    if HRP and config.fakePosition then HRP.CFrame = config.fakePosition end
                end)
            end

            if config.fakeDesyncActive then
                if now - (lastVoid or 0) >= 0.065 then
                    lastVoid = now
                    config.fakePosition = HRP.CFrame
                    local offset = Vector3.new(math.random(-120000000,120000000), math.random(60000000,160000000), math.random(-120000000,120000000))
                    HRP.CFrame = HRP.CFrame + offset
                    task.delay(0.055, function()
                        if HRP and config.fakePosition then HRP.CFrame = config.fakePosition end
                    end)
                end
            end

            if config.meowDesyncActive then
                if not config.fakePosition then config.fakePosition = HRP.CFrame end
                local flick = Vector3.new(math.random(-12000000,12000000), math.random(20000000,45000000), math.random(-12000000,12000000))
                local spin = CFrame.Angles(math.rad(math.random(-35,35)), math.rad(math.random(-180,180)), math.rad(math.random(-35,35)))
                HRP.CFrame = config.fakePosition * spin + flick
                task.delay(0.045, function()
                    if HRP and config.fakePosition then HRP.CFrame = config.fakePosition end
                end)
            end
        end)
    end

    -- Orbit (Working)
    connections.orbit = RunService.Heartbeat:Connect(function(dt)
        if not config.orbitActive or not HRP then return end
        orbitAngle = orbitAngle + config.orbitSpeed * dt * 8
        local offset = Vector3.new(math.cos(orbitAngle) * config.orbitRadius, 10, math.sin(orbitAngle) * config.orbitRadius)
        HRP.CFrame = CFrame.new(HRP.Position + offset)
    end)

    -- UI
    VoidTab:CreateSection("Void Systems")
    VoidTab:CreateToggle({Name = "Void Protocol", CurrentValue = false, Callback = function(v) config.voidActive = v UpdateDesync() end})
    VoidTab:CreateToggle({Name = "Fake Desync", CurrentValue = false, Callback = function(v) config.fakeDesyncActive = v UpdateDesync() end})
    VoidTab:CreateToggle({Name = "Meow Desync", CurrentValue = false, Callback = function(v) config.meowDesyncActive = v UpdateDesync() end})
    VoidTab:CreateSlider({Name = "Void Spam Time (s)", Range = {0.01, 0.25}, Increment = 0.01, CurrentValue = config.voidSpamTime, Callback = function(v) config.voidSpamTime = v end})

    OrbitTab:CreateSection("Orbit")
    OrbitTab:CreateToggle({Name = "Enable Orbit", CurrentValue = false, Callback = function(v) config.orbitActive = v end})
    OrbitTab:CreateSlider({Name = "Orbit Speed", Range = {1, 25}, Increment = 1, CurrentValue = config.orbitSpeed, Callback = function(v) config.orbitSpeed = v end})
    OrbitTab:CreateSlider({Name = "Orbit Radius", Range = {5, 60}, Increment = 1, CurrentValue = config.orbitRadius, Callback = function(v) config.orbitRadius = v end})

    AdvTab:CreateSection("Info")
    AdvTab:CreateLabel("Try Void + Orbit")

    MainRayfield:Notify({Title = "Loaded", Content = "Void & Orbit Ready", Duration = 5})
end)
