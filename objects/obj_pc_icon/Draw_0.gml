// --- Draw Event ---
if (!visible) exit;

var _box_size = 64;

// 1. Calculate Scale & Position
var _scale = min(_box_size / sprite_width, _box_size / sprite_height);
var _sprite_w = sprite_width * _scale;
var _sprite_h = sprite_height * _scale;

var _visual_x = x + (_box_size - _sprite_w) / 2;
var _visual_y = y + (_box_size - _sprite_h) / 2;

var _draw_x = _visual_x + (sprite_get_xoffset(sprite_index) * _scale);
var _draw_y = _visual_y + (sprite_get_yoffset(sprite_index) * _scale);

// 2. Draw Icon (With Hover Tint)
var _icon_blend = c_white;
if (hovering) {
    // Subtle blue-ish tint when hovering
    _icon_blend = make_color_rgb(200, 220, 255); 
}

draw_sprite_ext(sprite_index, 0, _draw_x, _draw_y, _scale, _scale, 0, _icon_blend, 1);

// 3. Draw Text (With Hover Color)
draw_set_font(fnt_vga); 
draw_set_halign(fa_center);
draw_set_valign(fa_top);

if (hovering) {
    // Bright Sky Blue for hover (Regular c_blue is too dark on Teal)
    draw_set_color(make_color_rgb(80, 200, 255));
} else {
    draw_set_color(c_white);
}

var _text_y = _visual_y + _sprite_h + 2; 
draw_text(x + (_box_size / 2), _text_y, label_text);

// Reset
draw_set_halign(fa_left);
draw_set_color(c_white);