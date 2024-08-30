AddCSLuaFile('shared.lua')
AddCSLuaFile('cl_init.lua')
include('shared.lua')
include('cl_init.lua')
include('data_base.lua')
util.AddNetworkString( "message_box" )
util.AddNetworkString( "Oplata" )
function ENT:Initialize()

	self:SetModel('models/metrostroi_3demc/metrostroi_vending_machine/Blindozer.mdl');
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS);
	self:SetUseType(SIMPLE_USE);
	local phys = self:GetPhysicsObject()
	self.ID_ENTITY = "Blindozer"
	self.MessageData = {}
	self:EntIndex()
	phys:SetMass(1000); 
	phys:SetVelocity((self:GetUp()*2));
	if phys:IsValid() then 
		phys:Wake(); 
	end
	self:SetHealth(500)
end	

function ENT:OnTakeDamage( dmginfo )
	if self:Health() > 0 then
		self:SetHealth(self:Health() - 5)
	end
end

function ENT:Use(activator)
	if(self.MessageData["USER"] != nil) then 

		self.MessageData["LASTUSER"] = self.MessageData["USER"]
	end 
		
	self.MessageData["USER"] = activator

	net.Start( "message_box" )
		net.WriteEntity(self)
		net.WriteTable(self.MessageData)
	net.Send(activator)
	--activator:ChatPrint(table.ToString(self.MessageData))
end

function ENT:PhysicsCollide( colData, collider )
  
	if(self.MessageData["USER"] != nil) then 

		--self.MessageData["USER"]:ChatPrint(tostring(collision_ent))
	end 
end
function ENT:AcceptInput(name,ply,caller)
	net.Receive("Oplata",function(len,ply)
		local sms = net.ReadTable()
		local spawnbutton = ents.Create(sms.model)
		local position = self:LocalToWorld(Vector(0,-28,10))
		spawnbutton:SetPos(position)
		spawnbutton:Spawn()
	end)
end
--[MADE IN RUSSIAN]--
--[MADE COPY FYURI4]--
--[MADE COPY 3DEMC]--
--[Copyright 2024 BLINDOZER. Все права защищены. ООО "Сити Венд Кафе"]--