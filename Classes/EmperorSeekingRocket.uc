//-----------------------------------------------------------
//
//-----------------------------------------------------------
class EmperorSeekingRocket extends EmperorSeekingProjectile;

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
    SetTimer(0.001, true);
}

defaultproperties
{
}
