//-----------------------------------------------------------
//
//-----------------------------------------------------------
class SSPMetalSkaarjII extends SMPMetalSkaarj;

event PostBeginPlay()
{
	Super.PostBeginPlay();
	MyAmmo.ProjectileClass = class'MetalSkaarjIIProj';
}

function bool SameSpeciesAs(Pawn P)
{
	return ( Monster(P) != none &&
		(P.IsA('SSPMetalSkaarjII') || P.IsA('SSPIceSkaarjII') || P.IsA('SSPSkaarjII') || P.IsA('SSPFireSkaarjII')));
}

function SpawnTwoShots()
{
	local vector X,Y,Z, FireStart;
	local rotator FireRotation;

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
	FireRotation = Controller.AdjustAim(SavedFireProperties,FireStart,600);
	Spawn(MyAmmo.ProjectileClass,,,FireStart,FireRotation);

	FireStart = FireStart - 1.8 * CollisionRadius * Y;
	spawn(MyAmmo.ProjectileClass,,,FireStart, FireRotation);
}

defaultproperties
{
     AmmunitionClass=Class'tk_SpecialSkaarjPackv4.MetalSkaarjIIAmmo'
     ScoringValue=10
     Skins(0)=FinalBlend'tk_SpecialSkaarjPackv4.Skins.MetalSkaarjIIFinal'
}
