local x = 0
local y = 0
local z = 0
local home_set = false
local gps_on = false
local hud_idz = nil
local hud_idx = nil
local hud_idy = nil
local hud_idd = nil
local hud_idb = nil
local player_name = ""
local saved_huds = {}

-- Define the local functions
-- Define function to display position
local function get_home(player)
    local pos = player:get_pos() -- Get player's position
    x = math.floor(pos.x) -- Round position values for clarity
    y = math.floor(pos.y)
    z = math.floor(pos.z)
    home_set = true
    
    -- Display the coordinates in the chat
    minetest.chat_send_player(player:get_player_name(), "Your home position Lat:"..z..", Long:"..x..", Alt:"..y)
end

--Define function to show home position
local function show_home(player)
    -- Display the coordinates in the chat
    minetest.chat_send_player(player:get_player_name(), "Your home position Lat:"..z..", Long:"..x..", Alt:"..y)
end

-- Define function to set position
local function move_player_to_position(player, newx, newy, newz)
    -- Ensure the player is valid
    if player then
        -- Retrieve current position
        local pos = player:get_pos()
        -- Set new position with provided X and Z coordinates (keep Y position unchanged)
        pos.x = tonumber(newx) or pos.x
        pos.y = tonumber(newy) or pos.y
        pos.z = tonumber(newz) or pos.z
        -- Move the player to the new position
        player:set_pos(pos)
        -- Notify the player about the movement
        minetest.chat_send_player(player:get_player_name(), "You have been moved to Lat:"..pos.z..", Long:"..pos.x..", Alt:"..pos.y)
    end
end

local function gps_hud(player)
    if gps_on then
        local pos = player:get_pos() -- Get player's position
        local look_dir = player:get_look_dir()  -- Get the direction the player is looking at
        local direction = ""

        nowx = math.floor(pos.x) -- Round position values for clarity
        nowy = math.floor(pos.y)
        nowz = math.floor(pos.z)
        
        -- Determine cardinal direction based on the look direction
        if math.abs(look_dir.x) > math.abs(look_dir.z) then
            if look_dir.x > 0 then
                direction = "E"  -- East
            else
                direction = "W"  -- West
            end
        else
            if look_dir.z > 0 then
                direction = "N"  -- North
            else
                direction = "S"  -- South
            end
        end

        if hud_idz then
            if nowz >= 0 then
                player:hud_change(hud_idz, "text", "N = " .. nowz)
            else
                player:hud_change(hud_idz, "text", "S = " .. nowz)
            end
            if nowx >= 0 then
                player:hud_change(hud_idx, "text", "E = " .. nowx)
            else
                player:hud_change(hud_idx, "text", "W = " .. nowx)
            end
            player:hud_change(hud_idy, "text", "Alt= " .. nowy)
            player:hud_change(hud_idd, "text", "Dir = " .. direction)
        else
            hud_idb =player:hud_add({
                hud_elem_type = "image",
                position  = {x = 0.775, y = 0.12},
                --offset    = {x = 0, y = 0},
                text      = "gps.png",
                scale     = { x = 1, y = 1},
                alignment = { x = 1, y = 0 },
            })
            hud_idz = player:hud_add({
                hud_elem_type = "text",
                position = {x = 0.8, y = 0.07},
                name = "gps_ns",
                text = "Z=" .. nowz,
                alignment = {x = 1, y = 0},
                scale = {x = 100, y = 100},
                number = 0x000000,
            })
            hud_idx = player:hud_add({
                hud_elem_type = "text",
                position = {x = 0.8, y = 0.09},
                name = "gps_ew",
                text = "X=" .. nowx,
                alignment = {x = 1, y = 0},
                scale = {x = 100, y = 100},
                number = 0x000000,
            })
            hud_idy = player:hud_add({
                hud_elem_type = "text",
                position = {x = 0.8, y = 0.11},
                name = "gps_x",
                text = "Y=" .. nowy,
                alignment = {x = 1, y = 0},
                scale = {x = 100, y = 100},
                number = 0x000000,
            })
            hud_idd = player:hud_add({
                hud_elem_type = "text",
                position = {x = 0.8, y = 0.13},
                name = "gps_dir",
                text = "Dir = " .. direction,
                alignment = {x = 1, y = 0},
                scale = {x = 100, y = 100},
                number = 0x000000, -- Set to black or another suitable color
            })
        end
    end 
end

-- Define register calls
-- Register chat command to move player to position x y z 
minetest.register_chatcommand("move_to", {
    params = "<lat> <long> <alt>",
    description = "Move player to specified X and Z coordinates",
    func = function(name, param)
        local player = minetest.get_player_by_name(name)
        if player then
            local myz, myx, myy = param:match("(%S+)%s+(%S+)%s+(%S+)")
            if x and z then
                move_player_to_position(player, myx, myy, myz)
            else
                minetest.chat_send_player(name, "Usage: /movepos <lat> <long> <alt>")
            end
        else
            minetest.chat_send_player(name, "Player not found!")
        end
    end,
})

-- Register chat command to move player home 
minetest.register_chatcommand("go_home", {
    description = "Move player to home coordinates",
    func = function(name, param)
        local player = minetest.get_player_by_name(name)
        if player then
            if home_set then
                move_player_to_position(player, x, y, z)
            else
                minetest.chat_send_player(name, "Home not set!")
            end
        else
            minetest.chat_send_player(name, "Player not found!")
        end
    end,
})

-- Register chat command to set the player home position
minetest.register_chatcommand("set_home", {
    params = "",
    description = "Display your current position",
    func = function(name, param)
        local player = minetest.get_player_by_name(name)
        if player then
            get_home(player)
        else
            minetest.chat_send_player(name, "Player not found!")
        end
    end,
})

-- Register chat command to show the player home position
minetest.register_chatcommand("show_home", {
    params = "",
    description = "Display your home position",
    func = function(name, param)
        local player = minetest.get_player_by_name(name)
        if player then
            if home_set then
                show_home(player)
            else
                minetest.chat_send_player(name, "Home not set!")
            end
        else
            minetest.chat_send_player(name, "Player not found!")
        end
    end,
})

-- Register chat command to set gps on or off
minetest.register_chatcommand("gps", {
    params = "<state>",
    description = "Turn GPS on or off",
    func = function(name, param)
        local player = minetest.get_player_by_name(name)
        if player then
            if param == "on" then
                gps_on = param == "on"
                minetest.chat_send_player(name, "GPS is now " .. param)
            elseif param == "off" then
                gps_on = param == "oFF"
                if hud_idz ~= nil then 
                    player:hud_remove(hud_idz)
                    player:hud_remove(hud_idx)
                    player:hud_remove(hud_idy)
                    player:hud_remove(hud_idb)
                    player:hud_remove(hud_idd)
                    hud_idz = nil
                    hud_idx = nil
                    hud_idy = nil
                    hud_idb = nil
                    hud_idd = nil
                end
                minetest.chat_send_player(name, "GPS is now " .. param)
            else
                minetest.chat_send_player(name, "Usage: /gps <on|off>")
            end
        else
            minetest.chat_send_player(name, "Player not found!")
        end
    end,
})

-- Register the setup of player joining
minetest.register_on_joinplayer(function(player)
    player_name = player:get_player_name()
    minetest.chat_send_all("Player " .. player_name .. " has joined the game!")
end)

-- Register the commands to run on globalstep
minetest.register_globalstep(function(dtime)
    local player = minetest.get_player_by_name(player_name) -- Change "singleplayer" to the name of your player
    if player then
       gps_hud(player)
    end
end)
