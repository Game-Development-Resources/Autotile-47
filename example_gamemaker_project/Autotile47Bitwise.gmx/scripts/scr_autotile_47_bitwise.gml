/// scr_autotile_47_bitwise(x, y, width, height, tile_array)

/// Description: Autotile an object with other objects
/// Parameter 0 {real}  - x          - X position of the object to autotile
/// Parameter 1 {real}  - y          - Y position of the object to autotile
/// Parameter 2 {real}  - width      - Width of the object to autotile
/// Parameter 3 {real}  - height     - Height of the object to autotile
/// Parameter 4 {array} - tile_array - Array of objects to tile with


// --------------------------
// 1 - Define local variables
// --------------------------

var _x, _y, _w, _h, _array_tile_objects, _bit_count, _subimage;
var _up_left, _up, _up_right, _right, _down_right, _down, _down_left, _left;


// -------------------
// 2 - Grab parameters
// -------------------

_x = argument[0];
_y = argument[1];
_w = argument[2];
_h = argument[3];
_array_tile_objects = argument[4];


//--------------------
// 3 -- Find Neighbors
//--------------------

// 3.1 - Initizlize variables to store data about neighbors
// If an object is found for one of these locations, the value of the variable
// is set to the base 10 equivelant of a unique bit value. In the end, we will
// add up all of the base 10 values to get a number that is unique to a specific
// combination of sums.
_up         = 0;
_down       = 0;
_left       = 0;
_right      = 0;
_up_right   = 0;
_down_right = 0;
_up_left    = 0;
_down_left  = 0;

// 3.2 - For each object to tile with, check whether it exists in any of the eight positions
for (var i=0; i<array_length_1d(_array_tile_objects); i++) {
    var _object_type = _array_tile_objects[i];
    
    // If nothing has been found yet in a given adjacent tile and we find something there, set the directional bit value
    if (not _up_left)    and position_meeting(_x-_w, _y-_h, _object_type) { _up_left    = 1;   }
    if (not _up)         and position_meeting(_x,    _y-_h, _object_type) { _up         = 2;   }
    if (not _up_right)   and position_meeting(_x+_w, _y-_h, _object_type) { _up_right   = 4;   }
    if (not _left)       and position_meeting(_x-_w, _y,    _object_type) { _left       = 8;   }
    if (not _right)      and position_meeting(_x+_w, _y,    _object_type) { _right      = 16;  }
    if (not _down_left)  and position_meeting(_x-_w, _y+_h, _object_type) { _down_left  = 32;  }
    if (not _down)       and position_meeting(_x,    _y+_h, _object_type) { _down       = 64;  }
    if (not _down_right) and position_meeting(_x+_w, _y+_h, _object_type) { _down_right = 128; }
}


// ----------------------------------------------------
// 4 - Add up the base 10 values to get a unique number
// ----------------------------------------------------

// 4.1 - Add up the orthagonal bit values
_bit_count = _up + _right + _down + _left;

// 4.2 - Add up the diagonal values
// Only add the diagonal values if both of the ajacent orthagonal values exist
if (_up and _left)    { _bit_count += _up_left;    }
if (_up and _right)   { _bit_count += _up_right;   }
if (_down and _right) { _bit_count += _down_right; }
if (_down and _left)  { _bit_count += _down_left;  }


// ---------------------------------------
// 5 - Convert unique number into subimage
// ---------------------------------------

// global.map_bitwise_tile_47 is a hash table created outside of this function that maps each unique number to a unique subimage from 0 to 47.
_subimage = global.map_bitwise_tile_47[? _bit_count];
return(_subimage);
