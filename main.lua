require("util")
require("grid")
suit = require("suit")

function love.load()
	love.window.setMode(960, 720)
	love.window.setVSync(0)
	slider = { value = 50, min = 0, max = 100 }
	Grid:load()
end

function love.keyreleased()
	Grid:keyreleased()
end

function love.mousepressed()
	if suit.mouseInRect(600, 630, 200, 50) then
		Grid:reset()
	end
	Grid:mousepressed()
end

function love.update(dt)
	suit.Label("Mouse Click to Toggle a Cell", 30, 625, 230, 40)
	suit.Label("Hit <Enter> to Start!", 30, 640, 230, 40)
	suit.Slider(slider, 380, 650, 200, 20)
	suit.Label(tostring(slider.value), 380, 660, 200, 40)
	speed_label = suit.Label("Speed", 380, 610, 200, 40)
	reset_button = suit.Button("Reset", 710, 630, 200, 50)
	Grid:update(dt)
end

function love.draw()
	love.window.setTitle("Lua Life - Generation :" .. Grid.generation)
	suit.draw()
	Grid:draw()
end
