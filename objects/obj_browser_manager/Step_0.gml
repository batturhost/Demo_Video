// --- Step Event ---
event_inherited();

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
var _click = mouse_check_button_pressed(mb_left);
if (heal_message_timer > 0) heal_message_timer--;

// =========================================================
// 1. POPUP DELAY TIMER
// =========================================================
if (variable_instance_exists(id, "popup_delay_timer") && popup_delay_timer > 0) {
    popup_delay_timer--;
    if (popup_delay_timer <= 0) {
        show_popup_ad = true;
        // [SOUND] Play chime when popup appears
        if (audio_exists(snd_ui_click)) audio_play_sound(snd_ui_click, 10, false);
    }
}

// =========================================================
// 2. DEPTH CHECK (Prevent clicking through windows)
// =========================================================
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


// =========================================================
// 3. POPUP CLICK LOGIC (Click Anywhere on Popup)
// =========================================================
if (variable_instance_exists(id, "show_popup_ad") && show_popup_ad) {
    
    if (mouse_check_button_pressed(mb_left)) {
        // Check if clicking inside the Popup Window Frame
        if (point_in_rectangle(_mx, _my, popup_x1, popup_y1, popup_x2, popup_y2)) {
            
            // A. Play Sound & Close
            if (audio_exists(snd_ui_click)) audio_play_sound(snd_ui_click, 10, false);
            show_popup_ad = false;
            
            // B. TRIGGER GLITCH BATTLE INSTANTLY
            if (!instance_exists(obj_battle_manager)) {
                var _glitch_opp = {
                    name: "0xUNKNOWN",
                    profile_pic_sprite: spr_snub_nosed_monkey_idle, 
                    critter_keys: ["snub_nosed_monkey"],
                    critter_levels: [99], 
                    lose_message: "...",
                    is_glitched: true 
                };
                global.demo_is_gold_monkey = true;
                
                var _new_battle = instance_create_layer(0, 0, "Instances", obj_battle_manager, { 
                    is_casual: true, 
                    opponent_data: _glitch_opp, 
                    level_cap: 100 
                });
                global.top_window_depth--;
                _new_battle.depth = global.top_window_depth;
            }
        }
    }
    exit; // Block other input while popup is visible
}


// =========================================================
// 4. BROWSER BUTTON LOGIC
// =========================================================
if (browser_state == "browsing") {
    btn_ranked_hover = point_in_box(_mx, _my, btn_ranked_x1, btn_ranked_y1, btn_ranked_x2, btn_ranked_y2);
    btn_casual_hover = point_in_box(_mx, _my, btn_casual_x1, btn_casual_y1, btn_casual_x2, btn_casual_y2);
    btn_heal_hover = point_in_box(_mx, _my, btn_heal_x1, btn_heal_y1, btn_heal_x2, btn_heal_y2);

    if (_click && !is_dragging) {
        
        // --- RANKED BUTTON ---
        if (btn_ranked_hover) {
            if (instance_exists(obj_battle_manager)) exit;

            if (global.PlayerData.current_opponent_index >= array_length(current_cup.opponents)) {
                heal_message_text = "You've beaten everyone in this cup!";
                heal_message_timer = 120;
            } else {
                browser_state = "searching"; 
                search_timer = 120;
                is_casual_search = false; // Mark as ranked
            }
        }
        
        // --- CASUAL BUTTON (FIXED) ---
        if (btn_casual_hover) {
            if (instance_exists(obj_battle_manager)) exit;

            // [FIX] Only start the search timer. DO NOT create battle here.
            browser_state = "searching"; 
            search_timer = 120; // 2 seconds of "Searching..."
            is_casual_search = true; // Mark as casual
        }
        
        // --- HEAL BUTTON ---
        if (btn_heal_hover) {
            for (var i = 0; i < array_length(global.PlayerData.team); i++) {
                var _critter = global.PlayerData.team[i];
                _critter.hp = _critter.max_hp;
                _critter.atk_stage = 0; 
                _critter.def_stage = 0; 
                _critter.spd_stage = 0;
                for (var m = 0; m < array_length(_critter.moves); m++) {
                    _critter.move_pp[m] = _critter.moves[m].max_pp;
                }
            }
            heal_message_text = "All critters fully restored!";
            heal_message_timer = 120;
        }
    }
}


// =========================================================
// 5. SEARCH STATE & GLITCH INTERCEPT
// =========================================================
if (browser_state == "searching") {
    search_timer--;
    if (search_timer <= 0) {
        browser_state = "match_found";
        match_display_timer = 180; // Show "Match Found" for 3 seconds
    }
}
else if (browser_state == "match_found") {
    match_display_timer--;
    if (match_display_timer <= 0) {
        
        // Retrieve the flag we set in the button click
        var _is_casual = (variable_instance_exists(id, "is_casual_search") && is_casual_search);
        var _battle_data = {};
        
        if (_is_casual) {
             // ====================================================
             // [DEMO SCRIPT] GLITCH INTERCEPT
             // ====================================================
             var _trigger_glitch = false;
             if (variable_global_exists("demo_browser_open_count") && global.demo_browser_open_count >= 2) _trigger_glitch = true;
             if (global.weather_condition == "STORM") _trigger_glitch = true;

             if (_trigger_glitch) {
                 // --- FORCE GLITCHED BATTLE ---
                 var _glitch_opp = {
                    name: "0xUNKNOWN",
                    profile_pic_sprite: spr_snub_nosed_monkey_idle, 
                    critter_keys: ["snub_nosed_monkey"],
                    critter_levels: [99], 
                    lose_message: "...",
                    is_glitched: true 
                };
                global.demo_is_gold_monkey = true;
                
                // Force this specific opponent data
                _battle_data = { is_casual: true, opponent_data: _glitch_opp, level_cap: 100 };
             } 
             else {
                 // --- STANDARD RANDOM BATTLE ---
                 var _cup = global.CupDatabase[global.PlayerData.current_cup_index];
                 _battle_data = { is_casual: true, opponent_data: noone, level_cap: _cup.level_cap };
             }
             
             is_casual_search = false; // Reset flag
             
        } else {
             // --- RANKED MATCH ---
             var _opp_data = current_cup.opponents[global.PlayerData.current_opponent_index];
             _battle_data = { is_casual: false, opponent_data: _opp_data, level_cap: current_level_cap };
        }
        
        // LAUNCH BATTLE
        var _new_battle = instance_create_layer(0, 0, "Instances", obj_battle_manager, _battle_data);
        global.top_window_depth--;
        _new_battle.depth = global.top_window_depth;
        
        browser_state = "browsing"; 
    }
}

// Recalculate UI positions (Sticky UI)
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

btn_casual_x1 = sidebar_x1 + 10;
btn_casual_y1 = btn_ranked_y2 + _spacing;
btn_casual_x2 = sidebar_x2 - 10;
btn_casual_y2 = btn_casual_y1 + _btn_h;

btn_heal_x1 = sidebar_x1 + 10;
btn_heal_y1 = btn_casual_y2 + _spacing;
btn_heal_x2 = sidebar_x2 - 10;
btn_heal_y2 = btn_heal_y1 + _btn_h;