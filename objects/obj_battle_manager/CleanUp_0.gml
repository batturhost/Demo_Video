// --- Clean Up Event ---

// 1. Reset Stat Stages
if (variable_global_exists("PlayerData") && variable_struct_exists(global.PlayerData, "team")) {
    for (var i = 0; i < array_length(global.PlayerData.team); i++) {
        var _critter = global.PlayerData.team[i];
        _critter.atk_stage = 0;
        _critter.def_stage = 0;
        _critter.spd_stage = 0;
        _critter.glitch_timer = 0;
    }
}

// 2. Ensure Actors are destroyed
if (variable_instance_exists(id, "player_actor") && instance_exists(player_actor)) {
    instance_destroy(player_actor);
}
if (variable_instance_exists(id, "enemy_actor") && instance_exists(enemy_actor)) {
    instance_destroy(enemy_actor);
}

// --- NEW: TRIGGER SEQUENCE ON EXIT ---
// Check if we were fighting the Glitch Monkey
if (variable_instance_exists(id, "current_opponent_data")) {
    if (current_opponent_data.name == "0xUNKNOWN") {
        // Set Stage 1: Wait 2 seconds, then open download
        global.glitch_event_stage = 1;
        global.glitch_timer = 120;
    }
}