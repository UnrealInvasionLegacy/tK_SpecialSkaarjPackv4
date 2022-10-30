//-----------------------------------------------------------
//
//-----------------------------------------------------------
class SSPKrakenWaveEmitter extends Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         UseDirectionAs=PTDU_Forward
         UseColorScale=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         ColorScale(0)=(Color=(B=255,G=192,R=160))
         ColorScale(1)=(RelativeTime=0.100000,Color=(B=255,G=192,R=160))
         ColorScale(2)=(RelativeTime=0.800000,Color=(B=255,G=192,R=160))
         ColorScale(3)=(RelativeTime=1.000000,Color=(B=255,G=192,R=160))
         Opacity=0.500000
         UseRotationFrom=PTRS_Actor
         SizeScale(0)=(RelativeSize=2.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=30.000000,Max=30.000000))
         Texture=Texture'AW-2004Particles.Energy.SmoothRing'
         LifetimeRange=(Min=1.000000,Max=1.000000)
         StartVelocityRange=(X=(Min=1.000000,Max=1.000000))
         WarmupTicksPerSecond=1.000000
         RelativeWarmupTime=1.000000
     End Object
     Emitters(0)=SpriteEmitter'tk_SpecialSkaarjPackv4.SSPKrakenWaveEmitter.SpriteEmitter1'

     AutoDestroy=True
     bNoDelete=False
     Physics=PHYS_Trailer
     bHardAttach=True
     bDirectional=True
}
