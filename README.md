# StoneMoSScreen

A Screen resolution library that draws objects responsive. Write your game in one resolution and play it in infinite resolutions.

You can use it simply, like this:

```lua
StoneMoSScreen = require "libs.StoneMoSScreen"; StoneMoSScreen.new(800, 600, true)
```

## Example

To run example create a symlink to the two files init.lua and ScaleDimension.lua

### Windows

```cmd
mklink /H init.lua "../../../init.lua"
mklink /H ScaleDimension.lua "../../../ScaleDimension.lua"
```

### Linux

```shell
ln  ../../../init.lua
ln  ../../../ScaleDimension.lua
```

## Functions

### getScaleDimension()

Function that returns scale calculator class

### new(width, height, [override], [aspectRatio])

Function that create a instance of the library.
* override - true if want to override love.graphics.draw default library
* width - the width your game is designed for
* height - the height your game is designed for

### create(objectType, drawable, x, y, r, sx, sy, ox, oy, kx, ky)

Works like love.graphics.draw, but it creates a calculated scale and saves it.
Identifier cames in drawable and in case of existing texture and quad, identifier should be a table like this
```lua
{identifier = "something", drawable = {texture, quad}}
```

### draw(drawableObject, [x, y, r, sx, sy, ox, oy, kx, ky])

draw the object with the key saved in create function above.
It works like, if object exists, will use the existing object values. Otherwise will generate a dynamic item and calculate it value automatically in every function call (But, to do it, at least x, y, sx and sy will be needed)

### overrideDefaultDraw()

If you want to override the default function sometime you can

### restoreDefaultDraw()

If you have overrided the default draw function, can restore it

## When use overrideDefaultDraw and restoreDefaultDraw

When you are using a third party library, maybe you want to resize the elements drawn by this library. So use like this
```lua
StoneMoSScreen:overrideDefaultDraw()
otherLibrary:draw()
StoneMoSScreen:restoreDefaultDraw()
```
