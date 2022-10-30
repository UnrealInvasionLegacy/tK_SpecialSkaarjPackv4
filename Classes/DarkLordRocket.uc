//-----------------------------------------------------------
//
//-----------------------------------------------------------
class DarkLordRocket extends Projectile;

var Actor HomingTarget;
var vector InitialDir;

var xEmitter SmokeTrailEffect;

replication
{
    reliable if (bNetInitial && Role == ROLE_Authority)
        InitialDir, HomingTarget;
}

simulated function Destroyed()
{
	if ( SmokeTrailEffect != None )
		SmokeTrailEffect.mRegen = False;
	Super.Destroyed();
}

simulated function PostBeginPlay()
{
	if (Level.NetMode != NM_DedicatedServer)
	{
		SmokeTrailEffect = Spawn(class'DarkLordRocketTrail',self);
	}

	InitialDir = vector(Rotation);
	Velocity = InitialDir * Speed;

	SetTimer(0.1, true);

    if (PhysicsVolume.bWaterVolume)
		Velocity = 0.6 * Velocity;

	Super.PostBeginPlay();
}

simulated function Timer()
{
	local float VelMag;
	local vector ForceDir;

	if (HomingTarget == None)
		return;

	ForceDir = Normal(HomingTarget.Location - Location);
	if (ForceDir dot InitialDir > 0)
	{
	    	// Do normal guidance to target.
	    	VelMag = VSize(Velocity);

	    	ForceDir = Normal(ForceDir * 0.75 * VelMag + Velocity);
		Velocity =  VelMag * ForceDir;
    		Acceleration = 5 * ForceDir;

	    	// Update rocket so it faces in the direction its going.
		SetRotation(rotator(Velocity));
	}
}

simulated function Landed( vector HitNormal )
{
	Explode(Location,HitNormal);
}

simulated function ProcessTouch (Actor Other, Vector HitLocation)
{
	if ( (Other != instigator) && (!Other.IsA('Projectile') || Other.bProjTarget) )
	{
		Explode(HitLocation, vect(0,0,1));
	}
}

function BlowUp(vector HitLocation)
{
	HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation );
	MakeNoise(1.0);
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	local PlayerController PC;

	PlaySound(sound'WeaponSounds.BExplosion3',,2.5*TransientSoundVolume);

    if ( EffectIsRelevant(Location,false) )
    {
    	Spawn(class'NewExplosionA',,,HitLocation + HitNormal*20,rotator(HitNormal));
    	PC = Level.GetLocalPlayerController();
		if ( (PC.ViewTarget != None) && VSize(PC.ViewTarget.Location - Location) < 5000 )
	        Spawn(class'ExplosionCrap',,, HitLocation + HitNormal*20, rotator(HitNormal));
    }

	BlowUp(HitLocation);
	Destroy();
}

defaultproperties
{
     Speed=1000.000000
     MaxSpeed=1000.000000
     Damage=100.000000
     DamageRadius=200.000000
     MomentumTransfer=10000.000000
     MyDamageType=Class'tk_SpecialSkaarjPackv4.DamTypeDarkLordRocket'
     ExplosionDecal=Class'Onslaught.ONSRocketScorch'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'WeaponStaticMesh.RocketProj'
     AmbientSound=Sound'GeneralAmbience.firefx11'
     LifeSpan=7.000000
     DrawScale3D=(Y=0.400000,Z=0.400000)
     AmbientGlow=96
     FluidSurfaceShootStrengthMod=10.000000
     SoundVolume=255
     SoundRadius=100.000000
     bFixedRotationDir=True
     RotationRate=(Roll=50000)
     DesiredRotation=(Roll=900000)
     ForceType=FT_Constant
     ForceRadius=100.000000
     ForceScale=5.000000
}
