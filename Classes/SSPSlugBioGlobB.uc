//-----------------------------------------------------------
//
//-----------------------------------------------------------
class SSPSlugBioGlobB extends SSPSlugBioGlob;

function AdjustSpeed()
{
	Velocity = Vector(Rotation) * Speed * 2;
	Velocity.Z += TossZ * 2;
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	local vector start, bstart;
    local rotator rot;
    local int i, x;
    local SSPSlugMiniBioGlob Glob;
    local SSPSlugBioGlobC GlobC;

	start = Location - 40 * Dir;
	bstart = Location - 60 * Dir;

	if ( Role == ROLE_Authority )
	{
		HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation);

        for (i=0; i<6; i++)
		{
			rot = Rotation;
			rot.yaw += FRand()*32000-16000;
			rot.pitch += FRand()*32000-16000;
			rot.roll += FRand()*32000-16000;
			Glob = Spawn( class 'SSPSlugMiniBioGlob',, '', Start, rot);
		}
        //This give the illusion that the big glob is bouncing
		for (x=0; x<1; x++)
		{
			rot = Rotation;
			rot.yaw += FRand()*32000-16000;
			rot.pitch += FRand()*32000-16000;
			rot.roll += FRand()*32000-16000;
			GlobC = Spawn( class 'SSPSlugBioGlobC',, '', bStart, rot);
		}
	}
    Destroy();
}

defaultproperties
{
     Speed=1500.000000
}
