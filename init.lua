local currentPath   = (...):gsub('%.init$', '') .. "."
local ScaleDimension = require(string.format("%sScaleDimension", currentPath))
local StoneMoSScreen = {}; StoneMoSScreen.__index = StoneMoSScreen
local instance = nil; local defaultDraw = love.graphics.draw
local defaultPrint = love.graphics.print; local defaultPrintf = love.graphics.printf

local function getScaleDimension()
    return ScaleDimension
end

function StoneMoSScreen:new(aspectRatio, width, height, staticText)
    local this = setmetatable({
        static = {}, dynamic = {}, aspectRatio = {x = 0, y = 0, active = aspectRatio or false},
        width = width, height = height, staticText = staticText or false,
        scaleDimension = ScaleDimension:new(width, height)
    }, StoneMoSScreen)
    if aspectRatio then this:calculateAspectRatio() end
    return this
end

function StoneMoSScreen:calculateAspectRatio()
    local scaleX = love.graphics.getWidth() /self.width
    local scaleY = love.graphics.getHeight() / self.height
    if scaleX < scaleY then scaleY = scaleX
    else scaleX = scaleY
    end
    self.aspectRatio.x = (love.graphics.getWidth() - (self.width * scaleX)) / 2
    self.aspectRatio.y = (love.graphics.getHeight() - (self.height * scaleY)) / 2
    --print(self.aspectRatio.x, self.aspectRatio.y)
end

function StoneMoSScreen:isStatic(drawableObject)
    return not self.dynamic[drawableObject]
end

function StoneMoSScreen:create(objectType, drawable, x, y, r, sx, sy, ox, oy, kx, ky)
    local identifier = drawable
    if type(drawable) == "table" then
        identifier = drawable.identifier
        drawable = drawable.drawable
    end
    local scales = self.scaleDimension:calculeScales(identifier, ox, oy, x, y)
    local newScale = {x = scales.scaleX * sx, y = scales.scaleY * sy, originalSize = nil}
    scales.relative = newScale; local temp = self.aspectRatio
    if self.aspectRatio.active then self.scaleDimension:generateAspectRatio(identifier) end
    self[objectType][identifier] = {
        x = scales.x + temp.x, y = scales.y + temp.y, sx = newScale.x, sy = newScale.y,
        ox = --[[scales.width--]]ox, oy = --[[scales.height--]]oy, r = r, drawable = drawable,
        original_sx = sx, original_sy = sy
    }
    collectgarbage("step"); --[[print(collectgarbage("count")))--]]
    return self[objectType][identifier]
end

function StoneMoSScreen:updateScales(identifier)
    local sx, sy = self["static"][identifier].original_sx, self["static"][identifier].original_sy
    local scales = self.scaleDimension:getScale(identifier)
    local newScale = {x = scales.scaleX * sx, y = scales.scaleY * sy, originalSize = nil}
    scales.relative = newScale; local temp = self.aspectRatio
    if self.aspectRatio.active then self.scaleDimension:generateAspectRatio(identifier) end
    self["static"][identifier].x = scales.x + temp.x; self["static"][identifier].y = scales.y + temp.y
    self["static"][identifier].sx, self["static"][identifier].sy = newScale.x, newScale.y
end

function StoneMoSScreen:swap(drawableObject)
    if self.static[drawableObject] then self.dynamic[drawableObject] = self.static[drawableObject]; self.static[drawableObject] = nil
    elseif self.dynamic[drawableObject] then self.static[drawableObject] = self.dynamic[drawableObject]; self.dynamic[drawableObject] = nil
    end
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
    if not instance:isStatic(text) and instance.staticText then instance:swap(text) end
    defaultPrint(text, scales.x, scales.y, scales.r, scales.sx, scales.sy, scales.ox, scales.oy)
end

local function overridePrintf(text, x, y, limit, align, r, sx, sy, ox, oy, kx, ky)
    local scales = instance:calculate(text, x or 0, y or 0, r or 0, sx or 1, sy or 1, ox or 0, oy or 0)
    scales.limit, scales.align = limit, align
    if not instance:isStatic(text) and instance.staticText then instance:swap(text) end
    defaultPrintf(text, scales.x, scales.y, scales.limit, scales.align, r, scales.sx, scales.sy, scales.ox, scales.oy)
end

local function overrideDraw(...)
    local parameters = {...}; local drawType = 0
    if (type(parameters[2]) == "userdata" and type(parameters[3]) == "number") then drawType = 1
    elseif type(parameters[2]) ~= "number" then defaultDraw(...)
    else
        local texture, drawable, x, y, r, sx, sy, ox, oy, kx, ky = parameters[0 + drawType], parameters[1 + drawType], parameters[2 + drawType], parameters[3 + drawType], parameters[4 + drawType], parameters[5 + drawType], parameters[6 + drawType], parameters[7 + drawType], parameters[8 + drawType], parameters[9 + drawType], parameters[10 + drawType]
        local scales = {}
        if texture then
            scales = instance:calculate({texture = texture, drawable = drawable}, x or 0, y or 0, r or 0, sx or 1, sy or 1, ox or 0, oy or 0)
        else
            scales = instance:calculate(drawable, x or 0, y or 0, r or 0, sx or 1, sy or 1, ox or 0, oy or 0)
        end
        if type(scales.drawable) == "table" then
            local object = scales.drawable
            defaultDraw(object.texture, object.drawable, scales.x, scales.y, scales.r, scales.sx, scales.sy, scales.ox, scales.oy)
        else
            defaultDraw(scales.drawable, scales.x, scales.y, scales.r, scales.sx, scales.sy, scales.ox, scales.oy)
        end
    end
end

local function create(objectType, drawable, x, y, r, sx, sy, ox, oy, kx, ky)
    return instance:create(objectType, drawable, x, y, r, sx, sy, ox, oy, kx, ky)
end

local function screenResize(w, h)
    instance:calculateAspectRatio(); instance.scaleDimension:screenResize(w, h)
    for index, _ in pairs(instance.static) do instance:updateScales(index) end
end

--[[
    override - default LÖVE graphics draw
    width - pretended screen width
    height - pretended screen height
]]
local function new(width, height, override, aspectRatio, staticText)
    if not instance then instance = StoneMoSScreen:new(aspectRatio, width, height, staticText) end
    if override then love.graphics.draw = overrideDraw; love.graphics.print = overridePrint
        love.graphics.printf = overridePrintf; local temp = love.resize
        love.resize = function(w, h) temp(w,h); instance.scaleDimension:screenResize(w, h) end
    end
    --[[instance.scaleDimension:setGameScreenScale(width, height)--]]
end

local function draw(drawableObject, isUnique)
    local scales = instance:get(drawableObject)
    if scales then defaultDraw(drawable, scales.x, scales.y, scales.r, scales.sx, scales.sy, scales.ox, scales.oy) end
end

local function print(text)
    local scales = instance:get(text)
    defaultPrint(text, scales.x, scales.y, scales.r, scales.sx, scales.sy, scales.ox, scales.oy)
end

local function restoreDefaultDraw() love.graphics.draw = defaultDraw end

local function overrideDefaultDraw() love.graphics.draw = overrideDraw end

return {
    getScaleDimension = getScaleDimension, restoreDefaultDraw = restoreDefaultDraw,
    new = new, draw = draw, create = create, overrideDefaultDraw = overrideDefaultDraw,
    screenResize = screenResize
}
