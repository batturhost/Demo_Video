// --- Draw GUI Event ---

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

if (sprite_exists(sprite_index)) {
    // Draw at mouse position with the calculated scale
    draw_sprite_ext(sprite_index, image_index, _mx, _my, cursor_scale, cursor_scale, 0, c_white, 1);
}