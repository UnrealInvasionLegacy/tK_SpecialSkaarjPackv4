//-----------------------------------------------------------
//
//-----------------------------------------------------------
class DamTypeKrakenBio extends WeaponDamageType
    abstract;

defaultproperties
{
     DeathString="%o was killed by a Kraken's bio."
     FemaleSuicide="%o was killed by a Kraken's bio."
     MaleSuicide="%o was killed by a Kraken's bio."
     bDetonatesGoop=True
     DeathOverlayMaterial=Shader'XGameShaders.PlayerShaders.LinkHit'
     DamageOverlayTime=3.000000
     KDamageImpulse=10000.000000
}
