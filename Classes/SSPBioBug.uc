//-----------------------------------------------------------
//
//-----------------------------------------------------------
class SSPBioBug extends SkaarjPupae;

var byte row;

function bool SameSpeciesAs(Pawn P)
{
	return ( Monster(P) != none &&
		(P.IsA('SSPBioBug') || P.IsA('SMPQueen') || P.IsA('SkaarjPupae')|| P.IsA('SSPEmperor')));
}


function vector GetFireStart(vector X, vector Y, vector Z)
{
    return Location + 0.9 * CollisionRadius * X + 0.9 * CollisionRadius * Y + 0.4 * CollisionHeight * Z;
}

function SpawnShot()
{
	local vector X,Y,Z, projStart;

	if(Controller==none)
		return;
	GetAxes(Rotation,X,Y,Z);

	if (row == 0)
		MakeNoise(1.0);
	if ( !SavedFireProperties.bInitialized )
	{
		SavedFireProperties.AmmoClass = MyAmmo.Class;
		SavedFireProperties.ProjectileClass = MyAmmo.ProjectileClass;
		SavedFireProperties.WarnTargetPct = MyAmmo.WarnTargetPct;
		SavedFireProperties.MaxRange = MyAmmo.MaxRange;
		SavedFireProperties.bTossed = MyAmmo.bTossed;
		SavedFireProperties.bTrySplash = MyAmmo.bTrySplash;
		SavedFireProperties.bLeadTarget = MyAmmo.bLeadTarget;
		SavedFireProperties.bInstantHit = MyAmmo.bInstantHit;
		SavedFireProperties.bInitialized = true;
	}

	projStart = Location + 1 * CollisionRadius * X + ( 0.7 - 0.2 * row) * CollisionHeight * Z + 0.2 * CollisionRadius * Y;
	spawn(MyAmmo.ProjectileClass ,self,,projStart,Controller.AdjustAim(SavedFireProperties,projStart,600));

	projStart = Location + 1 * CollisionRadius * X + ( 0.7 - 0.2 * row) * CollisionHeight * Z - 0.2 * CollisionRadius * Y;
	spawn(MyAmmo.ProjectileClass ,self,,projStart,Controller.AdjustAim(SavedFireProperties,projStart,600));
	row++;
}

function RangedAttack(Actor A)
{
	local float Dist;

	if ( bShotAnim )
		return;

	Dist = VSize(A.Location - Location);
	if ( Dist > 350 )
		return;
	bShotAnim = true;
	PlaySound(ChallengeSound[Rand(4)], SLOT_Interact);
	if ( Dist < MeleeRange + CollisionRadius + A.CollisionRadius )
	{
  		if ( FRand() < 0.5 )
  			SetAnimAction('Bite');
  		else
  			SetAnimAction('Stab');
		MeleeDamageTarget(8, vect(0,0,0));
		Controller.bPreparingMove = true;
		Acceleration = vect(0,0,0);
		return;
	}

	bLunging = false;
	Enable('Bump');
	SetAnimAction('Lunge');
	Velocity = 500 * Normal(A.Location + A.CollisionHeight * vect(0,0,0.75) - Location);
	if ( dist > CollisionRadius + A.CollisionRadius + 35 )
		Velocity.Z += 0.7 * dist;
	SetPhysics(PHYS_Falling);

    FireProjectile();
}

function PlayTakeHit(vector HitLocation, int Damage, class<DamageType> DamageType)
{
	Super.PlayTakeHit(HitLocation, Damage, DamageType);
	FireProjectile();
	FireProjectile();

	return;
}

defaultproperties
{
     AmmunitionClass=Class'tk_SpecialSkaarjPackv4.BioBugAmmo'
     ScoringValue=2
     Skins(0)=Texture'tk_SpecialSkaarjPackv4.Skins.JBioBug1'
     Skins(1)=Texture'tk_SpecialSkaarjPackv4.Skins.JBioBug1'
}
