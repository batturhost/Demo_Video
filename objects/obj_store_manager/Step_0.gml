// --- Step Event ---

// 1. INHERIT PARENT (Handles dragging)
event_inherited();

// 2. RECALCULATE LAYOUT (Sticky)
window_x2 = window_x1 + window_width;
window_y2 = window_y1 + window_height;

// [FIX] Recalculate with new margins
content_x1 = window_x1 + 4;
content_y1 = window_y1 + title_bar_height + header_height;
content_x2 = window_x2 - 4;
content_y2 = window_y2 - footer_height;

content_w = content_x2 - content_x1;
content_h = content_y2 - content_y1;

max_scroll = max(0, (array_length(catalog) * (card_height + card_spacing)) - content_h + 20);


// 3. INTERACTION LOGIC
var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

if (instance_exists(obj_battle_manager)) exit;
if (variable_instance_exists(id, "input_locked") && input_locked) exit;

if (feedback_timer > 0) feedback_timer--;

// Scroll
if (point_in_rectangle(_mx, _my, window_x1, window_y1, window_x2, window_y2)) {
    var _wheel = mouse_wheel_down() - mouse_wheel_up();
    if (_wheel != 0) {
        scroll_y += _wheel * 20; 
        scroll_y = clamp(scroll_y, 0, max_scroll);
    }
}

// Click Buy Buttons
if (mouse_check_button_pressed(mb_left) && !is_dragging) {
    if (point_in_rectangle(_mx, _my, content_x1, content_y1, content_x2, content_y2)) {
        
        var _rel_mouse_y = (_my - content_y1) + scroll_y;
        
        for (var i = 0; i < array_length(catalog); i++) {
            var _card_y_start = i * (card_height + card_spacing);
            
            var _btn_x1 = content_x2 - btn_buy_w - 10;
            var _btn_y1 = content_y1 + _card_y_start - scroll_y + (card_height/2) - (btn_buy_h/2);
            var _btn_x2 = _btn_x1 + btn_buy_w;
            var _btn_y2 = _btn_y1 + btn_buy_h;
            
            if (point_in_rectangle(_mx, _my, _btn_x1, _btn_y1, _btn_x2, _btn_y2)) {
                var _item = catalog[i];
                
                if (global.PlayerData.coins >= _item.price) {
                    global.PlayerData.coins -= _item.price;
                    array_push(global.PlayerData.inventory, _item);
                    
                    if (audio_exists(snd_ui_click)) audio_play_sound(snd_ui_click, 10, false);
                    
                    refresh_counts(); 
                    feedback_msg = "Purchased " + _item.name + "!";
                    feedback_timer = 60;
                } else {
                    feedback_msg = "Insufficient Funds!";
                    feedback_timer = 60;
                }
            }
        }
    }
}