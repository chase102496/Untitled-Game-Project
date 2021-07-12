#region Init config and tools
//
function scrEquipStateInit(_default) : conStateInit(_default) constructor
{
}
///
function scrEquipStateMemory() //Used to store the previous state in memory
{
	if state.stored != state.current state.previous = state.stored;
	
	state.stored = state.current;
}
///
function scrEquipBroadcastListener() //Used to run one-time evensts
{
	if event_data[? "event_type"] == "sequence event"
	{
		switch (event_data[? "message"])
	    {
		    case "seqGreatswordStab-2f":
			{
		        owner.stats.hVel += sign(owner.stats.xScale)*1;
		        break;
			}
		}
	}
}
///
function scrSequenceCreator(_sequence)
{
	if currentSequence != _sequence
	{
		currentSequence = _sequence;
		currentSequenceElement = layer_sequence_create(currentLayer,owner.x,owner.y,currentSequence);
		currentSequenceInstance = layer_sequence_get_instance(currentSequenceElement);
		sequence_instance_override_object(currentSequenceInstance,object_index,id)
	}
}
//
#endregion

#region Empty states
//
function scrEquipStateEmpty()
{
	image_index = 1;
	sprite_index = sprStick;
}
function scrEquipStateEmptyIdle()
{
}
//
#endregion

#region Greatsword states
//
function scrEquipStateGreatsword()
{
}
//
function scrEquipStateGreatswordChangeDirection() //Switching directions
{
	//Sequence init
	scrSequenceCreator(seqGreatswordChangeDirection);
	
	//Modules
	scrEquipAnimations();
	
	//State switches
	if !in_sequence state.current = state.previous;
	if keyAttackPrimaryPress state.current[1] = scrEquipStateGreatswordStab;
}
//
function scrEquipStateGreatswordIdle() //Idle
{
	//Config
	sprite_index = sprGreatswordIdle;
	
	//Sequence init
	scrSequenceCreator(seqGreatswordIdle);
	
	//Modules
	scrEquipAnimations();
	
	//State switches
	if changedDirection != 0 state.current[1] = scrEquipStateGreatswordChangeDirection;
	if keyAttackPrimaryPress state.current[1] = scrEquipStateGreatswordStab;
}
//
function scrEquipStateGreatswordStab() //Stab Attack
{
	//Sequence init
	scrSequenceCreator(seqGreatswordStab);	
	with owner
	{
		state.current = scrPlayerStateAttack;
		if stats.hVel != 0
		{
		if (abs(stats.hVel) >= stats.hSlideDecel) stats.hVel -= sign(stats.hVel) * stats.hSlideDecel;
		else stats.hVel = 0;
		}
	}
	
	//Modules
	scrEquipAnimations();
	
	//State switches
	if !in_sequence
	{
		owner.state.current = owner.state.previous;
		state.current[1] = scrEquipStateGreatswordIdle;
	}
}
//
#endregion

#region Bow states
//
function scrEquipStateBow()
{
}
//
function scrEquipStateBowChangeDirection() //Switching directions
{
	//Sequence init
	scrSequenceCreator(seqBowChangeDirection);
	
	//Modules
	scrEquipAnimations();
	
	//State switches
	if !in_sequence state.current = state.previous;
	if keyAttackPrimaryPress state.current = [scrEquipStateBow, scrEquipStateBowDraw];
}
//
function scrEquipStateBowIdle() //Idle
{	
	//Config
	sprite_index = sprBowIdle;
	aimRange[0] = 75; //Aim limit down
	aimRange[1] = 75; //Aim limit up
	
	//Sequence init
	scrSequenceCreator(seqBowIdle);
		
	//Modules
	scrEquipAnimations();
	
	//State switches
	if changedDirection != 0 state.current[1] = scrEquipStateBowChangeDirection;
	if keyAttackPrimaryHold state.current[1] = scrEquipStateBowDraw;
}
//
function scrEquipStateBowDraw() //Primary Attack - Draw
{
	//Config
	sprite_index = sprBowDraw;
	var _slow = 0.5; //Slow during hold

	//Sequence init
	scrSequenceCreator(seqBowDraw);
	image_index = layer_sequence_get_headpos(currentSequenceElement);

	//Extra
	owner.stats.hVel = clamp(owner.stats.hVel,-owner.stats.hMaxVel*_slow,owner.stats.hMaxVel*_slow); //Limiting player movement during draw
	
	if sign(mouse_x - owner.x) >= 0 state.current[2] = [scrBowAiming,1];
	else state.current[2] = [scrBowAiming,-1];

	//Projectile init
	if !instance_exists(equipProjectile)
	{
		equipProjectile = instance_create_layer(x,y,"layProjectile",objProjectile);
		equipProjectile.owner = owner.id;
		equipProjectile.equip = id;
		with equipProjectile
		{
			sprite_index = sprArrow;
			stateHold = [scrProjectileStateHoldArrow];
			state.free = [[scrProjectileStateFree,true,true,true,true,3]];
			state.collideTerrain = [[scrProjectileStateCollide,objTerrain,3]];
			state.collideEntity = [[scrProjectileStateCollide,objEntity,3]];
			state.destroy = [scrProjectileStateDestroy];
			state.current = stateHold;
			
			entityBuffs = [[scrBuffsStats,global.buffsID.swiftness,"hMaxVel",7,2.0]]; //script:scrBuffsStats id:swiftness statchange:hMaxVel time:7s strength:2.0
			entityStats = [100,"Physical",true]; //Do 10 magical damage, with flinching
		}
	}
	else equipProjectile.projectilePower = round(((image_index+1)/image_number) * equipProjectile.projectilePowerMax); //Projectile power updating var as bow pulls back, power goes up
	
	//State switches
	if !keyAttackPrimaryHold
	{
		equipProjectile.state.current = equipProjectile.state.free;
		equipProjectile = noone;
		state.current = [scrEquipStateBow,scrEquipStateBowIdle];
	}
	else if !in_sequence
	{
		state.current[1] = scrEquipStateBowHold;
	}
}
//
function scrEquipStateBowHold() //Primary Attack - Hold
{
	//Config
	sprite_index = sprBowDraw;
	image_index = image_number-1; //set to last frame of scrEquipStateBowDraw
	var _slow = 0.5; //Slow during hold
	
	//Projectile power
	equipProjectile.projectilePower = equipProjectile.projectilePowerMax;
	
	//Extra
	owner.stats.hVel = clamp(owner.stats.hVel,-owner.stats.hMaxVel*_slow,owner.stats.hMaxVel*_slow); //Limiting player movement during hold
	
	//Sequence init
	scrSequenceCreator(seqBowHold);
	
	//State switches
	if !keyAttackPrimaryHold state.current[1] = scrEquipStateBowFire;
}
//
function scrEquipStateBowFire() //Primary Attack - Fire
{
	//Config
	sprite_index = sprBowFire;

	//Sequence init
	scrSequenceCreator(seqBowFire);

	if instance_exists(equipProjectile)
	{
		equipProjectile.state.current = equipProjectile.state.free
		equipProjectile = noone; //not associated with the object anymore
	}

	image_index = layer_sequence_get_headpos(currentSequenceElement);

	//State switches
	if !in_sequence state.current = [scrEquipStateBow,scrEquipStateBowIdle];
}
//
#endregion

