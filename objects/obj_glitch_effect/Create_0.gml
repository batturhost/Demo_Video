// --- Create Event ---
// This object handles the "Black Void + Seagull" background and deleting icons

// Timer for deleting icons
delete_timer = 60; // Start deleting 1 second after creation

// Find the seagull sprite (ensure the asset exists)
sprite_index = spr_seagull_idle;
image_speed = 1.0; 

// Force depth to be between Icons (0-100) and Background (300)
depth = 200;