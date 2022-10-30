//-----------------------------------------------------------
//
//-----------------------------------------------------------
class DragonflyProj extends Projectile;

var xEmitter Fire;
var class<xEmitter> FireClass;

var protected float TimerIndex;

simulated function Destroyed()
{
	if(Fire != None)
		Fire.Destroy();
/*
	if(FlameTrail != None)
		FlameTrail.Destroy(); */
}

simulated function PostBeginPlay()
{
	//No fire underwater.
	if(PhysicsVolume.bWaterVolume)
	{
		Destroy();
		return;
	}

	if(Level.Netmode != NM_DedicatedServer)
	{
		Fire = spawn(FireClass, self);
		Fire.SetBase(self);
	}

    Velocity = Vector(Rotation) * Speed;

	if(Instigator != None)
		Velocity += 0.5 * Instigator.Velocity;

	Timer();
	SetTimer(0.1, true);
}

simulated function Timer()
{
    local Actor Target;
    local vector HitLocation;
    local vector Momentum;

    TimerIndex = Level.TimeSeconds * 0.3;// Damage radius increases through out lifespan

    SetCollisionSize(CollisionRadius + 2.5, CollisionHeight + 2.5);

        foreach VisibleActors( class'Actor', Target, (DamageRadius * TimerIndex) )
        {
        	if((Instigator == None) || ((Target != Instigator) && Target != Instigator && (Target.IsA('Pawn')
            || Target.IsA('ONSPowerCore')
            || Target.IsA('DestroyableObjective')
            || Target.bProjTarget) ))

            Target.TakeDamage(Damage, Instigator, HitLocation, Momentum, MyDamageType);
        }
}

simulated function ProcessTouch(Actor Other, Vector HitLocation){}
simulated function BlowUp(vector HitLocation){}
simulated function Explode(vector HitLocation, vector HitNormal){}

defaultproperties
{
     FireClass=Class'tk_SpecialSkaarjPackv4.SSPDragonFlyFireBall'
     Speed=700.000000
     MaxSpeed=1100.000000
     TossZ=0.000000
     Damage=10.000000
     DamageRadius=12.000000
     MomentumTransfer=500.000000
     MyDamageType=Class'tk_SpecialSkaarjPackv4.DamTypeDragonfly'
     LightType=LT_Steady
     LightHue=32
     LightSaturation=128
     LightBrightness=16.000000
     LightRadius=8.000000
     DrawType=DT_None
     bDynamicLight=True
     AmbientSound=Sound'GeneralAmbience.firefx1'
     LifeSpan=5.250000
     bFullVolume=True
     SoundVolume=255
     SoundPitch=56
     SoundRadius=128.000000
     CollisionRadius=2.000000
     CollisionHeight=2.000000
     bBlockZeroExtentTraces=False
     bBlockNonZeroExtentTraces=False
     ForceType=FT_Constant
     ForceRadius=60.000000
     ForceScale=3.000000
}
