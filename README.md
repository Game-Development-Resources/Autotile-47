# Autotile-47

This repository provides code, graphics, and explanation for implementing autotiling in GameMaker 1.4. These methods can be adapted for other development environments.



# What is autotiling?

In video games, "tiles" are generally square-ish graphics that can be placed next to one another to create many visuals within a level. Tiles can either be visually independent from one another, or they can visually connect to neighboring tiles.

Visually independent tiles:

![image_1_640x360](https://user-images.githubusercontent.com/6045676/173730990-1ed1ee23-b1ea-42f1-897e-664b47dfec92.png)

Visually connected tiles:

![image_2_640x360](https://user-images.githubusercontent.com/6045676/173730998-36ebc0bd-3ef4-423a-a7f4-bf8cb251d103.png)

**Tiling** means selecting tiles in such a way that neighboring tiles visually connect to one another (as in the graphic above).

**Autotiling** is the use of code to select tiles (rather than having to select each tile manually). There are many ways to achieve this effect, but the most computationally efficient autotiling method (that I know of) is referred to as bitmasking or bitwise-autotiling (which we'll get to later).

*Note: This autotile example is for tiling against both orthogonal and diagonal neighbors. In addition, this example allows for tiling against more than one type of object, as in the example graphic below that has some plain grass tiles and some grass tiles with red bits:*

![image_3_640x360](https://user-images.githubusercontent.com/6045676/173731006-a9b64fb5-4b56-43ab-9542-0d8094289ee4.png)



# Why use autotiling?

Autotiling is extremely useful in the following situations:
* **Dynamic in-game systems:** Implementing autotiling code gives you real-time autotiling capabilities. This allows your game to change the appearance of tiles as the player interacts with the world, such as when a block is created or destroyed.
* **Extended autotiling functionality:** While many 2D game engines these days have some form of autotiling built in, you likely won't be able to extend that autotiling functionality. Thus, building your own script lets you customize and optimize the tiling functionality to best suit your project. For example, if you want to build a level editor into your game, you'll likely want to implement autotiling.
* **Quick level design:** If the game engine you are using doesn't have autotiling built in, you can create an autotile script to save yourself from having to manually select tiles for each individual instance. This not only saves a huge amount of time, but it lets you quickly iterate with level design (because you won't have to manually rework the tiles every time you make changes to a level).

For reference, the video clip below shows level editor in my game, [The True Slime King](https://www.thetrueslimeking.com). It uses autotiling scripts to update blocks as they are placed and destroyed. You can also see how there are two different block types that look different but tile with each other.

https://user-images.githubusercontent.com/6045676/173731022-4979aca7-c93d-4c5a-bf70-33ba75aa71cd.mp4



# Autotiling function explained

There are three parts to the autotiling function:
1. **The autotile script** looks at each tile and outputs an integer. The integer varies depending on how many neighbors the tile has and where those neighbors are located.
1. **The hash table** maps from each unique integer value to the appropriate tile graphic (out of 47 different tile graphics).
1. **The autotile graphic** is broken up into 47 subimages that represent all the possible tile graphics. In GameMaker, these can be loaded in one image and turned into a tile sheet, or they can be loaded in as a sprite and split into individual subimages. In this example, the tile graphics are all loaded in as subimages of one sprite asset in GameMaker, which automatically assigns the subimages number values starting at 0.

**Performance:** The run time of this whole operation is proportional to the number of objects being autotiled multiplied by the number of objects that are being tiled against. For example, if `object_1` is being autotiled against both themselves (`object_1`) and a second object type (`object_2`), the code must loop through all instances of `object_1`, and then within that loop, it must loop through all the instances of `object_1` and `object_2` to determine if they are neighboring.

*Note: This example does not assume objects are constrained to a grid. However, if you want to improve performance (and you can guarantee that your objects will be on the grid and will only each take up one grid space each), you can improve performance by doing the following:*
1. *Create a `ds_grid` or 2D array that stores the bitmap value for each grid square in the level.*
1. *Instead of using a nested `for loop` (as mentioned above), just iterate twice over each object you want to tile. In the first `loop`, add the relevant bitmap values to the squares around it. The second `loop` will be to check the object's associated grid square and apply that bitmap value as the object's subimage.*

*If you are applying this technique along with the examples provided below, you'll need to use the pattern below for applying bitmap values. You'll notice it is reversed from the bitmap position values below. That is because here we are applying values from the perspective of the object that is being tiled against, whereas below, we are applying values from the perspective of the object that is being tiled.*

![tile_chart_4_245x245](https://user-images.githubusercontent.com/6045676/173917548-54fd9dd5-c265-4fcc-8e44-38c1b3da81ad.png)

## Autotile script

[scr_autotile_47_bitwise(x, y, width, height, object_array)](/example_gamemaker_project/Autotile47Bitwise.gmx/scripts/scr_autotile_47_bitwise.gml)

The autotile script finds each object's neighbors to determine what the object's subimage should be.

The first step in the script is to create variables to hold the bitmap information for each neighboring grid square. If a neighbor is found in the relative position (up, down, left, ...), the variable will be set as the bit value associated for that position (more on this below).

```
up         = 0;
down       = 0;
left       = 0;
right      = 0;
up_right   = 0;
down_right = 0;
up_left    = 0;
down_left  = 0;
```

Next, we loop through all the objects we want to tile in order to find their neighbors. As we check, we'll assign a unique value to each adjacent tile such that when we add up all the values, we always have a unique identifying number that we can map to a specific graphic. To do this, we use powers of 2 (although for other applications, such as blending between multiple tile types, you can use powers of 3 or more, but that's not always advised, since you would need a lot of graphics). This is where the method gets its "Bitmap" or "Bitwise" name.

In the graphic below, the center tile represents the tile we want to autotile and the adjacent squares display the values we assign to each of the 8 positions around the tile.

![tile_chart_1_245x245](https://user-images.githubusercontent.com/6045676/173731130-ee5db358-64b4-401c-b084-76db39d003eb.png)

In the graphic below, there is a tile above and a tile to the right, so we would add up 2 + 16 to get a value of 18. This value of 18 would then be mapped to a subimage number so our center tile can display the appropriate graphic.

![tile_chart_2_245x245](https://user-images.githubusercontent.com/6045676/173731163-22f5be3a-e28c-4832-8b23-c99a0690294d.png)

In the graphic below, there are tiles in the following positions:
* up-left (+1)
* up (+2)
* left (+8)
* down (+64)
Adding all those values together gives us the value 75, which we would map to the appropriate subimage number.

![tile_chart_3_245x245](https://user-images.githubusercontent.com/6045676/173731150-d732395d-da2a-4155-ae33-da4d9339c2ea.png)

*Note: The order in which you number your tile positions isn't important, but if you change it from the order here, you'll also have to change your hash table (see below) to appropriately map between the bitmap values and the subimage numbers.*

Here is the GameMaker code that looks for objects and assigns the bitmap values:

```
for (var i=0; i<array_length_1d(object_array); i++) {
    var object_type = object_array[i];
    
    // If nothing has been found yet in a given adjacent tile and we find something there, set the directional bit value
    if (not up_left)    and position_meeting(x-w, y-h, object_type) { up_left    = 1;   }  // 2^0
    if (not up)         and position_meeting(x  , y-h, object_type) { up         = 2;   }  // 2^1
    if (not up_right)   and position_meeting(x+w, y-h, object_type) { up_right   = 4;   }  // 2^2
    if (not left)       and position_meeting(x-w, y,   object_type) { left       = 8;   }  // 2^3
    if (not right)      and position_meeting(x+w, y,   object_type) { right      = 16;  }  // 2^4
    if (not down_left)  and position_meeting(x-w, y+h, object_type) { down_left  = 32;  }  // 2^5
    if (not down)       and position_meeting(x,   y+h, object_type) { down       = 64;  }  // 2^6
    if (not down_right) and position_meeting(x+w, y+h, object_type) { down_right = 128; }  // 2^7
}
```

*Note: If an object has already been found for a given direction, GameMaker will skip running the position_meeting() function, which saves on computation time.*

Next, we add up all the bit values that the code above collected.

```
bit_count = up + right + down + left;

if (up   and left ) { bit_count += up_left;    }
if (up   and right) { bit_count += up_right;   }
if (down and right) { bit_count += down_right; }
if (down and left ) { bit_count += down_left;  }
```

Note that we only want to add the diagonal values if both the adjacent orthogonal tiles exist. When there are zero or one orthogonal tiles (adjacent to the diagonal tile), we want to display diagonal tiles as disconnected from one another. This is demonstrated in the example image below (assuming we're autotiling the center tile):
* The upper-right tile doesn't have any supporting orthogonal blocks, so the center tile should be autotiled in a way that ignores the upper-right tile.
* The upper-left and bottom-right tiles are only supported by one orthogonal block, so we also want to autotile the center tile while ignoring those diagonal tiles.
* The bottom-left block is supported by two orthogonal blocks, so we want to autotile the center tile in a way that makes all four tiles appear connected.

![image_orthagonal_diagonal_192x192](https://user-images.githubusercontent.com/6045676/173733185-d1431319-cf14-484f-bc4e-88890ff4cd13.png)

Once we have calculated the bitmap value for the tile, we need to convert it into the appropriate subimage. To do this, we'll use a hash table (that will need to be defined ahead of time).

```
subimage = global.map_bitwise_tile_47[? bit_count];
```

## Autotile hash table

[scr_init_bitwise_map()](/example_gamemaker_project/Autotile47Bitwise.gmx/scripts/scr_init_bitwise_map.gml)

In this example, our GameMaker global variable `global.map_bitwise_tile_47` is a hash table that maps all possible bitmap values (that can be produced by our script above) to their corresponding graphics subimage numbers.

There are 47 possible subimages (thus the reason for this example being named "Autotile-47").
```
global.map_bitwise_tile_47[? 2]   = 0;
global.map_bitwise_tile_47[? 16]  = 1;
global.map_bitwise_tile_47[? 64]  = 2;
global.map_bitwise_tile_47[? 8]   = 3;
...
global.map_bitwise_tile_47[? 255] = 43;
global.map_bitwise_tile_47[? 0]   = 44;
global.map_bitwise_tile_47[? 66]  = 45;
global.map_bitwise_tile_47[? 24]  = 46;
```

This map is generated once at the start of the game. Once generated, passing in a key (our bitmap number) to access a value (our subimage number) from the hash tables effectively takes O(1) time. The map is saved in a global variable, because in GameMaker 1.4, global variables are 10% faster to access than local variables (at least in my testing).

## Autotile graphic

![template_autotile_47_with_text](https://user-images.githubusercontent.com/6045676/173731196-f662239b-ceb1-4cb8-9685-894c442be5b6.png)

The [provided graphics templates](/graphics_templates/) are 32x32 pixels because that is what I prefer to use for game development (as a tradeoff between level of detail and work speed for pixel art). You are welcome to scale the templates up or down to whatever size you want for your game, and you do not have to stick to pixel art. If you adjust the size of the graphics, you'll just need to adjust the `width` and `height` variables passed into `scr_autotile_47_bitwise()` to match your tile size. So instead of using this: `scr_autotile_47_bitwise(..., ..., 32, 32, ...)`, you might use `scr_autotile_47_bitwise(..., ..., 128, 64, ...)` if your graphics are 128 pixels wide and 64 pixels tall.

I've included template PNG files and [Pyxel Edit](https://www.pyxeledit.com) files. In the Pyxel Edit files, I have broken down each wall tile into 4 Pyxel tiles. The Pyxel tiles get copied around to different parts of different wall tiles. Whenever one of the Pyxel tiles is updated, it updates in all locations where that tile is. This system makes it very efficient to create and alter the 47 wall tiles while making sure all the graphics line up correctly. I chose to split each wall tile into 4 Pyxel tiles because repetition at this level is what I tend to use in my pixel art. You can set up your own sizes if you want, whether that's just doing each tile separately or dividing each tile into even smaller Pyxel tile chunks.

Templates in action:

![autotile_template_1_32x32](https://user-images.githubusercontent.com/6045676/173731212-8d93e90f-c4f7-4a93-a266-b9747a57202d.png)
![autotile_example_1_640x360](https://user-images.githubusercontent.com/6045676/173731218-b7e7919e-4f1f-4f16-9fc1-e6846b609a41.png)

![autotile_template_2_32x32](https://user-images.githubusercontent.com/6045676/173731225-771dac5f-299f-492b-baff-4ac5b15cb77d.png)
![autotile_example_2_640x360](https://user-images.githubusercontent.com/6045676/173731233-6d918564-6b39-4685-839e-b35d1df84492.png)

![autotile_template_3_32x32](https://user-images.githubusercontent.com/6045676/173731241-a888a25a-06b3-43e6-91b7-b49fca23d192.png)
![autotile_example_3_640x360](https://user-images.githubusercontent.com/6045676/173731246-2b1fb9a2-e290-49c8-b107-6d26232909de.png)



# Limitations and further thoughts

* The included GameMaker 1.4 example uses objects. You could reworked things to use tiles instead of objects, but it using GameMaker tiles for this requires a bit more code for finding neighbors and for mapping to subimages. If this is something you would really like to see a tutorial in, let me know and I will put one together, since I already have it implemented in my game, [The True Slime King](https://www.thetrueslimeking.com).
* For additional autotiling examples and explanations, search the internet for "tile bitmasking", "autotile bitmasking", or "bitwise autotiling".
* If you want to make a level editor with real-time autotiling as the user places tiles, you can just autotile the tiles adjacent to where a tile gets created or destroyed (as opposed to autotiling the entire level).
