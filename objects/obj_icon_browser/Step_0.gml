// --- Step Event ---

var _center_x = x + 32;
var _center_y = y + 32;
var _radius = 45; 

hovering = point_in_rectangle(mouse_x, mouse_y, _center_x - _radius, _center_y - _radius, _center_x + _radius, _center_y + _radius);

if (hovering && mouse_check_button_pressed(mb_left)) {
    var _blocked = false;
    var _gui_mx = device_mouse_x_to_gui(0);
    var _gui_my = device_mouse_y_to_gui(0);

    if (instance_exists(obj_battle_manager)) {
        _blocked = true;
    } else {
        with (obj_window_parent) {
            if (visible && point_in_rectangle(_gui_mx, _gui_my, window_x1, window_y1, window_x2, window_y2)) {
                _blocked = true;
                break; 
            }
        }
    }
    
    if (!_blocked) {
        play_ui_click(); 
        
        if (!instance_exists(obj_browser_manager)) {
            // 1. Create the Window and capture its ID
            var _new_browser = instance_create_layer(0, 0, "Instances", obj_browser_manager);
            
            // 2. INJECT DEMO DATA (Override the defaults)
            // Initialize counter if it doesn't exist
            if (!variable_global_exists("demo_browser_count")) global.demo_browser_count = 0;
            global.demo_browser_count++;
            
            // Apply settings to the specific window we just made
            with (_new_browser) {
                if (global.demo_browser_count == 1) {
                    // --- 1st Open: PERFECT WEATHER ---
                    weather_desc = "Sunny";
                    weather_icon_idx = 0; // Sun Icon
                    weather_temp = 24;
                    weather_string = "24";
                    global.weather_condition = "SUN";
                    
                    current_news = "Market prices stable. No anomalies detected.";
                    current_deal = "Upgrade your RAM to 64MB today!";
                    current_fact = "Sea otters hold hands while sleeping.";
                } 
                else {
                    // --- 2nd Open+: GLITCH STORM ---
                    weather_desc = "DATA STORM";
                    weather_icon_idx = 3; // Lightning Icon
                    weather_temp = 99;
                    weather_string = "#ERR";
                    global.weather_condition = "STORM";
                    
                    current_news = "CRITICAL WARNING: Connection unstable.";
                    current_deal = "FATAL EXCEPTION 0E at 0028:C0011E36";
                    current_fact = "Error loading fact.dat: File Corrupted.";
                }
            }
        }
    }
}