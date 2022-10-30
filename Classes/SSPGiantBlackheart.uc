//-----------------------------------------------------------
//
//-----------------------------------------------------------
class SSPGiantBlackheart extends SSPBlackheart;

var int numChildren;
var() int MaxChildren;

var bool	bSpawn;

function RangedAttack(Actor A)
{
	local vector adjust;

	if ( bShotAnim )
		return;
	if ( VSize(A.Location - Location) < MeleeRange + CollisionRadius + A.CollisionRadius )
	{
		adjust = vect(0,0,0);
		adjust.Z = Controller.Target.CollisionHeight;
		Acceleration = AccelRate * Normal(Controller.Target.Location - Location + adjust);
		PlaySound(sound'twopunch1g',SLOT_Talk);
		if (FRand() < 0.5)
			SetAnimAction('TwoPunch');
		else
			SetAnimAction('Pound');
	}

    else
		SetAnimAction('Belch');
    bShotAnim = true;
}

function SpawnChildren()
{
	local NavigationPoint N;
	local SSPBlackheartChild B;

	For ( N=Level.NavigationPointList; N!=None; N=N.NextNavigationPoint )
	{
		if(numChildren>=MaxChildren)
			return;
		else if(vsize(N.Location-Location)<2000 && FastTrace(N.Location,Location))
		{
			B=spawn(class 'SSPBlackheartChild' ,self,,N.Location);
		    if(B!=none)
		    {
		    	B.LifeSpan=20+Rand(10);
				numChildren++;
			}
		}
	}
}

function SpawnBelch()
{
    local int EventNum;

    if ( (numChildren >= MaxChildren) || (FRand() > 0.2) ||(DrawScale==1) )
	{
    	FireProjectile();
	}
    else if (EventNum==0)
		SpawnChildren();
	else
        return;
}

function PunchDamageTarget()
{
	if (MeleeDamageTarget(50, (39000 * Normal(Controller.Target.Location - Location))))
		PlaySound(sound'Hit1g', SLOT_Interact);
}

function PoundDamageTarget()
{
	if (MeleeDamageTarget(70, (24000 * Normal(Controller.Target.Location - Location))))
		PlaySound(sound'Hit1g', SLOT_Interact);
}

defaultproperties
{
     MaxChildren=2
     AmmunitionClass=Class'tk_SpecialSkaarjPackv4.SSPGiantBlackHeartAmmo'
     ScoringValue=8
     DrawScale=4.000000
     CollisionRadius=117.500000
     CollisionHeight=90.000000
}
