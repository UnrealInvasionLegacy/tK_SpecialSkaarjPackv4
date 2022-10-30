//-----------------------------------------------------------
//
//-----------------------------------------------------------
class SSPGayLordSeekingRocket extends SSPGayLordRocket;

var Actor Seeking;
var vector InitialDir;

replication
{
    reliable if( bNetInitial && (Role==ROLE_Authority) )
        Seeking, InitialDir;
}

simulated function Timer()
{
    local float VelMag;
    local vector ForceDir;


    if ( InitialDir == vect(0,0,0) )
        InitialDir = Normal(Velocity);

	Acceleration = vect(0,0,0);
    Super.Timer();
    if ( (Seeking != None) && (Seeking != Instigator) )
    {
		// Do normal guidance to target.
		ForceDir = Normal(Seeking.Location - Location);
		if( (ForceDir Dot InitialDir) > 0 )
		{
			VelMag = VSize(Velocity);

			// track vehicles better
			if ( Seeking.Physics == PHYS_Karma )
				ForceDir = Normal(ForceDir * 0.8 * VelMag + Velocity);
			else
				ForceDir = Normal(ForceDir * 0.5 * VelMag + Velocity);
			Velocity =  VelMag * ForceDir;
			Acceleration += 5 * ForceDir;
		}
		// Update rocket so it faces in the direction its going.
		SetRotation(rotator(Velocity));
    }
}

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
    SetTimer(0.1, true);
}

defaultproperties
{
     Speed=1000.000000
     MaxSpeed=1000.000000
     Damage=70.000000
     DamageRadius=200.000000
     LifeSpan=10.000000
}
