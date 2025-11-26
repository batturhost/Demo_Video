// --- Draw Event ---

// 1. Draw Infinite Black Void (Covers the room background)
draw_set_color(c_black);
draw_rectangle(0, 0, room_width, room_height, false);
draw_set_color(c_white);

// 2. Draw the Seagull Sprite (Centered)
if (sprite_exists(sprite_index)) {
    var _cx = room_width / 2;
    var _cy = room_height / 2;
    
    // Scale it up slightly for effect
    draw_sprite_ext(sprite_index, image_index, _cx, _cy, 2, 2, 0, c_white, 1);
}