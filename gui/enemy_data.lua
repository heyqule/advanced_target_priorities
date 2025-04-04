---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by heyqule.
--- DateTime: 2/12/2025 12:50 AM
---
local enemy_data = {
    ['biters'] = {
        delimiter = '-',
        name = "biters",
        prefix = nil,
        suffix = nil,
        --- 4 type of options 'size', 'unit_type', 'tier','variant'
        options = {
            {'small','medium','big','behemoth'},
            {'biter','spitter'}
        },
        --- controls order of text concatenation
        option_titles = {
            'size', 'unit_type'
        },
        --- allow delimiter override for each option
        option_delimiters = {}
    },
}

if script.active_mods["space-age"] then
    enemy_data['asteroids'] = {
        delimiter = '-',
        name = "asteroids",
        prefix = nil,
        suffix = 'asteroid',
        options = {
            {'small','medium','big','huge'},
            {'oxide','carbonic','metallic','promethium'}
        },
        option_titles = {
            'size', 'unit_type'
        }
    }
    enemy_data['segmented-unit'] = {
        name = "segmented-unit",
        delimiter = '-',
        prefix = nil,
        suffix = nil,
        options = {
            {'small','medium','big'},
            {'demolisher'}
        },
        option_titles = {
            'size', 'unit_type'
        }
    }
    enemy_data['pentapods'] = {
        name = "pentapods",
        delimiter = '-',
        prefix = nil,
        suffix = nil,
        options = {
            {'small','medium','big'},
            {'strafer-pentapod','stomper-pentapod','wriggler-pentapod'}
        },
        option_titles = {
            'size', 'unit_type'
        }
    }
end

if script.active_mods["Toxic_biters"] or
   script.active_mods["Cold_biters"] or
   script.active_mods["ArmouredBiters"] or
   script.active_mods["Explosive_biters"]
then
    enemy_data["biter_variants"] = {
        delimiter = '-',
        name = "biter_variants",
        prefix = nil,
        suffix = nil,
        options = {
            {'small','medium','big','behemoth','leviathan','mother'},
            {},
            {'biter','spitter'},
        },
        option_titles = {
            'size', 'variant', 'unit_type',
        },
    }
end

if script.active_mods["Toxic_biters"] then
    table.insert(enemy_data["biter_variants"]['options'][2], 'toxic')
end
if script.active_mods["Cold_biters"] then
    table.insert(enemy_data["biter_variants"]['options'][2], 'cold')
end
if script.active_mods["ArmouredBiters"] then
    table.insert(enemy_data["biter_variants"]['options'][2], 'armoured')
end
if script.active_mods["Explosive_biters"] then
    table.insert(enemy_data["biter_variants"]['options'][2], 'explosive')
end
if script.active_mods['Electric_flying_enemies'] then
    enemy_data["fulgoran_enemies"] = {
        delimiter = '-',
        name = "fulgoran_enemies",
        prefix = nil,
        suffix = nil,
        options = {
            {'walking-electric-unit','flying-electric-unit'},
            {1,2,3,4,5},
        },
        option_titles = {
            'unit_type', 'tier' ,
        },
    }
end

if script.active_mods['planet-arrakis'] then
    table.insert(enemy_data['segmented-unit']['options'][2], 'sandworm')
end

if script.active_mods['tenebris'] or script.active_mods['tenebris-prime'] then
    enemy_data["tenebris"] = {
        delimiter = '-',
        name = "tenebris",
        prefix = nil,
        suffix = nil,
        options = {
            {'centipede-head'},
            {'small','medium','large','giant',},
        },
        option_titles = {
            'unit_type', 'size' ,
        },
    }
end

if script.active_mods['behemoth-enemies'] then
    table.insert(enemy_data['pentapods']['options'][1],'behemoth')
    table.insert(enemy_data['segmented-unit']['options'][1],'behemoth')
end

return enemy_data