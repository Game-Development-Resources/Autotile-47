/// scr_init_bitwise_map()

// Returns a bitwise map for autotiling.

/* Base 10 bit values for squares relative to a center square
Up-left     - 1
Up          - 2
Up-right    - 4
Left        - 8
Right       - 16
Down-left   - 32
Down        - 64
Down-right  - 128
*/

var _map;

_map = ds_map_create(); // Maps base 10 bitwise numbers to autotile subimages
_map[? 2]   = 0;
_map[? 16]  = 1;
_map[? 64]  = 2;
_map[? 8]   = 3;
_map[? 18]  = 4;
_map[? 80]  = 5;
_map[? 72]  = 6;
_map[? 10]  = 7;
_map[? 22]  = 8;
_map[? 208] = 9;
_map[? 104] = 10;
_map[? 11]  = 11;
_map[? 82]  = 12;
_map[? 88]  = 13;
_map[? 74]  = 14;
_map[? 26]  = 15;
_map[? 86]  = 16;
_map[? 210] = 17;
_map[? 214] = 18;
_map[? 216] = 19;
_map[? 120] = 20;
_map[? 248] = 21;
_map[? 106] = 22;
_map[? 75]  = 23;
_map[? 107] = 24;
_map[? 30]  = 25;
_map[? 27]  = 26;
_map[? 31]  = 27;
_map[? 90]  = 28;
_map[? 94]  = 29;
_map[? 218] = 30;
_map[? 122] = 31;
_map[? 91]  = 32;
_map[? 222] = 33;
_map[? 250] = 34;
_map[? 123] = 35;
_map[? 95]  = 36;
_map[? 126] = 37;
_map[? 219] = 38;
_map[? 254] = 39;
_map[? 223] = 40;
_map[? 127] = 41;
_map[? 251] = 42;
_map[? 255] = 43;
_map[? 0]   = 44;
_map[? 66]  = 45;
_map[? 24]  = 46;

return(_map);
