local mod = get_mod("BuffStackHUD")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")

local definitions = {
  	scenegraph_definition = {
		screen = UIWorkspaceSettings.screen,
  	},
  	widget_definitions = {
  	}
}

local buff_count = 6

local stack_font_size = 30
local label_font_size = 15

for i = 1, buff_count do
	local buff_group_name = "buff_" .. i
	definitions["scenegraph_definition"][buff_group_name .. "_area"] = {
		parent = "screen",
		size = { 150, 150 },
		vertical_alignment = "center",
		horizontal_alignment = "center",
		position = { 200, 300 - (100 * i), 5 }
	}
	definitions["widget_definitions"][buff_group_name] = UIWidget.create_definition({
		{
			pass_type = "text",
			value = "",
			value_id = "stack",
			style_id = "stack",
			style = {
				font_type = "machine_medium",
				font_size = stack_font_size,
				drop_shadow = true,
				text_vertical_alignment = "center",
				text_horizontal_alignment = "center",
				text_color = Color.dark_magenta(255, true),
				offset = { 0, 0, 100 }
			}
		},
		{
			pass_type = "texture",
			style_id = "charge_bar",
			value = "content/ui/materials/effects/powersword_bar",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				offset = { 15, 15, 99 },
				size = { 0, 0 },
				color = Color.dark_magenta(255, true),
				material_values = {
					active = 1,
					color_blend = 0,
					fill_opacity = 1,
					lockout = 0,
					outline_opacity = 1,
					progress = 0,
				},
			},
		},
		{
			pass_type = "text",
			value = "",
			value_id = "label",
			style_id = "label",
			style = {
				font_type = "machine_medium",
				font_size = label_font_size,
				drop_shadow = true,
				text_vertical_alignment = "center",
				text_horizontal_alignment = "center",
				text_color = Color.dark_magenta(255, true),
				offset = { 0, 60, 101 }
			}
		},
	}, buff_group_name .. "_area")
end

HudElementStackBuff = class("HudElementStackBuff", "HudElementBase")

function HudElementStackBuff:init(parent, draw_layer, start_scale)
	HudElementStackBuff.super.init(self, parent, draw_layer, start_scale, definitions)
end

HudElementStackBuff.clear_timer = function(self)
	for _, w in pairs(self._widgets) do
		w.visible = false
	end
end

local _populate_buff = function(widget, buff_name, stack_count, max_stack, duration_pct)
	widget.visible = true
	widget.content.stack = stack_count
	widget.content.label = mod.labels[buff_name] and mod:localize(buff_name) or ""
	local font_size = stack_font_size
	if duration_pct > 0.75 then
		font_size = font_size + math.lerp(0, font_size, duration_pct - 0.75)
	end
	widget.style.stack.font_size = font_size
	widget.style.label.font_size = label_font_size
	widget.style.charge_bar.size = { 150, 150 }
	widget.style.charge_bar.material_values.progress = math.lerp(0.028, 0.252, duration_pct)
	widget.style.charge_bar.material_values.color_blend = stack_count > 15 and 1 or math.lerp(0.01, 1, stack_count / (max_stack or 1))

	local custom_color = mod.colors[buff_name]
	if custom_color and Color[custom_color] then
		widget.style.stack.text_color = Color[custom_color](255, true)
		widget.style.charge_bar.color = Color[custom_color](255, true)
		widget.style.label.text_color = Color[custom_color](255, true)
	else
		widget.style.stack.text_color = Color.dark_magenta(255, true)
		widget.style.charge_bar.color = Color.dark_magenta(255, true)
		widget.style.label.text_color = Color.dark_magenta(255, true)
	end
end

HudElementStackBuff.update = function(self, dt, t, ui_renderer, render_settings, input_service)
	HudElementStackBuff.super.update(self, dt, t, ui_renderer, render_settings, input_service)
	local player = Managers.player:local_player(1)
	if not player or not player.player_unit then
		return self:clear_timer()
	end
	local archetype = player:archetype_name()
	local buff_extensions = ScriptUnit.extension(player.player_unit, "buff_system")
	if not buff_extensions then
		return self:clear_timer()
	end
	local buff_max = #self._widgets
	local nodupe = {}
	local buffs_needs_slots = {}
	local reserved_slots = {}
	for _, buff in pairs(buff_extensions._buffs_by_index) do
		local template = buff:template()
		if template and mod.colors[template.name] then
			local buff_stack = buff:stat_buff_stacking_count() or 0
			local duration_pct = buff:duration_progress() or 0
			if buff_stack > 0 and duration_pct > 0 and not nodupe[template.name] then
				nodupe[template.name] = {
					stack = buff_stack,
					max_stack = buff:max_stacks(),
					duration_pct = duration_pct,
				}
				if mod.last_buff_idx[template.name] and mod.last_buff_idx[template.name] <= buff_max then
					reserved_slots[mod.last_buff_idx[template.name]] = template.name
				else
					buffs_needs_slots[#buffs_needs_slots + 1] = template.name
					-- mod:echo("buff need slot " .. template.name)
				end
			end
		end
	end

	mod.last_buff_idx = {}
	table.sort(buffs_needs_slots, function(a, b)
		return a < b
	end)
	local buff_iters, _, next_idx = pairs(buffs_needs_slots)
	local buff_name = nil

	for buff_idx = 1, buff_max do
		local widget = self._widgets_by_name["buff_" .. buff_idx]
		if reserved_slots[buff_idx] then
			local buff = nodupe[reserved_slots[buff_idx]]
			_populate_buff(widget, reserved_slots[buff_idx], buff.stack, buff.max_stack, buff.duration_pct)
			mod.last_buff_idx[reserved_slots[buff_idx]] = buff_idx
		else
			next_idx, buff_name = buff_iters(buffs_needs_slots, next_idx)
			if buff_name then
				local buff = nodupe[buff_name]
				_populate_buff(widget, buff_name, buff.stack, buff.max_stack, buff.duration_pct)
				-- mod:echo("new buff slot for " .. buff_name .. " on index " .. buff_idx .. " for widget " .. widget.name)
				mod.last_buff_idx[buff_name] = buff_idx
			else
				buffs_needs_slots = {}
				widget.visible = false
			end
		end
	end
end

return HudElementStackBuff
