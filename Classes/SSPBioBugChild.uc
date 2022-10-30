//-----------------------------------------------------------
//
//-----------------------------------------------------------
class SSPBioBugChild extends SSPBioBug;

var SSPEmperor MotherEmperor;


simulated function PreBeginPlay()
{
//	Log(Owner);
	MotherEmperor=SSPEmperor(Owner);
	if(MotherEmperor==none)
		Destroy();
	Super.PreBeginPlay();
}
function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType)
{
	if(EventInstigator.IsA('SSPEmperor'))
		Destroy();
	super.TakeDamage( Damage,EventInstigator,HitLocation, Momentum, DamageType);
}

function Tick(float DeltaTime)
{
	super.Tick(DeltaTime);
	if(MotherEmperor==none || MotherEmperor.Controller==none || MotherEmperor.Controller.Enemy==self)
	{
		Destroy();
		return;
	}
	if(MotherEmperor.Controller!=none && Controller!=none && Health>=0)
	{
		Controller.Enemy=MotherEmperor.Controller.Enemy;
		Controller.Target=MotherEmperor.Controller.Target;
	}
}

function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	Destroy();
}
function bool MeleeDamageTarget(int hitdamage, vector pushdir)
{
	local vector HitLocation, HitNormal;
	local actor HitActor;
	if(MotherEmperor==none)
		return false;
	// check if still in melee range
	If ( (Controller.target != None) && (VSize(Controller.Target.Location - Location) <= MeleeRange * 1.4 + Controller.Target.CollisionRadius + CollisionRadius)
		&& ((Physics == PHYS_Flying) || (Physics == PHYS_Swimming) || (Abs(Location.Z - Controller.Target.Location.Z)
			<= FMax(CollisionHeight, Controller.Target.CollisionHeight) + 0.5 * FMin(CollisionHeight, Controller.Target.CollisionHeight))) )
	{
		HitActor = Trace(HitLocation, HitNormal, Controller.Target.Location, Location, false);
		if ( HitActor != None )
			return false;
		Controller.Target.TakeDamage(hitdamage, MotherEmperor,HitLocation, pushdir, class'MeleeDamage');
		return true;
	}
	return false;
}

function Destroyed()
{
	if ( MotherEmperor != None )
		MotherEmperor.numChildren--;
	Super.Destroyed();
}
function bool SameSpeciesAs(Pawn P)
{
	return ( Monster(P) != none &&
		(P.IsA('SSPBioBug') || P.IsA('SMPQueen') || P.IsA('SkaarjPupae')|| P.IsA('SSPEmperor')));
}

defaultproperties
{
     ScoringValue=0
}
