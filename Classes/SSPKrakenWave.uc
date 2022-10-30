//-----------------------------------------------------------
//
//-----------------------------------------------------------
class SSPKrakenWave extends Projectile;

var Emitter WaveEffect;

var() vector ShakeRotMag;           // how far to rot view
var() vector ShakeRotRate;          // how fast to rot view
var() float  ShakeRotTime;          // how much time to rot the instigator's view
var() vector ShakeOffsetMag;        // max view offset vertically
var() vector ShakeOffsetRate;       // how fast to offset view vertically
var() float  ShakeOffsetTime;       // how much time to offset view

simulated function Destroyed()
{
	if ( WaveEffect != None )
		WaveEffect.Destroy();
    Super.Destroyed();
}

simulated function PostBeginPlay()
{
	local Rotator R;

    if ( Level.NetMode != NM_DedicatedServer)
	{
		WaveEffect = Spawn(class'SSPKrakenWaveEmitter', self);
    }

	Super.PostBeginPlay();

    Velocity = Vector(Rotation);
    Velocity *= Speed;

    R = Rotation;
    R.Roll = Rand(65536);
    SetRotation(R);
}

function ProcessTouch (Actor Other, Vector HitLocation)
{
	ShakeView();
}

function ShakeView()
{
    local Controller C;
    local PlayerController PC;
    local float Dist, Scale;

    for ( C=Level.ControllerList; C!=None; C=C.NextController )
    {
        PC = PlayerController(C);
        if ( PC != None && PC.ViewTarget != None )
        {
            Dist = VSize(Location - PC.ViewTarget.Location);
            if ( Dist < DamageRadius * 2.0)
            {
                if (Dist < DamageRadius)
                    Scale = 1.0;
                else
                    Scale = (DamageRadius*2.0 - Dist) / (DamageRadius);
                C.ShakeView(ShakeRotMag*Scale, ShakeRotRate, ShakeRotTime, ShakeOffsetMag*Scale, ShakeOffsetRate, ShakeOffsetTime);
            }
        }
    }
}

simulated function Landed( vector HitNormal )
{
	Explode(Location,HitNormal);
}
simulated function HitWall(vector HitNormal, Actor HitWall)
{
	Explode(Location,HitNormal);
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	local PlayerController PC;

    HurtRadius(0, DamageRadius, MyDamageType, MomentumTransfer, HitLocation);

    if ( EffectIsRelevant(Location,false) )
    {
    	Spawn(class'SSPKrakenGroundShock',,,HitLocation + HitNormal*20,rotator(HitNormal));
    	PC = Level.GetLocalPlayerController();
    }
	PlaySound(ImpactSound, SLOT_Misc);
    ShakeView();
    Destroy();
}

defaultproperties
{
     ShakeRotMag=(Z=250.000000)
     ShakeRotRate=(Z=7500.000000)
     ShakeRotTime=30.000000
     ShakeOffsetMag=(Z=40.000000)
     ShakeOffsetRate=(Z=800.000000)
     ShakeOffsetTime=10.000000
     Speed=10000.000000
     MaxSpeed=10000.000000
     DamageRadius=250.000000
     MomentumTransfer=150000.000000
     MyDamageType=None
     ImpactSound=Sound'WeaponSounds.BaseImpactAndExplosions.BExplosion3'
     LifeSpan=99.000000
     DrawScale=5.000000
     SoundVolume=255
     SoundRadius=100.000000
     bProjTarget=True
}
