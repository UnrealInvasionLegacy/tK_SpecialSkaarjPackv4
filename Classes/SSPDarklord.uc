//-----------------------------------------------------------
//
//-----------------------------------------------------------
class SSPDarklord extends WarLord;

function bool SameSpeciesAs(Pawn P)
{
    return ( Monster(P) != none &&
        (P.IsA('SSPDarklord')));
}

function vector GetFireStart(vector X, vector Y, vector Z)
{
    return Location + 0.5 * CollisionRadius * (X+Z-Y);
}

event Landed(vector HitNormal)
{
    SetPhysics(PHYS_Walking);
    Super.Landed(HitNormal);
}

event HitWall( vector HitNormal, actor HitWall )
{
    if ( HitNormal.Z > MINFLOORZ )
        SetPhysics(PHYS_Walking);
    Super.HitWall(HitNormal,HitWall);
}

function FireProjectile()
{
    local vector FireStart,X,Y,Z;
    local rotator ProjRot;
    local DarkLordRocket R;
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
        R = Spawn(class'DarkLordRocket',,,FireStart,ProjRot);
        R.HomingTarget = Controller.Enemy;
        PlaySound(FireSound,SLOT_Interact);
    }
}

defaultproperties
{
     AmmunitionClass=Class'tk_SpecialSkaarjPackv4.DarklordAmmo'
     ScoringValue=13
     DeResMat0=Shader'tk_SpecialSkaarjPackv4.Decal.Lava_DeRes'
     DeResMat1=Shader'tk_SpecialSkaarjPackv4.Decal.Lava_DeRes'
     Skins(0)=FinalBlend'tk_SpecialSkaarjPackv4.Skins.Darklord1'
     Skins(1)=FinalBlend'tk_SpecialSkaarjPackv4.Skins.Darklord1'
}
