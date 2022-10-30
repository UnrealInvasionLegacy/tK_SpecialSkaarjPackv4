//-----------------------------------------------------------
//
//-----------------------------------------------------------
class EmperorSmokeTrail extends xEmitter;

#EXEC OBJ LOAD File=XGameShadersB.utx

defaultproperties
{
     mStartParticles=0
     mMaxParticles=150
     mLifeRange(0)=0.500000
     mLifeRange(1)=0.500000
     mRegenRange(0)=90.000000
     mRegenRange(1)=90.000000
     mSpeedRange(0)=0.000000
     mSpeedRange(1)=0.000000
     mMassRange(0)=-0.030000
     mMassRange(1)=-0.010000
     mRandOrient=True
     mSpinRange(0)=-75.000000
     mSpinRange(1)=75.000000
     mSizeRange(0)=25.000000
     mSizeRange(1)=35.000000
     mGrowthRate=13.000000
     mColorRange(0)=(B=0,G=0)
     mColorRange(1)=(B=0,G=0)
     mAttenFunc=ATF_ExpInOut
     mRandTextures=True
     mNumTileColumns=4
     mNumTileRows=4
     CullDistance=10000.000000
     Physics=PHYS_Trailer
     Skins(0)=Texture'AW-2004Particles.Weapons.SmokePanels1'
     Style=STY_Translucent
}
