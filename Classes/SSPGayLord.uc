//-----------------------------------------------------------
// This is a joke monster.
//-----------------------------------------------------------
class SSPGayLord extends WarLord;

#EXEC OBJ LOAD FILE=Resources\tk_SpecialSkaarjPackv4_rc.usx PACKAGE=tk_SpecialSkaarjPackv4

simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
    local float frame, rate;
    local name seq;
    local LavaDeath LD;
    local RainbowBodyEffect BE;

    if ( DamageType != None )
    {
        if ( DamageType.default.bSkeletize )
        {
            SetOverlayMaterial(DamageType.Default.DamageOverlayMaterial, 4.0, true);
            if (!bSkeletized)
            {
                if ( (Level.NetMode != NM_DedicatedServer) && (SkeletonMesh != None) )
                {
                    if ( DamageType.default.bLeaveBodyEffect )
                    {
                        BE = spawn(class'RainbowBodyEffect',self);
                        if ( BE != None )
                        {
                            BE.DamageType = DamageType;
                            BE.HitLoc = HitLoc;
                            bFrozenBody = true;
                        }
                    }
                    GetAnimParams( 0, seq, frame, rate );
                    LinkMesh(SkeletonMesh, true);
                    Skins.Length = 0;
                    PlayAnim(seq, 0, 0);
                    SetAnimFrame(frame);
                }
                if (Physics == PHYS_Walking)
                    Velocity = Vect(0,0,0);
                TearOffMomentum *= 0.25;
                bSkeletized = true;
                if ( (Level.NetMode != NM_DedicatedServer) && (DamageType == class'FellLava') )
                {
                    LD = spawn(class'LavaDeath', , , Location + vect(0, 0, 10), Rotation );
                    if ( LD != None )
                        LD.SetBase(self);
                    PlaySound( sound'WeaponSounds.BExplosion5', SLOT_None, 1.5*TransientSoundVolume );
                }
            }
        }
        else if ( DamageType.Default.DeathOverlayMaterial != None )
            SetOverlayMaterial(DamageType.Default.DeathOverlayMaterial, DamageType.default.DeathOverlayTime, true);
        else if ( (DamageType.Default.DamageOverlayMaterial != None) && (Level.DetailMode != DM_Low) && !Level.bDropDetail )
            SetOverlayMaterial(DamageType.Default.DamageOverlayMaterial, 2*DamageType.default.DamageOverlayTime, true);
    }

    AmbientSound = None;
    bCanTeleport = false;
    bReplicateMovement = false;
    bTearOff = true;
    bPlayedDeath = true;

    LifeSpan = RagdollLifeSpan;
    GotoState('Dying');

    Velocity += TearOffMomentum;
    BaseEyeHeight = Default.BaseEyeHeight;
    SetInvisibility(0.0);
    PlayDirectionalDeath(HitLoc);
    SetPhysics(PHYS_Falling);
}

function FireProjectile()
{
    local vector FireStart,X,Y,Z;
    local rotator ProjRot;
    local SSPGayLordSeekingRocket R;
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
        ProjRot = Controller.AdjustAim(SavedFireProperties,FireStart,600);
        if ( bRocketDir )
            ProjRot.Yaw += 3072;
        else
            ProjRot.Yaw -= 3072;
        bRocketDir = !bRocketDir;
        R = Spawn(class'SSPGayLordSeekingRocket',,,FireStart,ProjRot);
        R.Seeking = Controller.Enemy;
        PlaySound(FireSound,SLOT_Interact);
    }
}

defaultproperties
{
     AmmunitionClass=Class'tk_SpecialSkaarjPackv4.SSPGayLordAmmo'
     DeResMat0=Shader'tk_SpecialSkaarjPackv4.Decal.Rainbow_DeRes'
     DeResMat1=Shader'tk_SpecialSkaarjPackv4.Decal.Rainbow_DeRes'
     Skins(0)=FinalBlend'tk_SpecialSkaarjPackv4.Skins.JGayLord1'
     Skins(1)=FinalBlend'tk_SpecialSkaarjPackv4.Skins.JGayLord1'
}
