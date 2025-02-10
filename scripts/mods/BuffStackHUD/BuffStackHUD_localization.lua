local mod = get_mod("BuffStackHUD")
local BuffTemplates = require("scripts/settings/buff/buff_templates")

mod.buff_names = {}

local loc = {
	mod_name = {
		en = "HUD Buff Stacks",
	},
	mod_description = {
		en = "Show a timer and stack of various stackable buffs on the HUD.",
	},
	enable = {
		en = "Enabled"
	},
	showlabel = {
		en = "Show Label"
	},
	color = {
		en = "Color"
	},
	chaos_beast_of_nurgle_hit_by_vomit = {
		en = "Beast of Nurgle Vomit"
	},
	fire_burninating = {
		en = "Burning"
	},
	flamer_assault = {
		en = "Burning (Flamer)"
	},
	ogryn_big_bully_heavy_hits_buff = {
		en = Localize("loc_talent_ogryn_big_bully_heavy_hits")
	},
	ogryn_charge_trample_buff = {
		en = Localize("loc_talent_ogryn_ability_charge_trample")
	},
	ogryn_crit_chance_on_kill_effect = {
		en = Localize("loc_talent_ogryn_crit_chance_on_kill")
	},
	ogryn_heavy_hitter_damage_effect = {
		en = Localize("loc_talent_ogryn_heavy_hitter_max_stacks_improves_toughness")
	},
	psyker_crits_empower_warp_buff = {
		en = Localize("loc_talent_psyker_crits_empower_next_attack")
	},
	psyker_cycle_stacking_non_warp_damage = {
		en = Localize("loc_talent_psyker_kills_stack_other_weapon_damage") .. " (Nonwrap)"
	},
	psyker_cycle_stacking_warp_damage = {
		en = Localize("loc_talent_psyker_kills_stack_other_weapon_damage") .. " (Wrap)"
	},
	psyker_force_staff_quick_attack_debuff = {
		en = Localize("loc_talent_psyker_force_staff_quick_attack_bonus")
	},
	psyker_marked_enemies_passive_bonus_stacking = {
		en = Localize("loc_talent_psyker_marked_enemies_passive")
	},
	psyker_marked_enemies_passive_bonus_stacking_increased_duration = {
		en = Localize("loc_talent_psyker_mark_increased_duration")
	},
	psyker_marked_enemies_passive_bonus_stacking_increased_stacks = {
		en = Localize("loc_talent_psyker_mark_increased_max_stacks")
	},
	psyker_overcharge_stance_damage = {
		en = Localize("loc_talent_psyker_combat_ability_overcharge_stance")
	},
	psyker_overcharge_stance_finesse_damage = {
		en = Localize("loc_ability_psyker_overcharge_weakspot")
	},
	psyker_shout_warp_generation_reduction = {
		en = Localize("loc_talent_psyker_shout_reduces_warp_charge_generation")
	},
	psyker_souls = {
		en = Localize("loc_talent_psyker_souls")
	},
	psyker_souls_increased_max_stacks = {
		en = Localize("loc_talent_psyker_increased_souls")
	},
	psyker_stacking_movement_buff = {
		en = Localize("loc_talent_psyker_crits_regen_tougness_and_movement_speed")
	},
	psyker_throwing_knife_stacking_speed_buff = {
		en = Localize("loc_talent_psyker_throwing_knives_reduced_cooldown")
	},
	veteran_damage_after_sprinting_buff = {
		en = Localize("loc_talent_veteran_damage_damage_after_sprinting")
	},
	veteran_dodging_crit_buff = {
		en = Localize("loc_talent_veteran_dodging_grants_crit")
	},
	veteran_improved_tag_allied_buff = {
		en = Localize("loc_talent_veteran_improved_tag_dead_coherency_bonus")
	},
	veteran_improved_tag_allied_buff_increased_stacks = {
		en = Localize("loc_talent_veteran_improved_tag_more_damage")
	},
	veteran_ranged_weakspot_toughenss_buff = {
		en = Localize("loc_talent_veteran_toughness_on_weakspot_kill")
	},
	veteran_weapon_switch_ranged_buff = {
		en = Localize("loc_talent_veteran_weapon_switch")
	},
	weapon_trait_bespoke_chainaxe_p1_guaranteed_melee_crit_on_activated_kill_effect = {
		en = "Chain Axe Guarantee Crit"
	},
	weapon_trait_bespoke_combataxe_p2_guaranteed_melee_crit_after_crit_weakspot_kill_effect_percentage = {
		en = "Combat Axe Guarantee Crit"
	},
	zealot_bleeding_crits_effect = {
		en = Localize("loc_talent_zealot_bleed_melee_crit_chance")
	},
	zealot_channel_toughness_bonus = {
		en = Localize("loc_talent_zealot_bolstering_prayer")
	},
	zealot_multi_hits_increase_impact_effect = {
		en = Localize("loc_talent_zealot_multi_hits_increase_impact")
	},
	zealot_quickness_active = {
		en = Localize("loc_talent_zealot_quickness")
	},
	zealot_stacking_melee_damage_effect = {
		en = Localize("loc_talent_zealot_increased_damage_stacks_on_hit")
	},
}

local hide_buffs = {
	bleed = 1,
	increase_damage_received_while_electrocuted = 1,
	increase_damage_received_while_staggered = 1,
	increase_damage_taken = 1,
	increase_impact_received_while_staggered = 1,
	power_maul_sticky_tick = 1,
	psyker_biomancer_warpfire_debuff = 1,
	rending_burn_debuff = 1,
	rending_debuff = 1,
	rending_debuff_medium = 1,
	warp_fire = 1,
}

for buff_name, buff in pairs(BuffTemplates) do
	if buff.max_stacks and buff.max_stacks > 1 and buff.duration and buff.duration > 0 and not hide_buffs[buff_name] then
		mod.buff_names[#mod.buff_names + 1] = buff_name
		loc["enable_" .. buff_name] = loc["enable"]
		loc["color_" .. buff_name] = loc["color"]
		loc["showlabel_" .. buff_name] = loc["showlabel"]

		local key = "group_" .. buff_name

		loc[key] = loc[key] or {}
		loc[key]["en"] = "    " .. buff_name
		if loc[buff_name] and loc[buff_name].en then
			loc[key]["en"] = "    " .. loc[buff_name].en
		end
	end
end

table.sort(mod.buff_names, function(a, b)
	return a < b
end)

for i, name in ipairs(Color.list) do
    local c = Color[name](255, true)
    local text = string.format("{#color(%s,%s,%s)}%s{#reset()}", c[2], c[3], c[4], string.gsub(name, "_", " "))

    loc[name] = {}
    loc[name].en = text
end

return loc
