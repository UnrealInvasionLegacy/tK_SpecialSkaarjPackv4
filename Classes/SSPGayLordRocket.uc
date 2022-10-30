//-----------------------------------------------------------
//
//-----------------------------------------------------------
class SSPGayLordRocket extends Projectile;

var bool bRing,bHitWater,bWaterStart;

var class<Emitter> ExplosionEffectClass;
var	xEmitter RainbowTrail;
var Effects RainbowCorona;

var bool bCurl;
var vector Dir;

var() float	FlockRadius;
var() float	FlockStiffness;
var() float FlockMaxForce;
var() float	FlockCurlForce;

var byte FlockIndex;
var SSPGayLordRocket Flock[2];
var int i;
var float decision;

replication
{
    reliable if( bNetInitial && (Role==ROLE_Authority) )
        FlockIndex, bCurl;
}

simulated function Destroyed()
{
	if ( RainbowTrail != None )
		RainbowTrail.mRegen = False;
	if ( RainbowCorona != None )
		RainbowCorona.Destroy();
	Super.Destroyed();
}

simulated function PostBeginPlay()
{
    decision = FRand();

    if ( Level.NetMode != NM_DedicatedServer)
	{
        //SmokeTrail = Spawn(class'RocketTrailSmoke',self);
        RainbowTrail = Spawn(class'SSPGayLordRocketTrail',self);
		//Corona = Spawn(class'RocketCorona',self);
	    //RainbowCorona[i] = Spawn(RainbowCorona[i],self);
        if (decision<0.167)
    		RainbowCorona = Spawn(class'SSPGLRocketCorona',self);  //Red corona
        else if (decision<0.334)
            RainbowCorona = Spawn(class'SSPGLRocketCorona_orange',self);
        else if (decision<0.501)
            RainbowCorona = Spawn(class'SSPGLRocketCorona_yellow',self);
        else if (decision<0.668)
            RainbowCorona = Spawn(class'SSPGLRocketCorona_green',self);
        else if (decision<0.835)
            RainbowCorona = Spawn(class'SSPGLRocketCorona_blue',self);
        else if (decision<1.000)
            RainbowCorona = Spawn(class'SSPGLRocketCorona_purple',self);
    }

	SetTimer(0.1, true);
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
	local SSPGayLordRocket R;
	local PlayerController PC;

	Super.PostNetBeginPlay();

	if ( FlockIndex != 0 )
	{
	    SetTimer(0.1, true);

	    // look for other rockets
	    if ( Flock[1] == None )
	    {
			ForEach DynamicActors(class'SSPGayLordRocket',R)

            if ( R.FlockIndex == FlockIndex )
			{
				Flock[i] = R;
				if ( R.Flock[0] == None )
					R.Flock[0] = self;
				else if ( R.Flock[0] != self )
					R.Flock[1] = self;
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

simulated function Timer()
{
    local vector ForceDir, CurlDir;
    local float ForceMag;

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

simulated function Explode(vector HitLocation, vector HitNormal)
{
//	local int i;
    decision = FRand();

    if (decision<0.167)
        Spawn(class'SSPGLRocketExplosion',,,HitLocation + HitNormal*20,rotator(HitNormal));
    else if (decision<0.334)
        Spawn(class'SSPGLRocketExplosion_orange',,,HitLocation + HitNormal*20,rotator(HitNormal));
    else if (decision<0.501)
        Spawn(class'SSPGLRocketExplosion_yellow',,,HitLocation + HitNormal*20,rotator(HitNormal));
    else if (decision<0.668)
        Spawn(class'SSPGLRocketExplosion_green',,,HitLocation + HitNormal*20,rotator(HitNormal));
    else if (decision<0.835)
        Spawn(class'SSPGLRocketExplosion_blue',,,HitLocation + HitNormal*20,rotator(HitNormal));
    else if (decision<1.000)
        Spawn(class'SSPGLRocketExplosion_purple',,,HitLocation + HitNormal*20,rotator(HitNormal));
    BlowUp(HitLocation);
	Destroy();
}

defaultproperties
{
     FlockRadius=12.000000
     FlockStiffness=-40.000000
     FlockMaxForce=600.000000
     FlockCurlForce=450.000000
     Speed=1350.000000
     MaxSpeed=1350.000000
     Damage=90.000000
     MomentumTransfer=50000.000000
     MyDamageType=Class'tk_SpecialSkaarjPackv4.DamageTypeGayLord'
     ExplosionDecal=Class'XEffects.RocketMark'
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=28
     LightBrightness=255.000000
     LightRadius=5.000000
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'WeaponStaticMesh.RocketProj'
     CullDistance=7500.000000
     bDynamicLight=True
     AmbientSound=Sound'WeaponSounds.RocketLauncher.RocketLauncherProjectile'
     LifeSpan=8.000000
     AmbientGlow=96
     FluidSurfaceShootStrengthMod=1000.000000
     SoundVolume=255
     SoundRadius=100.000000
     bFixedRotationDir=True
     RotationRate=(Roll=50000)
     DesiredRotation=(Roll=30000)
     ForceType=FT_Constant
     ForceRadius=100.000000
     ForceScale=5000.000000
}
