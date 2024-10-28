local gui = {}
local developer_id = "TesXter"
local script_name = "Undercity"
local code_name = get_hash(developer_id .. "_" .. script_name)
local version = "0.2"

local function create_checkbox(key)
    return checkbox:new(false, get_hash(code_name .. "_" .. key))
end

gui.elements = {
    main_tree = tree_node:new(0),
    main_toggle = create_checkbox("main_toggle"),
    settings_tree = tree_node:new(1),
    melee_logic = create_checkbox("melee_logic"),
    elite_only_toggle = create_checkbox("elite_only"),
    path_angle_slider = slider_int:new(0, 360, 10, get_hash("path_angle_slider")),
    explorer_grid_size_slider = slider_int:new(10, 20, 15, get_hash("explorer_grid_size_slider")),
}

function gui.render()
    if not gui.elements.main_tree:push(script_name .. " | " .. developer_id .. " | V" .. version) then return end

    gui.elements.main_toggle:render("Enable", "Enable the bot")
    
    if gui.elements.settings_tree:push("Settings") then
        gui.elements.melee_logic:render("Melee", "Do we need to move into Melee?")
        gui.elements.elite_only_toggle:render("Elite Only", "Do we only want to seek out elites in the Pit?")
        gui.elements.path_angle_slider:render("Path Angle", "Adjust the angle for path filtering (0-360 degrees)")
        gui.elements.explorer_grid_size_slider:render("Explorer Grid Size", "Adjust the grid size for exploration (1.0-2.0)")
        gui.elements.settings_tree:pop()
    end

    gui.elements.main_tree:pop()
end

return gui
