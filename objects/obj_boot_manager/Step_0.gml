// --- Step Event ---

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
var _click = mouse_check_button_pressed(mb_left);

// Check if text scrolling is finished
if (current_line >= array_length(text_lines)) {
    
    // 1. Button Logic (Reboot)
    btn_reboot_hover = point_in_rectangle(_mx, _my, btn_reboot_x1, btn_reboot_y1, btn_reboot_x2, btn_reboot_y2);
    
    if (btn_reboot_hover && _click) {
        // REBOOT SEQUENCE
        play_ui_click();
        
        // Reset Text
        current_line = 0;
        alarm[0] = text_speed;
        
        // Reset Auto-Start Timer
        auto_start_timer = auto_start_delay_max;
        
        // Exit early so we don't trigger the room transition below
        exit; 
    }
    
    // 2. Auto-Transition Logic (The Default)
    if (auto_start_timer > 0) {
        auto_start_timer--;
    } else {
        // Timer finished -> Go to Login Screen
        room_goto(rm_login);
    }
} else {
    // Text is still scrolling, no interactions
    btn_reboot_hover = false;
}

// --- SPACEBAR SHORTCUT (Debug Override) ---
if (keyboard_check_pressed(vk_space)) {
    global.open_debug_battle = true;
    room_goto(rm_hub);
}