// --- Step Event ---

// 1. Follow Mouse (Update object position)
x = mouse_x;
y = mouse_y;

// 2. Hourglass Logic (Optional - Keep if you added it)
if (instance_exists(obj_browser_manager)) {
    if (obj_browser_manager.browser_state == "searching") {
        sprite_index = spr_ui_hourglass;
    } else {
        sprite_index = spr_ui_cursor;
    }
} else {
    sprite_index = spr_ui_cursor;
}