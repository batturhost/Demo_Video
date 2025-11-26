// --- Step Event ---

// 1. DELETION LOGIC
delete_timer--;

if (delete_timer <= 0) {
    var _targets = [];
    
    // Gather all desktop icons currently existing
    with (obj_icon_browser) array_push(_targets, id);
    with (obj_icon_bestiary) array_push(_targets, id);
    with (obj_pc_icon) array_push(_targets, id);
    with (obj_store_icon) array_push(_targets, id);
    with (obj_messenger_icon) array_push(_targets, id);
    
    // If there are icons left, delete one
    if (array_length(_targets) > 0) {
        // Pick a random icon
        var _victim = _targets[irandom(array_length(_targets) - 1)];
        instance_destroy(_victim);
        
        // Play glitch/damage sound
        if (audio_exists(snd_damage_default)) {
             var _snd = audio_play_sound(snd_damage_default, 10, false);
             audio_sound_pitch(_snd, random_range(0.5, 0.8)); // Low pitch
        }
        
        // Reset timer for next deletion (approx 0.75 seconds)
        delete_timer = 45; 
    } 
    else {
        // --- ALL ICONS ARE GONE. DELETE THE TASKBAR. ---
        if (instance_exists(obj_hub_manager)) {
            instance_destroy(obj_hub_manager);
            
            // Play power-down sound
            if (audio_exists(snd_withdraw)) {
                var _snd = audio_play_sound(snd_withdraw, 10, false);
                audio_sound_pitch(_snd, 0.6);
            }
        }
        
        // We stop the timer here, but we DO NOT destroy this object.
        // This ensures the Black Void and Seagull (drawn in Draw Event) remain on screen.
        delete_timer = 999999; 
    }
}