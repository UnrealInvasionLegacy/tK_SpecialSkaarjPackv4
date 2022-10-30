//-----------------------------------------------------------
//
//-----------------------------------------------------------
class SSPCrystalisBigCrystalA extends SSPCrystalisBigCrystal;
/*
function SpawnChunks(int num)
{
	local int    NumChunks,i;
	local SMPTitanBigRock   TempRock;
	local float pscale;

	NumChunks = 1+Rand(num);
	pscale = 12 * sqrt(0.52/NumChunks);
	speed = VSize(Velocity);
	for (i=0; i<NumChunks; i++)
	{
		TempRock = Spawn(class'SMPTitanBigRock');
		if (TempRock != None )
			TempRock.InitFrag(self, pscale);
	}
	InitFrag(self, 0.5);
}  */

function MakeSound()
{
	local float soundRad;
	soundRad = 90 * DrawScale;

	PlaySound(ImpactSound, SLOT_Misc, DrawScale/20,,soundRad);
}
simulated function HitWall (vector HitNormal, actor Wall)
{
	Velocity = 0.75 * (Velocity - 2 * HitNormal * (Velocity Dot HitNormal));
	SetRotation(rotator(HitNormal));
	setDrawScale( DrawScale* 0.7);
	SpawnChunks(9);
	Destroy();
}

defaultproperties
{
     Speed=1300.000000
     MaxSpeed=1300.000000
     ImpactSound=Sound'satoreMonsterPackSound.Titan.Rockhit'
     StaticMesh=StaticMesh'tk_SpecialSkaarjPackv4.Projectile.crystal'
     DrawScale=15.000000
     DrawScale3D=(X=0.500000,Y=0.500000,Z=0.500000)
     CollisionRadius=60.000000
     CollisionHeight=60.000000
}
