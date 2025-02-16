data.raw["gui-style"]["default"]["atp_square_green_button"] =
{
    type = "button_style",
    parent = "button",
    size = 32,
    left_padding = 1,
    right_padding = 1,
    default_graphical_set =
    {
        base = {position = {68, 17}, corner_size = 8},
        shadow = default_dirt
    },
    hovered_graphical_set =
    {
        base = {position = {102, 17}, corner_size = 8},
        shadow = default_dirt,
        glow = default_glow(green_button_glow_color, 0.5)
    },
    clicked_graphical_set =
    {
        base = {position = {119, 17}, corner_size = 8},
        shadow = default_dirt
    },
    disabled_graphical_set =
    {
        base = {position = {85, 17}, corner_size = 8},
        shadow = default_dirt
    },
    left_click_sound = {{ filename = "__core__/sound/gui-green-confirm.ogg", volume = 1 }},
}

data.raw["gui-style"]["default"]["atp_square_red_button"] =
{
    type = "button_style",
    parent = "button",
    size = 32,
    left_padding = 1,
    right_padding = 1,
    default_graphical_set =
    {
        base = {position = {136, 17}, corner_size = 8},
        shadow = default_dirt
    },
    hovered_graphical_set =
    {
        base = {position = {170, 17}, corner_size = 8},
        shadow = default_dirt,
        glow = default_glow(red_button_glow_color, 0.5)
    },
    clicked_graphical_set =
    {
        base = {position = {187, 17}, corner_size = 8},
        shadow = default_dirt
    },
    disabled_graphical_set =
    {
        base = {position = {153, 17}, corner_size = 8},
        shadow = default_dirt
    },
    left_click_sound = { filename = "__core__/sound/gui-red-button.ogg", volume = 0.5 }
}
