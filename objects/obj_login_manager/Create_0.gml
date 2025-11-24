// --- Create Event ---

// 1. Window Setup
window_width = 550;  
window_height = 320; 
window_title = "CritterNet Logon";

// Center Position
window_x1 = (display_get_gui_width() / 2) - (window_width / 2);
window_y1 = (display_get_gui_height() / 2) - (window_height / 2);
window_x2 = window_x1 + window_width;
window_y2 = window_y1 + window_height;

// 2. Data
username = "Administrator"; 
password_input = "";
max_pass_length = 14;
cursor_blink = 0;

// Scripted Failure Vars
login_attempts = 0; 
show_error_popup = false; 

// 3. Layout
var _padding_outer = 25;
var _col_gap = 30;

// Logo Area
logo_area_w = 160; 
logo_area_x = window_x1 + _padding_outer;
logo_area_center_x = logo_area_x + (logo_area_w / 2);

// Content Area
content_x = logo_area_x + logo_area_w + _col_gap;
content_w = (window_x2 - _padding_outer) - content_x;

content_start_y = window_y1 + 60; 
label_gap = 8;    
field_gap = 30;   

user_label_y = content_start_y;
user_box_y = user_label_y + 25; 
user_box_h = 50; 

pass_label_y = user_box_y + user_box_h + field_gap;
pass_box_y = pass_label_y + 25;
pass_box_h = 28; 

// Buttons
btn_w = 100; 
btn_h = 32;
var _btn_margin_bottom = 30;

btn_ok_y1 = window_y2 - _btn_margin_bottom - btn_h;
btn_ok_y2 = btn_ok_y1 + btn_h;
btn_cancel_y1 = btn_ok_y1;
btn_cancel_y2 = btn_ok_y2;

btn_cancel_x2 = window_x2 - _padding_outer; 
btn_cancel_x1 = btn_cancel_x2 - btn_w;

btn_ok_x2 = btn_cancel_x1 - 15; 
btn_ok_x1 = btn_ok_x2 - btn_w;

// Error Popup Layout
err_w = 300;
err_h = 120;
err_x1 = window_x1 + (window_width - err_w) / 2;
err_y1 = window_y1 + (window_height - err_h) / 2;
err_x2 = err_x1 + err_w;
err_y2 = err_y1 + err_h;

err_btn_w = 80;
err_btn_h = 25;
err_btn_x1 = err_x1 + (err_w / 2) - (err_btn_w / 2);
err_btn_y1 = err_y2 - 35;
err_btn_x2 = err_btn_x1 + err_btn_w;
err_btn_y2 = err_btn_y1 + err_btn_h;