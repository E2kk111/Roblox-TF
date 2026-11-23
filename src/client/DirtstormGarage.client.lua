-- Dirtstorm XT™ garage HUD | place in StarterPlayer > StarterPlayerScripts as LocalScript
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local player=Players.LocalPlayer
local event=ReplicatedStorage:WaitForChild("DirtstormCustomize")
local gui=Instance.new("ScreenGui");gui.Name="DirtstormGarage";gui.ResetOnSpawn=false;gui.Parent=player:WaitForChild("PlayerGui")
local panel=Instance.new("Frame");panel.Size=UDim2.fromOffset(250,235)
panel.Position=UDim2.new(0,12,1,-250);panel.BackgroundColor3=Color3.fromRGB(20,23,31);panel.Parent=gui
local corner=Instance.new("UICorner");corner.CornerRadius=UDim.new(0,12);corner.Parent=panel
local function label(text,y,height)
  local t=Instance.new("TextLabel");t.Size=UDim2.new(1,-16,0,height);t.Position=UDim2.fromOffset(8,y)
  t.BackgroundTransparency=1;t.Text=text;t.TextColor3=Color3.fromRGB(255,255,255)
  t.TextScaled=true;t.Font=Enum.Font.GothamBold;t.Parent=panel
end
label("DIRTSTORM XT GARAGE",8,30)
label("Choose a FREE truck color",44,24)
local palette={
  {name="Blue",color=Color3.fromRGB(25,110,245)},
  {name="Red",color=Color3.fromRGB(220,43,48)},
  {name="Gold",color=Color3.fromRGB(245,179,24)},
  {name="Green",color=Color3.fromRGB(39,176,104)}
}
for i,item in ipairs(palette) do
  local b=Instance.new("TextButton")
  b.Name=item.name;b.Size=UDim2.fromOffset(108,43)
  b.Position=UDim2.fromOffset(12+((i-1)%2)*120,78+math.floor((i-1)/2)*49)
  b.Text=item.name;b.TextScaled=true;b.Font=Enum.Font.GothamBold
  b.BackgroundColor3=item.color;b.TextColor3=Color3.new(1,1,1);b.Parent=panel
  local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,7);c.Parent=b
  b.Activated:Connect(function() event:FireServer(item.name) end)
end
label("Race 4 gates = 1 free star!",181,36)
