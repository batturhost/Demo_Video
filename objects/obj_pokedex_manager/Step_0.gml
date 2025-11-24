// --- Step Event ---

// 1. INHERIT PARENT
event_inherited();

// [FIX] Reset Glitch Sound & Increment Counter
if (selected_index != last_selected_index) {
    last_selected_index = selected_index;
    glitch_sound_played = false;
    viewed_counter++;
    
    // Reset reveal timer on swap
    glitch_reveal_timer = 0;
    glitch_reveal_active = false;
}

// [NEW] Handle Glitch Reveal Timer (Flicker Effect)
// Check if current critter is the monkey
var _curr_key = critter_keys[selected_index];
var _curr_data = global.bestiary[$ _curr_key];

if (_curr_data.animal_name == "Snub-Nosed Monkey") {
    if (glitch_reveal_timer > 0) {
        glitch_reveal_timer--;
        glitch_reveal_active = true;
    } else {
        glitch_reveal_active = false;
        // 1% chance per frame to flash normal (approx every 1-2 seconds)
        if (irandom(90) == 0) {
            // Flash for 0.1 to 0.2 seconds (6 to 12 frames)
            glitch_reveal_timer = irandom_range(6, 12);
        }
    }
} else {
    glitch_reveal_active = false;
}


var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
var _click = mouse_check_button_pressed(mb_left);

// Depth Check
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

// 2. Internal Button Logic
btn_hovering = point_in_box(_mx, _my, btn_x1, btn_y1, btn_x2, btn_y2);

if (_click) {
    if (btn_hovering) {
        instance_destroy();
        exit;
    }
    
    if (!is_dragging) {
        if (point_in_box(_mx, _my, list_x1, list_y1, list_x2, list_y2)) {
            var _relative_y = _my - list_y1;
            var _click_index = floor(_relative_y / list_item_height) + list_top_index;
            if (_click_index < critter_count) {
                selected_index = _click_index;
            }
        }
    }
}

// 3. Scrolling Logic
var _scroll = mouse_wheel_down() - mouse_wheel_up();
if (_scroll != 0) {
    if (point_in_box(_mx, _my, list_x1, list_y1, list_x2, list_y2)) {
        var _max_scroll = max(0, critter_count - floor(list_h / list_item_height));
        list_top_index = clamp(list_top_index + _scroll, 0, _max_scroll);
    }
}

// 4. Recalculate UI
list_x1 = window_x1 + 20;
list_y1 = window_y1 + 50;
list_h = window_height - 100;
list_x2 = list_x1 + list_w;
list_y2 = list_y1 + list_h;

display_x = list_x2 + 20;
display_y = list_y1;

btn_x1 = window_x2 - btn_w - 15;
btn_y1 = window_y2 - btn_h - 15;
btn_x2 = btn_x1 + btn_w;
btn_y2 = btn_y1 + btn_h;