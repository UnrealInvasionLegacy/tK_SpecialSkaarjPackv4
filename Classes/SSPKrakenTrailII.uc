//-----------------------------------------------------------
//
//-----------------------------------------------------------
class SSPKrakenTrailII extends Emitter;

defaultproperties
{
     Begin Object Class=TrailEmitter Name=TrailEmitter3
         TrailShadeType=PTTST_Linear
         TrailLocation=PTTL_FollowEmitter
         MaxPointsPerTrail=150
         DistanceThreshold=20.000000
         UseCrossedSheets=True
         PointLifeTime=0.750000
         AutomaticInitialSpawning=False
         MaxParticles=1
         StartSizeRange=(X=(Min=5.000000,Max=5.000000))
         InitialParticlesPerSecond=2000.000000
         Texture=Texture'AW-2004Particles.Energy.SmoothRing'
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=999999.000000,Max=999999.000000)
     End Object
     Emitters(0)=TrailEmitter'tk_SpecialSkaarjPackv4.SSPKrakenTrailII.TrailEmitter3'

     AutoDestroy=True
     bNoDelete=False
     Physics=PHYS_Trailer
     bHardAttach=True
     bDirectional=True
}
