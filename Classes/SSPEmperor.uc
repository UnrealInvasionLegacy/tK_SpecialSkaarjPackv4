class SSPEmperor extends SMPQueen config(satoreMonsterPack);

var bool bRocketDir;
var ColorModifier EmperorFadeOutSkin;
var sound eScreamSound[2];

var SSPEmperorShield eShield;

var() sound Cryout;

function PostBeginPlay()
{
	Super.PostBeginPlay();
    GroundSpeed = GroundSpeed * (1 + 0.1 * MonsterController(Controller).Skill);
    EmperorFadeOutSkin= new class'ColorModifier';
	EmperorFadeOutSkin.Material=Skins[0];
	Skins[0]=EmperorFadeOutSkin;
}

simulated function Destroyed()
{
	EmperorFadeOutSkin=none;
    if(eShield!=none)
    	eShield.Destroy();
    super.Destroyed();
}

function bool SameSpeciesAs(Pawn P)
{
	return ( Monster(P) != none &&
		(P.IsA('SSPEmperor') || P.IsA('SMPQueen') || P.IsA('SSPMetalSkaarjII') || P.IsA('SSPIceSkaarjII') || P.IsA('SSPFireSkaarjII') || P.IsA('SSPBioBug')));
}
function vector GetFireStart(vector X, vector Y, vector Z)
{
    return Location + 0.5 * CollisionRadius * (X+Z-Y);
}

simulated function Tick(float DeltaTime)
{
	if(bTeleporting)
	{
		AChannel-=300 *DeltaTime;
	}
	else
		AChannel=255;
	EmperorFadeOutSkin.Color.A=AChannel;

	if(MonsterController(Controller)!=none && Controller.Enemy==none)
	{
		if(MonsterController(Controller).FindNewEnemy())
		{
			SetAnimAction('Meditate');
			GotoState('Teleporting');
			bJustScreamed = false;
	    }
	}


	super.Tick(DeltaTime);
}

function Scream()
{
	local Actor A;
	local int EventNum;


//	PlaySound(ScreamSound, SLOT_Talk, 2 * TransientSoundVolume);
//	PlaySound(ScreamSound, SLOT_None, 2 * TransientSoundVolume);
//	PlaySound(ScreamSound, SLOT_None, 2 * TransientSoundVolume);
	PlaySound(eScreamSound[Rand(2)], SLOT_None, 3 * TransientSoundVolume);
	SetAnimAction('Scream');
	Controller.bPreparingMove = true;
	Acceleration = vect(0,0,0);
	bJustScreamed = true;


	if ( ScreamEvent == '' )
		return;
	ForEach DynamicActors( class 'Actor', A, ScreamEvent )
	{
		A.Trigger(self, Instigator);
		EventNum++;
	}
	if(EventNum==0)
		SpawnChildren();
}

function bool CheckReflect( Vector HitLocation, out Vector RefNormal, int Damage )
{
	local Vector HitDir;
	local Vector FaceDir;
	FaceDir=vector(Rotation);
	HitDir = Normal(Location-HitLocation+ Vect(0,0,8));
	RefNormal=FaceDir;
	if ( FaceDir dot HitDir < -0.26 && eShield!=none) // 68 degree protection arc
	{
		eShield.Flash(Damage);

		return true;
	}
	return false;
}

function SpawnShield()
{
//	log("SpawneShield");
	//New eShield
	if(eShield!=none)
		eShield.Destroy();

	eShield = Spawn(class'SSPEmperorShield',,,Location);
	if(eShield!=none)
	{
		eShield.SetDrawScale(eShield.DrawScale*(drawscale/default.DrawScale));
	    eShield.AimedOffset.X=CollisionRadius;
		eShield.AimedOffset.Y=CollisionRadius;
		eShield.SetCollisionSize(CollisionRadius*1.2,CollisionHeight*1.2);
	}
//	eShield.SetBase(self);

}

function SpawnChildren()
{
	local NavigationPoint N;
	local SSPBioBugChild B;

	For ( N=Level.NavigationPointList; N!=None; N=N.NextNavigationPoint )
	{
		if(numChildren>=MaxChildren)
			return;
		else if(vsize(N.Location-Location)<2000 && FastTrace(N.Location,Location))
		{
			B=spawn(class 'SSPBioBugChild' ,self,,N.Location);
		    if(B!=none)
		    {
		    	B.LifeSpan=20+Rand(10);
				numChildren++;
			}
		}

	}

}

