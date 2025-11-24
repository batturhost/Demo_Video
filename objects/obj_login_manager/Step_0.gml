// --- Step Event ---
cursor_blink = (cursor_blink + 1) % 60;

// 1. Handle Error Popup (Modal)
if (show_error_popup) {
    // Check for click on the Error OK button OR Enter/Escape keys
    if (check_button_click(err_btn_x1, err_btn_y1, err_btn_x2, err_btn_y2) || keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_escape)) {
        
        show_error_popup = false;
        login_attempts++; 
        password_input = ""; 
        
        // Play click sound if keyboard used
        if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_escape)) play_ui_click();
    }
    exit; // Stop here
}

// 2. Typing
var _char = keyboard_lastchar;
if (_char != "") {
    if (string_length(password_input) < max_pass_length && ord(_char) >= 32 && ord(_char) <= 126) {
        password_input += _char;
    }
    keyboard_lastchar = "";
}
if (keyboard_check_pressed(vk_backspace)) {
    password_input = string_delete(password_input, string_length(password_input), 1);
}

// 3. Main Interaction
if (check_button_click(btn_ok_x1, btn_ok_y1, btn_ok_x2, btn_ok_y2) || keyboard_check_pressed(vk_enter)) {
    if (keyboard_check_pressed(vk_enter)) play_ui_click();
    
    if (login_attempts == 0) {
        show_error_popup = true;
        // Debug check: look for this in your compiler output
        show_debug_message("SCRIPTED FAILURE TRIGGERED"); 
    } else {
        room_goto(rm_hub);
    }
}

if (check_button_click(btn_cancel_x1, btn_cancel_y1, btn_cancel_x2, btn_cancel_y2)) {
    game_restart(); 
}