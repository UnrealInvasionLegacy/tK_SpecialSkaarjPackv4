//-----------------------------------------------------------
//
//-----------------------------------------------------------
class SSPEliteBountyHunter extends SMPMercenary;

var bool bRocketDir;

event PostBeginPlay()
{
	Super.PostBeginPlay();
	bMeleeFighter = (FRand() < 0.5);
	RocketAmmo=spawn(RocketAmmoClass);
}

function bool SameSpeciesAs(Pawn P)
{
	return ( Monster(P) != none &&
	(P.IsA('SSPBountyHunter') ||  P.IsA('SSPEliteBountyHunter')));
}

simulated function vector GetFireStart(vector X, vector Y, vector Z)
{
	if ( sprayoffset >= 1 && sprayoffset <= 5 )
	{
		if ( GetAnimSequence() == 'Spray' )
			return Location + 1.25 * CollisionRadius * X - CollisionRadius * (0.2 * sprayoffset - 0.3) * Y;
		else
			return Location + 1.25 * CollisionRadius * X - CollisionRadius * (0.1 * sprayoffset - 0.1) * Y;
	}
	else
		return Location + 0.5 * CollisionRadius * (X+Z-Y);
}

function RangedAttack(Actor A)
{
	local float decision;
	if ( bShotAnim )
		return;

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
    bShotAnim=true;
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

simulated function PlayDirectionalHit(Vector HitLoc)
{
    local Vector X,Y,Z, Dir;

    GetAxes(Rotation, X,Y,Z);
    HitLoc.Z = Location.Z;

    if ( bShotAnim )
		return;

    // random
    if ( VSize(Location - HitLoc) < 1.0 )
    {
        Dir = VRand();
    }
    // hit location based
    else
    {
        Dir = -Normal(Location - HitLoc);
    }

    if ( Dir Dot X > 0.7 || Dir == vect(0,0,0))
    {
        PlayAnim('GutHit',, 0.1);
    }
    else if ( Dir Dot X < -0.7 )
    {
      //  PlayAnim('Hit',, 0.1);
    }
    else if ( Dir Dot Y > 0 )
    {
        PlayAnim('RightHit',, 0.1);
    }
    else
    {
        PlayAnim('LeftHit',, 0.1);
    }
}

function SpawnRocket()
{
	local vector FireStart,X,Y,Z;
	local rotator ProjRot;
	local EliteBountyHunterMissile M;
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
		ProjRot = Controller.AdjustAim(SavedFireProperties,FireStart,600);
		if ( bRocketDir )
			ProjRot.Yaw += 3072;
		else
			ProjRot.Yaw -= 3072;
		bRocketDir = !bRocketDir;
		M = Spawn(class'EliteBountyHunterMissile',,,FireStart,ProjRot);
        M.Seeking = Controller.Enemy;
		PlaySound(FireSound,SLOT_Interact);
	}
}

defaultproperties
{
     RocketAmmoClass=Class'tk_SpecialSkaarjPackv4.EliteBountyMissileAmmo'
     WeaponSpray=Sound'ONSVehicleSounds-S.LaserSounds.Laser01'
     FireSound=Sound'ONSVehicleSounds-S.AVRiL.AvrilFire01'
     AmmunitionClass=Class'tk_SpecialSkaarjPackv4.EliteBountyHunterAmmo'
     Skins(0)=Texture'tk_SpecialSkaarjPackv4.Skins.JBountyHunter1'
}
