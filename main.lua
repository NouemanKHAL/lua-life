width, height = love.graphics.getWidth(), love.graphics.getHeight()
square_size = 60
w = width / square_size
h = height / square_size
generation = 0

function count_neighbors(g, x, y)
	coords = { { -1, 0 }, { 0, -1 }, { 0, 1 }, { 1, 0 }, { 1, 1 }, { 1, -1 }, { -1, 1 }, { -1, -1 } }

	neighbors = 0
	for i = 1, #coords do
		newX = x + coords[i][1]
		newY = y + coords[i][2]

		if g[newX] and g[newX][newY] then
			neighbors = neighbors + g[newX][newY]
		end
	end

	return neighbors
end

function update()
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

function draw_grid(g)
	for i = 1, w do
		for j = 1, h do
			draw_square(g, i, j)
		end
	end
end

function draw_square(g, x, y)
	if g[x][y] == 0 then
		love.graphics.setColor(0, 0, 0)
	else
		love.graphics.setColor(255, 255, 255)
	end
	love.graphics.rectangle("fill", square_size * x, square_size * y, square_size, square_size)
end

grid = {}
for i = 1, w do
	grid[i] = {}
	for j = 1, h do
		grid[i][j] = 0
	end
end

love.graphics.setColor(255, 255, 255)
love.graphics.setNewFont(14)
love.graphics.print("click on the square to change their colors", 0, 0)

state = false

function love.draw()
	if state == false then
		event = love.event.wait()
		if event == "keyreleased" then
			state = true
			goto continue
		end
		if event == "mousepressed" then
			x = love.mouse.getX()
			y = love.mouse.getY()
			if x == nil or y == nil then
				goto continue
			end
			pos_x = math.floor(x / square_size)
			pos_y = math.floor(y / square_size)
			grid[pos_x][pos_y] = 1
		end
		::continue::
		draw_grid(grid)
		return
	end
	draw_grid(grid)
	update()
	love.window.setTitle("Lua Life - Generation :" .. generation)
	love.timer.sleep(1 / 5)
end
