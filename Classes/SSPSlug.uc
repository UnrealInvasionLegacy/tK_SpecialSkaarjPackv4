//-----------------------------------------------------------
//
//-----------------------------------------------------------
class SSPSlug extends SMPSlith;

simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
	//These local variables are just for bio spawning
    local int i;
    local SSPSlugMiniBioGlob Glob;
    local rotator rot;
    local vector start;

    AmbientSound = None;
    bCanTeleport = false;
    bReplicateMovement = false;
    bTearOff = true;
    bPlayedDeath = true;

	HitDamageType = DamageType; // these are replicated to other clients
    TakeHitLocation = HitLoc;
	LifeSpan = RagdollLifeSpan;

    GotoState('Dying');

	Velocity += TearOffMomentum;
    BaseEyeHeight = Default.BaseEyeHeight;
	if(PhysicsVolume.bWaterVolume)
		PlayAnim('Dead2',1.2,0.05);
	else
	{
		SetPhysics(PHYS_Falling);
		PlayAnim('Dead1',1.2,0.05);
	}

    //When killed, Slug ejects two goops of bio.
    if ( Role == ROLE_Authority )
	{
        for (i=0; i<2; i++)
		{
			rot = Rotation;
			rot.yaw += FRand()*32000-16000;
			rot.pitch += FRand()*32000-16000;
			rot.roll += FRand()*32000-16000;
			Glob = Spawn( class 'SSPSlugMiniBioGlob',, '', Start, rot);
		}
	}
}

defaultproperties
{
     AmmunitionClass=Class'tk_SpecialSkaarjPackv4.SSPSlugAmmo'
     GroundSpeed=670.000000
     WaterSpeed=650.000000
     DrawScale=2.000000
     Skins(0)=FinalBlend'tk_SpecialSkaarjPackv4.Skins.JSlug1'
     Skins(1)=FinalBlend'tk_SpecialSkaarjPackv4.Skins.JSlug1'
     CollisionRadius=96.000000
     CollisionHeight=94.000000
}
