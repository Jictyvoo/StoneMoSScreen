# StoneMoSScreen

A Screen resolution library that draws objects responsive. Write your game in one resolution and play it in infinite resolutions.

You can use it simply, like this:

```lua
StoneMoSScreen = require "libs.StoneMoSScreen"; StoneMoSScreen.new(true, 800, 600)
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

### new(override, width, height)

Function that create a instance of the library.
* override - true if want to override love.graphics.draw default library
* width - the width your game is designed for
* height - the height your game is designed for

### create(objectType, drawable, x, y, r, sx, sy, ox, oy, kx, ky)

Works like love.graphics.draw, but it creates a calculated scale and saves it

### draw(drawableObject, [isUnique])

draw the object with the key saved in create function below

### overrideDefaultDraw()

If you want to override the default function sometime you can

### restoreDefaultDraw()

If you have overrided the default draw function, can restore it
