//-----------------------------------------------------------
//
//-----------------------------------------------------------
class SSPKrakenProjectile extends Projectile;

var KrakenTrail Trail;
//var Emitter SmokeTrailEffect;
var	xEmitter SparkleTrail;

simulated function PostBeginPlay()
{
	local Rotator R;

    if ( Level.NetMode != NM_DedicatedServer)
	{
		//SmokeTrailEffect = Spawn(class'SSPKrakenProjEmitter',self);
	    Trail = Spawn(class'KrakenTrail',self);
        SparkleTrail = Spawn(class'SSPKrakenSparkles',self);
    }

	Super.PostBeginPlay();

    Velocity = Vector(Rotation);
    Velocity *= Speed;

    R = Rotation;
    R.Roll = Rand(65536);
    SetRotation(R);
}

simulated function Destroyed()
{
	if (Trail != None)
    {
        Trail.Destroy();
    }
    /*if ( SmokeTrailEffect != None )
		SmokeTrailEffect.Kill();*/
	if ( SparkleTrail != None )
		SparkleTrail.mRegen = False;
    Super.Destroyed();
}

simulated function ProcessTouch (Actor Other, Vector HitLocation)
{
	if ( Other != instigator )
		Explode(HitLocation,Vect(0,0,1));
}

simulated function PhysicsVolumeChange( PhysicsVolume Volume )
{
}

simulated function Landed( vector HitNormal )
{
	Explode(Location,HitNormal);
}

simulated function HitWall(vector HitNormal, actor Wall)
{
	Explode(Location,HitNormal);
}

function BlowUp(vector HitLocation)
{
	HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation );
	MakeNoise(1.0);
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	local vector start;
    local rotator rot;
    local int i;
    local BioGlob NewGlob;

	start = Location + 10 * HitNormal;
	if ( Role == ROLE_Authority )
	{
		for (i=0; i<15; i++)
		{
			rot = Rotation;
			rot.yaw += FRand()*32000-16000;
			rot.pitch += FRand()*32000-16000;
			rot.roll += FRand()*32000-16000;
			NewGlob = Spawn( class 'BioGlob',, '', Start, rot);
		}
	}
    if ( EffectIsRelevant(Location,false) )
	{
        if ( EffectIsRelevant(Location,false) )
            Spawn(class'LinkProjSparks',,, HitLocation, rotator(HitNormal));
        else
            Spawn(class'LinkProjSparksYellow',,, HitLocation, rotator(HitNormal));
	}
    PlaySound(Sound'WeaponSounds.BioRifle.BioRifleGoo2');

	BlowUp(HitLocation);
	Destroy();
}

defaultproperties
{
     Speed=5000.000000
     MaxSpeed=5000.000000
     Damage=1000.000000
     DamageRadius=1.000000
     MomentumTransfer=100000.000000
     MyDamageType=Class'tk_SpecialSkaarjPackv4.DamTypeKrakenBio'
     ImpactSound=Sound'ONSVehicleSounds-S.AVRiL.AvrilFire01'
     ExplosionDecal=Class'XEffects.LinkBoltScorch'
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=100
     LightSaturation=100
     LightBrightness=255.000000
     LightRadius=3.000000
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'WeaponStaticMesh.LinkProjectile'
     CullDistance=3500.000000
     LifeSpan=20.000000
     DrawScale3D=(X=4.590000,Y=3.060000,Z=3.060000)
     PrePivot=(X=10.000000)
     Style=STY_Translucent
     SoundVolume=255
     SoundRadius=60.000000
     bFixedRotationDir=True
}
