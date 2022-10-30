//-----------------------------------------------------------
//
//-----------------------------------------------------------
class BlackHeartProjTrail extends Emitter;

#EXEC OBJ LOAD FILE=AS_FX_TX.utx

defaultproperties
{
     Begin Object Class=TrailEmitter Name=TrailEmitter0
         TrailShadeType=PTTST_Linear
         TrailLocation=PTTL_FollowEmitter
         MaxPointsPerTrail=150
         DistanceThreshold=20.000000
         UseCrossedSheets=True
         PointLifeTime=0.750000
         UseColorScale=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=198,R=198))
         ColorScale(1)=(RelativeTime=0.500000,Color=(B=198,R=198))
         ColorScale(2)=(RelativeTime=1.000000,Color=(B=198,R=198))
         MaxParticles=1
         StartSizeRange=(X=(Min=5.000000,Max=5.000000))
         InitialParticlesPerSecond=2000.000000
         Texture=Texture'AS_FX_TX.Trails.Trail_Blue'
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=999999.000000,Max=999999.000000)
     End Object
     Emitters(0)=TrailEmitter'tk_SpecialSkaarjPackv4.BlackHeartProjTrail.TrailEmitter0'

     AutoDestroy=True
     bNoDelete=False
     Physics=PHYS_Trailer
     bHardAttach=True
     bDirectional=True
}
