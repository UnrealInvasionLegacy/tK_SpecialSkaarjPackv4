//-----------------------------------------------------------
//
//-----------------------------------------------------------
class SSPVoidEffects extends emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         UseColorScale=True
         FadeOut=True
         FadeIn=True
         UseSizeScale=True
         UniformSize=True
         ColorScale(0)=(Color=(B=103,G=254,R=167))
         ColorScale(1)=(RelativeTime=0.100000,Color=(B=103,G=254,R=167))
         ColorScale(2)=(RelativeTime=0.800000,Color=(B=103,G=254,R=167))
         ColorScale(3)=(RelativeTime=1.000000,Color=(B=103,G=254,R=167))
         Opacity=0.200000
         FadeOutStartTime=0.900000
         FadeInEndTime=0.200000
         MaxParticles=4
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000)
         StartSizeRange=(Y=(Min=50.000000,Max=50.000000),Z=(Min=50.000000,Max=50.000000))
         DrawStyle=PTDS_Darken
         Texture=Texture'AW-2004Particles.Energy.SmoothRing'
         LifetimeRange=(Min=1.000000,Max=1.000000)
     End Object
     Emitters(0)=SpriteEmitter'tk_SpecialSkaarjPackv4.SSPVoidEffects.SpriteEmitter1'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         UniformSize=True
         StartSizeRange=(X=(Min=20.000000,Max=20.000000))
         DrawStyle=PTDS_Darken
         Texture=Texture'AW-2004Particles.Weapons.LargeSpot'
         LifetimeRange=(Min=0.100000,Max=0.400000)
     End Object
     Emitters(1)=SpriteEmitter'tk_SpecialSkaarjPackv4.SSPVoidEffects.SpriteEmitter2'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter6
         FadeOut=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         BlendBetweenSubdivisions=True
         UseRandomSubdivision=True
         Opacity=0.500000
         FadeOutStartTime=0.900000
         FadeInEndTime=0.200000
         CoordinateSystem=PTCS_Relative
         MaxParticles=40
         SpinCCWorCW=(X=0.000000,Y=0.000000,Z=0.000000)
         SpinsPerSecondRange=(X=(Min=0.200000,Max=0.200000))
         StartSpinRange=(X=(Min=50.000000,Max=55.000000))
         SizeScale(0)=(RelativeSize=0.100000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=0.200000)
         StartSizeRange=(X=(Min=300.000000,Max=300.000000),Y=(Min=300.000000,Max=300.000000),Z=(Min=300.000000,Max=300.000000))
         DrawStyle=PTDS_Darken
         Texture=Texture'EpicParticles.Smoke.Smokepuff2'
         TextureUSubdivisions=1
         TextureVSubdivisions=1
         StartVelocityRange=(X=(Min=-20.000000,Max=20.000000),Y=(Min=-20.000000,Max=20.000000),Z=(Min=-20.000000,Max=20.000000))
     End Object
     Emitters(2)=SpriteEmitter'tk_SpecialSkaarjPackv4.SSPVoidEffects.SpriteEmitter6'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter3
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         UseVelocityScale=True
         MaxParticles=500
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=50.000000,Max=100.000000)
         UseRotationFrom=PTRS_Actor
         SpinCCWorCW=(X=1.000000)
         SpinsPerSecondRange=(X=(Max=4.000000))
         StartSizeRange=(X=(Min=0.100000,Max=1.500000),Y=(Min=1.000000,Max=5.000000),Z=(Min=1.000000,Max=5.000000))
         ParticlesPerSecond=10.000000
         DrawStyle=PTDS_Darken
         Texture=Texture'EpicParticles.Flares.HotSpot'
         LifetimeRange=(Min=0.050000,Max=1.000000)
         InitialDelayRange=(Min=0.500000,Max=0.500000)
         StartVelocityRadialRange=(Min=-0.600000,Max=-0.600000)
         VelocityLossRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
         GetVelocityDirectionFrom=PTVD_AddRadial
         VelocityScale(1)=(RelativeTime=0.200000,RelativeVelocity=(X=-256.000000,Y=-256.000000,Z=-256.000000))
     End Object
     Emitters(3)=SpriteEmitter'tk_SpecialSkaarjPackv4.SSPVoidEffects.SpriteEmitter3'

     bNoDelete=False
     LifeSpan=2.000000
}
