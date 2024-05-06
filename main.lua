width, height = love.graphics.getWidth(), love.graphics.getHeight()
square_size = 5
w = width / square_size
h = height / square_size
generation = 0

grid = {}
for i = 1, w do
	grid[i] = {}
	for j = 1, h do
		grid[i][j] = math.random(2) - 1
	end
end

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

function love.draw()
	love.window.setTitle("Generation :" .. generation)
	for i = 1, w do
		for j = 1, h do
			if grid[i][j] == 0 then
				love.graphics.setColor(0, 0, 0)
			else
				love.graphics.setColor(255, 255, 255)
			end
			love.graphics.rectangle("fill", square_size * (i - 1), square_size * (j - 1), square_size, square_size)
		end
	end
	update()
	love.timer.sleep(1 / 60)
end
