--[[
--
-- Gideros
--
-- by GiderosMobile  (http://www.giderosmobile.com/)
--
--
]]

require "box2d"

-- set the MKS (meters-kilogram-second)
b2.setScale(20)

-- this table holds the dynamic bodies and their sprites
local actors = {}

-- create world
local world = b2.World.new(0, 9.8)


--we load the PhysicsData containing all PhysicsEditor's information for our bodies,
--obviously exported with "Gideros" exporter.

local scaleFactor = 1.0
local physics = (loadfile "PhysicsData.lua")().physicsData(scaleFactor)


-- create floor body
local floorBody = world:createBody{type = b2.STATIC_BODY}
floorBody.name = "floor"
floorBody:setPosition(0,960)
physics:addFixture(floorBody, "floor")
-- create floor sprite and add it to stage
local floor = Bitmap.new(Texture.new("floor.png"))
floor:setAnchorPoint(physics:getAnchorPoint("floor"))
floor:setY(960)
stage:addChild(floor)


-- we create a global table with all falling object's names within
local foodTable = { 'drink', 'hamburger', 'hotdog', 'icecream', 'icecream2', 'icecream3' ,'orange'}

local function createFallingObjects()

    -- we get a random item from the food table	
    item = foodTable[math.random(#foodTable)]
	
	-- create the body at a random x position
	local body = world:createBody{type = b2.DYNAMIC_BODY, position = {x = math.random(640), y = 0}}
	body.name = item
	physics:addFixture(body, item)	
	
	-- craete a related sprite
	local sprite = Bitmap.new(Texture.new(item..".png"))
	sprite:setAnchorPoint(physics:getAnchorPoint(item))
	sprite:setPosition(body:getPosition())	
	stage:addChild(sprite)
	
	actors[body] = sprite
end

-- we give a first run to the above function
createFallingObjects()

-- create a timer with 20 repetitions
timer = Timer.new(1000,20)
timer:addEventListener(Event.TIMER, createFallingObjects)
timer:start()

-- step the world and then update the position and rotation of sprites
local function onEnterFrame()
	world:step(1/60, 8, 3)	
	for body,sprite in pairs(actors) do
		sprite:setPosition(body:getPosition())
		sprite:setRotation(body:getAngle() * 180 / math.pi)
	end
end

stage:addEventListener(Event.ENTER_FRAME, onEnterFrame)



