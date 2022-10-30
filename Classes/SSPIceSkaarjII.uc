//-----------------------------------------------------------
//
//-----------------------------------------------------------
class SSPIceSkaarjII extends Skaarj;

var xEmitter MistEffect;

simulated function Destroyed()
{
	if ( MistEffect != None )
		MistEffect.mRegen = False;
    Super.Destroyed();
}

simulated function PostNetBeginPlay()
{
	if ( Level.NetMode != NM_DedicatedServer)
	{
    	MistEffect = Spawn(class'SSPIceSkaarjMist');
	    MistEffect.SetBase(self);
    }
	Super.PostNetBeginPlay();
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

function bool SameSpeciesAs(Pawn P)
{
	return ( Monster(P) != none &&
		(P.IsA('SSPMetalSkaarjII') || P.IsA('SSPIceSkaarjII') || P.IsA('SSPSkaarjII') || P.IsA('SSPFireSkaarjII')));
}

defaultproperties
{
     AmmunitionClass=Class'tk_SpecialSkaarjPackv4.IceSkaarjIIAmmo'
     ScoringValue=8
     Skins(0)=FinalBlend'SkaarjPackSkins.Skins.Skaarjw3'
}
