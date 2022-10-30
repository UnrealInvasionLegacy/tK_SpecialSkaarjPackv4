//-----------------------------------------------------------
//
//-----------------------------------------------------------
class MetalSkaarjIIProj extends Projectile;

var byte Bounces;
var	xEmitter Trail;
var Effects Corona;
var bool bTimerSet, bHitWater;
var float ExplodeTimer, LastSparkTime;
var class<xEmitter> HitEffectClass;
var() float DampenFactor, DampenFactorParallel;

replication
{
    reliable if (Role==ROLE_Authority)
        ExplodeTimer;
}

simulated function Destroyed()
{
	if ( Trail != None )
		Trail.mRegen = False;
	Super.Destroyed();
}


simulated function PostBeginPlay()
{
    Super.PostBeginPlay();

	if ( Level.NetMode != NM_DedicatedServer)
	{
		Trail = Spawn(class'MetalSkaarjIIProjTrail',self);
	}

    if ( Role == ROLE_Authority )
    {
        Velocity = Speed * Vector(Rotation);
        RandSpin(25000);
        if (Instigator.HeadVolume.bWaterVolume)
        {
            bHitWater = true;
            Velocity = 0.6*Velocity;
        }
    }
    if ( Instigator != None )
		InstigatorController = Instigator.Controller;
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
    Explode(Location, vect(0,0,1));
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
    Velocity = -VNorm * DampenFactor + (Velocity - VNorm) * DampenFactorParallel;

    RandSpin(100000);
    Speed = VSize(Velocity);

    if ( Speed > 10 )
    {
        bBounce = True;
        SetPhysics(PHYS_Falling);
    }
    else
    {
		if ( (Level.NetMode != NM_DedicatedServer) && (Speed > 250) )
			PlaySound(ImpactSound, SLOT_Misc );
        if ( !Level.bDropDetail && (Level.DetailMode != DM_Low) && (Level.TimeSeconds - LastSparkTime > 0.5) && EffectIsRelevant(Location,false) )
        {
			Spawn(HitEffectClass,,, Location, Rotator(HitNormal));
            LastSparkTime = Level.TimeSeconds;
        }
    }
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	local PlayerController PC;


    if ( Role == ROLE_Authority )
        HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation );

    PlaySound(sound'WeaponSounds.BExplosion3',,2.5*TransientSoundVolume);
    if ( EffectIsRelevant(Location,false) )
    {
    	Spawn(class'NewExplosionA',,,HitLocation + HitNormal*20,rotator(HitNormal));
    	PC = Level.GetLocalPlayerController();
		if ( (PC.ViewTarget != None) && VSize(PC.ViewTarget.Location - Location) < 5000 )
	        Spawn(class'ExplosionCrap',,, HitLocation + HitNormal*20, rotator(HitNormal));
//		if ( (ExplosionDecal != None) && (Level.NetMode != NM_DedicatedServer) )
//			Spawn(ExplosionDecal,self,,Location, rotator(-HitNormal));
    }

	Destroy();
}

defaultproperties
{
     ExplodeTimer=1.500000
     HitEffectClass=Class'XEffects.WallSparks'
     DampenFactor=0.500000
     DampenFactorParallel=0.800000
     Speed=1050.000000
     MaxSpeed=2750.000000
     TossZ=0.000000
     Damage=45.000000
     DamageRadius=700.000000
     MomentumTransfer=10000.000000
     MyDamageType=Class'tk_SpecialSkaarjPackv4.DamTypeMetalNade'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'VMWeaponsSM.PlayerWeaponsGroup.VMGrenade'
     Physics=PHYS_Flying
     LifeSpan=40.000000
     DrawScale=0.100000
     bBounce=True
     bFixedRotationDir=True
}
