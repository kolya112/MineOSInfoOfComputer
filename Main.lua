-- Import libraries
local GUI = require("GUI")
local system = require("System")
local paths = require("Paths")
local fs = require("filesystem")
local component = require("Component")
local image = require("Image")

-- Переменные

local EFI = component.eeprom
local totalMemoryKB = math.modf(computer.totalMemory() / 1024)
local freeMemoryKB = math.modf(computer.freeMemory() / 1024)
local totalMemoryMB = math.modf(totalMemoryKB / 1024)
local freeMemoryMB = math.modf(freeMemoryKB / 1024)
local address = computer.address()
local cache = fs.path(system.getCurrentScript())
local lvlenergy = math.modf(computer.energy())
local maxenergy = math.modf(computer.maxEnergy())
local uptime = math.modf(computer.uptime())
local efiname = EFI.getLabel()
local boot = EFI.getData()
local apath = fs.path(system.getCurrentScript())

---------------------------------------------------------------------------------

-- Add a new window to MineOS workspace
local workspace, window, menu = system.addWindow(GUI.filledWindow(1, 1, 113, 43, 0xE1E1E1))

-- Get localization table dependent of current system language
local lang = system.getCurrentScriptLocalization()

-- Add single cell layout to window
local layout = window:addChild(GUI.layout(1, 1, window.width, window.height, 1, 1))

-- Functions

local function addButton(text)
  return layout:addChild(GUI.roundedButton(1, 1, 36, 3, 0xD2D2D2, 0x696969, 0x4B4B4B, 0xF0F0F0, text))
end

local function draw()
  layout:addChild(GUI.image(1, 1, image.load(apath .. "/Icon.pic")))
end

local function addText(text)
  layout:addChild(GUI.text(1, 1, 0x696969, text))
end

local function addTab(text, func)
  window.tabBar:addItem(text).onTouch = function()
    layout:removeChildren()
    draw()
    func()
    workspace:draw()
  end
end
-- Add nice gray text object to layout
layout:addChild(GUI.image(1, 1, image.load(cache .. "/Icon.pic")))
layout:addChild(GUI.text(2, 2, 0x4B4B4B, lang.welcome .. system.getUser()))
layout:addChild(GUI.text(3, 3, 0x4B4B4B, totalMemoryKB .. lang.KB .. totalMemoryMB .. lang.MBtotal))
layout:addChild(GUI.text(4, 4, 0x4B4B4B, freeMemoryKB .. lang.KB .. freeMemoryMB .. lang.MBfree))
layout:addChild(GUI.text(5, 5, 0x4B4B4B, lvlenergy .. lang.lvlenergy.. maxenergy .. lang.maxenergy))
layout:addChild(GUI.text(6, 6, 0x4B4B4B, uptime .. lang.uptime))
layout:addChild(GUI.text(7, 7, 0x4B4B4B, efiname .. lang.efiname))
layout:addChild(GUI.text(8, 8, 0x4B4B4B, boot .. lang.boot))
layout:addChild(GUI.text(10, 10, 0x4B4B4B, address .. lang.address))
if computer.users() == "" then
layout:addChild(GUI.text(11, 11, 0x4B4B4B, lang.userslist .. computer.users()))
end
local lable = layout:addChild(GUI.input(15, 15, 30, 3, 0xEEEEEE, 0x555555, 0x999999, 0xFFFFFF, 0x2D2D2D, "", lang.efinameinput))
addButton(lang.editefiname).onTouch = function()
  if #lable.text > 0 then
    EFI.setLabel(lable.text)
    GUI.alert(lang.newefiname)
  else
    GUI.alert(lang.emptystring)
  end
end
layout:addChild(GUI.text(16, 16, 0x33DB40, lang.version))
layout:addChild(GUI.text(17, 17, 0x0049FF, lang.dev))

-- You can also add items without context menu
menu:addItem(lang.exit).onTouch = function()
  window:remove()
end

-- Create callback function with resizing rules when window changes its' size
window.onResize = function(newWidth, newHeight)
  window.backgroundPanel.width, window.backgroundPanel.height = newWidth, newHeight
  layout.width, layout.height = newWidth, newHeight
end

---------------------------------------------------------------------------------

-- Draw changes on screen after customizing your window
workspace:draw()
