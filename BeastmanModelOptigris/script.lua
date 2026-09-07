-- This should hopefully get you started on making a Figura model.
-- This has multiple parts you'll need to mess with:
--   - `avatar.json`: This defines metadata about your model. Like what its name is!
--   - `model.bbmodel`: Your Blockbench model file. See https://www.blockbench.net/ for more information.
--   - `avatar.png`: This is the icon that shows up in the in-game menu when you select this model.
--   - `script.lua`: This file! It defines any custom behaviour you need via Lua scripting. See https://www.lua.org/ for information about Lua.
--   - `texture.png`: The texture for the model. Edit this in Blockbench.
-- See https://figura-wiki.pages.dev/ for more information about making Figura models!

-- Here we import a library, SquAPI, for the jiggle physics.
local squapi = require("SquAPI")

-- we don't want to render items and parrots ourselves
-- but everything else is custom!
-- see https://figura-wiki.pages.dev/globals/Vanilla-Model/VanillaModel for the options here.
vanilla_model.ALL:setVisible(false)
vanilla_model.HELD_ITEMS:setVisible(true)
vanilla_model.PARROTS:setVisible(true)

-- Get the body parts as defined in our `model.bbmodel` file.
local modelRoot = models.model.model

-- display normally hidden elements
models.model.Skull:visible(true)

-- idle animation
animations.model.idle:play()

-- See https://mrsirsquishy.notion.site/Squishy-API-Guide-3e72692e93a248b5bd88353c96d8e6c5 for how to set up more!
squapi.tail:new(
    {
        modelRoot.Body.tail,
        modelRoot.Body.tail.tail2,
        modelRoot.Body.tail.tail2.tail3,
        modelRoot.Body.tail.tail2.tail3.tail4,
        modelRoot.Body.tail.tail2.tail3.tail4.tail5,
    },
    5,
    20,
    0.75,
    0.75,
    4,
    2,
    0,
    2,
    0,
    .95,
    90,
    -45,
    45
)

squapi.ear:new(
    modelRoot.Body.Head.ear,
    modelRoot.Body.Head.ear2,
    0.5,
    false,
    1,
    true,
    400,
    0.2,
    0.8
)

-- set up blinking
local blinking = {}

local function setupBlinking(part)
    if part:getName() == "blink" then
        part:visible(false)
        table.insert(blinking, part)
    end

    for i, v in ipairs(part:getChildren()) do
        setupBlinking(v)
    end
end
setupBlinking(modelRoot)

-- set up action wheel
local mainPage = action_wheel:newPage()

local blinkingEnabled = true
local blinkAction
local function updateBlinkAction()
    blinkAction = blinkAction
        :title("Blinking: " .. (blinkingEnabled and "ON" or "OFF"))
        :item(blinkingEnabled and "minecraft:redstone" or "minecraft:glowstone_dust")
end

function pings.toggleblink()
    blinkingEnabled = not blinkingEnabled
    updateBlinkAction()
end

blinkAction = mainPage:newAction(1)
    :onLeftClick(pings.toggleblink)
updateBlinkAction()

local eyesOpen = true
local eyesAction
local function updateEyesAction()
    eyesAction = eyesAction
        :title("Eyes: " .. (eyesOpen and "OPEN" or "CLOSED"))
        :item(eyesOpen and "minecraft:ender_eye" or "minecraft:ender_pearl")
end

function pings.toggleeyes()
    eyesOpen = not eyesOpen
    updateEyesAction()
end

eyesAction = mainPage:newAction(2)
    :onLeftClick(pings.toggleeyes)
updateEyesAction()

action_wheel:setPage(mainPage)

-- handle events
local headPos = modelRoot.Body.Head:getPos()
function events.tick()
    -- fix crouching
    local yoff = vec(0, 0, 0)
    if player:isCrouching() then
        yoff = vec(0, 4, 0)
    end
    modelRoot.Body.Head:setPos(headPos + yoff)

    -- handle blinking
    for i, part in ipairs(blinking) do
        if blinkingEnabled then
            part:visible(not eyesOpen or math.random() < 1/200)
        else
            part:visible(not eyesOpen)
        end
    end
end
