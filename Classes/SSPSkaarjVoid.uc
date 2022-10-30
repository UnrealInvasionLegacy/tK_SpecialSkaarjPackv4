//-----------------------------------------------------------
//
//-----------------------------------------------------------
class SSPSkaarjVoid extends Projectile;

var() float Attraction, ActiveTime;

var SSPVoidEffect TrailEffect;
var SSPVoidRingEffect RingTrail;

var SSPVoidEffects VoidEffects;

var SSPAntiSkaarj AntiSkaarj;

var protected float HurtTime;

simulated function Destroyed()
{
	if ( TrailEffect != None )
		TrailEffect.mRegen = False;
	if ( RingTrail != None )
		RingTrail.mRegen = False;
    Super.Destroyed();
}

simulated function PostBeginPlay()
{
	if (Level.NetMode != NM_DedicatedServer)
	{
        TrailEffect = Spawn(class'SSPVoidEffect',self);
		RingTrail = Spawn(class'SSPVoidRingEffect',self);
	}

    Velocity = Vector(Rotation);
    Velocity *= Speed;

    Super.PostBeginPlay();
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



state Dying
{
	/*
    function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation,
							Vector momentum, class<DamageType> damageType) {} */
	function BeginState()
    {
        bHidden = true;
		SetPhysics(PHYS_None);
		SetCollision(false,false,false);
		SpawnVisualEffects();
        InitialState = 'Dying';
		SetTimer(0.05, false);
        if ( TrailEffect != None )
    		TrailEffect.mRegen = False;
    	if ( RingTrail != None )
    		RingTrail.mRegen = False;
    }

    simulated function SpawnVisualEffects()
    {
    	local float TimeRemaining;

    	//AmbientSound = VortexAmbientSound;	// doesn't work? (works with bFullVolume) - Wormbo
       // PlaySound(VortexAmbientSound, SLOT_Interact, 255.0,, 6000.0);
    	if ( Level.NetMode == NM_DedicatedServer )
    		return;

    	TimeRemaining = ActiveTime;

    	VoidEffects = Spawn(class'SSPVoidEffects',Self);
    }

    simulated function Tick(float DeltaTime)
	{
		local actor Other;
        SuckIt(Other, DeltaTime);
	}

    simulated function SuckIt( actor Other, float DeltaTime )
    {
        local float Dist;
        local vector Momentum, Force, Dir, HitLocation;

        HurtTime += DeltaTime;

        foreach VisibleActors( class'Actor', Other, DamageRadius )
        {
            Dist = VSize(Other.Location - Location);
        	Dir = Normal(Other.Location - Location);
            Force = Dir * ( (Dist - DamageRadius) * Damage );

            //if ( Other.IsA('Projectile') )


            if((Instigator == None) || ((Other != Instigator) && Other != Instigator && (Other.IsA('Pawn')
            || Other.IsA('ONSPowerCore')
            || Other.IsA('DestroyableObjective')
            || Other.IsA('Projectile')
            || Other.bProjTarget) ))

            if ( dist < DamageRadius && HurtTime > 0.2 )
                Other.TakeDamage(Damage, Instigator, HitLocation, Momentum, MyDamageType);

        	if ( Other.Physics == PHYS_Projectile )
				Other.SetRotation(Other.Rotation - rotator(Other.Velocity));

            if (IsAfflicted(Other))
        	{
        		if((Other.Physics == PHYS_KarmaRagdoll) || (Other.Physics == PHYS_Karma))
        		{
        			if ( !Other.KIsAwake() )
        				Other.KWake();
        			Other.KAddImpulse(Force /* / Other.KGetMass() */, Other.Location, 'bip01 Spine');
        		}
        		else
        		{
        			Other.SetPhysics(PHYS_Falling);
        			Force = Force / Other.Mass;
        			Other.Velocity += Force;
        			Other.bBounce = true;
        		}
        	}
        }
        if ( HurtTime > 0.2 )
    		HurtTime -= 0.2;
    }

    simulated function bool IsAfflicted(Actor Other)
    {
    	if (other == none)
            return false;
    	if ((Other.Physics == PHYS_Karma) || (Other.Physics == PHYS_KarmaRagDoll))
    		return true;
    	if (((Other.bMovable) && (!Other.bStatic) &&
    	( (Other.Physics == PHYS_Walking) || (Other.Physics == PHYS_Spider) || (Other.Physics == PHYS_Falling) || (Other.Physics == PHYS_Swimming) || (Other.Physics == PHYS_Flying) || (Other.Physics == PHYS_Karma) || (Other.Physics == PHYS_KarmaRagDoll) ) &&
    	( Other != self ) &&
    	( (Other.bCollideWorld) && (Other.Physics != PHYS_None) ) &&
        (SSPAntiSkaarj(Other) == none) &&
        (SSPVoidEffect(Other) == none) &&
        (SSPVoidRing(Other) == none) &&
        (SSPVoidEffects(Other) == none)))
        {
    	  return true;
    	}
        else
        {
    	  return false;
    	}
        return Other.Physics == PHYS_Projectile || Other.Physics == PHYS_Falling || Other.Physics == PHYS_Karma;
    }

Begin:
	Sleep(ActiveTime);
	Destroy();
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	GotoState('Dying');
}

defaultproperties
{
     Attraction=150.000000
     ActiveTime=0.500000
     Speed=2000.000000
     MaxSpeed=2500.000000
     Damage=20.000000
     DamageRadius=500.000000
     MyDamageType=Class'tk_SpecialSkaarjPackv4.DamTypeAntiSkaarj'
     ExplosionDecal=Class'XEffects.ShockImpactScorch'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'XEffects.EffectsSphere144'
     Physics=PHYS_Flying
     LifeSpan=20.000000
     DrawScale=0.300000
     AmbientGlow=96
     ForceType=FT_DragAlong
     ForceRadius=60.000000
     ForceScale=3.000000
}