#region Orb states

function scrEquipStateOrb()
{
}
//
function scrEquipStateOrbChangeDirection()
{
	//Sequence init
	scrSequenceCreator(seqOrbChangeDirection);
	
	//Modules
	scrEquipAnimations();
	
	//State switches
	if !in_sequence state.current = state.previous;
	if keyAttackPrimaryPress state.current[1] = scrEquipStateOrbCharge;
}
//
function scrEquipStateOrbIdle()
{
	//Config
	sprite_index = sprOrbIdle;
	aimRange[0] = 15; //Aim limit, purely cosmetic for this use
	aimRange[1] = 15; //
	
	//Sequence init
	scrSequenceCreator(seqOrbIdle);
		
	//Modules
	scrEquipAnimations();
	
	//State switches
	if changedDirection != 0 state.current[1] = scrEquipStateOrbChangeDirection;
	if keyAttackPrimaryHold state.current[1] = scrEquipStateOrbCharge;
}
//
function scrEquipStateOrbCharge()
{
	//Sequence init
	scrSequenceCreator(seqOrbCharge);
	
	//Extra
	if sign(mouse_x - owner.x) >= 0 state.current[2] = [scrBowAiming,1];
	else state.current[2] = [scrBowAiming,-1];
	
	with owner
	{
		var _mod = 2; //decel at twice the normal rate
		state.current = scrPlayerStateAttack;
		
		if stats.hVel != 0
		{
			if (abs(stats.hVel) >= stats.hSlideDecel*_mod) stats.hVel -= sign(stats.hVel) * stats.hSlideDecel*_mod;
			else stats.hVel = 0;
		}
	}
	
	owner.stats.hVel = clamp(owner.stats.hVel,-owner.stats.hMaxVel/2,owner.stats.hMaxVel/2); //Limiting player movement during
	
	//State switches
	if !keyAttackPrimaryHold
	{
		owner.state.current = owner.state.previous;
		state.current = [scrEquipStateOrb,scrEquipStateOrbIdle];
	}
	else if !scrInSequence(currentSequenceElement)
	{
		owner.state.current = owner.state.previous;
		state.current[1] = scrEquipStateOrbCast;
	}
}
//
function scrEquipStateOrbCast()
{
	//Sequence init
	scrSequenceCreator(seqOrbCast);
	
	//Projectile init
	if !instance_exists(equipProjectile)
	{
		var _range = 128; //Sets cast range to 128 pixels
		var _castRange = scrCastRange(owner.x,owner.y,mouse_x,mouse_y,_range);
		
		equipProjectile = instance_create_layer(_castRange[0],_castRange[1],"layProjectile",objProjectile); //[0] is x, [1] is y
		equipProjectile.owner = owner.id;
		equipProjectile.equip = id;
		with equipProjectile
		{
			sprite_index = sprArcaneBlast;
			
			//State init
			state.free = [[scrProjectileStateFree,false,false,true,false,-2]]; //Static projectile, lasts until animation end
			state.collideEntity = [[scrProjectileStateCollide,objEntity,-2]]; //Normal collision with entities, but last until animation end
			state.destroy = [scrProjectileStateDestroy];
			state.current = state.free;
			
			//Buff and stat transfer init
			entityBuffs = [[scrBuffsStats,global.buffsID.swiftness,"hMaxVel",7,2.0]]; //script:scrBuffsStats id:swiftness statchange:hMaxVel time:7s strength:2.0
			entityStats = [10,"Magical",true]; //Do 10 magical damage, with flinching
		}
	}
	else equipProjectile.image_index = round((equipProjectile.image_number-1)*scrSequenceRatio());

	//State switches, for some reason !in_sequence isn't working so i made a better script than YoYo
	if !scrInSequence(currentSequenceElement) state.current = [scrEquipStateOrb,scrEquipStateOrbIdle];
}

#endregion