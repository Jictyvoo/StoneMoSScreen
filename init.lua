local currentPath   = (...):gsub('%.init$', '') .. "."
local ScaleDimension = require(string.format("%sScaleDimension", currentPath))
local StoneMoSScreen = {}; StoneMoSScreen.__index = StoneMoSScreen
local instance = nil; local defaultDraw = love.graphics.draw
local defaultPrint = love.graphics.print; local defaultPrintf = love.graphics.printf

local function getScaleDimension()
    return instance.scaleDimension
end

function StoneMoSScreen:new(aspectRatio)
    return setmetatable({
        static = {}, dynamic = {}, aspectRatio = aspectRatio or false,
        scaleDimension = ScaleDimension:new()
    }, StoneMoSScreen)
end

function StoneMoSScreen:isStatic(drawableObject)
    return not self.dynamic[drawableObject]
end

function StoneMoSScreen:create(objectType, drawable, x, y, r, sx, sy, ox, oy, kx, ky)
    local scales = self.scaleDimension:calculeScales(drawable, ox, oy, x, y)
    local newScale = {x = scales.scaleX * sx, y = scales.scaleY * sy, originalSize = nil}
    scales.relative = newScale
    self[objectType][drawable] = {
        x = scales.x, y = scales.y, sx = newScale.x, sy = newScale.y,
        ox = scales.width, oy = scales.height, r = r
    }
    return self[objectType][drawable]
end

function StoneMoSScreen:calculate(drawable, x, y, r, sx, sy, ox, oy, kx, ky)
    local createdNow = false
    local exists = self.static[drawable] or self.dynamic[drawable] or false
    if not exists then exists = self:create("dynamic", drawable, x, y, r, sx, sy, ox, oy); createdNow = true end
    if not instance:isStatic(drawable) and not createdNow then
        return self:create("dynamic", drawable, x, y, r, sx, sy, ox, oy)
    end
    return exists
end

function StoneMoSScreen:get(drawableObject)
    return self.static[drawableObject]
end

local function overridePrint(text, x, y, r, sx, sy, ox, oy)
    local scales = instance:calculate(text, x or 0, y or 0, r or 0, sx or 1, sy or 1, ox or 0, oy or 0)
    defaultPrint(text, scales.x, scales.y, scales.r, scales.sx, scales.sy, scales.ox, scales.oy)
end

local function overridePrintf(text, x, y, limit, align, r, sx, sy, ox, oy, kx, ky)
    local scales = instance:calculate(text, x or 0, y or 0, r or 0, sx or 1, sy or 1, ox or 0, oy or 0)
    scales.limit, scales.align = limit, align
    defaultPrintf(text, scales.x, scales.y, scales.limit, scales.align, scales.r, scales.sx, scales.sy, scales.ox, scales.oy)
end

local function overrideDraw(...)
    local parameters = {...}; local drawType = 0
    if (type(parameters[2]) == "userdata" and type(parameters[3]) == "number") then drawType = 1
    elseif type(parameters[2]) ~= "number" then defaultDraw(...)
    else
        local texture, drawable, x, y, r, sx, sy, ox, oy, kx, ky = parameters[0 + drawType], parameters[1 + drawType], parameters[2 + drawType], parameters[3 + drawType], parameters[4 + drawType], parameters[5 + drawType], parameters[6 + drawType], parameters[7 + drawType], parameters[8 + drawType], parameters[9 + drawType], parameters[10 + drawType]
        local scales = instance:calculate(drawable, x or 0, y or 0, r or 0, sx or 1, sy or 1, ox or 0, oy or 0)
        defaultDraw(drawable, scales.x, scales.y, scales.r, scales.sx, scales.sy, scales.ox, scales.oy)
    end
end

local function create(objectType, drawable, x, y, r, sx, sy, ox, oy, kx, ky)
    return instance:create(objectType, drawable, x, y, r, sx, sy, ox, oy, kx, ky)
end

--[[
    override - default LÖVE graphics draw
    width - pretended screen width
    height - pretended screen height
]]
local function new(override, width, height, aspectRatio)
    if not instance then instance = StoneMoSScreen:new(aspectRatio) end
    if override then love.graphics.draw = overrideDraw; love.graphics.print = overridePrint
        love.graphics.printf = overridePrintf; local temp = love.resize
        love.resize = function(w, h) temp(w,h); instance.scaleDimension:screenResize(w, h) end
    end
    instance.scaleDimension:setGameScreenScale(width, height)
end

local function draw(drawableObject, isUnique)
    local scales = instance:get(drawableObject)
    if scales then defaultDraw(drawable, scales.x, scales.y, scales.r, scales.sx, scales.sy, scales.ox, scales.oy) end
end

local function restoreDefaultDraw() love.graphics.draw = defaultDraw end

local function overrideDefaultDraw() love.graphics.draw = overrideDraw end

return {
    getScaleDimension = getScaleDimension, restoreDefaultDraw = restoreDefaultDraw,
    new = new, draw = draw, create = create, overrideDefaultDraw = overrideDefaultDraw
}
