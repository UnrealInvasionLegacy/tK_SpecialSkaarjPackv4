//-----------------------------------------------------------
//
//-----------------------------------------------------------
class SSPGolem extends SMPTitan;

function bool SameSpeciesAs(Pawn P)
{
	return ( Monster(P) != none &&
	(P.IsA('SMPTitan') ||  P.IsA('SSPGolem') || P.IsA('SSPCrystalis') || P.IsA('SMPStoneTitan') ) );
}

function SpawnRock()
{
	local vector X,Y,Z, FireStart;
	local rotator FireRotation;
	local Projectile Proj;

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
	if (FRand() < 0.4)
	{
		Proj=Spawn(class'SSPGolemBigRock',,,FireStart,FireRotation);
		if(Proj!=none)
		{
			Proj.SetPhysics(PHYS_Projectile);
			Proj.setDrawScale(Proj.DrawScale*DrawScale/default.DrawScale);
			Proj.SetCollisionSize(Proj.CollisionRadius*DrawScale/default.DrawScale,Proj.CollisionHeight*DrawScale/default.DrawScale);
			Proj.Velocity = (ProjectileSpeed+Rand(ProjectileMaxSpeed-ProjectileSpeed)) *vector(Proj.Rotation)*DrawScale/default.DrawScale;
		}
		return;
	}

	Proj=Spawn(MyAmmo.ProjectileClass,,,FireStart,FireRotation);
	if(Proj!=none)
	{
		Proj.SetPhysics(PHYS_Projectile);
		Proj.setDrawScale(Proj.DrawScale*DrawScale/default.DrawScale);
		Proj.SetCollisionSize(Proj.CollisionRadius*DrawScale/default.DrawScale,Proj.CollisionHeight*DrawScale/default.DrawScale);
		Proj.Velocity = (ProjectileSpeed+Rand(ProjectileMaxSpeed-ProjectileSpeed)) *vector(Proj.Rotation)*DrawScale/default.DrawScale;
	}
	FireStart=Location + 1.2*CollisionRadius * X -40*Y+ 0.4 * CollisionHeight * Z;
	bStomped=false;
}

defaultproperties
{
     ProjectileSpeed=1350.000000
     ProjectileMaxSpeed=1500.000000
     InvalidityMomentumSize=150000.000000
     AmmunitionClass=Class'tk_SpecialSkaarjPackv4.SSPGolemAmmo'
     ScoringValue=20
     DrawScale=2.000000
     Skins(0)=Texture'tk_SpecialSkaarjPackv4.Skins.JGolem_RAW'
     Skins(1)=Texture'tk_SpecialSkaarjPackv4.Skins.JGolem_RAW'
     CollisionRadius=220.000000
     CollisionHeight=230.000000
     Mass=3000.000000
     RotationRate=(Yaw=50000)
}
