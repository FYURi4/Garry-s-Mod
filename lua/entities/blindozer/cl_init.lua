include('shared.lua')
include('data_base.lua')

if CLIENT then
--[SHRIFTS]--
    surface.CreateFont( "TheDefaultSettings", {font = "ChatFont", extended = false,size = 22,weight = 500,blursize = 0,scanlines = 0,antialias = true,underline = false,italic = false,strikeout = false,symbol = false,rotary = false,shadow = false,additive = false,outline = false, } )
    surface.CreateFont( "TheDefaultSettings2", {font = "ChatFont", extended = false,size = 28,weight = 500,blursize = 0,scanlines = 0,antialias = true,underline = false,italic = false,strikeout = false,symbol = false,rotary = false,shadow = false,additive = false,outline = false, } )
    surface.CreateFont('info', {font = 'Open Sans Bold',size = 20,weight = 600} )   
--[CODE START]--
    local keysl = nil
    local owner = nil
    local usersee = nil
    --[FUNCTION ENT_DRAW - Drawing graphic elements on a blindozer]
    function ENT:Draw()
        self:DrawModel()
        local pos, ang = self:LocalToWorld(Vector(0,0,0)), self:GetAngles() --The position of the blindozer in the world, the angle--
        local dist = LocalPlayer():EyePos():Distance(self:GetPos()) --The player's distance to the object--
        local viewdist = 140 --Maximum display distance-
        local viewdistmax = viewdist
        local blindozer_hp = self:Health() --Local health variable--
        local viewdistmin = viewdist*0,75 --The minimum value of the interface display--
        local text_1, text_2 = 'БЛИНДОЗЕР Ser.№' ..self:EntIndex(), 'HP: ' ..blindozer_hp..' / 500 %'
        blindozer_config.blindozer_health = self:Health() --The blindozer's health is entered in the table--

        if dist > viewdistmin and dist < viewdistmax then
            alpha = 255
        elseif dist > viewdistmax then 
            alpha = 0   
        end

    --Rendering the interface on a blindozer--
        if alpha > 0 then
            cam.Start3D2D(pos, ang, 0.1)
                draw.SimpleText(text_1, 'TheDefaultSettings2', -15, 210, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                draw.SimpleText(text_2, 'TheDefaultSettings2', -15, 280, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                draw.RoundedBox(5,-370,320,700,30,color_white)
                if blindozer_hp <= 500 then
                    draw.RoundedBox(5,-367,323,math.Clamp(blindozer_hp,0,694)*1.387,24,Color(206,154,10,200))
                else
                    draw.RoundedBox(5,-367,323,694,24,Color(206,154,10,200))
                end
            cam.End3D2D()
        end
    end

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
                draw.RoundedBox(2, 0, 0, w, h, Color(0,0,0,20))
            end
                local image1 = vgui.Create("DImageButton", frame1)
                image1:SetPos(0, 0)
                image1:SetSize(1000, 820)      
                if blindozer_config.blindozer_health > 0 then
                    image1:SetImage("materials/metrostroi_3demc/vending_machine/BLINDOZER_GUI/GUI_YES.png")
                    image1.DoClick = function()
                        chat.PlaySound()
                        frame2()
                        frame1:Close()
                    end
                else
                    image1:SetImage("materials/metrostroi_3demc/vending_machine/BLINDOZER_GUI/GUI_NO.png")
                    image1.DoClick = function()
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
            draw.RoundedBox(2, 0, 0, w, h, Color(0,0,0,0))
        end

        local GUIIMAGE = createButton('DImage',frame2,0,0,1000,820,"materials/metrostroi_3demc/vending_machine/BLINDOZER_GUI/GUI_ONE.png")
        local BUTTON_NEXT = createButton('DImageButton',frame2,727,63,232,59,"materials/metrostroi_3demc/vending_machine/BLINDOZER_GUI/BUTTON_NEXT.png")
        BUTTON_NEXT.DoClick = function()
            chat.PlaySound()
            frame4()
            frame2:Close()
        end 
        if usersee == owner then
            local BUTTON_STATISTIC = createButton('DImageButton',frame2,866,780,90,21,"materials/metrostroi_3demc/vending_machine/BLINDOZER_GUI/BUTTON_STATISTICS.png")
            BUTTON_STATISTIC.DoClick = function()
                chat.PlaySound()
                frame3()
                frame2:Close()
            end
        end

        local x = 42
        local y = 175
        for k,v in SortedPairs(blindozer_menu) do
            if k <= 8 then     
                local BUTTON_MENU = createButton('DImageButton',frame2,x,y,220,280,v.icon)
                BUTTON_MENU.DoClick = function()
                    chat.PlaySound()
                    keysl = v 
                    frame5()
                    frame2:Close()
                end
                BUTTON_MENU.OnCursorEntered = function()
                    BUTTON_MENU:SetSize(220 * 1.02, 280 * 1.02)
                end
                    
                BUTTON_MENU.OnCursorExited = function()
                    BUTTON_MENU:SetSize(220, 280)
                end
                if x < 736 then
                    x = x + 232
                elseif x > 736 then
                    y = y + 300
                    x = x - 693
                elseif y == 475 or x < 736 then
                    x = x + 232
                end  
            end
        end
    end
    function frame3()
        local blinhp = blindozer_config.blindozer_health
        local frame3 = vgui.Create("DFrame")
        frame3:CenterHorizontal(0.25)
        frame3:CenterVertical(0.15)
        frame3:SetSize(1000, 820)
        frame3:SetTitle("")
        frame3:SetVisible(true)
        frame3:SetDraggable(true)
        frame3:MakePopup()
        frame3.Paint = function(self,w,h)
            draw.RoundedBox(2, 0, 0, w, h, Color(0,0,0,0))
        end
        local GUIIMAGE2 = createButton("DImage",frame3,0,0,1000,820,"materials/metrostroi_3demc/vending_machine/BLINDOZER_GUI/GUI_TWO.png")
        if blinhp <= 500 then
            local GUIIMAGE3 = createButton("DImage",frame3,56,693,math.Clamp(blinhp,0,437)*0.999,13,"materials/metrostroi_3demc/vending_machine/BLINDOZER_GUI/BAR_HEALTH.png")
        else
            local GUIIMAGE3 = createButton("DImage",frame3,56,693,437,13,"materials/metrostroi_3demc/vending_machine/BLINDOZER_GUI/BAR_HEALTH.png")
        end 
        createLabel(frame3, 180, 689,'Состояние аппарата', 300, 25, "TheDefaultSettings", Color(255, 255, 255))
        local mGUIMaso = createButton("DImage",frame3, 325, 177, 85, 58, "materials/metrostroi_3demc/vending_machine/BLINDOZER_GUI/mGUI_1.png")
        local mGUIMaso = createButton("DImage",frame3, 138, 177, 85, 58, "materials/metrostroi_3demc/vending_machine/BLINDOZER_GUI/mGUI_1.png")
        local mGUIMaso = createButton("DImage",frame3, 325, 537, 85, 58, "materials/metrostroi_3demc/vending_machine/BLINDOZER_GUI/mGUI_1.png")
        local mGUIMaso = createButton("DImage",frame3, 376, 447, 85, 58, "materials/metrostroi_3demc/vending_machine/BLINDOZER_GUI/mGUI_3.png")
        local mGUIMaso = createButton("DImage",frame3, 376, 357, 85, 58, "materials/metrostroi_3demc/vending_machine/BLINDOZER_GUI/mGUI_3.png")
        local mGUIMaso = createButton("DImage",frame3, 376, 267, 85, 58, "materials/metrostroi_3demc/vending_machine/BLINDOZER_GUI/mGUI_3.png")
        local mGUIMaso = createButton("DImage",frame3, 87, 440, 85, 70, "materials/metrostroi_3demc/vending_machine/BLINDOZER_GUI/mGUI_2.png")
        local mGUIMaso = createButton("DImage",frame3, 87, 350, 85, 70, "materials/metrostroi_3demc/vending_machine/BLINDOZER_GUI/mGUI_2.png")
        local mGUIMaso = createButton("DImage",frame3, 87, 260, 85, 70, "materials/metrostroi_3demc/vending_machine/BLINDOZER_GUI/mGUI_2.png")
        local BUTTON_SPEED = createButton("DImageButton",frame3, 557, 560, 101, 36, "materials/metrostroi_3demc/vending_machine/BLINDOZER_GUI/BUTTON_1LVL.png")
        local BUTTON_EKONOMIA = createButton("DImageButton",frame3, 697, 560, 101, 36, "materials/metrostroi_3demc/vending_machine/BLINDOZER_GUI/BUTTON_1LVL.png")
        local BUTTON_PROCHNIY = createButton("DImageButton",frame3, 843, 560, 101, 36, "materials/metrostroi_3demc/vending_machine/BLINDOZER_GUI/BUTTON_1LVL.png")
        local BUTTON_CAMERA = createButton("DImageButton",frame3, 557, 632, 387, 36, "materials/metrostroi_3demc/vending_machine/BLINDOZER_GUI/BUTTON_CAMERA_NO.png")

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
            draw.RoundedBox(2, 0, 0, w, h, Color(0,0,0,0))
        end

        local GUIIMAGE1 = createButton('DImage',frame4,0,0,1000,820,"materials/metrostroi_3demc/vending_machine/BLINDOZER_GUI/GUI_ONE.png")
        local BUTTON_NEXT2 = createButton('DImageButton',frame4,727,63,232,59,"materials/metrostroi_3demc/vending_machine/BLINDOZER_GUI/BUTTON_NEXT.png")
        BUTTON_NEXT2.DoClick = function()
            chat.PlaySound()
            frame2()
            frame4:Close()
        end
        local x = 42
        local y = 175
        for k,v in SortedPairs(blindozer_menu) do
            if k >= 9 then     
                local BUTTON_MENU = createButton('DImageButton',frame4,x,y,220,280,v.icon)
                BUTTON_MENU.DoClick = function()
                    chat.PlaySound()
                    keysl = v
                   frame5()
                   frame4:Close()
                end
                BUTTON_MENU.OnCursorEntered = function()
                    BUTTON_MENU:SetSize(220 * 1.02, 280 * 1.02)
                end
                    
                BUTTON_MENU.OnCursorExited = function()
                    BUTTON_MENU:SetSize(220, 280)
                end
                if x < 736 then
                    x = x + 232
                elseif x > 736 then
                    y = y + 300
                    x = x - 693
                elseif y == 475 or x < 736 then
                    x = x + 232
                end  
            end
        end
    end

    function frame5()

        local frame5 = vgui.Create("DFrame")
        frame5:CenterHorizontal(0.25)
        frame5:CenterVertical(0.15)
        frame5:SetSize(1000, 820)
        frame5:SetTitle("")
        frame5:SetVisible(true)
        frame5:SetDraggable(true)
        frame5:MakePopup()
        frame5.Paint = function(self,w,h)
            draw.RoundedBox(2, 0, 0, w, h, Color(0,0,0,0))
        end

        local GUIIMAGE3 = createButton('DImage',frame5,0,0,1000,820,"materials/metrostroi_3demc/vending_machine/BLINDOZER_GUI/GUI_THREE.png")
        local IMAGE1 = createButton('DImage',frame5,42,175,220,280,keysl.icon)
        local BUTTON_OTMENA = createButton('DImageButton',frame5,42,705,220,58,"materials/metrostroi_3demc/vending_machine/BLINDOZER_GUI/Otmena_zakaz.png")
        BUTTON_OTMENA.DoClick = function()
            chat.PlaySound()
            frame2()
            frame5:Close()
        end
        local BUTTON_CUPIT = createButton('DImageButton',frame5,736,705,220,58,"materials/metrostroi_3demc/vending_machine/BLINDOZER_GUI/Olatit_zakaz.png")
        BUTTON_CUPIT.DoClick = function()
            net.Start("Oplata")
                net.WriteTable(keysl)
            net.SendToServer()
            frame5:Close()
        end

        createLabel(frame5, 370, 248, keysl.massa, 100, 25, "TheDefaultSettings", Color(0, 0, 0))
        createLabel(frame5, 465, 295, keysl.colories, 100, 25, "TheDefaultSettings", Color(0, 0, 0))
        createLabel(frame5, 284, 333, keysl.sostav, 460, 100, "TheDefaultSettings", Color(0, 0, 0))
        if keysl.sostav1 then
            createLabel(frame5, 284, 390, keysl.sostav1, 460, 100, "TheDefaultSettings", Color(0, 0, 0))
        end
        createLabel(frame5, 840, 258, keysl.belki, 350, 25, "TheDefaultSettings", Color(0, 0, 0))
        createLabel(frame5, 840, 298, keysl.jiri, 350, 25, "TheDefaultSettings", Color(0, 0, 0))
        createLabel(frame5, 880, 340, keysl.yglevodi, 350, 25, "TheDefaultSettings", Color(0, 0, 0))
        createLabel(frame5, 410, 720, 'Общая стоимость: ' ..keysl.price.. '$', 350, 25, "TheDefaultSettings", Color(0, 0, 0))
        createLabel(frame5, 280, 200, keysl.name, 350, 25, "TheDefaultSettings", Color(120, 120, 120))
        createLabel(frame5, 280, 158, keysl.name, 350, 60, "TheDefaultSettings2", Color(0, 0, 0))
        if keysl.button_dobavka then
            local Conteiner = vgui.Create("DHorizontalScroller", frame5)
                Conteiner:SetSize(913, 67)
                Conteiner:SetPos(42, 498)
                Conteiner:SetOverlap( -4 )
            function Conteiner.btnLeft:Paint( w, h )
                draw.RoundedBox( 0, 0, 0, w, h, Color( 200, 100, 0,0) )
            end
            function Conteiner.btnRight:Paint( w, h )
                draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 100, 200,0) )
            end
      
            local posx = 42
      
            for k, v in pairs(blindozer_menu) do
                if k == 1 then
                    for k, v in SortedPairs(v.button_dobavka) do
                        local DImageButton = vgui.Create("DImageButton",Conteiner)
                        if v.condition == false then 
                            DImageButton:SetImage(v.icon_false)
                        else
                            DImageButton:SetImage(v.icon_true)
                        end
                        DImageButton:SetSize(220, 55)
                        DImageButton:SetPos(posx, 0)
                        DImageButton.DoClick = function()
                            if v.condition == false then 
                                v.condition = true
                            else
                                v.condition = false
                            end
                        end
                        Conteiner:AddPanel( DImageButton )
      
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
--[MADE IN RUSSIAN]--
--[MADE COPY FYURI4]--
--[MADE COPY 3DEMC]--
--[Copyright 2024 BLINDOZER. Все права защищены. ООО "Сити Венд Кафе"]--
