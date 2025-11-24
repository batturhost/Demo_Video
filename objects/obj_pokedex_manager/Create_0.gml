// --- Create Event ---

// 1. INHERIT PARENT
event_inherited();

// 2. Window Properties
window_width = 1024;
window_height = 600;
window_title = "CritterNet Bestiary";

window_x1 = (display_get_gui_width() / 2) - (window_width / 2);
window_y1 = (display_get_gui_height() / 2) - (window_height / 2);
window_x2 = window_x1 + window_width;
window_y2 = window_y1 + window_height;

// 3. Data Logic
critter_keys = variable_struct_get_names(global.bestiary);
array_sort(critter_keys, true);

critter_count = array_length(critter_keys);
selected_index = 0; 

// [NEW] Glitch & Reveal Tracking
last_selected_index = -1;
glitch_sound_played = false;
viewed_counter = 0; 

glitch_reveal_timer = 0;   // How long to show the real sprite
glitch_reveal_active = false; // Are we showing it right now?

// Animation
animation_frame = 0;
animation_speed = 0.1; 

// 4. Internal UI Variables
list_w = 250; 
list_item_height = 20;
list_top_index = 0;
btn_w = 100; 
btn_h = 30;
btn_hovering = false;

// Positions
list_x1 = window_x1 + 20;
list_y1 = window_y1 + 50;
list_h = window_height - 100;
list_x2 = list_x1 + list_w;
list_y2 = list_y1 + list_h;

display_x = list_x2 + 20;
display_y = list_y1;
display_w = (window_x2 - 20) - display_x;

btn_x1 = window_x2 - btn_w - 15;
btn_y1 = window_y2 - btn_h - 15;
btn_x2 = btn_x1 + btn_w;
btn_y2 = btn_y1 + btn_h;

// Prepare List
critter_display_list = [];
for (var i = 0; i < array_length(critter_keys); i++) {
    var _key = critter_keys[i];
    var _data = global.bestiary[$ _key];
    array_push(critter_display_list, { 
        name: _data.animal_name,
        key: _key 
    });
}