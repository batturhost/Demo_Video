// --- Draw GUI Event ---
draw_set_font(fnt_vga);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// [FIX] 1. Manual Window Draw (Replaces event_inherited for custom look)
// Draw Main Frame
draw_rectangle_95(window_x1, window_y1, window_x2, window_y2, "raised");

// Draw Taller Title Bar (Navy)
draw_set_color(c_navy);
// Padding of 3px for the border, height defined in Create (42px)
draw_rectangle(window_x1 + 3, window_y1 + 3, window_x2 - 3, window_y1 + title_bar_height, false);

// Draw Title Text (Vertically Centered)
draw_set_color(c_white);
draw_set_font(fnt_vga_bold);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);
// +10 padding for text
draw_text(window_x1 + 10, window_y1 + (title_bar_height / 2) + 2, window_title);

// Draw Close Button (Manual placement to match logic)
draw_set_valign(fa_top);
var _close_state = btn_close_hover ? "sunken" : "raised";
draw_rectangle_95(btn_close_x1, btn_close_y1, btn_close_x2, btn_close_y2, _close_state);
draw_set_color(c_black);
draw_set_halign(fa_center); 
draw_set_valign(fa_middle);
draw_text(btn_close_x1 + ((btn_close_x2 - btn_close_x1) / 2), btn_close_y1 + ((btn_close_y2 - btn_close_y1) / 2), "X");
draw_set_halign(fa_left);
draw_set_valign(fa_top);


// [FIX] 2. Web Header (Stretched)
// Drawn immediately below title bar
var _banner_y = window_y1 + title_bar_height;
var _banner_color = make_color_rgb(0, 51, 153); 

draw_set_color(_banner_color);
// Fill from left edge (+4) to right edge (-4)
draw_rectangle(window_x1 + 4, _banner_y, window_x2 - 4, content_y1, false);

draw_set_color(c_white);
draw_set_font(fnt_vga_bold);
draw_text_transformed(window_x1 + 20, _banner_y + 15, "CRITTERNET MARKETPLACE", 1.5, 1.5, 0);
draw_set_font(fnt_vga);
draw_text(window_x1 + 25, _banner_y + 45, "The #1 Source for Digital Supplies.");

// Wallet
draw_set_halign(fa_right);
draw_text(window_x2 - 20, _banner_y + 25, "Wallet: $" + string(global.PlayerData.coins));
draw_set_halign(fa_left);


// 3. Page Content Background (White)
// Fills the rest of the space down to the footer
draw_set_color(c_white);
draw_rectangle(content_x1, content_y1, content_x2, content_y2, false);
// Optional: Inner border for the web view
draw_border_95(content_x1, content_y1, content_x2, content_y2, "sunken");


// --- START SCROLLING CONTENT ---
gpu_set_scissor(content_x1 + 2, content_y1 + 2, content_w - 4, content_h - 4);

