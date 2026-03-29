local StageIntro = Class("StageIntro", crystal.Widget);

local textures = {
    crystal.assets.get("assets/stage_1.png");
    crystal.assets.get("assets/stage_2.png");
    crystal.assets.get("assets/stage_3.png");
    crystal.assets.get("assets/stage_4.png");
    crystal.assets.get("assets/stage_5.png");
};

StageIntro.init = function(self, stage_number)
    StageIntro.super.init(self);
    local overlay = self:set_child(crystal.Overlay:new());
    local texture = textures[stage_number];
    assert(texture);
    local image = overlay:add_child(crystal.Image:new(texture));
end

return StageIntro;