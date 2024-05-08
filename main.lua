require("util")

function love.load()
	love.window.setMode(990, 830)
	width, height = love.graphics.getWidth(), love.graphics.getHeight()
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
end

function love.keyreleased()
	state = true
end

function love.mousereleased()
	if state == false then
		x, y = love.mouse.getPosition()
		if x == nil or y == nil then
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
	if state == false then
		return
	end

	-- prepare new grid to hold the new values
	newGrid = {}
	for i = 1, w do
		newGrid[i] = {}
		for j = 1, h do
			newGrid[i][j] = 0
		end
	end

	for i = 1, w do
		for j = 1, h do
			live_neighbors = count_neighbors(grid, i, j)
			if grid[i][j] == 0 then
				if live_neighbors == 3 then
					newGrid[i][j] = 1
				end
			elseif grid[i][j] == 1 then
				if live_neighbors == 2 or live_neighbors == 3 then
					newGrid[i][j] = 1
				end
			end
		end
	end

	grid = newGrid
	generation = generation + 1
end

function love.draw()
	draw_grid(grid)
	draw_grid_lines()
	love.window.setTitle("Lua Life - Generation :" .. generation)
	love.timer.sleep(1 / 6)
end
