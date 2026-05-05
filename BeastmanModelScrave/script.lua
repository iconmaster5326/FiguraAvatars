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

-- squapi.FPHand:new(
--     modelRoot.Body.RightArm.arm3.arm4,
--     0,
--     0,
--     0,
--     1,
--     false
-- )

local headPos = modelRoot.Body.Head:getPos()
function events.tick()
    -- fix crouching
    local yoff = vec(0, 0, 0)
    if player:isCrouching() then
        yoff = vec(0, 4, 0)
    end
    modelRoot.Body.Head:setPos(headPos + yoff)
end
