local mod = get_mod("BuffStackHUD")

local color_option = {}

local _is_duplicated = function(a)
    local join = function(t)
        return string.format("%s,%s,%s", t[2], t[3], t[4])
    end

    for i, table in ipairs(color_option) do
        local b = Color[table.text](255, true)

        if join(a) == join(b) then
            return true
        end
    end

    return false
end

for i, name in ipairs(Color.list) do
    if not _is_duplicated(Color[name](255, true)) then
        color_option[#color_option + 1] = { text = name, value = name }
    end
end

table.sort(color_option, function(a, b)
    return a.text < b.text
end)

local widgets = {
}

for _, buff_name in ipairs(mod.buff_names) do
	widgets[#widgets + 1] = {
		setting_id = "group_" .. buff_name,
		type = "group",
		sub_widgets = {
			{
				setting_id = "enable_" .. buff_name,
				type = "checkbox",
				default_value = true
			},
			{
				setting_id = "showlabel_" .. buff_name,
				type = "checkbox",
				default_value = true
			},
			{
				setting_id = "color_" .. buff_name,
				type = "dropdown",
				default_value = "dark_magenta",
				options = table.clone(color_option)
			}
		}
	}
end

return {
	name = mod:localize("mod_name"),
	description = mod:localize("mod_description"),
	is_togglable = true,
	options = {
		widgets = widgets
	}
}
