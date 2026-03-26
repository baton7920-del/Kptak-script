 -- 🐪 Kptak script Release 1.3

local p=game.Players.LocalPlayer
local UIS=game:GetService("UserInputService")
local RS=game:GetService("RunService")

local c=p.Character or p.CharacterAdded:Wait()

local function getHum()
    return c:FindFirstChildOfClass("Humanoid")
end

local function getHRP()
    return c:FindFirstChild("HumanoidRootPart")
end

-- GUI
local g=Instance.new("ScreenGui",p.PlayerGui)
g.ResetOnSpawn = false

local f=Instance.new("Frame",g)
f.Size=UDim2.new(0,460,0,380)
f.Position=UDim2.new(0.5,-230,0.5,-190)
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
title.Text="🐪 Kptak script Release 1.3"
title.BackgroundTransparency=1
title.TextColor3=Color3.new(1,1,1)

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

-- HIDE
local hide=Instance.new("TextButton",f)
hide.Size=UDim2.new(0,40,0,30)
hide.Position=UDim2.new(1,-45,0,5)
hide.Text="-"

local hidden=false
hide.MouseButton1Click:Connect(function()
hidden = not hidden
for _,v in pairs(f:GetChildren()) do
    if v:IsA("Frame") or v:IsA("TextButton") then
        if v ~= title and v ~= hide and v ~= plus and v ~= minus then
            v.Visible = not hidden
        end
    end
end
hide.Text = hidden and "+" or "-"
end)

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
b.Size=UDim2.new(0,115,0,30)
b.Position=UDim2.new(0,x,0,45)
b.Text=txt
b.BackgroundColor3=Color3.fromRGB(50,50,50)
b.TextColor3=Color3.new(1,1,1)
Instance.new("UICorner",b)
return b end

local tpTab=tab("TP",0)
local visTab=tab("VISUAL",115)
local plrTab=tab("PLAYER",230)
local bringTab=tab("BRING",345)

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
local bringPage=page()

local function show(pg)
tpPage.Visible=false
visPage.Visible=false
plrPage.Visible=false
bringPage.Visible=false
pg.Visible=true
end

tpTab.MouseButton1Click:Connect(function() show(tpPage) end)
visTab.MouseButton1Click:Connect(function() show(visPage) end)
plrTab.MouseButton1Click:Connect(function() show(plrPage) end)
bringTab.MouseButton1Click:Connect(function() show(bringPage) end)

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

-- TP
local function tp(names)
local hrp=getHRP()
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

btn(tpPage,"TP Deer",10).MouseButton1Click:Connect(function() tp({"deer"}) end)
btn(tpPage,"TP Log",55).MouseButton1Click:Connect(function() tp({"log","wood"}) end)
btn(tpPage,"TP Campfire",100).MouseButton1Click:Connect(function() tp({"campfire","fire"}) end)

-- VISUAL
local espOn=false
btn(visPage,"ESP",10).MouseButton1Click:Connect(function()
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

-- 🐪 KPTAK MODE
local km=false
local original={}

btn(visPage,"Kptak Mode",55).MouseButton1Click:Connect(function()
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
end end end end)

-- PLAYER
btn(plrPage,"Speed 3x",10).MouseButton1Click:Connect(function()
local h=getHum()
if h then h.WalkSpeed=48 end
end)

btn(plrPage,"Speed 4x",55).MouseButton1Click:Connect(function()
local h=getHum()
if h then h.WalkSpeed=64 end
end)

-- FLY
local fl=false
local bv

btn(plrPage,"Fly",100).MouseButton1Click:Connect(function()
fl=not fl
local hrp=getHRP()
if not hrp then return end

if fl then
bv=Instance.new("BodyVelocity",hrp)
bv.MaxForce=Vector3.new(1e5,1e5,1e5)
else
if bv then bv:Destroy() bv=nil end
end end)

RS.RenderStepped:Connect(function()
local hrp=getHRP()
if fl and bv and hrp then
bv.Velocity=workspace.CurrentCamera.CFrame.LookVector*60
end end)

-- INF JUMP
local inf=false
btn(plrPage,"Infinite Jump",145).MouseButton1Click:Connect(function()
inf = not inf
end)

UIS.JumpRequest:Connect(function()
if inf then
local h=getHum()
if h then
h:ChangeState(Enum.HumanoidStateType.Jumping)
end
end
end)

-- TP UP
btn(plrPage,"Teleport Up",190).MouseButton1Click:Connect(function()
local hrp=getHRP()
if hrp then
hrp.CFrame += Vector3.new(0,50,0)
end
end)

-- 🐪 NOCLIP (FIXED)
local noclip=false

btn(plrPage,"NoClip",235).MouseButton1Click:Connect(function()
noclip = not noclip
end)

RS.Stepped:Connect(function()
if noclip and c then
for _,v in pairs(c:GetDescendants()) do
if v:IsA("BasePart") then
v.CanCollide = false
end
end
end
end)

-- BRING
local function bring(names)
local hrp=getHRP()
if not hrp then return end

for _,v in pairs(workspace:GetDescendants()) do
for _,n in pairs(names) do
if string.find(string.lower(v.Name),n) then
local p=v:IsA("BasePart") and v or v:FindFirstChildWhichIsA("BasePart")
if p then
p.CFrame = hrp.CFrame * CFrame.new(0,2,-3)
end end end end
end

local metal = {Radio={"radio"},Bolt={"bolt"}}
local fuel = {Coal={"coal"},Fuel={"fuel"},Oil={"oil","barrel"},Log={"log","wood"}}

local function dropdown(par,list,y)
local keys={}
for k in pairs(list) do table.insert(keys,k) end
table.sort(keys)

local sel=keys[1]
local b=btn(par,sel,y)

b.MouseButton1Click:Connect(function()
for i,v in ipairs(keys) do
if v==sel then sel=keys[i+1] or keys[1] break end end
b.Text=sel
end)

return function() return list[sel] end
end

local getM=dropdown(bringPage,metal,10)
local getF=dropdown(bringPage,fuel,55)

btn(bringPage,"Bring Metal",100).MouseButton1Click:Connect(function() bring(getM()) end)
btn(bringPage,"Bring Fuel",145).MouseButton1Click:Connect(function() bring(getF()) end)

-- CHARACTER FIX
p.CharacterAdded:Connect(function(x)
c=x
if bv then bv:Destroy() bv=nil end
end)

print("🐪 Kptak 1.3 LOADED")
