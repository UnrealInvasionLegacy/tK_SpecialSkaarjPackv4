//-----------------------------------------------------------
//
//-----------------------------------------------------------
class SSPBlackHeartProj extends Projectile;

var Emitter TrailEffect;
var vector InitialDir;
var Actor HomingTarget;
var byte Bounces;
var float ExplodeTimer;
var bool bTimerSet;

replication
{
    reliable if (bNetInitial && Role == ROLE_Authority)
        InitialDir, HomingTarget;
}

simulated function PostBeginPlay()
{
	if (Level.NetMode != NM_DedicatedServer)
	{
		TrailEffect = Spawn(class'BlackHeartProjTrail',self);
	}

    InitialDir = vector(Rotation);
    Velocity = InitialDir * Speed;

	SetTimer(0.1, true);

    Super.PostBeginPlay();
}

simulated function Destroyed()
{
	if ( TrailEffect != None )
		TrailEffect.Kill();
	Super.Destroyed();
}

simulated function PostNetBeginPlay()
{
	if ( Physics == PHYS_None )
    {
        SetTimer(ExplodeTimer, false);
        bTimerSet = true;
    }
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
    HitWall( HitNormal, None );
}

simulated function ProcessTouch( actor Other, vector HitLocation )
{
    if ( Pawn(Other) != None && (Other != Instigator) )
    {
		Explode(HitLocation, Normal(HitLocation-Other.Location));
    }
}

simulated function HitWall( vector HitNormal, actor Wall )
{
    local Vector VNorm;

    if (!bTimerSet)
    {
        SetTimer(ExplodeTimer, false);
        bTimerSet = true;
    }

    VNorm = (Velocity dot HitNormal) * HitNormal;
    Velocity = -VNorm + (Velocity - VNorm) ;

    RandSpin(100000);
    Speed = VSize(Velocity);

    if ( Speed < 20 )
    {
        bBounce = False;
        SetPhysics(PHYS_None);
    }
    else
    {
		if ( (Level.NetMode != NM_DedicatedServer) && (Speed > 250) )
			PlaySound(ImpactSound, SLOT_Misc );
    }
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	local PlayerController PC;

	PlaySound(sound'WeaponSounds.BExplosion3',,2.5*TransientSoundVolume);

    if ( EffectIsRelevant(Location,false) )
    {
    	Spawn(class'ONSShockTankShockExplosion',,,HitLocation + HitNormal*20,rotator(HitNormal));
    	PC = Level.GetLocalPlayerController();
		if ( (PC.ViewTarget != None) && VSize(PC.ViewTarget.Location - Location) < 5000 )
	        Spawn(class'ComboDecal',,, HitLocation + HitNormal*20, rotator(HitNormal));
    }

	BlowUp(HitLocation);
	Destroy();
}

defaultproperties
{
     Bounces=2
     ExplodeTimer=1.000000
     Speed=4000.000000
     MaxSpeed=5000.000000
     Damage=20.000000
     DamageRadius=200.000000
     MomentumTransfer=10000.000000
     MyDamageType=Class'tk_SpecialSkaarjPackv4.DamTypeBlackHeart'
     ExplosionDecal=Class'Onslaught.ONSRocketScorch'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'WeaponStaticMesh.NEWTranslocatorPUCK'
     Physics=PHYS_Flying
     AmbientSound=Sound'VMVehicleSounds-S.HoverTank.IncomingShell'
     LifeSpan=5.000000
     DrawScale=0.350000
     AmbientGlow=96
     FluidSurfaceShootStrengthMod=10.000000
     SoundVolume=255
     SoundRadius=50.000000
     CollisionRadius=10.000000
     CollisionHeight=10.000000
     bProjTarget=True
     bBounce=True
     bFixedRotationDir=True
     ForceType=FT_DragAlong
     ForceRadius=100.000000
     ForceScale=5.000000
}
