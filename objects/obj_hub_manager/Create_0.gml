// --- Create Event ---

// 1. Check if the "save file" exists.
if (!variable_global_exists("PlayerData")) {
    // DEBUG MODE SETUP
    if (!variable_global_exists("bestiary")) init_database();
    if (!variable_global_exists("CupDatabase")) init_cup_database();
    global.PlayerData = {
        name: "DEBUG_USER", gender: 0,
        profile_pic: spr_1, 
        current_cup_index: 0, current_opponent_index: 0,
        team: [], pc_box: [], collection_progress: {},
        starter_key: "arctic_fox", starter_name: "Arctic Fox", starter_nickname: "Debug Fox",
        coins: 10000, // Give debug money
        inventory: [] // <--- NEW: Item Inventory
    };
    var _starter_critter = new AnimalData(
        global.bestiary.arctic_fox.animal_name,
        global.bestiary.arctic_fox.base_hp, global.bestiary.arctic_fox.base_atk,
        global.bestiary.arctic_fox.base_def, global.bestiary.arctic_fox.base_spd,
        100, 
        global.bestiary.arctic_fox.sprite_idle, global.bestiary.arctic_fox.sprite_idle_back,
        global.bestiary.arctic_fox.sprite_signature_move, global.bestiary.arctic_fox.moves,
        global.bestiary.arctic_fox.blurb, global.bestiary.arctic_fox.size
    );
    _starter_critter.nickname = "Debug Fox";
    recalculate_stats(_starter_critter);
    array_push(global.PlayerData.team, _starter_critter);
    
    // Add test PC critters
    var _all_keys = variable_struct_get_names(global.bestiary);
    for (var i = 0; i < 5; i++) {
        var _key = _all_keys[irandom(array_length(_all_keys)-1)];
        var _db = global.bestiary[$ _key];
        var _c = new AnimalData(_db.animal_name, _db.base_hp, _db.base_atk, _db.base_def, _db.base_spd, irandom_range(3,7), _db.sprite_idle, _db.sprite_idle_back, _db.sprite_signature_move, _db.moves, _db.blurb, _db.size);
        _c.nickname = _db.animal_name; _c.gender = irandom(1);
        recalculate_stats(_c);
        array_push(global.PlayerData.pc_box, _c);
    }
    
    global.tutorial_complete = true;
}

// Ensure coins/inventory exist if loading an old save
if (!variable_struct_exists(global.PlayerData, "coins")) global.PlayerData.coins = 0;
if (!variable_struct_exists(global.PlayerData, "inventory")) global.PlayerData.inventory = [];

if (!variable_global_exists("tutorial_complete")) global.tutorial_complete = false;

// 2. Clock Setup
time_string = "";
alarm[0] = 60;

// ================== START MENU & TASKBAR VARS ==================
start_menu_open = false;
start_hover_index = -1;

menu_w = 280;
menu_h = 330; // Increased height for new item
menu_item_h = 35;

menu_items = [
    ["CritterNet Browser", "browser"],
    ["Bestiary", "pokedex"],
    ["Storage System", "pc"],
    ["Messenger", "messenger"],
    ["C-Store", "store"], // <--- NEW START MENU ITEM
    ["Save Game", "save"],
    ["Shut Down...", "shutdown"]
];

// Taskbar Apps List
// [FIX] Removed obj_trapdoor_manager reference since you deleted it
applications_list = [
    [obj_browser_manager, "Browser"],
    [obj_pokedex_manager, "Bestiary"],
    [obj_pc_manager, "Storage"],
    [obj_messenger_manager, "Messenger"],
    [obj_store_manager, "C-Store"], 
    [obj_battle_manager, "Battle"]
];

global.top_window_depth = -100;

// ================== AUTO-SPAWN STORE ICON ==================
// If the icon isn't in the room (from the editor), spawn it automatically
if (!instance_exists(obj_store_icon)) {
    // [FIX] Changed Y from 512 to 416 to fill the empty space
    instance_create_layer(32, 416, "Instances", obj_store_icon);
}

if (variable_global_exists("open_debug_battle") && global.open_debug_battle) {
    global.open_debug_battle = false;
    if (!instance_exists(obj_debug_battle_setup)) {
        instance_create_layer(0, 0, "Instances", obj_debug_battle_setup);
    }
}

// [DEMO SCRIPT] Initialize the browser open counter
global.demo_browser_open_count = 0;

// ... (Keep the applications_list and top_window_depth code above this) ...

// ================== ICON AUTO-ALIGNMENT SYSTEM ==================
// This forces all desktop icons to snap to a consistent grid (X=32, Y+=96)
var _icon_x = 32;
var _start_y = 32;
var _spacing_y = 96; // Exact distance between each icon slot

// Slot 1: Browser
if (instance_exists(obj_icon_browser)) {
    obj_icon_browser.x = _icon_x;
    obj_icon_browser.y = _start_y + (0 * _spacing_y); // Y = 32
}

// Slot 2: Bestiary
if (instance_exists(obj_icon_bestiary)) {
    obj_icon_bestiary.x = _icon_x;
    obj_icon_bestiary.y = _start_y + (1 * _spacing_y); // Y = 128
}

// Slot 3: PC Storage
if (instance_exists(obj_pc_icon)) {
    obj_pc_icon.x = _icon_x;
    obj_pc_icon.y = _start_y + (2 * _spacing_y); // Y = 224
}

// Slot 4: Messenger
if (instance_exists(obj_messenger_icon)) {
    obj_messenger_icon.x = _icon_x;
    obj_messenger_icon.y = _start_y + (3 * _spacing_y); // Y = 320
}

// Slot 5: C-Store (Spawn if missing, then Align)
if (!instance_exists(obj_store_icon)) {
    instance_create_layer(0, 0, "Instances", obj_store_icon);
}
// Now align it to Slot 5
if (instance_exists(obj_store_icon)) {
    obj_store_icon.x = _icon_x;
    obj_store_icon.y = _start_y + (4 * _spacing_y); // Y = 416
}


// ================== DEBUGGING TOOLS ==================
if (variable_global_exists("open_debug_battle") && global.open_debug_battle) {
    global.open_debug_battle = false;
    if (!instance_exists(obj_debug_battle_setup)) {
        instance_create_layer(0, 0, "Instances", obj_debug_battle_setup);
    }
}

// [DEMO SCRIPT] One-time override
if (variable_global_exists("PlayerData")) {
    // Only set this if we haven't set it for the demo yet
    if (!variable_instance_exists(id, "demo_coins_set")) {
        global.PlayerData.coins = 1800;
        global.PlayerData.name = "Administrator";
        demo_coins_set = true;
    }
}