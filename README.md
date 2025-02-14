### Enemy Race Manager

This mod provide a streamline tool to pick units for turret's target priorities.

### Native supported enemy mods
- All enemy race manager units
- Toxic_biters
- Cold_biters
- ArmouredBiters
- Explosive_biters
- Fulgoran enemies
- Behemonth Enemies Mod
- Sandworm from Planet Arrakis
- Centipedes from Planet Tenebris


### TODOs
- Preset system
- Records are shared by force.

### Developer Integration
##### New dataset can be register through remote_api
```lua
--- Add a new remote API class if you don't have one
--- add this function to register your dataset
function RemoteAPI.advanced_target_priorities_register_section_data()
    local data =  {
        {
           --- Required 
           delimiter = '-',
           --- Required
           name = "biters",
           --- (Optional)
           prefix = "enemy",
           --- (Optional)
           suffix = nil,
           --- (Required) acccepts 4 type of options 'size', 'unit_type', 'tier','variant'
           options = {
               {'small','medium','big','behemoth'},
               {'biter','spitter'},
               {1,2,3,4,5}
           },
           --- (Required) controls order of text concatenation
           option_titles = {
               'size', 'unit_type','tier'
           },
           --- (Optional) allow delimiter override for each option, example 
           --- enemy--small-biter--1, default uses "--" as delimiter and you override the size one with "-"
           option_delimiters = {
               '-'
           },
           --- (Optional) define the number of columns for unit_type list.
           unit_type_columns = 2,
       }
    }
    
    return data
end


--- In control.lua,
local RemoteApi = require("__your_mod__/remote_api")
remote.add_interface("your_mode", RemoteApi)
```

#### Inserting new value into existing section
```lua
--- Add a new remote API class if you don't have one
--- add this function to register your dataset
function RemoteAPI.advanced_target_priorities_register_section_data()
    local data =  {
       {
           section = 'asteroids',
           option_title = 'unit_type',
           option = 'new_type'
       },
       {
           section = 'biters',
           option_title = 'size',
           option = 'titan'
       }
    }
    
    return data
end


--- In control.lua,
local RemoteApi = require("__your_mod__/remote_api")
remote.add_interface("your_mode", RemoteApi)
```