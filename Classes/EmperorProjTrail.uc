//-----------------------------------------------------------
//
//-----------------------------------------------------------
class EmperorProjTrail extends Emitter;

defaultproperties
{
     Begin Object Class=TrailEmitter Name=TrailEmitter0
         TrailShadeType=PTTST_Linear
         TrailLocation=PTTL_FollowEmitter
         MaxPointsPerTrail=150
         DistanceThreshold=20.000000
         UseCrossedSheets=True
         PointLifeTime=0.150000
         AutomaticInitialSpawning=False
         MaxParticles=1
         StartSizeRange=(X=(Min=12.000000,Max=12.000000))
         InitialParticlesPerSecond=2000.000000
         Texture=Texture'AS_FX_TX.Trails.Trail_red'
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=999999.000000,Max=999999.000000)
     End Object
     Emitters(0)=TrailEmitter'tk_SpecialSkaarjPackv4.EmperorProjTrail.TrailEmitter0'

     AutoDestroy=True
     bNoDelete=False
     Physics=PHYS_Trailer
     bHardAttach=True
     bDirectional=True
}
