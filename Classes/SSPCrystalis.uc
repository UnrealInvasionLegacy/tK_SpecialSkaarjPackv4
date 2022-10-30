//-----------------------------------------------------------
//
//-----------------------------------------------------------
class SSPCrystalis extends SMPTitan;

function bool SameSpeciesAs(Pawn P)
{
	return ( Monster(P) != none &&
	(P.IsA('SMPTitan') ||  P.IsA('SSPGolem') || P.IsA('SSPCrystalis') || P.IsA('SMPStoneTitan') ) );
}

function SpawnRock()
{
	local vector X,Y,Z, FireStart;
	local rotator FireRotation;
	local Projectile   Proj;

	GetAxes(Rotation,X,Y,Z);
	FireStart = Location + 1.2*CollisionRadius * X + 0.4 * CollisionHeight * Z;
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

	FireRotation = Controller.AdjustAim(SavedFireProperties,FireStart,600);
	if (FRand() < 0.250)
	{
		Proj=Spawn(class'SSPCrystalisBigCrystalA',,,FireStart,FireRotation);
		if(Proj!=none)
		{
			Proj.SetPhysics(PHYS_Projectile);
			Proj.setDrawScale(Proj.DrawScale*DrawScale/default.DrawScale);
			Proj.SetCollisionSize(Proj.CollisionRadius*DrawScale/default.DrawScale,Proj.CollisionHeight*DrawScale/default.DrawScale);
			Proj.Velocity = (ProjectileSpeed+Rand(ProjectileMaxSpeed-ProjectileSpeed)) *vector(Proj.Rotation)*DrawScale/default.DrawScale;
		}
		return;
	}
    else if (FRand() < 1.000)
    {
    	Proj=Spawn(MyAmmo.ProjectileClass,,,FireStart,FireRotation);
    	if(Proj!=none)
    	{
    		Proj.SetPhysics(PHYS_Projectile);
    		Proj.setDrawScale(Proj.DrawScale*DrawScale/default.DrawScale);
    		Proj.SetCollisionSize(Proj.CollisionRadius*DrawScale/default.DrawScale,Proj.CollisionHeight*DrawScale/default.DrawScale);
    		Proj.Velocity = (ProjectileSpeed+Rand(ProjectileMaxSpeed-ProjectileSpeed)) *vector(Proj.Rotation)*DrawScale/default.DrawScale;
    	}
	}
    FireStart=Location + 1.2*CollisionRadius * X -40*Y+ 0.4 * CollisionHeight * Z;
	bStomped=false;
}

defaultproperties
{
     AmmunitionClass=Class'tk_SpecialSkaarjPackv4.SSPCrystalisAmmo'
     Skins(0)=FinalBlend'tk_SpecialSkaarjPackv4.Skins.Crystalis'
     Skins(1)=FinalBlend'tk_SpecialSkaarjPackv4.Skins.Crystalis'
}
