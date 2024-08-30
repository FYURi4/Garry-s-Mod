include('shared.lua')

if CLIENT then
    function ENT:Draw()
        self:DrawModel()
        local pos, ang = self:LocalToWorld(Vector(3,20,2)), self:GetAngles() --The position of the blindozer in the world, the angle--
        local dist = LocalPlayer():EyePos():Distance(self:GetPos()) --The player's distance to the object--
        local viewdist = 140 --Maximum display distance-
        local viewdistmax = viewdist
        local blindozer_hp = self:Health() --Local health variable--
        local viewdistmin = viewdist*0,75 --The minimum value of the interface display--
        blindozer_config.blindozer_health = self:Health() --The blindozer's health is entered in the table--

        if dist > viewdistmin and dist < viewdistmax then
            alpha = 255
        elseif dist > viewdistmax then 
            alpha = 0   
        end

    --Rendering the interface on a blindozer--
        if alpha > 0 then
            cam.Start3D2D(pos, ang, 0.1)
                draw.SimpleText("Блин с вишней", 'TheDefaultSettings2', -15, 210, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            cam.End3D2D()
        end
    end
end
--[MADE IN RUSSIAN]--
--[MADE COPY FYURI4]--
--[MADE COPY 3DEMC]--
--[Copyright 2024 BLINDOZER. Все права защищены. ООО "Сити Венд Кафе"]--
