//-----------------------------------------------------------
//
//-----------------------------------------------------------
class SSPBlackheartChild extends SSPBlackheart;

var SSPGiantBlackheart ParentGiantBlackheart;

simulated function PreBeginPlay()
{
//	Log(Owner);
	ParentGiantBlackheart=SSPGiantBlackheart(Owner);
	if(ParentGiantBlackheart==none)
		Destroy();
	Super.PreBeginPlay();
}
function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType)
{
	if(EventInstigator.IsA('SSPGiantBlackheart'))
		Destroy();
	super.TakeDamage( Damage,EventInstigator,HitLocation, Momentum, DamageType);
}

function Tick(float DeltaTime)
{
	super.Tick(DeltaTime);
	if(ParentGiantBlackheart==none || ParentGiantBlackheart.Controller==none || ParentGiantBlackheart.Controller.Enemy==self)
	{
		Destroy();
		return;
	}
	if(ParentGiantBlackheart.Controller!=none && Controller!=none && Health>=0)
	{
		Controller.Enemy=ParentGiantBlackheart.Controller.Enemy;
		Controller.Target=ParentGiantBlackheart.Controller.Target;
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
	if(ParentGiantBlackheart==none)
		return false;
	// check if still in melee range
	If ( (Controller.target != None) && (VSize(Controller.Target.Location - Location) <= MeleeRange * 1.4 + Controller.Target.CollisionRadius + CollisionRadius)
		&& ((Physics == PHYS_Flying) || (Physics == PHYS_Swimming) || (Abs(Location.Z - Controller.Target.Location.Z)
			<= FMax(CollisionHeight, Controller.Target.CollisionHeight) + 0.5 * FMin(CollisionHeight, Controller.Target.CollisionHeight))) )
	{
		HitActor = Trace(HitLocation, HitNormal, Controller.Target.Location, Location, false);
		if ( HitActor != None )
			return false;
		Controller.Target.TakeDamage(hitdamage, ParentGiantBlackheart,HitLocation, pushdir, class'MeleeDamage');
		return true;
	}
	return false;
}

function Destroyed()
{
	if ( ParentGiantBlackheart != None )
		ParentGiantBlackheart.numChildren--;
	Super.Destroyed();
}
function bool SameSpeciesAs(Pawn P)
{
	return false;
}

defaultproperties
{
     ScoringValue=0
}