function SpawnShot()
{
		local vector FireStart,X,Y,Z;
        local rotator ProjRot;
		local EmperorSeekingProjectile S;
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

            ProjRot = Controller.AdjustAim(SavedFireProperties,FireStart,1000);

            if ( bRocketDir )
				ProjRot.Yaw += 3072;
			else
				ProjRot.Yaw -= 3072;
			bRocketDir = !bRocketDir;
			S = Spawn(class'EmperorSeekingRocket',,,FireStart,ProjRot);
	        S.Seeking = Controller.Enemy;
			PlaySound(FireSound,SLOT_Interact);

			if ( bRocketDir )
				ProjRot.Yaw += 3072;
			else
				ProjRot.Yaw -= 3072;
			bRocketDir = !bRocketDir;
			S = Spawn(class'EmperorSeekingRocket',,,FireStart,ProjRot);
	        S.Seeking = Controller.Enemy;
			PlaySound(FireSound,SLOT_Interact);
        }
}



simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
	AmbientSound = None;
    bCanTeleport = false;
    bReplicateMovement = false;
    bTearOff = true;
    bPlayedDeath = true;

	HitDamageType = DamageType; // these are replicated to other clients
    TakeHitLocation = HitLoc;
	LifeSpan = RagdollLifeSpan;
    if(eShield!=none)
    	eShield.Destroy();
    GotoState('Dying');

	Velocity += TearOffMomentum;
    BaseEyeHeight = Default.BaseEyeHeight;
    SetPhysics(PHYS_Falling);


	PlayAnim('OutCold',0.7, 0.1);
}

function RangedAttack(Actor A)
{
	local float decision;
//	log("Queen RangedAttack");
	if ( bShotAnim )
		return;
	decision = FRand();
	if ( VSize(A.Location - Location) < MeleeRange + CollisionRadius + A.CollisionRadius )
	{
		if (decision < 0.4)
		{
			PlaySound(Stab, SLOT_Interact);
 			SetAnimAction('Stab');
 		}
		else if (decision < 0.7)
		{
			PlaySound(Claw, SLOT_Interact);
			SetAnimAction('Claw');
		}
		else
		{
			PlaySound(Claw, SLOT_Interact);
			SetAnimAction('Gouge');
		}

	}
	else if (!Controller.bPreparingMove && Controller.InLatentExecution(Controller.LATENT_MOVETOWARD) )
	{
		SetAnimAction(MovementAnims[0]);
		bShotAnim = true;
		return;

	}
	else if(VSize(A.Location-Location)>7000 && (decision < 0.70))
	{
		SetAnimAction('Meditate');
		GotoState('Teleporting');
		bJustScreamed = false;
	}
	else if (!bJustScreamed && (decision < 0.15) )
		Scream();
	else if ( (eShield != None) && (decision < 0.5)
		&& (((A.Location - Location) dot (eShield.Location - Location)) > 0) )
		Scream();
	else if((decision < 0.8 && eShield != None ) || decision < 0.4)
	{
		if ( eShield != None )
			eShield.Destroy();
		row = 0;
		bJustScreamed = false;
		SetAnimAction('Shoot1');
		PlaySound(Shoot, SLOT_Interact);
	}
	else if(eShield==none && (decision < 0.9))
	{
		SetAnimAction('Shield');
	}
	else if(!IsInState('Teleporting') && (decision < 0.6))
	{
		SetAnimAction('Meditate');
		GotoState('Teleporting');
	}
	else
	{
		if ( eShield != None )
			eShield.Destroy();
		row = 0;
		bJustScreamed = false;
		SetAnimAction('Shoot1');
		PlaySound(Shoot, SLOT_Interact);
//		log("Queen :ShootSound");
	}
	Controller.bPreparingMove = true;
	Acceleration = vect(0,0,0);
	bShotAnim = true;
}

state Dying
{
    ignores AnimEnd, Trigger, Bump, HitWall, HeadVolumeChange, PhysicsVolumeChange, Falling, BreathTimer;
    simulated function ProcessHitFX(){}
}

defaultproperties
{
     eScreamSound(0)=Sound'satoreMonsterPackSound.Queen.yell3Q'
     eScreamSound(1)=Sound'satoreMonsterPackSound.Queen.nearby2Q'
     ClawDamage=140
     StabDamage=180
     MonsterName="Emperor"
     AmmunitionClass=Class'tk_SpecialSkaarjPackv4.EmperorAmmo'
     ScoringValue=20
     DrawScale=1.500000
     Skins(0)=Texture'tk_SpecialSkaarjPackv4.Skins.JEmperor1'
     Skins(1)=Texture'tk_SpecialSkaarjPackv4.Skins.JEmperor1'
     CollisionRadius=135.000000
     CollisionHeight=158.500000
}
