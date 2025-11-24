// --- Create Event ---
event_inherited();

// 1. Window Setup
window_width = 750;
window_height = 550;
// [FIX] New Title
window_title = "CritterNet Marketplace"; 

// Center Position
window_x1 = (display_get_gui_width() / 2) - (window_width / 2);
window_y1 = (display_get_gui_height() / 2) - (window_height / 2);
window_x2 = window_x1 + window_width;
window_y2 = window_y1 + window_height;

// 2. Data
catalog = global.store_catalog;
inventory_counts = {};

refresh_counts = function() {
    inventory_counts = {};
    for (var i = 0; i < array_length(global.PlayerData.inventory); i++) {
        var _item = global.PlayerData.inventory[i];
        var _name = _item.name;
        if (!variable_struct_exists(inventory_counts, _name)) {
            inventory_counts[$ _name] = 0;
        }
        inventory_counts[$ _name]++;
    }
};
refresh_counts();

// 3. Layout Settings
title_bar_height = 42; // [FIX] Taller title bar
header_height = 80;    // Banner height
footer_height = 35;    // Status bar

// [FIX] Stretched Body (Margins set to 4 for the window frame thickness)
content_x1 = window_x1 + 4;
content_y1 = window_y1 + title_bar_height + header_height;
content_x2 = window_x2 - 4;
content_y2 = window_y2 - footer_height;

content_w = content_x2 - content_x1;
content_h = content_y2 - content_y1;

// Product Card Settings
card_height = 70;
card_spacing = 10;
scroll_y = 0; 
max_scroll = max(0, (array_length(catalog) * (card_height + card_spacing)) - content_h + 20);

btn_buy_w = 80;
btn_buy_h = 24;

feedback_msg = "";
feedback_timer = 0;