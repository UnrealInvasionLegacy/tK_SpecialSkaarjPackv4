//-----------------------------------------------------------
//
//-----------------------------------------------------------
class SSPAntiSkaarj extends Skaarj;

var xEmitter FogEffect;

function bool SameSpeciesAs(Pawn P)
{
	return ( Monster(P) != none &&
		(P.IsA('SSPAntiSkaarj')));
}

simulated function Destroyed()
{
	if ( FogEffect != None )
		FogEffect.mRegen = False;
    Super.Destroyed();
}

simulated function PostNetBeginPlay()
{
	if ( Level.NetMode != NM_DedicatedServer)
	{
    	FogEffect = Spawn(class'SSPAntiSkaarjFog');
	    FogEffect.SetBase(self);
    }
	Super.PostNetBeginPlay();
}

function SetMovementPhysics()
{
	SetPhysics(PHYS_Flying);
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
}

defaultproperties
{
     AmmunitionClass=Class'tk_SpecialSkaarjPackv4.SSPAntiSkaarjAmmo'
     DeResMat0=Shader'tk_SpecialSkaarjPackv4.Decal.AntiSkaarj_DeRes'
     DeResMat1=Shader'tk_SpecialSkaarjPackv4.Decal.AntiSkaarj_DeRes'
     Skins(0)=FinalBlend'tk_SpecialSkaarjPackv4.Skins.AntiSkaarj'
}
