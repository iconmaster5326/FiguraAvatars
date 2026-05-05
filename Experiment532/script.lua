local blend = require("GSAnimBlend")
local anims = require("JimmyAnims")

-- jimmy boilerplate
anims.excluBlendTime = 4
anims.incluBlendTime = 4
anims.autoBlend = true
anims.addExcluAnims()
anims.addIncluAnims()
anims.addAllAnims()
anims(animations.model)

-- ensure that there is no blending of holding animations
-- (otherwise it looks weird)
animations.model.spearR:setBlendTime(0)
animations.model.spearL:setBlendTime(0)
-- animations.model["ID_minecraft:shield_holdR"]:setBlendTime(0)

-- we don't want to render items and parrots ourselves
-- but everything else? custom, baby!
vanilla_model.ALL:setVisible(false)
vanilla_model.HELD_ITEMS:setVisible(true)
vanilla_model.PARROTS:setVisible(true)

-- usually have these disabled in the model file
-- so let's make sure they're visible
models.model.Portrait:setVisible(true)
models.model.Skull:setVisible(true)

function events.tick()
    -- make the walk anims faster when running, slower when crawling, etc
    local SPEED_FACTOR = 12
    local speed = player:getVelocity().xz:length()

    animations.model.walk:setSpeed(speed * SPEED_FACTOR)
    animations.model.crouchwalk:setSpeed(speed * SPEED_FACTOR)
    animations.model.climb:setSpeed(2)
    animations.model.climbcrouchwalk:setSpeed(2)
end

function events.render(delta, context)
    -- make the head follow the look vector
    -- (done instead of using Head groups because of crouching offsets)
    -- (the math is weird to make turning your head quickly not bug out)
    local headRot = (vanilla_model.HEAD:getOriginRot() + 180) % 360 - 180
    models.model.lower_body.upper_body.head:setRot(headRot)
    models.model.lower_body.upper_body.gun:setRot(headRot)
end
