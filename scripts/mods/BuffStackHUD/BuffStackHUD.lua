local mod = get_mod("BuffStackHUD")

mod:register_hud_element({
	class_name = "HudElementStackBuff",
	filename = "BuffStackHUD/scripts/mods/BuffStackHUD/HudElementStackBuff",
	use_hud_scale = true,
	visibility_groups = {
		"alive",
	},
})

mod.last_buff_idx = {}
mod.colors = {}
mod.labels = {}

local function get_toggles()
	mod.colors = {}
	mod.labels = {}
	for _, buff_name in ipairs(mod.buff_names) do
		if mod:get("enable_" .. buff_name) then
			mod.colors[buff_name] = mod:get("color_" .. buff_name) or "dark_magenta"
			mod.labels[buff_name] = mod:get("showlabel_" .. buff_name)
		end
	end
end

get_toggles()

mod.on_setting_changed = function()
	get_toggles()
end
