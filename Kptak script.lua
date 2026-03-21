-- 🐪 Kptak script Release 1.0

local p=game.Players.LocalPlayer
local c=p.Character or p.CharacterAdded:Wait()
local UIS=game:GetService("UserInputService")
local RS=game:GetService("RunService")

-- GUI
local g=Instance.new("ScreenGui",p.PlayerGui)
local f=Instance.new("Frame",g)
f.Size=UDim2.new(0,400,0,360)
f.Position=UDim2.new(0.5,-200,0.5,-180)
f.BackgroundColor3=Color3.fromRGB(25,25,25)
Instance.new("UICorner",f)

-- SCALE
local scale=Instance.new("UIScale",f)
scale.Scale=1
local function resize(v)
scale.Scale=math.clamp(scale.Scale+v,0.6,1.6)
end

-- TITLE
local title=Instance.new("TextLabel",f)
title.Size=UDim2.new(1,0,0,40)
title.Text="🐪 Kptak script Release 1.0"
title.BackgroundTransparency=1
title.TextColor3=Color3.new(1,1,1)

-- HIDE
local hide=Instance.new("TextButton",f)
hide.Size=UDim2.new(0,40,0,30)
hide.Position=UDim2.new(1,-45,0,5)
hide.Text="-"

local hidden=false
hide.MouseButton1Click:Connect(function()
hidden=not hidden
for _,v in pairs(f:GetChildren()) do
if v~=title and v~=hide then
v.Visible=not hidden
end end
hide.Text=hidden and "+" or "-"
end)

-- SCALE BUTTONS
local plus=Instance.new("TextButton",f)
plus.Size=UDim2.new(0,35,0,30)
plus.Position=UDim2.new(1,-45,1,-35)
plus.Text="+"

local minus=Instance.new("TextButton",f)
minus.Size=UDim2.new(0,35,0,30)
minus.Position=UDim2.new(1,-85,1,-35)
minus.Text="-"

plus.MouseButton1Click:Connect(function() resize(0.1) end)
minus.MouseButton1Click:Connect(function() resize(-0.1) end)

-- DRAG
local drag=false
local ds,sp

title.InputBegan:Connect(function(i)
if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
drag=true ds=i.Position sp=f.Position
end end)

UIS.InputChanged:Connect(function(i)
if drag then
local d=i.Position-ds
f.Position=sp+UDim2.new(0,d.X,0,d.Y)
end end)

UIS.InputEnded:Connect(function() drag=false end)

-- TABS
local function tab(txt,x)
local b=Instance.new("TextButton",f)
b.Size=UDim2.new(0,130,0,30)
b.Position=UDim2.new(0,x,0,45)
b.Text=txt
b.BackgroundColor3=Color3.fromRGB(50,50,50)
b.TextColor3=Color3.new(1,1,1)
Instance.new("UICorner",b)
return b end

local tpTab=tab("TELEPORT",0)
local visTab=tab("VISUAL",135)
local plrTab=tab("PLAYER",270)

-- PAGES
local function page()
local p=Instance.new("Frame",f)
p.Size=UDim2.new(1,0,1,-90)
p.Position=UDim2.new(0,0,0,85)
p.BackgroundTransparency=1
return p end

local tpPage=page()
local visPage=page()
local plrPage=page()

local function show(pg)
tpPage.Visible=false
visPage.Visible=false
plrPage.Visible=false
pg.Visible=true
end

tpTab.MouseButton1Click:Connect(function() show(tpPage) end)
visTab.MouseButton1Click:Connect(function() show(visPage) end)
plrTab.MouseButton1Click:Connect(function() show(plrPage) end)

show(tpPage)

-- BUTTON
local function btn(par,txt,y)
local b=Instance.new("TextButton",par)
b.Size=UDim2.new(0,240,0,35)
b.Position=UDim2.new(0.5,-120,0,y)
b.Text=txt
b.BackgroundColor3=Color3.fromRGB(70,130,255)
b.TextColor3=Color3.new(1,1,1)
Instance.new("UICorner",b)
return b end

-- TELEPORT
local deer=btn(tpPage,"TP Deer",10)
local log=btn(tpPage,"TP Log",55)
local fire=btn(tpPage,"TP Campfire",100)

-- VISUAL
local esp=btn(visPage,"ESP",10)
local kptak=btn(visPage,"Kptak Mode",55)

-- PLAYER
local sp3=btn(plrPage,"Speed 3x",10)
local sp4=btn(plrPage,"Speed 4x",55)
local fly=btn(plrPage,"Fly",100)
local jump=btn(plrPage,"Infinite Jump",145)
local up=btn(plrPage,"Teleport Up",190)

-- TP
local function tp(names)
local hrp=c:FindFirstChild("HumanoidRootPart")
if not hrp then return end

local best,dist=nil,math.huge
for _,v in pairs(workspace:GetDescendants()) do
for _,n in pairs(names) do
if string.find(string.lower(v.Name),n) then
local p=v:IsA("BasePart") and v or v:FindFirstChildWhichIsA("BasePart")
if p then
local d=(hrp.Position-p.Position).Magnitude
if d<dist then dist=d best=p end
end end end end

if best then hrp.CFrame=best.CFrame+Vector3.new(0,5,0) end
end

deer.MouseButton1Click:Connect(function() tp({"deer"}) end)
log.MouseButton1Click:Connect(function() tp({"log","wood"}) end)
fire.MouseButton1Click:Connect(function() tp({"campfire","fire"}) end)

-- SPEED
sp3.MouseButton1Click:Connect(function()
c:FindFirstChildOfClass("Humanoid").WalkSpeed=48 end)

sp4.MouseButton1Click:Connect(function()
c:FindFirstChildOfClass("Humanoid").WalkSpeed=64 end)

-- FLY (ALPHA 0.8 STYLE)
local fl=false
local bv

fly.MouseButton1Click:Connect(function()
fl=not fl
local hrp=c:FindFirstChild("HumanoidRootPart")
if fl then
bv=Instance.new("BodyVelocity",hrp)
bv.MaxForce=Vector3.new(1e5,1e5,1e5)
bv.Velocity=workspace.CurrentCamera.CFrame.LookVector*60
else
if bv then bv:Destroy() bv=nil end
end
end)

RS.RenderStepped:Connect(function()
if fl and bv and c:FindFirstChild("HumanoidRootPart") then
bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * 60
end
end)

-- INF JUMP
local inf=false
jump.MouseButton1Click:Connect(function() inf=not inf end)

UIS.JumpRequest:Connect(function()
if inf then
c:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
end end)

-- TP UP
up.MouseButton1Click:Connect(function()
c.HumanoidRootPart.CFrame+=Vector3.new(0,50,0)
end)

-- ESP
local espOn=false
esp.MouseButton1Click:Connect(function()
espOn=not espOn
for _,v in pairs(workspace:GetDescendants()) do
if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") then
if espOn then
if not v:FindFirstChildOfClass("Highlight") then
Instance.new("Highlight",v)
end
else
local h=v:FindFirstChildOfClass("Highlight")
if h then h:Destroy() end
end end end end)

-- KPTAK MODE
local km=false
local original={}

kptak.MouseButton1Click:Connect(function()
km=not km
for _,v in pairs(c:GetDescendants()) do
if v:IsA("BasePart") then
if km then
if not original[v] then
original[v]={Color=v.Color,Material=v.Material}
end
v.Color=Color3.fromRGB(210,180,140)
v.Material=Enum.Material.Sand
else
if original[v] then
v.Color=original[v].Color
v.Material=original[v].Material
end
end
end end end)

p.CharacterAdded:Connect(function(x) c=x end)