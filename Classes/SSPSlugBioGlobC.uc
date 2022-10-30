//-----------------------------------------------------------
//
//-----------------------------------------------------------
class SSPSlugBioGlobC extends SSPSlugBioGlobB;

simulated function Explode(vector HitLocation, vector HitNormal)
{
	local vector start;
    local rotator rot;
    local int i;
    local SSPSlugMiniBioGlob Glob;

	start = Location - 60 * Dir;

    if ( Role == ROLE_Authority )
	{
		HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation);
		for (i=0; i<8; i++)
		{
			rot = Rotation;
			rot.yaw += FRand()*32000-16000;
			rot.pitch += FRand()*32000-16000;
			rot.roll += FRand()*32000-16000;
			Glob = Spawn( class 'SSPSlugMiniBioGlob',, '', Start, rot);
		}
	}
    Destroy();
}

defaultproperties
{
     Speed=1000.000000
     DrawScale=4.000000
     CollisionRadius=8.000000
     CollisionHeight=8.000000
}
