//-----------------------------------------------------------
//
//-----------------------------------------------------------
class SSPGLRocketCorona extends RocketCorona;

auto state Start
{
    simulated function Tick(float dt)
    {
        SetDrawScale(FMin(DrawScale + dt*12.0, 1.5));
        if (DrawScale >= 3.0)
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
        if (DrawScale <= 1.9)
        {
            GotoState('');
        }
    }
}

defaultproperties
{
     Texture=Texture'tk_SpecialSkaarjPackv4.Decal.GLRocketFlare_red'
     DrawScale=2.400000
     Skins(0)=Texture'tk_SpecialSkaarjPackv4.Decal.GLRocketFlare_red'
}
