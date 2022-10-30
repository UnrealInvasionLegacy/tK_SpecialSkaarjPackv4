//-----------------------------------------------------------
//
//-----------------------------------------------------------
class SSPKrakenGroundShock extends emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         UseColorScale=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=149,G=186,R=196,A=74))
         ColorScale(1)=(RelativeTime=0.900000,Color=(B=149,G=186,R=196))
         ColorScale(2)=(RelativeTime=1.000000)
         FadeOutStartTime=0.500000
         MaxParticles=20
         StartLocationShape=PTLS_All
         UseRotationFrom=PTRS_Actor
         SpinCCWorCW=(X=100.000000,Y=100.000000,Z=100.000000)
         StartSpinRange=(X=(Max=5.000000),Z=(Max=5.000000))
         RotationNormal=(X=5.000000,Y=5.000000,Z=5.000000)
         SizeScale(0)=(RelativeSize=0.100000)
         SizeScale(1)=(RelativeTime=0.500000,RelativeSize=0.500000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.000000)
         StartSizeRange=(X=(Min=20.000000,Max=20.000000),Y=(Min=20.000000,Max=20.000000),Z=(Min=20.000000,Max=20.000000))
         InitialParticlesPerSecond=200.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'EpicParticles.Spots.Spraydirt'
         LifetimeRange=(Min=3.000000,Max=3.000000)
         StartVelocityRange=(X=(Min=-100.000000,Max=100.000000),Y=(Min=-100.000000,Max=100.000000),Z=(Min=-100.000000,Max=100.000000))
     End Object
     Emitters(0)=SpriteEmitter'tk_SpecialSkaarjPackv4.SSPKrakenGroundShock.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         UseColorScale=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UniformSize=True
         AutomaticInitialSpawning=False
         UseVelocityScale=True
         ColorScale(0)=(Color=(B=39,G=34,R=31,A=74))
         ColorScale(1)=(RelativeTime=0.900000,Color=(B=39,G=34,R=31))
         ColorScale(2)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255))
         FadeOutStartTime=0.750000
         MaxParticles=100
         StartLocationShape=PTLS_All
         UseRotationFrom=PTRS_Actor
         SpinCCWorCW=(X=100.000000,Y=100.000000,Z=100.000000)
         StartSpinRange=(X=(Max=5.000000),Z=(Max=5.000000))
         RotationNormal=(X=5.000000,Y=5.000000,Z=5.000000)
         StartSizeRange=(X=(Min=20.000000,Max=20.000000),Y=(Min=20.000000,Max=20.000000),Z=(Min=20.000000,Max=20.000000))
         InitialParticlesPerSecond=500.000000
         DrawStyle=PTDS_Darken
         Texture=Texture'XEffects.EmitSmoke_t'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         LifetimeRange=(Min=3.000000,Max=3.000000)
         StartVelocityRange=(X=(Min=-25.000000,Max=25.000000),Y=(Min=-25.000000,Max=25.000000),Z=(Min=-25.000000,Max=25.000000))
         VelocityScale(0)=(RelativeVelocity=(X=5.000000,Y=5.000000,Z=5.000000))
         VelocityScale(1)=(RelativeTime=0.400000,RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
     End Object
     Emitters(1)=SpriteEmitter'tk_SpecialSkaarjPackv4.SSPKrakenGroundShock.SpriteEmitter1'

     AutoDestroy=True
     bNoDelete=False
     bNetTemporary=True
}
