local plugin_label = 'undercity' -- change to your plugin name

local utils = require "core.utils"
local settings = require 'core.settings'
local tracker = require "core.tracker"
local loot_start = get_time_since_inject()
local loot_timeout = 3

local status_enum = {
    IDLE = 'idle',
    WAITING = 'waiting for alfred to complete',
    LOOTING = 'looting stuff on floor'
}
local task = {
    name = 'alfred_running', -- change to your choice of task name
    status = status_enum['IDLE']
}

local function floor_has_loot()
    return loot_manager.any_item_around(get_player_position(), 30, true, true)
end

local function reset()
    if AlfredTheButlerPlugin then
        AlfredTheButlerPlugin.pause(plugin_label)
    elseif PLUGIN_alfred_the_butler then
        PLUGIN_alfred_the_butler.pause(plugin_label)
    end
    -- add more stuff here if you need to do something after alfred is done
    if floor_has_loot() then
        loot_start = get_time_since_inject()
        task.status = status_enum['LOOTING']
    else
        task.status = status_enum['IDLE']
    end
end

function task.shouldExecute()
    local status = {enabled = false}
    if AlfredTheButlerPlugin then
        status = AlfredTheButlerPlugin.get_status()
        -- add additional conditions to trigger if required
        if (status.enabled and status.need_trigger) or
            task.status == status_enum['WAITING'] or
            task.status == status_enum['LOOTING']
        then
            return true
        end
    elseif PLUGIN_alfred_the_butler then
        status = PLUGIN_alfred_the_butler.get_status()
        if status.enabled and (
            status.inventory_full or
            status.restock_count > 0 or
            status.need_repair or
            status.teleport or
            task.status == status_enum['WAITING'] or
            task.status == status_enum['LOOTING']
        ) then
            return true
        end
    end
    return false
end

function task.Execute()
    if task.status == status_enum['IDLE'] then
        if AlfredTheButlerPlugin then
            AlfredTheButlerPlugin.resume()
            AlfredTheButlerPlugin.trigger_tasks_with_teleport(plugin_label,reset)
        elseif PLUGIN_alfred_the_butler then
            PLUGIN_alfred_the_butler.resume()
            PLUGIN_alfred_the_butler.trigger_tasks_with_teleport(plugin_label,reset)
        end
        task.status = status_enum['WAITING']
    elseif task.status == status_enum['LOOTING'] and get_time_since_inject() > loot_start + loot_timeout then
        task.status = status_enum['IDLE']
    end
end

return task