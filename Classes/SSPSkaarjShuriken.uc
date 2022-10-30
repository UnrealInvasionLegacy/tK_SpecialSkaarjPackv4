//-----------------------------------------------------------
//
//-----------------------------------------------------------
class SSPSkaarjShuriken extends Projectile;

var vector Dir;
var bool bHitWater;

simulated function PostBeginPlay()
{
	local Rotator R;

    Dir = vector(Rotation);
	Velocity = speed * Dir;

	R = Rotation;
    R.Pitch = Rand(65536);
    SetRotation(R);

    if (PhysicsVolume.bWaterVolume)
	{
		bHitWater = True;
		Velocity=0.6*Velocity;
	}

    Super.PostBeginPlay();
}

simulated function Destroyed()
{
    Super.Destroyed();
}

simulated function ProcessTouch( actor Other, vector HitLocation )
{
    if ( AmbientSound != None )
		AmbientSound=None;
    PlaySound(ImpactSound, SLOT_Misc );
    Stick(Other, HitLocation);
    LifeSpan = 2.0;
    BlowUp(HitLocation);
}

simulated function HitWall( vector HitNormal, actor Wall )
{
    if ( AmbientSound != None )
		AmbientSound=None;
    PlaySound(ImpactSound, SLOT_Misc );
    SetPhysics(PHYS_None);
    LifeSpan = 2.0;
}

simulated function Landed( vector HitNormal )
{
    if ( AmbientSound != None )
		AmbientSound=None;
    PlaySound(ImpactSound, SLOT_Misc );
    SetPhysics(PHYS_None);
    LifeSpan = 2.0;
}

function BlowUp(vector HitLocation)
{
	HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation );
	MakeNoise(1.0);
}

simulated function Stick(actor HitActor, vector HitLocation)
{
    if ( AmbientSound != None )
		AmbientSound=None;

    LastTouched = HitActor;
    SetPhysics(PHYS_None);
    SetBase(HitActor);
    bCollideWorld = False;
    bProjTarget = true;
}

defaultproperties
{
     Speed=2000.000000
     MaxSpeed=5000.000000
     Damage=40.000000
     DamageRadius=1.000000
     MomentumTransfer=2000.000000
     MyDamageType=Class'tk_SpecialSkaarjPackv4.DamTypeShuriken'
     ImpactSound=Sound'XEffects.Impact1'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'tk_SpecialSkaarjPackv4.Projectile.Shuriken'
     AmbientSound=Sound'OutdoorAmbience.BThunder.wind1'
     LifeSpan=20.000000
     DrawScale=4.000000
     SoundVolume=255
     SoundRadius=50.000000
     bFixedRotationDir=True
     RotationRate=(Pitch=-400000)
     DesiredRotation=(Pitch=65536)
}
