--------------------------------------------------------------------------------------------------------------------------------------------------------
-- Adapted from CloneTrooper1019's Collision Editor plugin
--------------------------------------------------------------------------------------------------------------------------------------------------------


local Debris = game:GetService("Debris")
local Selection = game:GetService("Selection")
local CoreGui = game:GetService("CoreGui")
local TextService = game:WaitForChild("TextService")


local canCollideCount = 0
local canQueryCount = 0
local canTouchCount = 0
local pluginActive = false

local toolbar = plugin:CreateToolbar("Collision Visualizer")
local toolbarButton = toolbar:CreateButton("Show", "Collision Visualizer ", "rbxassetid://7525267454")
local gui = script:WaitForChild("CollisionVisualizerGui")



local canCollideButton = gui.Frame.CanCollideButton
local canQueryButton = gui.Frame.CanQueryButton
local canTouchButton = gui.Frame.CanTouchButton
local transparencyButton = gui.Frame.TransparencyButton
local maxDistanceTextBox = gui.Frame.MaxDistanceTextBox
local maxPartsTextBox = gui.Frame.MaxPartsTextBox
local refreshButton = gui.Frame.RefreshButton
local maxPartsReachedText = gui.Frame.MaxPartsReachedTextLabel

local CanCollideButtonValue = false
local CanQueryButtonValue = false
local CanTouchButtonValue = false
local TransparencyButtonValue = false
local MaxPartsValue = tonumber(maxDistanceTextBox.Text)
local MaxDistanceValue = tonumber(maxPartsTextBox.Text)

-- Set selector colors for the different attributes. 
local canCollideSelectionColor = Color3.fromRGB(255, 136, 51)
local canQuerySelectionColor = Color3.fromRGB(12, 125, 16)
local canTouchSelectionColor = Color3.fromRGB(151, 24, 255)
local transparencySelectionColor = Color3.fromRGB(255, 126, 253)


local visualBin = Instance.new("Folder")
visualBin.Name = "CollisionVisualizer"


function resetSelectionBoxes()
	if #visualBin:GetChildren() > 0 then
		for i, obj in pairs(visualBin:GetChildren()) do
			obj.Parent = nil
			Debris:AddItem(obj,3)
			
		end
	end
	
	for i = 1,MaxPartsValue do
		local s = Instance.new("SelectionBox")
		s.Name = i
		s.LineThickness = 0.04
		s.Parent = visualBin
		visualBin.Parent = CoreGui
	end

end


function visualUpdate()
	
	if maxPartsTextBox.Text ~= nil then
		if tonumber(maxPartsTextBox.Text) ~= MaxPartsValue then
			MaxPartsValue = tonumber(maxPartsTextBox.Text)
			resetSelectionBoxes()
		end
		
	else
		maxPartsTextBox.Text = MaxPartsValue
	end
	
	if maxDistanceTextBox.Text ~= nil then
		if tonumber(maxDistanceTextBox.Text) ~= MaxDistanceValue then
			MaxDistanceValue = tonumber(maxDistanceTextBox.Text)
		end

	else
		maxDistanceTextBox.Text = MaxDistanceValue
	end
	
	local c = workspace.CurrentCamera

	local pos = c.Focus.Position
	local corner1 = pos - Vector3.new(MaxDistanceValue,MaxDistanceValue,MaxDistanceValue)
	local corner2 = pos + Vector3.new(MaxDistanceValue,MaxDistanceValue,MaxDistanceValue)
	local region = Region3.new(corner1,corner2)
	local parts = workspace:FindPartsInRegion3(region,nil,MaxPartsValue + 1)
	
	if(#parts == MaxPartsValue + 1) then
		maxPartsReachedText.Visible = true
	else
		maxPartsReachedText.Visible = false
	end
	
	for i = 1,MaxPartsValue do
		local part = parts[i]
		if part then
			local adorn = visualBin[i]
			adorn.SurfaceTransparency = 1
			adorn.Adornee = nil
			
			if part.Transparency == 1 then  
				if TransparencyButtonValue == true then
					adorn.Adornee = part
					adorn.SurfaceColor3 = transparencySelectionColor
					adorn.SurfaceTransparency = .5
					adorn.Color3 = transparencySelectionColor
				else
				end
				
			end
			
			if part.CanCollide == true and CanCollideButtonValue == true then
				adorn.Adornee = part
				adorn.Color3 = canCollideSelectionColor
				
			elseif part.CanQuery == true  and part.CanCollide == false and CanQueryButtonValue == true then
				adorn.Adornee = part
				adorn.Color3 = canQuerySelectionColor
				
			elseif part.CanTouch == true  and CanTouchButtonValue == true then
				adorn.Adornee = part
				adorn.Color3 = canTouchSelectionColor
			end
		end
	end
end


function SetButton(button, newState)
	if newState == true then
		-- set to true (on)
		button.Text = "ON"
		button.BackgroundColor3 = Color3.new(0, 170, 0)
	else
		-- set to false (off)
		button.Text = "OFF"
		button.BackgroundColor3 = Color3.new(0.392157, 0.392157, 0.392157)
	end	
end


function SetCanCollideButton()
	CanCollideButtonValue = not CanCollideButtonValue
	SetButton(canCollideButton, CanCollideButtonValue)
	
	if CanCollideButtonValue == true then
		-- turn off the other buttons
		CanQueryButtonValue = true
		CanTouchButtonValue = true
		SetCanQueryButton()
		SetCanTouchButton()
		
	end
	visualUpdate()
end

function SetCanQueryButton()
	CanQueryButtonValue = not CanQueryButtonValue
	SetButton(canQueryButton, CanQueryButtonValue)
	
	if CanQueryButtonValue == true then
		
		CanCollideButtonValue = true
		CanTouchButtonValue = true
		SetCanTouchButton()
		SetCanCollideButton()
	end
	visualUpdate()
end

function SetCanTouchButton()
	CanTouchButtonValue = not CanTouchButtonValue
	SetButton(canTouchButton, CanTouchButtonValue)
	
	if CanTouchButtonValue == true then
		
		CanQueryButtonValue = true
		CanCollideButtonValue = true
		SetCanQueryButton()
		SetCanCollideButton()
		
	end
	visualUpdate()
end


function SetTransparencyButton()
	TransparencyButtonValue = not TransparencyButtonValue
	SetButton(transparencyButton, TransparencyButtonValue)

	visualUpdate()
end

function ClickRefreshButton()
	visualUpdate()
end

local function clickToolbarButton()
	pluginActive = not pluginActive
	toolbarButton:SetActive(pluginActive)
	gui.Enabled = pluginActive
	if pluginActive == false then
		visualBin.Parent = nil
		gui.Parent = script
	else
		gui.Parent = CoreGui
		resetSelectionBoxes()		
	end
end

toolbarButton.Click:Connect(clickToolbarButton)
canCollideButton.Activated:Connect(SetCanCollideButton)
canQueryButton.Activated:Connect(SetCanQueryButton)
canTouchButton.Activated:Connect(SetCanTouchButton)
transparencyButton.Activated:Connect(SetTransparencyButton)
refreshButton.Activated:Connect(ClickRefreshButton)
