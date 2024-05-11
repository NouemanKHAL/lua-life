require("util")

suit = require("suit")

update_timer = coroutine.create(function()
	while true do
		love.timer.sleep(1 / (1 + slider.value))
		coroutine.yield()
	end
end)

function love.load()
	love.window.setMode(960, 720)
	width, height = 960, 600
	square_size = 40
	w = math.ceil(width / square_size)
	h = math.ceil(height / square_size)
	generation = 0
	grid = {}
	for i = 1, w do
		grid[i] = {}
		for j = 1, h do
			grid[i][j] = 0
		end
	end
	state = false
	slider = { value = 50, min = 0, max = 100 }
	coroutine.resume(update_timer)
	counter = 0
	love.window.setVSync(0)
end

function love.keyreleased()
	state = true
end

function love.mousepressed()
	if suit.mouseInRect(600, 630, 200, 50) then
		newGrid = {}
		for i = 1, w do
			newGrid[i] = {}
			for j = 1, h do
				newGrid[i][j] = 0
			end
		end
		grid = newGrid
		generation = 0
		state = false
	end
	if state == false then
		x, y = love.mouse.getPosition()
		if x == nil or y == nil then
			return
		end
		if x > width or y > height then
			return
		end
		pos_x = math.floor(x / square_size) + 1
		pos_y = math.floor(y / square_size) + 1
		if not grid[pos_x] then
			grid[pos_x] = {}
		end
		grid[pos_x][pos_y] = (grid[pos_x][pos_y] + 1) % 2
	end
end

function love.update(dt)
	suit.Slider(slider, 250, 650, 200, 20)
	suit.Label(tostring(slider.value), 250, 660, 200, 40)
	speed_label = suit.Label("Speed", 250, 610, 200, 40)
	reset_button = suit.Button("Reset", 600, 630, 200, 50)
	if state == false then
		return
	end
	if coroutine.status(update_timer) == "suspended" then
		update_generation(grid)
		coroutine.resume(update_timer)
	end
end

function love.draw()
	draw_grid(grid)
	draw_grid_lines()
	love.graphics.setColor(255, 255, 255)
	suit.draw()
	love.window.setTitle("Lua Life - Generation :" .. generation)
	counter = counter + 1
end
