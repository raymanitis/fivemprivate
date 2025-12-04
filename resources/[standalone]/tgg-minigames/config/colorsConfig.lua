Config = Config or {}

Config.Colors = {

    container = {
        bg_overlay = "rgba(0, 0, 0, 0.45)",
        bg_container = "rgba(18, 26, 28, 0.87)", -- #121a1cde from HTML
        bg_header = "rgba(18, 26, 28, 0.89)", -- #121a1ce3 from HTML
        content_background = "rgba(0, 0, 0, 0)",
        border_color = "rgba(194, 244, 249, 0.4)", -- #c2f4f967 from HTML
        container_box_shadow = "rgba(0, 0, 0, 0.35)",
    },

    background = {
        gradient_color_1 = "rgba(18, 26, 28, 1)", -- #121a1c from HTML
        gradient_color_2 = "rgba(18, 26, 28, 0.9)", -- Darker variant
        gradient_color_3 = "rgba(18, 26, 28, 0.8)", -- Lighter variant
        grid_pattern_color = "rgba(194, 244, 249, 0.12)", -- Main color with low opacity
    },

    progress = {
        accent_color = "rgba(194, 244, 249, 1)", -- #C2F4F9 main color from HTML
        error_color = "rgba(248, 113, 113, 1)",
        warning_color = "rgba(251, 191, 36, 1)",
    },

    results = {
        success_color = "rgba(194, 244, 249, 1)", -- Using main color for success
        failure_color = "rgba(248, 113, 113, 1)",
        info_color = "rgba(255, 255, 255, 1)",
    },

    penalty = {
        penalty_color = "rgba(248, 113, 113, 1)",
    },

    gameOverlay = {
        overlay_background = "rgba(18, 26, 28, 0.95)", -- Using HTML bg color
        overlay_border = "rgba(194, 244, 249, 0.4)", -- #c2f4f967 from HTML
        overlay_text = "rgba(255, 255, 255, 1)",
    },

    text = {
        text_color = "rgba(255, 255, 255, 1)",
        text_secondary = "rgba(255, 255, 255, 0.5)", -- From HTML
        text_muted = "rgba(255, 255, 255, 0.3)",
        instructions_color = "rgba(255, 255, 255, 0.5)", -- From HTML
    },

    games = {
        main_color = "rgba(194, 244, 249, 1)", -- #C2F4F9 main color from HTML
        game_color_1 = "rgba(194, 244, 249, 0.8)", -- Variations of main color
        game_color_2 = "rgba(194, 244, 249, 0.6)",
        game_color_3 = "rgba(194, 244, 249, 0.4)",
        game_color_4 = "rgba(56, 79, 82, 0.31)", -- #384f524f from HTML key wrapper
        game_color_5 = "rgba(194, 244, 249, 0.12)", -- #c2f4f91e from HTML item-color
        game_color_6 = "rgba(255, 255, 255, 0.08)", -- #ffffff14 from HTML border separator
    },
}
