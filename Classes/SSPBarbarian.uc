//-----------------------------------------------------------
//
//-----------------------------------------------------------
class SSPBarbarian extends Brute;

var bool bRocketDir;

function bool SameSpeciesAs(Pawn P)
{
	return ( Monster(P) != none &&
	(P.IsA('SSPBarbarian')));
}

function SpawnLeftShot()
{
	local SeekingRocketProj S;
    local rotator ProjRot;
    local vector FireStart;

    bLeftShot = true;
	FireProjectile();

    ProjRot = Controller.AdjustAim(SavedFireProperties,FireStart,600);
		if ( bRocketDir )
			ProjRot.Yaw += 3072;
		else
			ProjRot.Yaw -= 3072;
		bRocketDir = !bRocketDir;
		S = Spawn(class'WarlordRocket',,,FireStart,ProjRot);
        S.Seeking = Controller.Enemy;
		PlaySound(FireSound,SLOT_Interact);
    ProjRot = Controller.AdjustAim(SavedFireProperties,FireStart,600);
		if ( bRocketDir )
			ProjRot.Yaw += 3072;
		else
			ProjRot.Yaw -= 3072;
		bRocketDir = !bRocketDir;
		S = Spawn(class'WarlordRocket',,,FireStart,ProjRot);
        S.Seeking = Controller.Enemy;
		PlaySound(FireSound,SLOT_Interact);
}

function SpawnRightShot()
{
	local SeekingRocketProj S;
    local rotator ProjRot;
    local vector FireStart;

    bLeftShot = false;
	FireProjectile();

    ProjRot = Controller.AdjustAim(SavedFireProperties,FireStart,600);
		if ( bRocketDir )
			ProjRot.Yaw += 3072;
		else
			ProjRot.Yaw -= 3072;
		bRocketDir = !bRocketDir;
		S = Spawn(class'WarlordRocket',,,FireStart,ProjRot);
        S.Seeking = Controller.Enemy;
		PlaySound(FireSound,SLOT_Interact);
    ProjRot = Controller.AdjustAim(SavedFireProperties,FireStart,600);
		if ( bRocketDir )
			ProjRot.Yaw += 3072;
		else
			ProjRot.Yaw -= 3072;
		bRocketDir = !bRocketDir;
		S = Spawn(class'WarlordRocket',,,FireStart,ProjRot);
        S.Seeking = Controller.Enemy;
		PlaySound(FireSound,SLOT_Interact);
}

defaultproperties
{
     bCanStrafe=True
}
