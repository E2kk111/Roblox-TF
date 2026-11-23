-- Dirtstorm XT™ v0.2 | Roblox Studio ServerScriptService
-- Server-authoritative, free-to-play arcade prototype. No purchases or data collection.
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local World = game:GetService("Workspace")
local old = World:FindFirstChild("DirtstormXT")
if old then old:Destroy() end
local root = Instance.new("Folder"); root.Name="DirtstormXT"; root.Parent=World
local remote = ReplicatedStorage:FindFirstChild("DirtstormCustomize") or Instance.new("RemoteEvent")
remote.Name="DirtstormCustomize"; remote.Parent=ReplicatedStorage
local colors = {
  Blue=Color3.fromRGB(25,110,245), Red=Color3.fromRGB(220,43,48),
  Gold=Color3.fromRGB(245,179,24), Green=Color3.fromRGB(39,176,104),
}
local function block(name,size,cf,color,material,parent)
  local p=Instance.new("Part")
  p.Name=name;p.Size=size;p.CFrame=cf;p.Color=color
  p.Material=material or Enum.Material.SmoothPlastic
  p.Anchored=true;p.Parent=parent or root
  return p
end
block("Ground",Vector3.new(380,2,280),CFrame.new(0,-2,0),Color3.fromRGB(60,123,74),Enum.Material.Grass)
block("Track",Vector3.new(270,1,185),CFrame.new(0,-0.45,0),Color3.fromRGB(124,81,48),Enum.Material.Ground)
block("Infield",Vector3.new(170,1.1,85),CFrame.new(0,-0.35,0),Color3.fromRGB(59,120,69),Enum.Material.Grass)
for _,z in ipairs({-94,94}) do block("Barrier",Vector3.new(276,5,3),CFrame.new(0,2,z),Color3.fromRGB(248,180,28),Enum.Material.Metal) end
for _,x in ipairs({-138,138}) do block("Barrier",Vector3.new(3,5,191),CFrame.new(x,2,0),Color3.fromRGB(248,180,28),Enum.Material.Metal) end
local gates={
  Vector3.new(-108,2,-68),Vector3.new(108,2,-68),
  Vector3.new(108,2,68),Vector3.new(-108,2,68)
}
for i,pos in ipairs(gates) do
  local g=block("Gate"..i,Vector3.new(16,7,16),CFrame.new(pos),Color3.fromRGB(45,226,219),Enum.Material.Neon)
  g.Transparency=.78;g.CanCollide=false
end
local sign=block("Sign",Vector3.new(58,9,2),CFrame.new(0,15,-100),Color3.fromRGB(19,19,24),Enum.Material.Metal)
local surface=Instance.new("SurfaceGui");surface.Face=Enum.NormalId.Front;surface.Parent=sign
local title=Instance.new("TextLabel");title.Size=UDim2.fromScale(1,1);title.BackgroundTransparency=1
title.Text="DIRTSTORM XT | THRILLFUSION";title.TextScaled=true;title.Font=Enum.Font.GothamBold
title.TextColor3=Color3.fromRGB(255,194,32);title.Parent=surface
local states={}
local function truckPart(model,name,size,offset,color,shape)
  local p=block(name,size,model:GetPivot()*offset,color,Enum.Material.SmoothPlastic,model)
  p.CanCollide=false
  if shape then p.Shape=shape end
  return p
end
local function spawnTruck(player)
  local index=(player.UserId%6)
  local start=CFrame.new(-117+index*4,3,69)*CFrame.Angles(0,math.pi,0)
  local model=Instance.new("Model");model.Name="XT_"..player.UserId;model.Parent=root
  local base=block("Chassis",Vector3.new(8,2,13),start,colors.Blue,Enum.Material.Metal,model)
  base.CanCollide=false;model.PrimaryPart=base
  local seat=Instance.new("VehicleSeat")
  seat.Name="Drive";seat.Size=Vector3.new(4,1,4);seat.CFrame=start*CFrame.new(0,1.6,0)
  seat.Anchored=true;seat.CanCollide=false;seat.Parent=model
  truckPart(model,"Cab",Vector3.new(7,3,5),CFrame.new(0,2,2),Color3.fromRGB(18,28,44))
  truckPart(model,"Stripe",Vector3.new(6,.12,3),CFrame.new(0,1.06,-3),colors.Gold)
  for _,x in ipairs({-4.5,4.5}) do for _,z in ipairs({-4,4}) do
    truckPart(model,"Wheel",Vector3.new(4,2,4),CFrame.new(x,-.35,z)*CFrame.Angles(0,0,math.pi/2),Color3.fromRGB(21,22,26),Enum.PartType.Cylinder)
  end end
  local s={model=model,seat=seat,cf=start,speed=0,gate=1,lastGate=0,paint="Blue",laps=0}
  states[player]=s
  return s
end
Players.PlayerAdded:Connect(function(player)
  local stats=Instance.new("Folder");stats.Name="leaderstats";stats.Parent=player
  local laps=Instance.new("IntValue");laps.Name="Laps";laps.Parent=stats
  local stars=Instance.new("IntValue");stars.Name="Stars";stars.Parent=stats
  spawnTruck(player)
end)
Players.PlayerRemoving:Connect(function(player)
  local s=states[player];if s then s.model:Destroy() end;states[player]=nil
end)
remote.OnServerEvent:Connect(function(player,colorName)
  if typeof(colorName)~="string" or not colors[colorName] then return end
  local s=states[player];if not s then return end
  s.paint=colorName
  local chassis=s.model:FindFirstChild("Chassis")
  if chassis then chassis.Color=colors[colorName] end
end)
RunService.Heartbeat:Connect(function(dt)
  dt=math.min(dt,.05)
  for player,s in pairs(states) do
    if not s.model.Parent then continue end
    local occupant=s.seat.Occupant
    local driving=occupant and Players:GetPlayerFromCharacter(occupant.Parent)==player
    local throttle=driving and s.seat.ThrottleFloat or 0
    local steer=driving and s.seat.SteerFloat or 0
    s.speed+=(throttle*53-s.speed)*math.min(1,dt*2.6)
    local turn=steer*dt*1.45*math.clamp(math.abs(s.speed)/15,.15,1)
    local newCf=s.cf*CFrame.Angles(0,turn,0)
    local pos=newCf.Position+newCf.LookVector*s.speed*dt
    pos=Vector3.new(math.clamp(pos.X,-127,127),3,math.clamp(pos.Z,-82,82))
    s.cf=CFrame.new(pos)*newCf.Rotation
    s.model:PivotTo(s.cf)
    if driving and os.clock()-s.lastGate>1.1 and (pos-gates[s.gate]).Magnitude<18 then
      s.lastGate=os.clock();s.gate+=1
      if s.gate>4 then
        s.gate=1;s.laps+=1
        player.leaderstats.Laps.Value=s.laps
        player.leaderstats.Stars.Value+=1 -- earned through play, not purchase
      end
    end
  end
end)
print("Dirtstorm XT v0.2 loaded: garage paint + free race rewards")
