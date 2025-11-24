// --- Create Event ---

// 1. Persistence & Depth
persistent = true; 
window_set_cursor(cr_none);
depth = -16000;

// 2. Visual Settings
sprite_index = spr_ui_cursor;
image_speed = 0; 
mask_index = -1; 

// [FIX] Manual Scale for 60x105 Sprite
// 0.25 (1/4th size) reduces it to ~15x26 pixels.
// This matches the standard Windows 98 cursor size.
cursor_scale = 1.0;