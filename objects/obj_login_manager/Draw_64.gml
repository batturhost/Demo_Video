// --- Draw GUI Event ---
draw_set_font(fnt_vga);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
var _mouse_held = mouse_check_button(mb_left);

// 1. Background
draw_set_color(c_teal);
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
draw_scanlines_95(0, 0, display_get_gui_width(), display_get_gui_height());

// 2. Window Frame
draw_rectangle_95(window_x1, window_y1, window_x2, window_y2, "raised");

// Title Bar
draw_set_color(c_navy);
draw_rectangle(window_x1 + 3, window_y1 + 3, window_x2 - 3, window_y1 + 28, false);

draw_set_color(c_white);
draw_set_font(fnt_vga_bold);
draw_set_valign(fa_middle);
draw_text(window_x1 + 10, window_y1 + 16, window_title);
draw_set_valign(fa_top);
draw_set_font(fnt_vga);

// 3. Logo
if (sprite_exists(spr_logo)) {
    var _s_scale = 0.4; 
    var _window_content_h = window_height - 40; 
    var _window_center_y = window_y1 + 30 + (_window_content_h / 2);
    var _draw_y = _window_center_y - 20;
    draw_sprite_ext(spr_logo, 0, logo_area_center_x, _draw_y, _s_scale, _s_scale, 0, c_white, 1);
}

// 4. Content
draw_set_color(c_black);
draw_text(content_x, user_label_y, "Select user name:");
draw_rectangle_95(content_x, user_box_y, content_x + content_w, user_box_y + user_box_h, "sunken");

var _select_margin = 2;
var _select_h = 22;
draw_set_color(c_navy);
draw_rectangle(content_x + _select_margin, user_box_y + _select_margin, content_x + content_w - _select_margin, user_box_y + _select_margin + _select_h, false);

draw_set_color(c_white); 
draw_text(content_x + 8, user_box_y + 6, username);

draw_set_color(c_black);
draw_text(content_x, pass_label_y, "Password:");
draw_rectangle_95(content_x, pass_box_y, content_x + content_w, pass_box_y + pass_box_h, "sunken");

var _masked = "";
repeat(string_length(password_input)) _masked += "*";
var _cursor = (cursor_blink < 30) ? "|" : "";
draw_text(content_x + 5, pass_box_y + 6, _masked + _cursor);

// 5. Buttons (Visual Logic Fixed)
// OK Button
var _ok_hover = point_in_rectangle(_mx, _my, btn_ok_x1, btn_ok_y1, btn_ok_x2, btn_ok_y2);
var _ok_state = (_ok_hover && _mouse_held) ? "sunken" : "raised";
draw_rectangle_95(btn_ok_x1, btn_ok_y1, btn_ok_x2, btn_ok_y2, _ok_state);

draw_set_color(c_black);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(btn_ok_x1 + (btn_w/2), btn_ok_y1 + (btn_h/2), "OK");

// Cancel Button
var _cancel_hover = point_in_rectangle(_mx, _my, btn_cancel_x1, btn_cancel_y1, btn_cancel_x2, btn_cancel_y2);
var _cancel_state = (_cancel_hover && _mouse_held) ? "sunken" : "raised";
draw_rectangle_95(btn_cancel_x1, btn_cancel_y1, btn_cancel_x2, btn_cancel_y2, _cancel_state);

draw_text(btn_cancel_x1 + (btn_w/2), btn_cancel_y1 + (btn_h/2), "Cancel");

// 6. Bottom Right Text
draw_set_font(fnt_vga_bold);
draw_set_halign(fa_right);
draw_set_valign(fa_bottom);
draw_set_color(c_white);
var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();
draw_text(_gui_w - 10, _gui_h - 25, "CritterNet");
draw_text(_gui_w - 10, _gui_h - 5, "Professional");


// 7. ERROR POPUP
if (show_error_popup) {
    // Dim Background
    draw_set_alpha(0.3);
    draw_set_color(c_black);
    draw_rectangle(0, 0, _gui_w, _gui_h, false);
    draw_set_alpha(1.0);

    // Popup Frame
    draw_rectangle_95(err_x1, err_y1, err_x2, err_y2, "raised");
    
    // Popup Title
    draw_set_color(c_navy);
    draw_rectangle(err_x1 + 3, err_y1 + 3, err_x2 - 3, err_y1 + 24, false);
    
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    draw_set_font(fnt_vga_bold);
    draw_text(err_x1 + 6, err_y1 + 14, "Logon Message");
    
    // Popup Text
    draw_set_font(fnt_vga);
    draw_set_color(c_black);
    draw_set_halign(fa_center);
    draw_text(err_x1 + (err_w/2), err_y1 + 45, "The password is incorrect.");
    draw_text(err_x1 + (err_w/2), err_y1 + 60, "Please retype the password.");
    
    // Popup OK Button
    var _err_hover = point_in_rectangle(_mx, _my, err_btn_x1, err_btn_y1, err_btn_x2, err_btn_y2);
    var _err_state = (_err_hover && _mouse_held) ? "sunken" : "raised";
    
    draw_rectangle_95(err_btn_x1, err_btn_y1, err_btn_x2, err_btn_y2, _err_state);
    draw_set_color(c_black);
    draw_text(err_btn_x1 + (err_btn_w/2), err_btn_y1 + (err_btn_h/2), "OK");
}

// Reset
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_font(fnt_vga);