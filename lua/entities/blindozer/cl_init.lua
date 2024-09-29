include('shared.lua')
include('data_base.lua')
include('font.lua')

if CLIENT then

    ------------------------------------------------------------------------------------------
    local owner = nil
    local usersee = nil
    local keysl = nil
    ------------------------------------------------------------------------------------------

    local function createButton(Type,parent, posX, posY, sizeX, sizeY, imagePath)
        local button = vgui.Create(Type, parent)
        button:SetPos(posX, posY)
        button:SetSize(sizeX, sizeY)
        button:SetImage(imagePath)
        return button
    end
    
    local function createLabel(parent, posX, posY, text, width, height, font, color)
        local label = vgui.Create("DLabel", parent)
        label:SetPos(posX, posY)
        label:SetTextColor(color)
        label:SetFont(font)
        label:SetSize(width, height)
        label:SetText(text)
        return label
    end

    local function createScroller(parent, x, y)
        local scroller = vgui.Create("DHorizontalScroller", parent)
        scroller:SetSize(913, 67)
        scroller:SetPos(x, y)
        scroller:SetOverlap(-4)

        function scroller.btnLeft:Paint(w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(200, 100, 0, 0))
        end

        function scroller.btnRight:Paint(w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(0, 100, 200, 0))
        end

        return scroller
    end

    function ENT:Draw()

        self:DrawModel()
        ------------------------------------------------------------------------------------------
        local pos, ang = self:LocalToWorld(Vector(0,0,0)), self:GetAngles()
        local dist = LocalPlayer():EyePos():Distance(self:GetPos())
        local viewdist = 140
        local viewdistmax = viewdist
        local viewdistmin = viewdist*0,75
        local text_1, text_2 = 'БЛИНДОЗЕР Ser.№' ..self:EntIndex(), 'HP: ' ..bler_cfg.bler_heth..' / 500 %'
        bler_cfg.bler_heth = self:Health()
        ------------------------------------------------------------------------------------------

        if dist > viewdistmin and dist < viewdistmax then
            alpha = 255
        elseif dist > viewdistmax then 
            alpha = 0   
        end

        if alpha > 0 then
            cam.Start3D2D(pos, ang, 0.1)
                draw.SimpleText(text_1, 'TheDefaultSettings2', -15, 210, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                draw.SimpleText(text_2, 'TheDefaultSettings2', -15, 280, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                draw.RoundedBox(5,-370,320,700,30,color_white)
                if self:Health() <= 500 then
                    draw.RoundedBox(5,-367,323,math.Clamp(self:Health(),0,694)*1.387,24,Color(206,154,10,200))
                else
                    draw.RoundedBox(5,-367,323,694,24,Color(206,154,10,200))
                end
            cam.End3D2D()
        end
    end

    function ENT:InitUIelement()

        local __ent = self;
        if(self.mainwindow == nil or not self.mainwindow:IsValid()) then 
            local frame1 = vgui.Create("DFrame")
            frame1:CenterHorizontal(0.25)
            frame1:CenterVertical(0.15)
            frame1:SetSize(1000, 820)
            frame1:SetTitle("")
            frame1:SetVisible(true)
            frame1:SetDraggable(true)
            frame1:MakePopup()
            frame1.Paint = function(self,w,h)
                Derma_DrawBackgroundBlur(self, self.startTime)
                draw.RoundedBox(2, 0, 0, w, h, Color(0,0,0,0))
            end

                if bler_cfg.bler_heth > 0 then
                    local button1 = createButton('DImageButton',frame1,0,0,1000,820,'materials/metrostroi_3demc/vending_machine/BLINDOZER_GUI/GUI_YES.png')  
                    button1.DoClick = function()
                        chat.PlaySound()
                        frame2()
                        frame1:Close()
                    end
                else
                    local button1 = createButton('DImageButton',frame1,0,0,1000,820,'materials/metrostroi_3demc/vending_machine/BLINDOZER_GUI/GUI_NO.png')
                    button1.DoClick = function()
                        chat.AddText( Color( 255, 183, 11 ),'BLINDOZER: ',Color( 200, 200, 200 ), 'Аппарат походу сломался, приходите позже.')
                        frame1:Close()
                    end
                end
            frame1:Hide()
            self.mainwindow = frame1;
        end
        return self.mainwindow
    end

    function frame2()

        local frame2 = vgui.Create("DFrame")
        frame2:CenterHorizontal(0.25)
        frame2:CenterVertical(0.15)
        frame2:SetSize(1000, 820)
        frame2:SetTitle("")
        frame2:SetVisible(true)
        frame2:SetDraggable(true)
        frame2:MakePopup()
        frame2.Paint = function(self,w,h)
            Derma_DrawBackgroundBlur(self, self.startTime)
            draw.RoundedBox(2, 0, 0, w, h, Color(0,0,0,0))
        end

        createButton('DImage',frame2,0,0,1000,820,'materials/metrostroi_3demc/vending_machine/BLINDOZER_GUI/GUI_ONE.png')

        local button_next = createButton('DImageButton',frame2,727,63,232,59,'materials/metrostroi_3demc/vending_machine/BLINDOZER_GUI/BUTTON_NEXT.png')
        button_next.DoClick = function()
            chat.PlaySound()
            frame4()
            frame2:Close()
        end

        local PosX = 42
        local PosY = 175

        for k, v in SortedPairs(bler_menu) do 
            if k <= 8 then
                local button_menu = createButton('DImageButton',frame2,PosX,PosY,220,280,v.Icon)
                button_menu.DoClick = function()
                    keysl = k
                    chat.PlaySound()
                    frame5()
                    frame2:Close()
                end
                button_menu.OnCursorEntered = function()
                    button_menu:SetSize(220 * 1.02, 280 * 1.02)
                end
                    
                button_menu.OnCursorExited = function()
                    button_menu:SetSize(220, 280)
                end
                if PosX < 736 then
                    PosX = PosX + 232
                elseif PosX > 736 then
                    PosY = PosY + 300
                    PosX = PosX - 693
                elseif PosY == 475 or PosX < 736 then
                    PosX = PosX + 232
                end
            end
        end
    end 
    function endframe5()
        for i = 1, 10 do
            if bler_dobavka[i].Condition then
                bler_dobavka[i].Condition = false
                bler_menu[keysl].Price = bler_menu[keysl].Price - bler_dobavka[i].Price
                bler_menu[keysl].Calories = bler_menu[keysl].Calories - bler_dobavka[i].Calories
                bler_menu[keysl].Squirrels = bler_menu[keysl].Squirrels - bler_dobavka[i].Squirrels
                bler_menu[keysl].Fats = bler_menu[keysl].Fats - bler_dobavka[i].Fats
                bler_menu[keysl].Carbohydrates = bler_menu[keysl].Carbohydrates - bler_dobavka[i].Carbohydrates
                bler_menu[keysl].Weight = bler_menu[keysl].Weight - bler_dobavka[i].Weight
            end
        end
        for i = 1, 5 do
            if bler_doping[i].Condition then
                bler_doping[i].Condition = false
                bler_menu[keysl].Price = bler_menu[keysl].Price - bler_doping[i].Price
                bler_menu[keysl].Calories = bler_menu[keysl].Calories - bler_doping[i].Calories
                bler_menu[keysl].Squirrels = bler_menu[keysl].Squirrels - bler_doping[i].Squirrels
                bler_menu[keysl].Fats = bler_menu[keysl].Fats - bler_doping[i].Fats
                bler_menu[keysl].Carbohydrates = bler_menu[keysl].Carbohydrates - bler_doping[i].Carbohydrates
                bler_menu[keysl].Weight = bler_menu[keysl].Weight - bler_doping[i].Weight
            end
        end
    end

    function frame4()

        local frame4 = vgui.Create("DFrame")
        frame4:CenterHorizontal(0.25)
        frame4:CenterVertical(0.15)
        frame4:SetSize(1000, 820)
        frame4:SetTitle("")
        frame4:SetVisible(true)
        frame4:SetDraggable(true)
        frame4:MakePopup()
        frame4.Paint = function(self,w,h)
            Derma_DrawBackgroundBlur(self, self.startTime)
            draw.RoundedBox(2, 0, 0, w, h, Color(0,0,0,0))
        end

        createButton('DImage',frame4,0,0,1000,820,'materials/metrostroi_3demc/vending_machine/BLINDOZER_GUI/GUI_ONE.png')

        local button_next = createButton('DImageButton',frame4,727,63,232,59,'materials/metrostroi_3demc/vending_machine/BLINDOZER_GUI/BUTTON_NEXT.png')
        button_next.DoClick = function()
            chat.PlaySound()
            frame2()
            frame4:Close()
        end 

        local PosX = 42
        local PosY = 175

        for k, v in SortedPairs(bler_menu) do 
            if k >= 9 then
                local button_menu = createButton('DImageButton',frame4,PosX,PosY,220,280,v.Icon)
                button_menu.DoClick = function()
                    keysl = k
                    chat.PlaySound()
                    frame5()
                    frame4:Close()
                end
                button_menu.OnCursorEntered = function()
                    button_menu:SetSize(220 * 1.02, 280 * 1.02)
                end
                    
                button_menu.OnCursorExited = function()
                    button_menu:SetSize(220, 280)
                end
                if PosX < 736 then
                    PosX = PosX + 232
                elseif PosX > 736 then
                    PosY = PosY + 300
                    PosX = PosX - 693
                elseif PosY == 475 or PosX < 736 then
                    PosX = PosX + 232
                end
            end
        end
    end 

    function refresh()
        if frame5() == nil then
            print('')
        end
    end
    function frame5()

        local pricesborka = bler_menu[keysl].Price
        local frame5 = vgui.Create("DFrame")
        frame5:CenterHorizontal(0.25)
        frame5:CenterVertical(0.15)
        frame5:SetSize(1000, 820)
        frame5:SetTitle("")
        frame5:SetVisible(true)
        frame5:SetDraggable(true)
        frame5:MakePopup()
        frame5.Paint = function(self, w, h)
            Derma_DrawBackgroundBlur(self, self.startTime)
            draw.RoundedBox(2, 0, 0, w, h, Color(0, 0, 0, 0))
        end

        local GUIIMAGE3 = createButton('DImage', frame5, 0, 0, 1000, 820, "materials/metrostroi_3demc/vending_machine/BLINDOZER_GUI/GUI_THREE.png")
        local IMAGE1 = createButton('DImage', frame5, 42, 175, 220, 280, bler_menu[keysl].Icon)
        local BUTTON_OTMENA = createButton('DImageButton', frame5, 42, 705, 220, 58, "materials/metrostroi_3demc/vending_machine/BLINDOZER_GUI/Otmena_zakaz.png")
        BUTTON_OTMENA.DoClick = function()
            chat.PlaySound()
            endframe5()
            frame2()
            frame5:Close()
        end

        if BUTTON_OTMENA:Toggle() then
            print('hello')
        end

        local BUTTON_CUPIT = createButton('DImageButton', frame5, 736, 705, 220, 58, "materials/metrostroi_3demc/vending_machine/BLINDOZER_GUI/Olatit_zakaz.png")
        BUTTON_CUPIT.DoClick = function()
            endframe5()
            frame5:Close()
        end

        createLabel(frame5, 370, 248, bler_menu[keysl].Weight .. ' г', 100, 25, "TheDefaultSettings", Color(0, 0, 0))
        createLabel(frame5, 465, 295, bler_menu[keysl].Calories .. ' ККал', 100, 25, "TheDefaultSettings", Color(0, 0, 0))
        createLabel(frame5, 284, 333, bler_menu[keysl].Composition, 460, 100, "TheDefaultSettings", Color(0, 0, 0))
        if bler_menu[keysl].Composition1 then
            createLabel(frame5, 284, 390, bler_menu[keysl].Composition1, 460, 100, "TheDefaultSettings", Color(0, 0, 0))
        end
        createLabel(frame5, 840, 258, bler_menu[keysl].Squirrels .. 'г', 350, 25, "TheDefaultSettings", Color(0, 0, 0))
        createLabel(frame5, 840, 298, bler_menu[keysl].Fats .. 'г', 350, 25, "TheDefaultSettings", Color(0, 0, 0))
        createLabel(frame5, 880, 340, bler_menu[keysl].Carbohydrates .. 'г', 350, 25, "TheDefaultSettings", Color(0, 0, 0))
        createLabel(frame5, 410, 720, 'Общая стоимость: ' ..pricesborka, 350, 25, "TheDefaultSettings", Color(0, 0, 0))
        createLabel(frame5, 280, 200, bler_menu[keysl].Name, 350, 25, "TheDefaultSettings", Color(120, 120, 120))
        createLabel(frame5, 280, 158, bler_menu[keysl].Name, 350, 60, "TheDefaultSettings2", Color(0, 0, 0))
        local Conteiner = createScroller(frame5, 42, 498)
        local Conteiner1 = createScroller(frame5, 42, 610)
        local posx = 0
        local function createImageButton(container, buttonData, posX)
            local button = vgui.Create("DImageButton", container)
            button:SetImage(buttonData.Condition and buttonData.Icon_true or buttonData.Icon_false)
            button:SetSize(220, 55)
            button:SetPos(posX, 0)
            button.DoClick = function()
                buttonData.Condition = not buttonData.Condition
                local modifier = buttonData.Condition and 1 or -1
                bler_menu[keysl].Price = bler_menu[keysl].Price + buttonData.Price * modifier
                bler_menu[keysl].Calories = bler_menu[keysl].Calories + buttonData.Calories * modifier
                bler_menu[keysl].Squirrels = bler_menu[keysl].Squirrels + buttonData.Squirrels * modifier
                bler_menu[keysl].Fats = bler_menu[keysl].Fats + buttonData.Fats * modifier
                bler_menu[keysl].Carbohydrates = bler_menu[keysl].Carbohydrates + buttonData.Carbohydrates * modifier
                bler_menu[keysl].Weight = bler_menu[keysl].Weight + buttonData.Weight * modifier
                frame5:Close()
                refresh()
            end
            container:AddPanel(button)
        end

        local function allConditionsFalse()
            if keysl == 1 or keysl == 2 then
                for i = 1, 10 do
                    if bler_dobavka[i].Condition then
                        return false
                    end
                end
                for i = 1, 5 do
                    if bler_doping[i].Condition then
                        return false
                    end
                end
                return true
            end
        end
        if allConditionsFalse() then
            local frame5_1 = vgui.Create("DPanel", frame5)
            frame5_1:SetPos(42, 462)
            frame5_1:SetSize(645, 40)
            frame5_1.Paint = function(self, w, h)
                draw.SimpleText("Блин пока что пустой, добавте, что нибудь:", "TheDefaultSettings2", 0, 0, Color(255, 0, 0))
            end
        end
        if keysl == 1 then 
            for k, _ in SortedPairs(bler_dobavka) do
                for _, v in pairs(bler_cfg.bler_add_mo_dobavka) do 
                    if k == v then
                        createImageButton(Conteiner, bler_dobavka[k], posx)
                        posx = posx + 232
                    end
                end
            end
            for k, _ in SortedPairs(bler_doping) do
                for _, v in pairs(bler_cfg.bler_add_mo_doping) do 
                    if k == v then
                        createImageButton(Conteiner1, bler_doping[k], posx)
                        posx = posx + 232
                    end
                end
            end
        elseif keysl == 2 then
            for k, _ in SortedPairs(bler_dobavka) do
                for _, v in pairs(bler_cfg.bler_add_s_dobavka) do 
                    if k == v then
                        createImageButton(Conteiner, bler_dobavka[k], posx)
                        posx = posx + 232
                    end
                end
            end
            for k, _ in SortedPairs(bler_doping) do
                for _, v in pairs(bler_cfg.bler_add_s_doping) do 
                    if k == v then
                        createImageButton(Conteiner1, bler_doping[k], posx)
                        posx = posx + 232
                    end
                end
            end
        elseif keysl > 2 and keysl < 13 then
            for k, _ in SortedPairs(bler_doping) do
                for _, v in pairs(bler_cfg.bler_add_ep_doping) do 
                    if k == v then
                        createImageButton(Conteiner1, bler_doping[k], posx)
                        posx = posx + 232
                    end
                end
            end
        elseif keysl > 12 then 
            for k, _ in SortedPairs(bler_doping) do
                for _, v in pairs(bler_cfg.bler_add_s_doping) do 
                    if k == v then
                        createImageButton(Conteiner1, bler_doping[k], posx)
                        posx = posx + 232
                    end
                end
            end
        end
    end
    net.Receive( "message_box", function( len, ply )
        local ent = net.ReadEntity()
        local r_table = net.ReadTable()
        local status = ent:InitUIelement()
        ent.MessageData = r_table
        owner = r_table.OWNER
        usersee = r_table.USER:SteamID()
        status:Show()
    end)
end