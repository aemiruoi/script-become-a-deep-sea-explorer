local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- REMOVE OLD
local old = playerGui:FindFirstChild("FishCatcherGui")
if old then old:Destroy() end

local fishFolder = ReplicatedStorage:WaitForChild("A__Assets"):WaitForChild("Fish")

local addToInventoryRF = ReplicatedStorage:WaitForChild("Packages")
    :WaitForChild("_Index")
    :WaitForChild("sleitnick_knit@1.7.0")
    :WaitForChild("knit")
    :WaitForChild("Services")
    :WaitForChild("FishService")
    :WaitForChild("RF")
    :WaitForChild("AddToInventory")

-- GUI
local gui = Instance.new("ScreenGui", playerGui)
gui.Name = "FishCatcherGui"

-- MAIN FRAME
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 0, 0, 0)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,16)

Instance.new("UIStroke", frame).Color = Color3.fromRGB(70,70,70)

-- OPEN ANIMATION
TweenService:Create(frame, TweenInfo.new(0.35, Enum.EasingStyle.Quart), {
    Size = UDim2.new(0, 360, 0, 330)
}):Play()

-- TITLE
local title = Instance.new("TextLabel", frame)
title.Text = "Fish Catcher"
title.Size = UDim2.new(1, -60, 0, 40)
title.Position = UDim2.new(0, 15, 0, 10)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left

-- CLOSE
local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -40, 0, 10)
close.Text = "✕"
close.BackgroundColor3 = Color3.fromRGB(200,60,60)
close.TextColor3 = Color3.new(1,1,1)
close.Font = Enum.Font.GothamBold
Instance.new("UICorner", close).CornerRadius = UDim.new(1,0)

close.MouseButton1Click:Connect(function()
    TweenService:Create(frame, TweenInfo.new(0.2), {
        Size = UDim2.new(0,0,0,0)
    }):Play()
    task.wait(0.2)
    gui:Destroy()
end)

-- SEARCH
local search = Instance.new("TextBox", frame)
search.Size = UDim2.new(1, -30, 0, 36)
search.Position = UDim2.new(0, 15, 0, 60)
search.PlaceholderText = "Search fish..."
search.BackgroundColor3 = Color3.fromRGB(35,35,35)
search.TextColor3 = Color3.new(1,1,1)
search.Font = Enum.Font.Gotham
search.TextSize = 14
Instance.new("UICorner", search).CornerRadius = UDim.new(0,10)

-- LIST
local list = Instance.new("ScrollingFrame", frame)
list.Size = UDim2.new(1, -30, 0, 160)
list.Position = UDim2.new(0, 15, 0, 105)
list.BackgroundTransparency = 1
list.ScrollBarThickness = 4

local layout = Instance.new("UIListLayout", list)
layout.Padding = UDim.new(0,6)

-- DATA
local fishButtons = {}
local selectedFish
local currentSelected

-- BUTTON CREATOR
local function createFishButton(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.Text = "   "..name
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)

    local indicator = Instance.new("Frame", btn)
    indicator.Size = UDim2.new(0,4,1,0)
    indicator.BackgroundColor3 = Color3.fromRGB(0,200,120)
    indicator.Visible = false
    Instance.new("UICorner", indicator)

    btn.MouseEnter:Connect(function()
        if btn ~= currentSelected then
            TweenService:Create(btn, TweenInfo.new(0.15), {
                BackgroundColor3 = Color3.fromRGB(60,60,60)
            }):Play()
        end
    end)

    btn.MouseLeave:Connect(function()
        if btn ~= currentSelected then
            TweenService:Create(btn, TweenInfo.new(0.15), {
                BackgroundColor3 = Color3.fromRGB(40,40,40)
            }):Play()
        end
    end)

    btn.MouseButton1Click:Connect(function()
        selectedFish = name

        if currentSelected then
            currentSelected.BackgroundColor3 = Color3.fromRGB(40,40,40)
            currentSelected:FindFirstChildOfClass("Frame").Visible = false
        end

        currentSelected = btn
        btn.BackgroundColor3 = Color3.fromRGB(0,170,100)
        indicator.Visible = true
    end)

    return btn
end

-- LOAD FISH
for _, fish in ipairs(fishFolder:GetChildren()) do
    local btn = createFishButton(fish.Name)
    btn.Parent = list
    fishButtons[fish.Name] = btn
end

-- SCROLL AUTO
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    list.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 10)
end)

-- SEARCH FILTER
search:GetPropertyChangedSignal("Text"):Connect(function()
    local text = string.lower(search.Text or "")

    for name, btn in pairs(fishButtons) do
        btn.Visible = (text == "" or string.find(string.lower(name), text))
    end
end)

-- GET BUTTON
local getBtn = Instance.new("TextButton", frame)
getBtn.Size = UDim2.new(1, -30, 0, 42)
getBtn.Position = UDim2.new(0, 15, 1, -65)
getBtn.Text = "Catch Fish"
getBtn.BackgroundColor3 = Color3.fromRGB(0,180,110)
getBtn.TextColor3 = Color3.new(1,1,1)
getBtn.Font = Enum.Font.GothamBold
getBtn.TextSize = 16
Instance.new("UICorner", getBtn).CornerRadius = UDim.new(0,12)

getBtn.MouseButton1Down:Connect(function()
    getBtn:TweenSize(UDim2.new(1, -30, 0, 38), "Out", "Quad", 0.1, true)
end)

getBtn.MouseButton1Up:Connect(function()
    getBtn:TweenSize(UDim2.new(1, -30, 0, 42), "Out", "Quad", 0.1, true)
end)

getBtn.MouseButton1Click:Connect(function()
    if not selectedFish then
        warn("Pilih ikan dulu!")
        return
    end

    pcall(function()
        addToInventoryRF:InvokeServer(selectedFish, "Catch")
    end)
end)

-- CREDIT TEXT
local credit = Instance.new("TextLabel")
credit.Size = UDim2.new(1, -30, 0, 16)
credit.Position = UDim2.new(0, 15, 1, -18)
credit.BackgroundTransparency = 1
credit.Text = "by mirehub"
credit.TextColor3 = Color3.fromRGB(120,120,120)
credit.Font = Enum.Font.Gotham
credit.TextSize = 12
credit.TextTransparency = 0.2
credit.TextXAlignment = Enum.TextXAlignment.Center
credit.Parent = frame

-- DRAG
local dragging, dragStart, startPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
