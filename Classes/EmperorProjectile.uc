//-----------------------------------------------------------
//
//-----------------------------------------------------------
class EmperorProjectile extends Projectile;

var xEmitter SmokeTrail;
var Emitter TrailEffect;
var Effects Corona;
var vector Dir;
var EmperorProjectile Flock[2];
var byte FlockIndex;
var bool bHitWater,bWaterStart;

var() float	FlockRadius;
var() float	FlockStiffness;
var() float FlockMaxForce;
var() float	FlockCurlForce;
var bool bCurl;

replication
{
    reliable if ( bNetInitial && (Role == ROLE_Authority) )
        FlockIndex, bCurl;
}

simulated function Destroyed()
{
	if ( TrailEffect != None )
		TrailEffect.Kill();
    if ( SmokeTrail != None )
		SmokeTrail.mRegen = False;
	if ( Corona != None )
		Corona.Destroy();
    Super.Destroyed();
}

simulated function PostBeginPlay()
{
    local rotator R;

    if ( Level.NetMode != NM_DedicatedServer)
	{
	    TrailEffect = Spawn(class'EmperorProjTrail',self);
        SmokeTrail = Spawn(class'EmperorSmokeTrail',self);
        Corona = Spawn(class'EmperorProjCorona',self);
    }

	R = Rotation;
    R.Roll = Rand(65536);
    SetRotation(R);

    Dir = vector(Rotation);
	Velocity = speed * Dir;
	if (PhysicsVolume.bWaterVolume)
	{
		bHitWater = True;
		Velocity=0.6*Velocity;
	}
	Super.PostBeginPlay();
}

simulated function PostNetBeginPlay()
{
	local EmperorProjectile P;
	local int i;
	local PlayerController PC;

	Super.PostNetBeginPlay();

	if ( FlockIndex != 0 )
	{
	    SetTimer(0.1, true);

	    if ( Flock[1] == None )
	    {
			ForEach DynamicActors(class'EmperorProjectile',P)
				if ( P.FlockIndex == FlockIndex )
				{
					Flock[i] = P;
					if ( P.Flock[0] == None )
						P.Flock[0] = self;
					else if ( P.Flock[0] != self )
						P.Flock[1] = self;
					i++;
					if ( i == 2 )
						break;
				}
		}
	}
    if ( Level.NetMode == NM_DedicatedServer )
		return;
	if ( Level.bDropDetail || (Level.DetailMode == DM_Low) )
	{
		bDynamicLight = false;
		LightType = LT_None;
	}
	else
	{
		PC = Level.GetLocalPlayerController();
		if ( (Instigator != None) && (PC == Instigator.Controller) )
			return;
		if ( (PC == None) || (PC.ViewTarget == None) || (VSize(PC.ViewTarget.Location - Location) > 3000) )
		{
			bDynamicLight = false;
			LightType = LT_None;
		}
	}
}

simulated function Landed( vector HitNormal )
{
	Explode(Location,HitNormal);
}

simulated function Timer()
{
    local vector ForceDir, CurlDir;
    local float ForceMag;
    local int i;

	Velocity =  Default.Speed * Normal(Dir * 0.5 * Default.Speed + Velocity);

	// Work out force between flock to add madness
	for(i=0; i<2; i++)
	{
		if(Flock[i] == None)
			continue;

		// Attract if distance between rockets is over 2*FlockRadius, repulse if below.
		ForceDir = Flock[i].Location - Location;
		ForceMag = FlockStiffness * ( (2 * FlockRadius) - VSize(ForceDir) );
		Acceleration = Normal(ForceDir) * Min(ForceMag, FlockMaxForce);

		// Vector 'curl'
		CurlDir = Flock[i].Velocity Cross ForceDir;
		if ( bCurl == Flock[i].bCurl )
			Acceleration += Normal(CurlDir) * FlockCurlForce;
		else
			Acceleration -= Normal(CurlDir) * FlockCurlForce;
	}
}

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
    if ( (Other != instigator) && (!Other.IsA('Projectile') || Other.bProjTarget) )
	{
		Explode(HitLocation, vect(0,0,1));
	}
}

function BlowUp(vector HitLocation)
{
	if ( Role == ROLE_Authority )
        HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation );
}

simulated function Explode(vector HitLocation,vector HitNormal)
{
   	PlaySound(ImpactSound, SLOT_Misc);

    if ( EffectIsRelevant(Location,false) )
	{
	    Spawn(class'EmperorExplosion',,, Location);
	}

    SetCollisionSize(0.0, 0.0);
    BlowUp(HitLocation);
    Destroy();
}

defaultproperties
{
     FlockRadius=12.000000
     FlockStiffness=-40.000000
     FlockMaxForce=600.000000
     FlockCurlForce=450.000000
     Speed=2500.000000
     MaxSpeed=2500.000000
     Damage=50.000000
     MomentumTransfer=700.000000
     MyDamageType=Class'tk_SpecialSkaarjPackv4.DamTypeEmperorProj'
     ImpactSound=Sound'WeaponSounds.ShockRifle.ShockRifleExplosion'
     ExplosionDecal=Class'tk_SpecialSkaarjPackv4.EmperorScorch'
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=255
     LightBrightness=255.000000
     LightRadius=5.000000
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'WeaponStaticMesh.LinkProjectile'
     bDynamicLight=True
     LifeSpan=20.000000
     DrawScale=2.000000
     PrePivot=(X=18.000000)
     Skins(0)=FinalBlend'tk_SpecialSkaarjPackv4.proj.TexEmperorProj'
     AmbientGlow=217
     Style=STY_Additive
     SoundVolume=255
     SoundRadius=60.000000
     bFixedRotationDir=True
     RotationRate=(Roll=80000)
}
