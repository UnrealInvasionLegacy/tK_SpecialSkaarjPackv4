//-----------------------------------------------------------
//
//-----------------------------------------------------------
class FireSkaarjIIProj extends Projectile;

var	xEmitter SmokeTrail;
var Emitter FlameEffect;
var vector Dir;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

    if ( Level.NetMode != NM_DedicatedServer )
	{
        SmokeTrail = Spawn(class'SSPFireSkaarjProjTrail',self);
        FlameEffect = Spawn(class'FireSkaarjIIProjFlame', self);
        FlameEffect.SetBase(self);
	}

    if ( Role == ROLE_Authority )
    {
        Velocity = Speed * Vector(Rotation);
        RandSpin(25000);
    }

    Dir = vector(Rotation);
	Velocity = speed * Dir;
}

simulated function Destroyed()
{
	if ( FlameEffect != None )
		FlameEffect.Destroy();
    if ( SmokeTrail != None )
		SmokeTrail.mRegen = False;
    Super.Destroyed();
}

simulated function Explode(vector HitLocation,vector HitNormal)
{
    if ( Role == ROLE_Authority )
        HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation );

   	PlaySound(sound'WeaponSounds.BExplosion3',,2.5*TransientSoundVolume);
	spawn(class'FlakExplosion',,,HitLocation + HitNormal*16 );
	spawn(class'FlashExplosion',,,HitLocation + HitNormal*16 );
	if ( (ExplosionDecal != None) && (Level.NetMode != NM_DedicatedServer) )
		Spawn(ExplosionDecal,self,,Location, rotator(-HitNormal));
	Destroy();
}

simulated function PhysicsVolumeChange( PhysicsVolume Volume )
{
    if (Volume.bWaterVolume)
    {
        if ( FlameEffect != None )
		FlameEffect.Destroy();
        Velocity *= 0.65;
    }
}

defaultproperties
{
     Speed=1000.000000
     MaxSpeed=1000.000000
     Damage=40.000000
     DamageRadius=150.000000
     MomentumTransfer=50000.000000
     MyDamageType=Class'tk_SpecialSkaarjPackv4.DamTypeLaveRock'
     ExplosionDecal=Class'XEffects.RocketMark'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'tk_SpecialSkaarjPackv4.Projectile.LavaRockA'
     bDynamicLight=True
     AmbientSound=Sound'GeneralAmbience.firefx11'
     LifeSpan=10.000000
     DrawScale=0.200000
     SoundVolume=255
     SoundRadius=100.000000
     bFixedRotationDir=True
}