for (var i = 0; i < array_length(catalog); i++) {
    var _item = catalog[i];
    var _cy = content_y1 + 2 + (i * (card_height + card_spacing)) - scroll_y;
    
    if (_cy + card_height < content_y1) continue;
    if (_cy > content_y2) break;
    
    // Card Background
    var _card_x1 = content_x1 + 10;
    var _card_x2 = content_x2 - 10;
    var _card_y2 = _cy + card_height;
    
    draw_set_color(make_color_rgb(245, 245, 245));
    draw_rectangle(_card_x1, _cy, _card_x2, _card_y2, false);
    draw_set_color(c_ltgray);
    draw_rectangle(_card_x1, _cy, _card_x2, _card_y2, true);
    
    // Icon Placeholder
    var _icon_size = 48;
    var _icon_x = _card_x1 + 10;
    var _icon_y = _cy + (card_height/2) - (_icon_size/2);
    
    draw_set_color(c_white);
    draw_rectangle(_icon_x, _icon_y, _icon_x + _icon_size, _icon_y + _icon_size, false);
    draw_set_color(c_black);
    draw_rectangle(_icon_x, _icon_y, _icon_x + _icon_size, _icon_y + _icon_size, true);
    
    // [FIX] Draw the Item Sprite
    if (variable_struct_exists(_item, "sprite") && sprite_exists(_item.sprite)) {
        var _spr = _item.sprite;
        
        // Calculate Scale to fit inside the 48x48 box (with 4px padding)
        var _max_size = _icon_size - 8; 
        var _scale = min(_max_size / sprite_get_width(_spr), _max_size / sprite_get_height(_spr));
        
        // Center the sprite
        var _draw_x = _icon_x + (_icon_size / 2);
        var _draw_y = _icon_y + (_icon_size / 2);
        
        // Draw (assumes Middle Center origin, but works with Top Left too via offsets if needed)
        // To be safe, we calculate offsets manually if your origins are 0,0
        var _x_off = sprite_get_xoffset(_spr);
        var _y_off = sprite_get_yoffset(_spr);
        var _w = sprite_get_width(_spr);
        var _h = sprite_get_height(_spr);
        
        // Re-center logic for ANY origin:
        var _final_x = _draw_x - ((_w/2) - _x_off) * _scale;
        var _final_y = _draw_y - ((_h/2) - _y_off) * _scale;

        draw_sprite_ext(_spr, 0, _final_x, _final_y, _scale, _scale, 0, c_white, 1);
    }
    
    // Text Info
    var _text_x = _icon_x + _icon_size + 15;
    
    draw_set_color(c_navy);
    draw_set_font(fnt_vga_bold);
    draw_text(_text_x, _cy + 8, _item.name);
    
    draw_set_color(c_black);
    draw_set_font(fnt_vga);
    draw_text(_text_x, _cy + 28, _item.description);
    
    var _count = variable_struct_exists(inventory_counts, _item.name) ? inventory_counts[$ _item.name] : 0;
    draw_set_color(c_dkgray);
    draw_text(_text_x, _cy + 45, "Owned: " + string(_count));
    
    // Buy Button
    var _btn_x2 = _card_x2 - 10;
    var _btn_x1 = _btn_x2 - btn_buy_w;
    var _btn_y1 = _cy + (card_height/2) - (btn_buy_h/2);
    var _btn_y2 = _btn_y1 + btn_buy_h;
    
    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);
    var _hover = point_in_rectangle(_mx, _my, _btn_x1, _btn_y1, _btn_x2, _btn_y2);
    var _state = (mouse_check_button(mb_left) && _hover) ? "sunken" : "raised";
    
    if (global.PlayerData.coins < _item.price) {
        draw_set_color(c_gray);
        draw_rectangle(_btn_x1, _btn_y1, _btn_x2, _btn_y2, false);
        _state = "raised";
    } else {
        draw_rectangle_95(_btn_x1, _btn_y1, _btn_x2, _btn_y2, _state);
    }
    
    draw_set_color(c_black);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(_btn_x1 + (btn_buy_w/2), _btn_y1 + (btn_buy_h/2), "BUY");
    
    // Price
    draw_set_halign(fa_right);
    draw_set_color(make_color_rgb(0, 100, 0));
    draw_set_font(fnt_vga_bold);
    draw_text(_btn_x1 - 15, _btn_y1 + (btn_buy_h/2), "$" + string(_item.price));
    draw_set_font(fnt_vga);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

gpu_set_scissor(0, 0, display_get_gui_width(), display_get_gui_height());
// --- END SCROLLING CONTENT ---


// 4. Footer (Status Bar)
// Draws from left edge to right edge, filling the bottom space
draw_set_color(c_ltgray);
draw_rectangle(window_x1 + 4, content_y2, window_x2 - 4, window_y2 - 4, false);
draw_border_95(window_x1 + 4, content_y2, window_x2 - 4, window_y2 - 4, "raised");

draw_set_color(c_black);
draw_set_valign(fa_middle);
if (feedback_timer > 0) {
    draw_set_color(c_blue);
    draw_text(window_x1 + 14, content_y2 + (footer_height/2), feedback_msg);
} else {
    draw_text(window_x1 + 14, content_y2 + (footer_height/2), "Secure Connection Established.");
}

// Reset
draw_set_valign(fa_top);
draw_set_color(c_white);