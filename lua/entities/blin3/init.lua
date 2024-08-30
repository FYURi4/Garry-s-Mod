AddCSLuaFile('shared.lua')
AddCSLuaFile('cl_init.lua')
include('shared.lua')
include('cl_init.lua')
util.AddNetworkString( "message_box" )
function ENT:Initialize()

	self:SetModel('models/metrostroi_3demc/metrostroi_vending_machine/blinchiki/blin3.mdl');
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS);
	self:SetUseType(SIMPLE_USE);
	local phys = self:GetPhysicsObject()
	self.ID_ENTITY = "blin_ovosh_maso"
	self.MessageData = {}
 
	phys:SetMass(1000); 
	phys:SetVelocity((self:GetUp()*2));
	if phys:IsValid() then 
		phys:Wake(); 
	end
end	

function ENT:Use(activator)
	self.MessageData["USER"] = activator
	if activator:Health() == 100 then
		activator:ChatPrint('Вы походу не голодны, попробуйте в другой раз.')
	else
		local peremennaya1 = activator:GetMaxHealth() - activator:Health()
		activator:SetHealth(activator:Health() + peremennaya1)
		self:Remove()
	end
	--activator:ChatPrint(table.ToString(self.MessageData))
end