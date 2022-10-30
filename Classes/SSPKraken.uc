//-----------------------------------------------------------
//
//-----------------------------------------------------------
class SSPKraken extends Monster;

var()	string	MonsterName;
var sound Echo, Victory;

var bool bSetLocation;

function bool SameSpeciesAs(Pawn P)
{
	return ( Monster(P) != none &&
	(P.IsA('SSPKraken') ||  P.IsA('SMPTentacle')));
}

function bool Dodge(eDoubleClickDir DoubleClickMove)
{
	local vector X,Y,Z,duckdir;

    GetAxes(Rotation,X,Y,Z);
	if (DoubleClickMove == DCLICK_Forward)
		duckdir = X;
	else if (DoubleClickMove == DCLICK_Back)
		duckdir = -1*X;
	else if (DoubleClickMove == DCLICK_Left)
		duckdir = Y;
	else if (DoubleClickMove == DCLICK_Right)
		duckdir = -1*Y;

	Controller.Destination = Location + 200 * duckDir;
	Velocity = AirSpeed * duckDir;
	Controller.GotoState('TacticalMove', 'DoMove');
	return true;
}

simulated function PlayDirectionalHit(Vector HitLoc)
{
	TweenAnim('TakeHit', 0.05);
}

simulated function PlayDirectionalDeath(Vector HitLoc)
{
	if ( FRand() < 0.5 )
		PlayAnim('Dead1Land',, 0.1);
	else
		PlayAnim('Dead2',, 0.1);
}

singular function Falling()
{
    SetPhysics(PHYS_Flying);
}

function PlayVictory()
{
	Controller.bPreparingMove = true;
	Acceleration = vect(0,0,0);
	bShotAnim = true;
    PlayAnim('Move1', 0.6, 0.1);
    Controller.Destination = Location;
    Controller.GotoState('TacticalMove','WaitForAnim');
}

Simulated function PlayWaiting()
{
	Controller.bPreparingMove = true;
	Acceleration = vect(0,0,0);
	bShotAnim = true;
    TweenAnim('Hide', 5.0);
    Controller.Destination = Location;
    Controller.GotoState('TacticalMove','WaitForAnim');
}

simulated function SetMovementPhysics()
{
	SetPhysics(PHYS_Flying);
}

function vector GetFireStart(vector X, vector Y, vector Z)
{
    return Location + CollisionHeight * vect(0,0,-1.2);
}

function SmackTarget()
{
	if ( MeleeDamageTarget(1500, 25000 * Normal(Controller.Target.Location - Location)))
		PlaySound(Sound'splat2tn', SLOT_Interact);
}

function bool MeleeDamageTarget(int hitdamage, vector pushdir)
{
	local vector HitLocation, HitNormal;
	local actor HitActor;

	// check if still in melee range
	if ( (Controller.target != None) && (VSize(Controller.Target.Location - Location) <= MeleeRange * 1.5 + Controller.Target.CollisionRadius + CollisionRadius))
	{
		HitActor = Trace(HitLocation, HitNormal, Controller.Target.Location, Location, false);
		if ( HitActor != None )
			return false;
		Controller.Target.TakeDamage(hitdamage, self,HitLocation, pushdir, class'MeleeDamage');
		return true;
	}
	return false;
}

function RangedAttack(Actor A)
{

	if ( bShotAnim )
		return;
	if ( VSize(A.Location - Location) < MeleeRange + CollisionRadius + A.CollisionRadius )
	{
		Controller.bPreparingMove = true;
		Acceleration = vect(0,0,0);
        PlaySound(Sound'strike2tn', SLOT_Interact);
		SetAnimAction('Smack');
	}
//	else if ( Controller.InLatentExecution(501) ) // LATENT_MOVETO
//		return;
	else
		SetAnimAction('Shoot');
		Controller.bPreparingMove = true;
		Acceleration = vect(0,0,0);

	bShotAnim = true;

}

