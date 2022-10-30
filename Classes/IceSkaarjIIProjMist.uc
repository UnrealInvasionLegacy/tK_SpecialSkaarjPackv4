//-----------------------------------------------------------
//
//-----------------------------------------------------------
class IceSkaarjIIProjMist extends Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter3
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         UseRandomSubdivision=True
         Opacity=0.500000
         CoordinateSystem=PTCS_Relative
         MaxParticles=20
         SpinsPerSecondRange=(X=(Min=0.200000,Max=0.200000))
         StartSpinRange=(X=(Min=50.000000,Max=55.000000))
         SizeScale(0)=(RelativeSize=0.100000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=0.400000)
         Texture=Texture'XEffects.EmitSmoke_t'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         LifetimeRange=(Min=0.500000,Max=0.750000)
         StartVelocityRange=(X=(Min=-40.000000,Max=40.000000),Y=(Min=-40.000000,Max=40.000000),Z=(Min=-40.000000,Max=40.000000))
     End Object
     Emitters(1)=SpriteEmitter'tk_SpecialSkaarjPackv4.IceSkaarjIIProjMist.SpriteEmitter3'

     AutoDestroy=True
     bNoDelete=False
     bNetTemporary=True
     bHardAttach=True
}
