// --- Create Event ---

// ==========================================================================================
// FORCE DEBUG DATA: LEVEL 23 JIMMY + UNIQUE PC BOX
// (We removed the 'if' check so this runs EVERY time, overwriting old saves)
// ==========================================================================================

if (!variable_global_exists("bestiary")) init_database();
if (!variable_global_exists("CupDatabase")) init_cup_database();

global.PlayerData = {
    name: "DEBUG_USER", gender: 0,
    profile_pic: spr_1, 
    current_cup_index: 0, current_opponent_index: 0,
    team: [], pc_box: [], collection_progress: {},
    starter_key: "arctic_fox", starter_name: "Arctic Fox", 
    starter_nickname: "Jimmy", // <--- The specific name you wanted
    coins: 1800, 
    inventory: []
};

// --- 1. CREATE STARTER (Jimmy, Lv 23) ---
var _starter_data = global.bestiary.arctic_fox;
var _starter_critter = new AnimalData(
    _starter_data.animal_name,
    _starter_data.base_hp, _starter_data.base_atk,
    _starter_data.base_def, _starter_data.base_spd,
    23, // <--- Level 23
    _starter_data.sprite_idle, _starter_data.sprite_idle_back,
    _starter_data.sprite_signature_move, _starter_data.moves,
    _starter_data.blurb, _starter_data.size, _starter_data.element_type
);
_starter_critter.nickname = "Jimmy"; 
recalculate_stats(_starter_critter);
array_push(global.PlayerData.team, _starter_critter);

// --- 2. CREATE PC BOX (Unique & Similar Levels) ---
var _all_keys = variable_struct_get_names(global.bestiary);

// Remove 'arctic_fox' from the pool so we don't get a duplicate of Jimmy
var _f_idx = -1;
for (var k=0; k<array_length(_all_keys); k++) {
    if (_all_keys[k] == "arctic_fox") { _f_idx = k; break; }
}
if (_f_idx != -1) array_delete(_all_keys, _f_idx, 1);

// Generate 5 unique critters
for (var i = 0; i < 5; i++) {
    if (array_length(_all_keys) == 0) break; 

    // Pick random key and REMOVE it to ensure uniqueness
    var _rand_index = irandom(array_length(_all_keys) - 1);
    var _key = _all_keys[_rand_index];
    array_delete(_all_keys, _rand_index, 1); 

    var _db = global.bestiary[$ _key];
    
    // Levels 21-25 to match Jimmy
    var _lvl = irandom_range(21, 25); 
    
    var _c = new AnimalData(
        _db.animal_name, _db.base_hp, _db.base_atk, _db.base_def, _db.base_spd, 
        _lvl, 
        _db.sprite_idle, _db.sprite_idle_back, _db.sprite_signature_move, 
        _db.moves, _db.blurb, _db.size, _db.element_type
    );
    _c.nickname = _db.animal_name; 
    _c.gender = irandom(1);
    recalculate_stats(_c);
    array_push(global.PlayerData.pc_box, _c);
}

global.tutorial_complete = true;

// ==========================================================================================
// STANDARD HUB SETUP (Clock, Menu, Icons)
// ==========================================================================================

// 1. Clock Setup
time_string = "";
alarm[0] = 60;

// 2. Start Menu & Taskbar Vars
start_menu_open = false;
start_hover_index = -1;

menu_w = 280;
menu_h = 330;
menu_item_h = 35;

menu_items = [
    ["CritterNet Browser", "browser"],
    ["Bestiary", "pokedex"],
    ["Storage System", "pc"],
    ["Messenger", "messenger"],
    ["C-Store", "store"], 
    ["Save Game", "save"],
    ["Shut Down...", "shutdown"]
];

// Taskbar Apps List
applications_list = [
    [obj_browser_manager, "Browser"],
    [obj_pokedex_manager, "Bestiary"],
    [obj_pc_manager, "Storage"],
    [obj_messenger_manager, "Messenger"],
    [obj_store_manager, "C-Store"], 
    [obj_battle_manager, "Battle"]
];

global.top_window_depth = -100;

// 3. Icon Auto-Alignment System
var _icon_x = 32;
var _start_y = 32;
var _spacing_y = 96; 

if (instance_exists(obj_icon_browser)) { obj_icon_browser.x = _icon_x; obj_icon_browser.y = _start_y + (0 * _spacing_y); }
if (instance_exists(obj_icon_bestiary)) { obj_icon_bestiary.x = _icon_x; obj_icon_bestiary.y = _start_y + (1 * _spacing_y); }
if (instance_exists(obj_pc_icon)) { obj_pc_icon.x = _icon_x; obj_pc_icon.y = _start_y + (2 * _spacing_y); }
if (instance_exists(obj_messenger_icon)) { obj_messenger_icon.x = _icon_x; obj_messenger_icon.y = _start_y + (3 * _spacing_y); }

// Slot 5: C-Store
if (!instance_exists(obj_store_icon)) instance_create_layer(0, 0, "Instances", obj_store_icon);
if (instance_exists(obj_store_icon)) { obj_store_icon.x = _icon_x; obj_store_icon.y = _start_y + (4 * _spacing_y); }

// 4. Demo Vars
global.demo_browser_open_count = 0;

// Clean up Debug Flag
if (variable_global_exists("open_debug_battle") && global.open_debug_battle) {
    global.open_debug_battle = false;
    if (!instance_exists(obj_debug_battle_setup)) instance_create_layer(0, 0, "Instances", obj_debug_battle_setup);
}