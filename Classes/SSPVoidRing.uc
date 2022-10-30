//-----------------------------------------------------------
//
//-----------------------------------------------------------
class SSPVoidRing extends Effects;

var(PclVisuals) color	ColorRange[2];

auto state Start
{
    simulated function Tick(float dt)
    {
        SetDrawScale(FMin(DrawScale + dt*12.0, 1.5));
        if (DrawScale >= 1.5)
        {
            GotoState('End');
        }
    }
}

state End
{
    simulated function Tick(float dt)
    {
        SetDrawScale(FMax(DrawScale - dt*12.0, 0.9));
        if (DrawScale <= 0.9)
        {
            GotoState('');
        }
    }
}

defaultproperties
{
     ColorRange(0)=(B=103,G=254,R=167)
     ColorRange(1)=(B=103,G=254,R=167)
     bTrailerSameRotation=True
     Physics=PHYS_Trailer
     Texture=Texture'AW-2004Particles.Energy.SmoothRing'
     DrawScale=0.350000
     DrawScale3D=(X=0.100000,Y=0.100000,Z=0.350000)
     Skins(0)=Texture'AW-2004Particles.Energy.SmoothRing'
     Style=STY_Subtractive
     Mass=13.000000
}
