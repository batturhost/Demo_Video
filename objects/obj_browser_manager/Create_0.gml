// --- Create Event ---
event_inherited();

// Window Setup
window_width = 800;
window_height = 500;
window_title = "CritterNet Browser";
window_x1 = (display_get_gui_width() / 2) - (window_width / 2);
window_y1 = (display_get_gui_height() / 2) - (window_height / 2);
window_x2 = window_x1 + window_width;
window_y2 = window_y1 + window_height;

// Player Data
var _cup_index = global.PlayerData.current_cup_index;
var _opp_index = global.PlayerData.current_opponent_index;
current_cup = global.CupDatabase[_cup_index];
current_level_cap = current_cup.level_cap;
current_cup_name = current_cup.cup_name;

if (_opp_index >= array_length(current_cup.opponents)) {
    next_opponent_name = "---";
    next_opponent_pfp = spr_avatar_user_default;
} else {
    var _next_opp = current_cup.opponents[_opp_index];
    next_opponent_name = _next_opp.name;
    next_opponent_pfp = _next_opp.profile_pic_sprite;
}

player_name = global.PlayerData.name;
player_pfp = global.PlayerData.profile_pic;

// State Machine
browser_state = "browsing"; 
search_timer = 0;
match_display_timer = 0;


// ==========================================
// DEMO SCRIPTED CONTENT (WEATHER + POPUP)
// ==========================================

// Initialize Popup State
show_popup_ad = false;
popup_delay_timer = 0; // [FIX] Initialize Timer

// Window Style Constants
popup_title_height = 24;
popup_border = 4;
popup_scale = 1.3; 

// Calculate Window Size based on the Sprite
var _spr_w = 320; 
var _spr_h = 180;

if (sprite_exists(asset_get_index("spr_popup_ad"))) {
    _spr_w = sprite_get_width(spr_popup_ad) * popup_scale;
    _spr_h = sprite_get_height(spr_popup_ad) * popup_scale;
}

// Total Window Dimensions
popup_w = _spr_w + (popup_border * 2);
popup_h = _spr_h + (popup_border * 2) + popup_title_height;

// Center on screen
popup_x1 = window_x1 + (window_width - popup_w) / 2;
popup_y1 = window_y1 + (window_height - popup_h) / 2;
popup_x2 = popup_x1 + popup_w;
popup_y2 = popup_y1 + popup_h;


// 1. Increment the counter
if (!variable_global_exists("demo_browser_open_count")) {
    global.demo_browser_open_count = 0;
}
global.demo_browser_open_count++;

// 2. Set Content based on count
if (global.demo_browser_open_count == 1) {
    // --- OPEN #1: NORMAL ---
    weather_desc = "Sunny";
    weather_icon_idx = 0;
    weather_temp = 24;
    weather_string = "24";
    global.weather_condition = "SUN";
    
    current_news = "Lifestyle: Are Apples actually good for electric types?";
    current_deal = "Bulk Biscuits Sale: 50% off family packs!";
    current_fact = "Sea otters hold hands while sleeping.";
} 
else {
    // --- OPEN #2: GLITCHED & POPUP ---
    weather_desc = "DATA STORM";
    weather_icon_idx = 3;
    weather_temp = 99; 
    weather_string = "#ERR";
    global.weather_condition = "STORM"; 
    
    current_news = "CRITICAL WARNING: Connection unstable.";
    current_deal = "FATAL EXCEPTION 0E at 0028:C0011E36";
    current_fact = "Error loading fact.dat: File Corrupted.";
    
    // [FIX] Don't show immediately. Set timer for 2 seconds (120 frames).
    popup_delay_timer = 120; 
}


// Layout Vars
sidebar_w = 180;
sidebar_x1 = window_x1 + 2;
sidebar_y1 = window_y1 + 32;
sidebar_x2 = sidebar_x1 + sidebar_w;
sidebar_y2 = window_y2 - 2;

content_x1 = sidebar_x2;
content_y1 = sidebar_y1;
content_x2 = window_x2 - 2;
content_y2 = window_y2 - 2;

var _start_y = sidebar_y1 + 100;
var _btn_h = 60;
var _spacing = 10;

btn_ranked_x1 = sidebar_x1 + 10;
btn_ranked_y1 = _start_y;
btn_ranked_x2 = sidebar_x2 - 10;
btn_ranked_y2 = btn_ranked_y1 + _btn_h;
btn_ranked_hover = false;

btn_casual_x1 = sidebar_x1 + 10;
btn_casual_y1 = btn_ranked_y2 + _spacing;
btn_casual_x2 = sidebar_x2 - 10;
btn_casual_y2 = btn_casual_y1 + _btn_h;
btn_casual_hover = false;

btn_heal_x1 = sidebar_x1 + 10;
btn_heal_y1 = btn_casual_y2 + _spacing;
btn_heal_x2 = sidebar_x2 - 10;
btn_heal_y2 = btn_heal_y1 + _btn_h;
btn_heal_hover = false;

heal_message_text = "";
heal_message_timer = 0;