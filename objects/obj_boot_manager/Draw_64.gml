// --- Draw GUI Event ---
draw_set_font(fnt_vga);
draw_set_halign(fa_left);
draw_set_color(c_white); 

// Draw lines typed so far
for (var i = 0; i < current_line; i++) {
    draw_text(20, 20 + (i * 20), text_lines[i]);
}

// Only draw controls if finished
if (current_line >= array_length(text_lines)) {
    
    // --- Draw Auto-Start Countdown (Optional visual feedback) ---
    // draw_text(20, btn_reboot_y2 + 10, "Starting in " + string(ceil(auto_start_timer/60)) + "...");

    // --- Draw Reboot Button ---
    var _state = btn_reboot_hover ? "sunken" : "raised";
    draw_rectangle_95(btn_reboot_x1, btn_reboot_y1, btn_reboot_x2, btn_reboot_y2, _state);
    
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_black);
    
    var _cx = btn_reboot_x1 + (btn_reboot_w / 2);
    var _cy = btn_reboot_y1 + (btn_reboot_h / 2);
    if (btn_reboot_hover && mouse_check_button(mb_left)) { _cx++; _cy++; } // Press effect
    
    draw_text(_cx, _cy, "Reboot System");
    
    // Reset draw settings
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
}