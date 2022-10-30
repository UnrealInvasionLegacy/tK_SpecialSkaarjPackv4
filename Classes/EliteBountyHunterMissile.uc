//-----------------------------------------------------------
//
//-----------------------------------------------------------
class EliteBountyHunterMissile extends Projectile;

var Actor Seeking;
var vector InitialDir;

var Emitter SmokeTrail;
var Effects Corona;

replication
{
    reliable if (bNetInitial && Role == ROLE_Authority)
        InitialDir, Seeking;
}

simulated function Destroyed()
{
	if ( SmokeTrail != None )
		SmokeTrail.Kill();
	if ( Corona != None )
		Corona.Destroy();
	Super.Destroyed();
}

simulated function PostBeginPlay()
{
	local vector Dir;

    if ( Level.NetMode != NM_DedicatedServer)
	{
		SmokeTrail = Spawn(class'ONSAvrilSmokeTrail',,,Location - 15 * Dir);
		SmokeTrail.Setbase(self);

		Corona = Spawn(class'RocketCorona',self);
	}

	Dir = vector(Rotation);
	Velocity = speed * Dir;

	if (PhysicsVolume.bWaterVolume)
		Velocity = 0.6 * Velocity;

	SetTimer(0.1, true);

	Super.PostBeginPlay();
}

simulated function Timer()
{
	local float VelMag;
	local vector ForceDir;

	if ( InitialDir == vect(0,0,0) )
        InitialDir = Normal(Velocity);

    Acceleration = vect(0,0,0);
    Super.Timer();
    if ( (Seeking != None) && (Seeking != Instigator) )
    {
    	ForceDir = Normal(Seeking.Location - Location);

        if( (ForceDir dot InitialDir) > 0)
    	{
    	    	// Do normal guidance to target.
    	    	VelMag = VSize(Velocity);

	    	if ( Seeking.Physics == PHYS_Karma )
    			ForceDir = Normal(ForceDir * 0.8 * VelMag + Velocity);
			else
				ForceDir = Normal(ForceDir * 0.5 * VelMag + Velocity);
			Velocity =  VelMag * ForceDir;
			Acceleration += 5 * ForceDir;

    	    	// Update rocket so it faces in the direction its going.
    		SetRotation(rotator(Velocity));
    	}
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
     Damage=125.000000
     DamageRadius=150.000000
     MomentumTransfer=50000.000000
     MyDamageType=Class'tk_SpecialSkaarjPackv4.DamTypeHunter'
     bScriptPostRender=True
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'VMWeaponsSM.AVRiLGroup.AVRiLprojectileSM'
     bUpdateSimulatedPosition=True
     bIgnoreVehicles=True
     LifeSpan=7.000000
     DrawScale=0.120000
     AmbientGlow=96
     bUseCylinderCollision=False
     bFixedRotationDir=True
     RotationRate=(Roll=50000)
     DesiredRotation=(Roll=30000)
     ForceType=FT_Constant
     ForceRadius=100.000000
     ForceScale=5.000000
}
