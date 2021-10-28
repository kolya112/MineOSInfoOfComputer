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

---------------------------------------------------------------------------------

-- Add a new window to MineOS workspace
local workspace, window, menu = system.addWindow(GUI.filledWindow(1, 1, 113, 43, 0xE1E1E1))

-- Get localization table dependent of current system language

-- Add single cell layout to window
local layout = window:addChild(GUI.layout(1, 1, window.width, window.height, 1, 1))

-- Функции

local function addButton(text)
return layout:addChild(GUI.roundedButton(1, 1, 36, 3, 0xD2D2D2, 0x696969, 0x4B4B4B, 0xF0F0F0, text))
end

local function addText(text)
layout:addChild(GUI.text(1, 1, 0x696969, text))
end

-- Add nice gray text object to layout
layout:addChild(GUI.image(1, 1, image.load(cache .. "/Icon.pic")))
layout:addChild(GUI.text(2, 2, 0x4B4B4B, "Привет, ".. system.getUser()))
layout:addChild(GUI.text(3, 3, 0x4B4B4B, totalMemoryKB .." КБ (".. totalMemoryMB .. " МБ) оперативной памяти у Вас всего"))
layout:addChild(GUI.text(4, 4, 0x4B4B4B, freeMemoryKB .. " КБ (".. freeMemoryMB .. " МБ) оперативной памяти у Вас свободно"))
layout:addChild(GUI.text(5, 5, 0x4B4B4B, lvlenergy .. " зафиксированная энергия на компьютере(".. maxenergy .." максимальная энергия)"))
layout:addChild(GUI.text(6, 6, 0x4B4B4B, uptime .. " секунд работает компьютер"))
layout:addChild(GUI.text(7, 7, 0x4B4B4B, efiname .. " - название EFI"))
layout:addChild(GUI.text(8, 8, 0x4B4B4B, boot .. " - адрес диска, с которого запущена операционная система"))
layout:addChild(GUI.text(10, 10, 0x4B4B4B, address .." - адрес устройства"))
if computer.users() == "" then
layout:addChild(GUI.text(11, 11, 0x4B4B4B, "Список пользователей устройства:".. computer.users()))
end
local lable = layout:addChild(GUI.input(15, 15, 30, 3, 0xEEEEEE, 0x555555, 0x999999, 0xFFFFFF, 0x2D2D2D, "", "Введите новое название EFI"))
addButton("Изменить название EFI").onTouch = function()
  if #lable.text > 0 then
    EFI.setLabel(lable.text)
    GUI.alert("Новое название EFI успешно установлено!")
  else
    GUI.alert("Пустая строка.")
  end
end
layout:addChild(GUI.text(16, 16, 0x33DB40, "Версия 1.07 stable"))
layout:addChild(GUI.text(17, 17, 0x0049FF, "Разработано на проекте Hilarious(hil.su)"))

-- You can also add items without context menu
menu:addItem("Выйти").onTouch = function()
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