function Shoot()
{
	local vector FireStart,X,Y,Z;
    local Projectile   Proj;
    local float decision;

	decision = FRand();

    if ( Controller != None )
	{
		GetAxes(Rotation,X,Y,Z);
		FireStart = GetFireStart(X,Y,Z);
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
    }
    if ( decision < 0.250 )
	{

        Proj=Spawn(class'SSPKrakenWave',,,FireStart,Controller.AdjustAim(SavedFireProperties,FireStart,100));
		PlaySound(Echo,SLOT_Interact);
    }
    else if ( decision < 1.000 )
    {
        Spawn(MyAmmo.ProjectileClass,,,FireStart,Controller.AdjustAim(SavedFireProperties,FireStart,100));
        PlaySound(FireSound,SLOT_Interact);
	}
}

simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
    SetPhysics(PHYS_Falling);
	AmbientSound = None;
    bCanTeleport = false;
    bReplicateMovement = false;
    bTearOff = true;
    bPlayedDeath = true;
    	LifeSpan = RagdollLifeSpan;
    Velocity=vect(0,0,800);


    GotoState('Dying');
	//PlaySound(Sound'death2tn', SLOT_Talk, 3 * TransientSoundVolume);
	if ( Velocity.Z > 200 )
		PlayAnim('Dead2', 0.7, 0.1);
	else
	{
		PlayAnim('Dead1', 0.7, 0.1);
		//SetPhysics(PHYS_None);
	}
}

defaultproperties
{
     MonsterName="Kraken"
     Echo=ProceduralSound'OutdoorAmbience.BThunder.P2creature1'
     Victory=ProceduralSound'OutdoorAmbience.BThunder.P1creature1'
     DodgeSkillAdjust=4.000000
     DeathSound(0)=ProceduralSound'OutdoorAmbience.BThunder.Pfrog1'
     DeathSound(1)=ProceduralSound'OutdoorAmbience.BThunder.Pfrog1'
     DeathSound(2)=ProceduralSound'OutdoorAmbience.BThunder.Pfrog1'
     DeathSound(3)=ProceduralSound'OutdoorAmbience.BThunder.Pfrog1'
     FireSound=SoundGroup'WeaponSounds.PulseRifle.PulseRifleFire'
     AmmunitionClass=Class'tk_SpecialSkaarjPackv4.SSPKrakenAmmo'
     ScoringValue=40
     bCanJump=False
     bCanWalk=False
     bCanFly=True
     AirSpeed=330.000000
     Health=2000
     MovementAnims(0)="Float"
     MovementAnims(1)="Float"
     MovementAnims(2)="Float"
     MovementAnims(3)="Float"
     TurnLeftAnim="Waver"
     TurnRightAnim="Waver"
     CrouchAnims(0)="Waver"
     CrouchAnims(1)="Waver"
     CrouchAnims(2)="Waver"
     CrouchAnims(3)="Waver"
     AirAnims(0)="Float"
     AirAnims(1)="Float"
     AirAnims(2)="Float"
     AirAnims(3)="Float"
     TakeoffAnims(0)="Float"
     TakeoffAnims(1)="Float"
     TakeoffAnims(2)="Float"
     TakeoffAnims(3)="Float"
     LandAnims(0)="Float"
     LandAnims(1)="Float"
     LandAnims(2)="Float"
     LandAnims(3)="Float"
     DodgeAnims(0)="Float"
     DodgeAnims(1)="Float"
     DodgeAnims(2)="Float"
     DodgeAnims(3)="Float"
     AirStillAnim="Float"
     TakeoffStillAnim="Float"
     CrouchTurnRightAnim="Float"
     CrouchTurnLeftAnim="Float"
     IdleWeaponAnim="Waver"
     Mesh=VertMesh'satoreMonsterPackMeshes.Tentacle1'
     DrawScale=5.000000
     Skins(0)=FinalBlend'tk_SpecialSkaarjPackv4.Skins.JKraken'
     Skins(1)=None
     CollisionRadius=140.000000
     CollisionHeight=180.000000
     Mass=5000.000000
}
