local M = {}

M.STATE_MENU = 1
M.STATE_CONTROLS = 2
M.STATE_CREDITS = 3
M.STATE_PLAYING = 4
M.STATE_PAUSE = 5
M.STATE_CLEAR = 6
M.STATE_GAMEOVER = 7
M.STATE_COMPLETE = 8

M.state = M.STATE_MENU

M.SCR_W = 0
M.SCR_H = 0
M.CANV_W = 0
M.CANV_H = 0
M.TILE_SIZE = 16
M.PIXEL_SIZE = 4
M.MAX_LEVELS = 10

M.level = 1
M.time = 0

M.offset = vmath.vector3(0)
M.scrollpos = vmath.vector3(0)
M.bounds = vmath.vector3(0)

M.gate = {}

function M.world2tile(p)
	return vmath.vector3(math.floor((p.x + M.TILE_SIZE) / M.TILE_SIZE), math.floor((p.y + M.TILE_SIZE) / M.TILE_SIZE), p.z)
end

function M.tile2world(p)
	return vmath.vector3((p.x * M.TILE_SIZE) - (M.TILE_SIZE / 2), (p.y * M.TILE_SIZE) - (M.TILE_SIZE / 2), p.z)
end

function M.hex2rgba(hex)
	hex = hex:gsub("#","")
	local rgba = vmath.vector4(tonumber("0x"..hex:sub(1,2))/255, tonumber("0x"..hex:sub(3,4))/255, tonumber("0x"..hex:sub(5,6))/255, 1)
	return rgba
end

function M.onscreen(p, m)
	if p.x > M.scrollpos.x - m and
		p.x < M.scrollpos.x + m + M.CANV_W and
		p.y > M.scrollpos.y - m and
		p.y < M.scrollpos.y + m + M.CANV_H then
		return true
	else
		return false
	end
end

function M.capdt(dt)
	if dt > 1/30 then
		dt = 1/30
	end
	return dt
end

function M.ms2str(time)
	local day = math.floor(time / 86400)
	local rem = time % 86400
	local hr = math.floor(rem / 3600)
	rem = rem % 3600
	local min = math.floor(rem / 60)
	rem = rem % 60
	local sec = rem

	local str = ""
	if day > 0 then str = tostring(day) .. "d " end
	if hr > 0 or day > 0 then str = str .. tostring(hr) .. ":" end

	str = string.format("%s%02d:%02d", str, min, math.floor(sec))
	return str
end

function M.sound(id)
	local t = M.gate[id] or 0
	t = os.clock() - t

	if t > 0.05 then
		M.gate[id] = os.clock()
		local url = "main:/sound#"..id
		sound.play(url)
	end
end

function M.fullscreen(self)
	defos.toggle_fullscreen()
	defos.disable_window_resize()
	defos.disable_maximize_button()
	defos.set_cursor_visible(not defos.is_fullscreen())
end

return M
