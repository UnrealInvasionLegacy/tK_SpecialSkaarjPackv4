//-----------------------------------------------------------
//
//-----------------------------------------------------------
class SSPBountyHunter extends SMPMercenary;

function bool SameSpeciesAs(Pawn P)
{
	return ( Monster(P) != none &&
	(P.IsA('SSPBountyHunter') ||  P.IsA('SSPEliteBountyHunter')));
}

function RangedAttack(Actor A)
{
	local float decision;
	if ( bShotAnim )
		return;
	bShotAnim=true;
	decision = FRand();

	if ( Physics == PHYS_Swimming )
		SetAnimAction('SwimFire');
	else if ( VSize(A.Location - Location) < MeleeRange + CollisionRadius + A.CollisionRadius )
	{
		if(GetAnimSequence()=='Swat')
			decision += 0.2;

		if ( decision < 0.5 )
		{
			SetAnimAction('Swat');
		}
		else
		{
			SetAnimAction('Punch');
		}
		PlaySound(Punch, SLOT_Interact);
		Controller.bPreparingMove = true;
		Acceleration = vect(0,0,0);
	}
	else if ( Velocity == vect(0,0,0) )
	{
		if (decision < 0.35)
		{
			SetAnimAction('Shoot');
			SpawnRocket();
		}
		else
		{
			sprayoffset = 0;
			PlaySound(WeaponSpray, SLOT_Interact);
			SetAnimAction('Spray');
		}
		Controller.bPreparingMove = true;
		Acceleration = vect(0,0,0);
	}
	else
	{
		if (decision < 0.35)
		{
			SetAnimAction('WalkFire');
		}
		else
		{
			sprayoffset = 0;
			PlaySound(WeaponSpray, SLOT_Interact);
			SetAnimAction('WalkSpray');
		}
	}
}

simulated function SprayTarget()
{
	local vector FireStart,X,Y,Z;

	if ( Controller != None )
	{
		GetAxes(Rotation,X,Y,Z);
		FireStart = GetFireStart(X,Y,Z);
		if ( !SavedFireProperties.bInitialized )
		{
			SavedFireProperties.AmmoClass = MyAmmo.Class;
			SavedFireProperties.ProjectileClass = MyAmmo.ProjectileClass;
			SavedFireProperties.WarnTargetPct = MyAmmo.WarnTargetPct;
			SavedFireProperties.MaxRange = MyAmmo.MaxRange;
			SavedFireProperties.bTossed = MyAmmo.bTossed;
			SavedFireProperties.bTrySplash = MyAmmo.bTrySplash;
			SavedFireProperties.bLeadTarget = MyAmmo.bLeadTarget;
			SavedFireProperties.bInstantHit = MyAmmo.bInstantHit;
			SavedFireProperties.bInitialized = true;
		}

		Spawn(MyAmmo.ProjectileClass,,,FireStart,Controller.AdjustAim(SavedFireProperties,FireStart,600));
		PlaySound(Sound'ONSVehicleSounds-S.LaserSounds.Laser01');
	}
}

function SpawnRocket()
{
	local vector RotX,RotY,RotZ,StartLoc;
	local SMPMercRocket R;

	GetAxes(Rotation, RotX, RotY, RotZ);
	StartLoc=GetFireStart(RotX, RotY, RotZ);
	if ( !RocketFireProperties.bInitialized )
	{
		RocketFireProperties.AmmoClass = RocketAmmo.Class;
		RocketFireProperties.ProjectileClass = RocketAmmo.default.ProjectileClass;
		RocketFireProperties.WarnTargetPct = RocketAmmo.WarnTargetPct;
		RocketFireProperties.MaxRange = RocketAmmo.MaxRange;
		RocketFireProperties.bTossed = RocketAmmo.bTossed;
		RocketFireProperties.bTrySplash = RocketAmmo.bTrySplash;
		RocketFireProperties.bLeadTarget = RocketAmmo.bLeadTarget;
		RocketFireProperties.bInstantHit = RocketAmmo.bInstantHit;
		RocketFireProperties.bInitialized = true;
	}

	R=SMPMercRocket(Spawn(RocketAmmo.ProjectileClass,,,StartLoc,Controller.AdjustAim(RocketFireProperties,StartLoc,200)));
	PlaySound(Sound'ONSVehicleSounds-S.AVRiL.AvrilFire01');
	if(bUseSeekingRocket && R!=none)
	{
		R.Seeking = Controller.Enemy;
	}
}

defaultproperties
{
     RocketAmmoClass=Class'tk_SpecialSkaarjPackv4.BountyMissileAmmo'
     WeaponSpray=Sound'ONSVehicleSounds-S.LaserSounds.Laser01'
     MonsterName="BountyHunter"
     AmmunitionClass=Class'tk_SpecialSkaarjPackv4.BountyHunterAmmo'
     Skins(0)=Texture'tk_SpecialSkaarjPackv4.Skins.JBountyHunter2'
}
