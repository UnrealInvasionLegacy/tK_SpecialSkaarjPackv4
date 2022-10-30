//-----------------------------------------------------------
//
//-----------------------------------------------------------
class SSPCrystalisShard extends SSPCrystalisBigCrystal;

simulated function PostBeginPlay()
{
	local vector Dir;
	local float decision;
	if ( bDeleteMe || IsInState('Dying') )
		return;

	Dir = vector(Rotation);
	Velocity = (speed+Rand(MaxSpeed-speed)) * Dir;
	//SetPhysics(PHYS_Falling);

	decision = FRand();

	if (decision < 0.34)
		SetStaticMesh(staticmesh'AW-2004Crystals.Crops.BrokenSpireTop');
	else if (decision < 0.33)
		SetStaticMesh(staticmesh'AW-2004Crystals.Crops.CrystalShard');
	else if (decision < 0.33)
		SetStaticMesh(staticmesh'tk_SpecialSkaarjPackv4.Projectile.CrystalA');
}

defaultproperties
{
     DrawScale3D=(X=0.700000,Y=0.700000,Z=0.700000)
}
