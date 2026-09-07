local home = os.getenv("HOME")
local conf = home .. "/.config/hypr/initial/configs"

-- Load sub-configs by explicit file path
dofile(conf .. "/monitors.lua")
dofile(conf .. "/env.lua")
dofile(conf .. "/input.lua")
dofile(conf .. "/cursor.lua")
dofile(conf .. "/general.lua")
dofile(conf .. "/decoration.lua")
dofile(conf .. "/animations.lua")
dofile(conf .. "/gestures.lua")
dofile(conf .. "/misc.lua")
dofile(conf .. "/keybinds.lua")
dofile(conf .. "/execs.lua")
