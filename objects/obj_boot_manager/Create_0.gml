// --- Create Event ---

// =================================================================
// DEV TOGGLE: SAVE SYSTEM
global.ENABLE_SAVE_SYSTEM = true; 
// =================================================================

init_database(); 
init_cup_database(); 
randomize();

// --- GLOBAL VARS ---
global.bargain_offered = false; 
global.unread_messages = []; 
global.trapdoor_unlocked = false;
global.dragged_window = noone; 

draw_set_font(fnt_vga);
current_line = 0; 
text_speed = 45; 

text_lines = [
    "CritterNet OS v1.0 (c) 1998, CNet Inc.",
    "System Memory Check: 128 MB OK",
    "Initializing Hardware I/O...",
    "Loading 'CNet_Kernel.dll'...",
    "Loading 'VMM.vxd'...",
    "Connecting to ARPANET backbone...",
    "Initializing virtual modem...",
    "** MODEM HANDSHKE SOUND PLAYS HERE **",
    "Connection Established. Welcome to the Net.",
    "Ready."
];

alarm[0] = text_speed; 

// --- NEW BUTTON: REBOOT ---
// Positioned near the bottom
btn_reboot_w = 160;
btn_reboot_h = 30;
btn_reboot_x1 = 20;
btn_reboot_y1 = 20 + (array_length(text_lines) * 20) + 40; // Below text
btn_reboot_x2 = btn_reboot_x1 + btn_reboot_w;
btn_reboot_y2 = btn_reboot_y1 + btn_reboot_h;
btn_reboot_hover = false;

// --- AUTO-START TIMER ---
// How long to wait on "Ready." before going to Login
// 180 frames = 3 seconds
auto_start_delay_max = 180;
auto_start_timer = auto_start_delay_max;

// [NEW] Spawn the Custom Mouse
if (!instance_exists(obj_cursor_manager)) {
    instance_create_depth(0, 0, -16000, obj_cursor_manager);
}