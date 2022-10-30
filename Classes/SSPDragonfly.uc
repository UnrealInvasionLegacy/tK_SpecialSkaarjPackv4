//-----------------------------------------------------------
//
//-----------------------------------------------------------
class SSPDragonfly extends Razorfly;

function bool SameSpeciesAs(Pawn P)
{
	return ( Monster(P) != none &&
		(P.IsA('SSPDragonfly')));
}

function SpawnBelch()
{
	FireProjectile();
}

function RangedAttack(Actor A)
{
	if ( VSize(A.Location - Location) < MeleeRange + CollisionRadius + A.CollisionRadius )
	{
		if ( MeleeDamageTarget(10, (15000.0 * Normal(A.Location - Location))) )
			PlaySound(sound'injur1rf', SLOT_Talk);

		Controller.Destination = Location + 110 * (Normal(Location - A.Location) + VRand());
		Controller.Destination.Z = Location.Z + 70;
		Velocity = AirSpeed * normal(Controller.Destination - Location);
		Controller.GotoState('TacticalMove', 'DoMove');
	}

    FireProjectile();
}

defaultproperties
{
     AmmunitionClass=Class'tk_SpecialSkaarjPackv4.DragonflyAmmo'
     ScoringValue=3
     Health=50
     DrawScale=3.000000
     Skins(0)=FinalBlend'tk_SpecialSkaarjPackv4.Skins.JDFly1'
     Skins(1)=FinalBlend'tk_SpecialSkaarjPackv4.Skins.JDFly1'
     CollisionRadius=27.000000
     CollisionHeight=15.500000
}
