/*----------------
Playful HUD
by BountieHuntre
----------------*/

local hideHUDElements = {
	["DarkRP_HUD"] = true,
	["DarkRP_EntityDisplay"] = false,
	["DarkRP_ZombieInfo"] = false,
	["DarkRP_LocalPlayerHUD"] = false,
	["DarkRP_Hungermod"] = false,
	["DarkRP_Agenda"] = false
}

hook.Add("HUDShouldDraw", "HideDefaultDarkRPHud", function(name)
	if hideHUDElements[name] then return false end
end)


local function formatNumber(n)

	if not n then return "" end
	if n >= 1e14 then return tostring(n) end
	n = tostring(n)
	local sep = sep or ","
	local dp = string.find(n, "%.") or #n+1
	for i=dp-4, 1, -3 do
		n = n:sub(1, i) .. sep .. n:sub(i+1)
	end
	return n
	
end

local function hudBase()

	local x = 210+110

	-- Background
	draw.RoundedBox(4, 0, ScrH()-200, 400, 200, Color(0,0,0,255))
	draw.RoundedBox(4, 1, ScrH()-199, 398, 198, Color(30,30,30,255))
	
	-- Player Info
	draw.RoundedBox(4, 149, ScrH()-194, 245, 189, Color(0,0,0,255))
	draw.RoundedBox(4, 150, ScrH()-193, 243, 187, Color(20,20,20,255))

end

local function hudHealth()

	local x = 155+233
	local Health = LocalPlayer():Health() or 0
	if Health < 0 then Health = 0 elseif Health > 100 then Health = 100 end
	local DrawHealth = math.Min(Health/GAMEMODE.Config.startinghealth, 1)
	
	draw.RoundedBox(10, 155, ScrH()-75, 233, 20, Color(0,0,0,255))
	if Health != 0 then
		draw.RoundedBox(10, 156, ScrH()-74, 231*DrawHealth, 18, Color(255,0,0,255))
	end
	draw.DrawText("Health", "Akbar_1_Outline", x/2+75, ScrH()-75, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	
end

local function hudArmor()

	local x = 155+233
	local Armor = LocalPlayer():Armor() or 0
	if Armor < 0 then Armor = 0 elseif Armor > 100 then Armor = 100 end
	
	draw.RoundedBox(10, 155, ScrH()-40, 233, 20, Color(0,0,0,255))
	if Armor != 0 then
		draw.RoundedBox(10, 156, ScrH()-39, 231*Armor/100, 18, Color(0, 0, 255, 255))
	end
	draw.DrawText("Armor", "Akbar_1_Outline", x/2+75, ScrH()-40, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	
end
	
local function hudName()

	local Name = LocalPlayer():Nick() or nil
	local x = 149+189
	
	draw.DrawText(Name, "Akbar_1", x/2+105, ScrH()-180, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	
end

local function hudMoney()

	local Money = formatNumber(LocalPlayer():getDarkRPVar("money") or 0)
	
	draw.DrawText("$"..Money, "Akbar_1", 200, ScrH()-145, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	
end

local function hudSalary()
	
	local Salary = formatNumber(LocalPlayer():getDarkRPVar("salary") or 0)
	
	draw.DrawText("+ $"..Salary, "Akbar_1", 200, ScrH()-110, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	
end

local function hudJob()

	local Job = LocalPlayer():getDarkRPVar("job") or ""
	local x = 40+75
	
	draw.RoundedBoxEx(8, 23, ScrH()-40, 110, 20, Color(0,0,0,255), false, false, true, true)
	draw.RoundedBoxEx(8, 24, ScrH()-39, 108, 18, Color( 70, 70, 70, 255 ), false, false, true, true)
	draw.DrawText(Job, "Akbar_1_Outline", x/2+21, ScrH()-40, team.GetColor( LocalPlayer( ):Team( ) ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	
end

local iconLicense	= "icon16/page_red.png"
local iconWanted	= "icon16/exclamation.png"

local function hudIcons()

	if LocalPlayer():getDarkRPVar("HasGunlicense") then
		surface.SetDrawColor(255,255,255,255)
	else
		surface.SetDrawColor(25,25,25,255)
	end
	surface.SetMaterial(Material(iconLicense))
	surface.DrawTexturedRect(325, ScrH()-145, 20, 20)
	
	if LocalPlayer():getDarkRPVar("wanted") then
		surface.SetDrawColor( 255, 255, 255, 255 )
	else
		surface.SetDrawColor( 25, 25, 25, 255 )
	end
	surface.SetMaterial( Material( iconWanted ) )
	surface.DrawTexturedRect(325, ScrH()-110, 20, 20)
	
end

hook.Add("HUDPaint", "PlayerModel", function( )
	local _p = LocalPlayer( );

	// Make sure valid player, otherwise model won't work
	if ( !IsValid( _p ) ) then return; end

	// Useful vars we reuse...
	local _model = _p:GetModel( );

	// Make sure the vgui element hasn't been made...
	if ( !PlayerModel || !ispanel( PlayerModel ) ) then
		PlayerModel = vgui.Create( "DModelPanel" );
		PlayerModel:SetModel( _model );
		PlayerModel.__Model = _model;
		PlayerModel:SetPos( 23, ScrH( ) - 40 - 150 );
		PlayerModel:SetAnimated( false );
		PlayerModel.bAnimated = false; -- SetAnimated should access this, but not sure why it doesn't.. May be a parent panel that takes it over, this should be corrected and I'll look into a fix for it.
		PlayerModel:SetSize( 110, 150 )
		PlayerModel:SetCamPos( Vector( 16, 0, 65 ) );
		PlayerModel:SetLookAt( Vector( 0, 0, 65 ) );
		PlayerModel:ParentToHUD( ); -- If it is used on the HUD...
	end

	// UPDATE the model if it changes
	if ( _p:GetModel( ) != PlayerModel.__Model ) then
		PlayerModel:SetModel( _model );   
		PlayerModel.__Model = _model;
	end

	// Draw it....
	-- up to you.
end );

local function hudPaint()

	hudBase()
	hudHealth()
	hudArmor()
	hudName()
	hudMoney()
	hudSalary()
	hudJob()
	hudIcons()
	
	
		
end
hook.Add("HUDPaint", "DarkRP_Mod_HUDPaint", hudPaint)

/*---------------------------
<Credit>
Acecool - Player Model code
---------------------------*/