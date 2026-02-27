--[[ 
    วิธีใช้ : Copy โค้ดนี้ไปรันใน Command Bar หรือ Delta X (ตัวรันนินจา) ของคุณ
]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui") -- ใช้ CoreGui เพื่อไม่ให้ GUI หายเวลาตาย (ถ้าใช้ใน Studio ให้เปลี่ยนเป็น PlayerGui)
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- 🛡️ ระบบความปลอดภัย (กำหนด ID ผู้มีสิทธิ์ใช้)
local AdminIDs = {LocalPlayer.UserId} 

-- 🎨 --- ส่วนการสร้าง GUI ด้วยโค้ด ---
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GeminiAdminSystem"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 450, 0, 300)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 2
MainFrame.Active = true
MainFrame.Draggable = true -- ทำให้ลากไปมาได้
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Text = "🚀 GEMINI UNIVERSAL ADMIN (ADVANCED)"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

-- 👥 รายชื่อผู้เล่น (Scrolling Frame)
local PlayerList = Instance.new("ScrollingFrame")
PlayerList.Size = UDim2.new(0.4, 0, 0.7, 0)
PlayerList.Position = UDim2.new(0.05, 0, 0.15, 0)
PlayerList.CanvasSize = UDim2.new(0, 0, 10, 0)
PlayerList.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
PlayerList.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = PlayerList
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- 🎯 ส่วนแสดงสถานะและช่องใส่ค่า
local SelectedLabel = Instance.new("TextLabel")
SelectedLabel.Size = UDim2.new(0.5, 0, 0.1, 0)
SelectedLabel.Position = UDim2.new(0.5, 0, 0.15, 0)
SelectedLabel.Text = "เป้าหมาย: ยังไม่เลือก"
SelectedLabel.TextColor3 = Color3.new(1, 0.8, 0)
SelectedLabel.BackgroundTransparency = 1
SelectedLabel.Parent = MainFrame

local ValueInput = Instance.new("TextBox")
ValueInput.Size = UDim2.new(0.45, 0, 0.1, 0)
ValueInput.Position = UDim2.new(0.5, 0, 0.25, 0)
ValueInput.PlaceholderText = "ใส่ตัวเลข (เช่น Speed)"
ValueInput.Text = ""
ValueInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ValueInput.TextColor3 = Color3.new(1, 1, 1)
ValueInput.Parent = MainFrame

-- 🔘 ฟังก์ชันสร้างปุ่มคำสั่ง
local selectedPlayerName = ""
local function CreateCmdBtn(name, pos, color, callback)
    local btn = Instance.new("TextButton")
    btn.Name = name .. "Btn"
    btn.Size = UDim2.new(0.2, 0, 0.12, 0)
    btn.Position = pos
    btn.Text = name
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.Parent = MainFrame
    btn.MouseButton1Click:Connect(callback)
end

-- 🔄 ฟังก์ชันอัปเดตรายชื่อผู้เล่น
local function RefreshList()
    for _, v in pairs(PlayerList:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end
    for _, p in pairs(Players:GetPlayers()) do
        local pBtn = Instance.new("TextButton")
        pBtn.Size = UDim2.new(1, 0, 0, 25)
        pBtn.Text = p.Name
        pBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        pBtn.TextColor3 = Color3.new(1, 1, 1)
        pBtn.Parent = PlayerList
        pBtn.MouseButton1Click:Connect(function()
            selectedPlayerName = p.Name
            SelectedLabel.Text = "เป้าหมาย: " .. p.Name
        end)
    end
end
Players.PlayerAdded:Connect(RefreshList)
Players.PlayerRemoving:Connect(RefreshList)
RefreshList()

-- ⚡ --- ลงทะเบียนคำสั่งแอดมิน ---
-- หมายเหตุ: หากรันใน LocalScript บางคำสั่งจะเห็นผลแค่เรา (เช่น Kill) 
-- ยกเว้นคุณจะมี RemoteEvent หรือรันผ่านสคริปต์ที่รองรับ Server

CreateCmdBtn("KILL", UDim2.new(0.5, 0, 0.4, 0), Color3.fromRGB(150, 0, 0), function()
    print("Executing Kill on: " .. selectedPlayerName)
    -- ในระบบขั้นสูง จะต้องส่งไปที่ Server แต่ในที่นี้เราเน้นโครงสร้าง GUI ที่สมบูรณ์
end)

CreateCmdBtn("SPEED", UDim2.new(0.75, 0, 0.4, 0), Color3.fromRGB(0, 120, 0), function()
    local s = tonumber(ValueInput.Text) or 16
    print("Setting Speed: " .. s .. " to " .. selectedPlayerName)
end)

CreateCmdBtn("TP", UDim2.new(0.5, 0, 0.55, 0), Color3.fromRGB(0, 100, 200), function()
    print("Teleporting to: " .. selectedPlayerName)
end)

CreateCmdBtn("KICK", UDim2.new(0.75, 0, 0.55, 0), Color3.fromRGB(200, 100, 0), function()
    print("Kicking: " .. selectedPlayerName)
end)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Parent = MainFrame
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

print("✅ Gemini Admin GUI Loaded Successfully!")
