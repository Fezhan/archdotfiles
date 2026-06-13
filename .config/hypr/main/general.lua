hl.config({
    general = {
        gaps_in = 7,
        gaps_out = 15,
        border_size = 2,

        col = {
            active_border = "rgba(f52891cc) rgba(00ff99ee) 45deg",
            inactive_border = "rgba(257566cc)",
        },

        resize_on_border = false,
        allow_tearing = false,
        layout = "dwindle",
    },

    dwindle = {
        force_split = 0,
        preserve_split = false,
        smart_split = false,
        smart_resizing = true,
        permanent_direction_override = false,
        special_scale_factor = 1.0,
        split_width_multiplier = 1.0,
        use_active_for_splits = true,
        default_split_ratio = 1.0,
        split_bias = 0.0,
        precise_mouse_move = false,
    },
})