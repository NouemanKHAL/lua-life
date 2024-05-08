function draw_grid_lines()
	love.graphics.setLineStyle("smooth")
	love.graphics.setLineWidth(1)
	love.graphics.setColor(70, 70, 70, 0.5)

	-- draw vertical lines
	for i = 1, w do
		love.graphics.line((i - 1) * square_size, 0, (i - 1) * square_size, height)
	end

	-- draw horizontal lines
	for j = 1, h do
		love.graphics.line(0, (j - 1) * square_size, width, (j - 1) * square_size)
	end

	love.graphics.reset()
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
	love.graphics.rectangle("fill", square_size * (x - 1), square_size * (y - 1), square_size, square_size)
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