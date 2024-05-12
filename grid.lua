Grid = {}

function Grid:load()
	self.generation = 0
	self.state = false
	self.grid = {}
	self.square_size = 40
	self.width = math.ceil(love.graphics.getWidth() / self.square_size)
	self.height = math.floor((0.85 * love.graphics.getHeight()) / self.square_size)
	self.w = self.width * self.square_size
	self.h = self.height * self.square_size
	for i = 1, self.width do
		self.grid[i] = {}
		for j = 1, self.height do
			self.grid[i][j] = 0
		end
	end
	self.counter = 0
	self.update_timer = coroutine.create(function()
		while true do
			love.timer.sleep(1 / (1 + slider.value))
			coroutine.yield()
		end
	end)
	coroutine.resume(self.update_timer)
end

function Grid:keyreleased()
	self.state = true
end

function Grid:mousepressed()
	if self.state then
		return
	end
	x, y = love.mouse.getPosition()
	if x == nil or y == nil then
		return
	end
	if x > self.w or y > self.h then
		return
	end
	pos_x = math.floor(x / self.square_size) + 1
	pos_y = math.floor(y / self.square_size) + 1
	if not self.grid[pos_x] then
		self.grid[pos_x] = {}
	end
	self.grid[pos_x][pos_y] = (self.grid[pos_x][pos_y] + 1) % 2
end

function Grid:update(dt)
	if self.state == false then
		return
	end
	if coroutine.status(self.update_timer) == "suspended" then
		self:update_generation()
		coroutine.resume(self.update_timer)
	end
end

function Grid:draw()
	self:draw_grid()
	self:draw_grid_lines()
	self.counter = self.counter + 1
end

function Grid:reset()
	for i = 1, self.w do
		self.grid[i] = {}
		for j = 1, self.h do
			self.grid[i][j] = 0
		end
	end
	self.generation = 0
	self.state = false
end

function Grid:draw_grid_lines()
	love.graphics.setLineStyle("smooth")
	love.graphics.setLineWidth(1)
	love.graphics.setColor(70, 70, 70, 0.5)
	love.graphics.rectangle("line", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

	-- draw vertical lines
	for i = 0, self.width do
		love.graphics.line(i * self.square_size, 0, i * self.square_size, self.h)
	end

	-- draw horizontal lines
	for j = 0, self.height do
		love.graphics.line(0, j * self.square_size, self.w, j * self.square_size)
	end
end

function Grid:draw_grid()
	for x = 1, self.width do
		for y = 1, self.height do
			if self.grid[x][y] == 0 then
				love.graphics.setColor(0, 0, 0)
			else
				love.graphics.setColor(255, 255, 255)
			end
			love.graphics.rectangle(
				"fill",
				self.square_size * (x - 1),
				self.square_size * (y - 1),
				self.square_size,
				self.square_size
			)
		end
	end
	love.graphics.reset()
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

function Grid:update_generation()
	newGrid = {}
	for i = 1, self.width do
		newGrid[i] = {}
		for j = 1, self.height do
			newGrid[i][j] = 0
		end
	end

	for i = 1, self.width do
		for j = 1, self.height do
			live_neighbors = count_neighbors(self.grid, i, j)
			if self.grid[i][j] == 0 then
				if live_neighbors == 3 then
					newGrid[i][j] = 1
				end
			elseif self.grid[i][j] == 1 then
				if live_neighbors == 2 or live_neighbors == 3 then
					newGrid[i][j] = 1
				end
			end
		end
	end

	self.grid = newGrid
	self.generation = self.generation + 1
end
