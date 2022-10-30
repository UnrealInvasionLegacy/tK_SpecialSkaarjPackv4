//-----------------------------------------------------------
//
//-----------------------------------------------------------
class SSPSlugBioGlob extends BioGlob;

var vector Dir;

function AdjustSpeed()
{
	Velocity = Vector(Rotation) * Speed * 4;
	Velocity.Z += TossZ * 4;
}

auto state Flying
{
    simulated function Landed( Vector HitNormal )
    {
        Explode(Location,HitNormal);
    }

    simulated function HitWall( Vector HitNormal, Actor Wall )
    {
        Landed(HitNormal);
    }
}
/*
function AdjustSpeed()
{
	if ( GoopLevel < 1 )
		Velocity = Vector(Rotation) * Speed * 0.5;
	else
		Velocity = Vector(Rotation) * Speed * 0.25;
	Velocity.Z += TossZ;
} */

simulated function Explode(vector HitLocation, vector HitNormal)
{
	local vector start, bstart;
    local rotator rot;
    local int i, x;
    local SSPSlugMiniBioGlob Glob;
    local SSPSlugBioGlobB GlobB;

	start = Location - 40 * Dir;
	bstart = Location + 80 * Dir;

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
			//rot.yaw += FRand()*32000-16000;
			rot.pitch += FRand()*32000-16000;
			//rot.roll += FRand()*32000-16000;
			GlobB = Spawn( class 'SSPSlugBioGlobB',, '', bStart, rot);
		}
	}
    Destroy();
}

defaultproperties
{
     TossZ=1.000000
     MyDamageType=Class'tk_SpecialSkaarjPackv4.DamTypeSlug'
     DrawScale=5.000000
     CollisionRadius=10.000000
     CollisionHeight=10.000000
}
