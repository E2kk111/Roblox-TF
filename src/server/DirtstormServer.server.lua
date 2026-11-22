-- DIRTSTORM XT™ Roblox prototype
-- Place this Script in ServerScriptService of a Roblox Studio Baseplate.
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local existing = Workspace:FindFirstChild("DirtstormXT")
if existing then existing:Destroy() end
local world = Instance.new("Folder")
world.Name = "DirtstormXT"
world.Parent = Workspace
local function part(name, size, cf, color, material, anchored, parent)
    local p = Instance.new("Part")
    p.Name, p.Size, p.CFrame, p.Color = name, size, cf, color
    p.Material = material or Enum.Material.SmoothPlastic
    p.Anchored = anchored ~= false
    p.Parent = parent or world
    return p
end
local dirt = Color3.fromRGB(113,73,42)
local gold = Color3.fromRGB(255,185,23)
local blue = Color3.fromRGB(30,111,239)
part("Ground", Vector3.new(400,2,310), CFrame.new(0,-2,0), Color3.fromRGB(50,110,65), Enum.Material.Grass)
part("DirtTrack", Vector3.new(260,1,170), CFrame.new(0,-0.45,0), dirt, Enum.Material.Ground)
part("Infield", Vector3.new(160,1.1,75), CFrame.new(0,-0.35,0), Color3.fromRGB(50,110,65), Enum.Material.Grass)
for _,z in ipairs({-90,90}) do part("Barrier",Vector3.new(280,5,3),CFrame.new(0,2,z),gold,Enum.Material.Metal) end
for _,x in ipairs({-135,135}) do part("Barrier",Vector3.new(3,5,180),CFrame.new(x,2,0),gold,Enum.Material.Metal) end
local checkpoints = {}
local positions = {Vector3.new(-105,3,-65),Vector3.new(105,3,-65),Vector3.new(105,3,65),Vector3.new(-105,3,65)}
for i,pos in ipairs(positions) do
    local gate = part("Checkpoint"..i,Vector3.new(4,11,19),CFrame.new(pos),i==1 and gold or Color3.fromRGB(38,221,219),Enum.Material.Neon)
    gate.Transparency = 0.55
    gate.CanCollide = false
    checkpoints[i] = gate
end
local truck = Instance.new("Model")
truck.Name = "XT_Blue_01"
truck.Parent = world
local start = CFrame.new(-105,4,58) * CFrame.Angles(0,math.rad(-90),0)
local chassis = part("Chassis",Vector3.new(9,2.2,14),start,blue,Enum.Material.Metal,false,truck)
chassis.CustomPhysicalProperties = PhysicalProperties.new(1,0.7,0.1)
truck.PrimaryPart = chassis
local seat = Instance.new("VehicleSeat")
seat.Name,seat.Size,seat.CFrame = "DriverSeat",Vector3.new(4,1,4),start*CFrame.new(0,2,0)
seat.Color = Color3.fromRGB(18,18,22)
seat.Anchored = false
seat.Parent = truck
local seatWeld = Instance.new("WeldConstraint")
seatWeld.Part0,seatWeld.Part1,seatWeld.Parent = chassis,seat,seat
local function detail(name,size,offset,color,material,shape)
    local p = part(name,size,start*offset,color,material,false,truck)
    if shape then p.Shape = shape end
    p.CanCollide,p.Massless = false,true
    local weld = Instance.new("WeldConstraint")
    weld.Part0,weld.Part1,weld.Parent = chassis,p,p
    return p
end
detail("Cab",Vector3.new(7,2.5,6),CFrame.new(0,2,1.5),Color3.fromRGB(13,25,46),Enum.Material.SmoothPlastic)
detail("HoodStripe",Vector3.new(6,0.15,3),CFrame.new(0,1.2,-4),gold,Enum.Material.Neon)
for _,x in ipairs({-5,5}) do
    for _,z in ipairs({-4.5,4.5}) do
        detail("OversizedWheel",Vector3.new(4.5,2.5,4.5),CFrame.new(x,-0.3,z)*CFrame.Angles(0,0,math.rad(90)),Color3.fromRGB(23,23,25),Enum.Material.Rubber,Enum.PartType.Cylinder)
    end
end
local attachment = Instance.new("Attachment")
attachment.Parent = chassis
local velocity = Instance.new("LinearVelocity")
velocity.Attachment0 = attachment
velocity.MaxForce = 50000
velocity.VectorVelocity = Vector3.zero
velocity.RelativeTo = Enum.ActuatorRelativeTo.World
velocity.Parent = chassis
local orient = Instance.new("AlignOrientation")
orient.Attachment0 = attachment
orient.Mode = Enum.OrientationAlignmentMode.OneAttachment
orient.MaxTorque = 200000
orient.Responsiveness = 12
orient.Parent = chassis
local state = {}
local function setupPlayer(player)
    local stats = Instance.new("Folder")
    stats.Name,stats.Parent = "leaderstats",player
    local laps = Instance.new("IntValue")
    laps.Name,laps.Parent = "Laps",stats
    state[player] = {nextGate=1,lastGateAt=0}
end
Players.PlayerAdded:Connect(setupPlayer)
for _,p in ipairs(Players:GetPlayers()) do setupPlayer(p) end
Players.PlayerRemoving:Connect(function(player) state[player] = nil end)
local yaw,speed,clock = math.rad(-90),0,0
RunService.Heartbeat:Connect(function(dt)
    dt = math.min(dt,0.05)
    clock += dt
    local humanoid = seat.Occupant
    local player = humanoid and Players:GetPlayerFromCharacter(humanoid.Parent)
    local throttle = player and seat.ThrottleFloat or 0
    local steer = player and seat.SteerFloat or 0
    local targetSpeed = throttle*55
    speed += (targetSpeed-speed)*math.min(1,dt*2.8)
    if player then yaw += steer*dt*1.35*math.clamp(math.abs(speed)/20,0.25,1) end
    local forward = CFrame.Angles(0,yaw,0).LookVector
    velocity.VectorVelocity = forward*speed + Vector3.new(0,chassis.AssemblyLinearVelocity.Y,0)
    orient.CFrame = CFrame.Angles(0,yaw,0)
    if player then
        local progress = state[player]
        if progress and clock-progress.lastGateAt > 1.2 then
            local gate = checkpoints[progress.nextGate]
            if (chassis.Position-gate.Position).Magnitude < 17 then
                progress.lastGateAt = clock
                progress.nextGate += 1
                if progress.nextGate > #checkpoints then
                    progress.nextGate = 1
                    player.leaderstats.Laps.Value += 1
                end
            end
        end
    end
end)
local sign = part("WelcomeSign",Vector3.new(60,10,2),CFrame.new(0,15,-100),Color3.fromRGB(20,20,25),Enum.Material.Metal)
local gui = Instance.new("SurfaceGui")
gui.Face,gui.Parent = Enum.NormalId.Front,sign
local label = Instance.new("TextLabel")
label.Size,label.BackgroundTransparency = UDim2.fromScale(1,1),1
label.Text = "DIRTSTORM XT  |  THRILLFUSION"
label.TextScaled,label.TextColor3,label.Font,label.Parent = true,gold,Enum.Font.GothamBlack,gui
print("Dirtstorm XT prototype loaded. Sit in XT_Blue_01 and drive through checkpoints.")
