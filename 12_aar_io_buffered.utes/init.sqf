Move = false;
//Here we declare the rate of fps to record at
fps = 0.1;
//Anim = [player, "none"];

//Here come globals
aartimer = true;
playbackMode = false;
recordMode = false;
offlineMode = false;
aarReady = false;
vrema = 0;
global_buffer = [];
[] execVM "f_spect\specta_init.sqf";
//Adding action to launch AAR
recorder addAction ["Launch AAR", "switch.sqf"];
recorder addAction ["SPECTATE", "spect.sqf"];