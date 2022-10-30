//-----------------------------------------------------------
//
//-----------------------------------------------------------
class IceSkaarjIIProj extends Projectile;

var Emitter MistEffect;
var vector Dir;
var bool bHitWater;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

    if ( Level.NetMode != NM_DedicatedServer )
	{
        MistEffect = Spawn(class'IceSkaarjIIProjMist', self);
        MistEffect.SetBase(self);
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
	if ( MistEffect != None )
		MistEffect.Destroy();
    Super.Destroyed();
}

simulated function Explode(vector HitLocation,vector HitNormal)
{
    local PlayerController PC;
    if ( Role == ROLE_Authority )
        HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation );

    if ( EffectIsRelevant(Location,false) )
    {
    	Spawn(class'IceExplosion',,,HitLocation + HitNormal*20,rotator(HitNormal));
    	PC = Level.GetLocalPlayerController();
    }

    PlaySound(ImpactSound, SLOT_Misc);
	Destroy();
}

defaultproperties
{
     Speed=1000.000000
     MaxSpeed=1000.000000
     Damage=40.000000
     DamageRadius=150.000000
     MomentumTransfer=50000.000000
     MyDamageType=Class'tk_SpecialSkaarjPackv4.DamTypeIceRock'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'tk_SpecialSkaarjPackv4.Projectile.LavaRockA'
     bDynamicLight=True
     LifeSpan=10.000000
     DrawScale=0.200000
     Skins(0)=Texture'AlleriaTerrain.ground.glacier01AL'
     bFixedRotationDir=True
}
