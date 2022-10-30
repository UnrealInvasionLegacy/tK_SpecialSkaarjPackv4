//-----------------------------------------------------------
//
//-----------------------------------------------------------
class SSPSkaarjII extends Skaarj;

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
	FireRotation = Controller.AdjustAim(SavedFireProperties,FireStart,300); //300 will mean more stable shots.
	Spawn(MyAmmo.ProjectileClass,,,FireStart,FireRotation); //Add some sound to the shot.
    PlaySound(FireSound,SLOT_Interact);

	FireStart = FireStart - 1.8 * CollisionRadius * Y;
	spawn(MyAmmo.ProjectileClass,,,FireStart,FireRotation);
}

function bool SameSpeciesAs(Pawn P)
{
	return ( Monster(P) != none &&
		(P.IsA('SSPMetalSkaarjII') || P.IsA('SSPIceSkaarjII') || P.IsA('SSPSkaarjII') || P.IsA('SSPFireSkaarjII')));
}

defaultproperties
{
     FireSound=Sound'SkaarjPack_rc.Skaarj.spin1s'
     AmmunitionClass=Class'tk_SpecialSkaarjPackv4.SSPSkaarjIIAmmo'
     GroundSpeed=880.000000
     Skins(0)=FinalBlend'tk_SpecialSkaarjPackv4.Skins.SkaarjIIw1'
}
