//-----------------------------------------------------------
//
//-----------------------------------------------------------
class SSPBlackheart extends GasBag;

var bool bRocketDir;
var byte row;

function bool SameSpeciesAs(Pawn P)
{
	return ( Monster(P) != none &&
	(P.IsA('SSPBlackheart') ||  P.IsA('SSPGiantBlackheart')));
}

function vector GetFireStart(vector X, vector Y, vector Z)
{
    return Location + 0.5 * CollisionRadius * (X+Z-Y);
}

function SpawnBelch()
{
	FireProjectile();
	FireProjectile(); //Second Projectile
	FireProjectile(); //Third Projectile
}

function PunchDamageTarget()
{
	if (MeleeDamageTarget(25, (39000 * Normal(Controller.Target.Location - Location))))
		PlaySound(sound'Hit1g', SLOT_Interact);
}

function PoundDamageTarget()
{
	if (MeleeDamageTarget(35, (24000 * Normal(Controller.Target.Location - Location))))
		PlaySound(sound'Hit1g', SLOT_Interact);
}

defaultproperties
{
     AmmunitionClass=Class'tk_SpecialSkaarjPackv4.SSPBlackHeartAmmo'
     ScoringValue=5
     Skins(0)=Texture'tk_SpecialSkaarjPackv4.Skins.BlackHeart1'
     Skins(1)=Texture'tk_SpecialSkaarjPackv4.Skins.BlackHeart2'
}
