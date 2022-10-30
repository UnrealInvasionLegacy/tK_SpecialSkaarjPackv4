//-----------------------------------------------------------
//
//-----------------------------------------------------------
class SSPGiantBlackHeartProj extends Projectile;

var Emitter TrailEffect;

simulated function PostBeginPlay()
{
	if (Level.NetMode != NM_DedicatedServer)
	{
		TrailEffect = Spawn(class'BlackHeartProjTrail',self);
	}

    Velocity = Vector(Rotation);
    Velocity *= Speed;

    Super.PostBeginPlay();
}

simulated function Destroyed()
{
	if ( TrailEffect != None )
		TrailEffect.Kill();
	Super.Destroyed();
}

simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
	if ( Other != Instigator )
	{
		SpawnEffects(HitLocation, -1 * Normal(Velocity) );
		Explode(HitLocation,Normal(HitLocation-Other.Location));
	}
}

simulated function Landed( vector HitNormal )
{
	SpawnEffects( Location, HitNormal );
	Explode(Location,HitNormal);
}

simulated function SpawnEffects( vector HitLocation, vector HitNormal )
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
}

simulated function HitWall (vector HitNormal, actor Wall)
{
	Landed(HitNormal);
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	local vector start;
    local rotator rot;
    local int i;
    local SSPBlackHeartProj BHP;

	start = Location + 10 * HitNormal;
	if ( Role == ROLE_Authority )
	{
		HurtRadius(damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation);
		for (i=0; i<4; i++)
		{
			rot = Rotation;
			rot.yaw += FRand()*32000-16000;
			rot.pitch += FRand()*32000-16000;
			rot.roll += FRand()*32000-16000;
			BHP = Spawn( class 'SSPBlackHeartProj',, '', Start, rot);
		}
	}
    Destroy();
}

defaultproperties
{
     Speed=3000.000000
     MaxSpeed=4000.000000
     Damage=90.000000
     DamageRadius=400.000000
     MomentumTransfer=75000.000000
     MyDamageType=Class'tk_SpecialSkaarjPackv4.DamTypeBlackHeart'
     ExplosionDecal=Class'Onslaught.ONSRocketScorch'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'WeaponStaticMesh.NEWTranslocatorPUCK'
     AmbientSound=Sound'VMVehicleSounds-S.HoverTank.IncomingShell'
     DrawScale=0.800000
     SoundVolume=255
     SoundRadius=100.000000
     CollisionRadius=50.000000
     CollisionHeight=50.000000
     bFixedRotationDir=True
     ForceType=FT_DragAlong
     ForceRadius=100.000000
     ForceScale=5.000000
}
