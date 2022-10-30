//-----------------------------------------------------------
//
//-----------------------------------------------------------
class SSPKrakenProjEmitter extends Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter18
         UseColorScale=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         UseRandomSubdivision=True
         ColorScale(1)=(RelativeTime=0.100000,Color=(B=255,G=192,R=160))
         ColorScale(2)=(RelativeTime=0.800000,Color=(B=255,G=192,R=160))
         ColorScale(3)=(RelativeTime=1.000000)
         CoordinateSystem=PTCS_Relative
         MaxParticles=5
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=0.500000)
         SizeScale(1)=(RelativeTime=0.300000,RelativeSize=0.900000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=0.250000)
         StartSizeRange=(X=(Min=25.000000,Max=25.000000))
         Texture=Texture'AW-2004Particles.Weapons.SmokePanels1'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         LifetimeRange=(Min=0.350000,Max=0.350000)
         StartVelocityRange=(X=(Min=400.000000,Max=400.000000))
         WarmupTicksPerSecond=1.000000
         RelativeWarmupTime=3.000000
     End Object
     Emitters(0)=SpriteEmitter'tk_SpecialSkaarjPackv4.SSPKrakenProjEmitter.SpriteEmitter18'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter54
         UseColorScale=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         ColorScale(1)=(RelativeTime=0.100000,Color=(B=255,G=192,R=160))
         ColorScale(2)=(RelativeTime=0.800000,Color=(B=255,G=192,R=160))
         ColorScale(3)=(RelativeTime=1.000000)
         Opacity=0.500000
         CoordinateSystem=PTCS_Relative
         MaxParticles=200
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=2.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=0.200000)
         StartSizeRange=(X=(Min=30.000000,Max=30.000000))
         Texture=Texture'AW-2004Particles.Weapons.BoloBlob'
         LifetimeRange=(Min=0.300000,Max=0.300000)
         StartVelocityRange=(X=(Min=10000.000000,Max=10000.000000))
         WarmupTicksPerSecond=1.000000
         RelativeWarmupTime=1.000000
     End Object
     Emitters(1)=SpriteEmitter'tk_SpecialSkaarjPackv4.SSPKrakenProjEmitter.SpriteEmitter54'

     AutoDestroy=True
     bNoDelete=False
     Physics=PHYS_Trailer
     bHardAttach=True
     bDirectional=True
}
