// --- Step Event ---

// 1. DELETION LOGIC
delete_timer--;

if (delete_timer <= 0) {
    var _targets = [];
    
    // Gather all desktop icons
    with (obj_icon_browser) array_push(_targets, id);
    with (obj_icon_bestiary) array_push(_targets, id);
    with (obj_pc_icon) array_push(_targets, id);
    with (obj_store_icon) array_push(_targets, id);
    with (obj_messenger_icon) array_push(_targets, id);
    
    if (array_length(_targets) > 0) {
        // Pick a random icon to delete
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
}