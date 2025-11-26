// --- Step Event ---

// 1. INHERIT PARENT
event_inherited();

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
var _click = mouse_check_button_pressed(mb_left);

// [FIX] DEPTH CHECK
var _is_covered = false;
with (obj_window_parent) {
    if (id != other.id && visible && depth < other.depth) {
        if (point_in_rectangle(_mx, _my, window_x1, window_y1, window_x2, window_y2)) {
            _is_covered = true;
            break;
        }
    }
}
if (_is_covered) _click = false;


// 2. Handle Special Closing Logic
if (_click && btn_close_hover) {
    if (global.bargain_offered && !global.trapdoor_unlocked) {
        global.trapdoor_unlocked = true;
    }
}

// 3. Internal Buttons
btn_send_hover = point_in_box(_mx, _my, btn_send_x1, btn_send_y1, btn_send_x2, btn_send_y2);

if (_click && !is_dragging) {
    // Check Buddy List Click
    if (point_in_box(_mx, _my, buddy_list_x, buddy_list_y, buddy_list_x + buddy_list_w, buddy_list_y + buddy_list_h)) {
        var _rel_y = _my - buddy_list_y;
        var _idx = floor(_rel_y / contact_item_height);
        
        if (_idx >= 0 && _idx < array_length(contact_list)) {
            selected_contact_index = _idx;
            selected_contact_name = contact_list[_idx];
        }
    }
}

// --- NEW: MESSAGE REVEAL ANIMATION ---
// 1. Reset if we switched contacts
if (selected_contact_index != last_selected_index) {
    visible_message_count = 0; // Start empty
    message_reveal_timer = 30; // Fast initial delay
    last_selected_index = selected_contact_index;
}

// 2. Reveal Timer Logic
var _current_log = chat_logs[$ selected_contact_name];
if (!is_undefined(_current_log)) {
    var _total_msgs = array_length(_current_log);
    
    // If we haven't shown all messages yet
    if (visible_message_count < _total_msgs) {
        message_reveal_timer--;
        
        if (message_reveal_timer <= 0) {
            // Reveal next message
            visible_message_count++;
            
            // Play sound effect
            if (audio_exists(snd_ui_chime)) {
                var _snd = audio_play_sound(snd_ui_chime, 10, false);
                audio_sound_pitch(_snd, 1.0 + (visible_message_count * 0.05)); 
            }
            
            // --- NEW: TRIGGER CLIFFHANGER ---
            // If this was the LAST message from Skater_X, start the ending sequence
            if (selected_contact_name == "Skater_X" && visible_message_count == _total_msgs && !cliffhanger_triggered) {
                 
                 cliffhanger_triggered = true;
                 
                 // Create the Glitch Effect Controller at Depth 200
                 // (Behind Icons @ 100/0, but In Front of Background @ 300)
                 instance_create_depth(0, 0, 200, obj_glitch_effect);
                 
                 // Hide the original background layer so our black void shows
                 var _lay_id = layer_get_id("Background");
                 if (layer_exists(_lay_id)) {
                     layer_set_visible(_lay_id, false);
                 }
            }
            // --------------------------------
            
            // Reset Timer
            message_reveal_timer = irandom_range(60, 120);
        }
    }
}

// 4. Recalculate UI
toolbar_y1 = window_y1 + 32;
buddy_list_x = window_x1 + 10;
buddy_list_y = toolbar_y1 + toolbar_h + 10;

chat_area_x = buddy_list_x + buddy_list_w + 10;
chat_area_y = buddy_list_y;
chat_area_h = buddy_list_h - 95;

input_area_x = chat_area_x;
input_area_y = chat_area_y + chat_area_h + 10;

btn_send_x1 = input_area_x + input_area_w - btn_send_w;
btn_send_y1 = input_area_y + input_area_h + 5;
btn_send_x2 = btn_send_x1 + btn_send_w;
btn_send_y2 = btn_send_y1 + btn_send_h;