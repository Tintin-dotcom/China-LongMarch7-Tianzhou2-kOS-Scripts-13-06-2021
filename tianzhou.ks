clearscreen.
wait 4.
lock throttle to 1.
stage.
wait 2.
set target to "Tianhe".
lock inclination to 90 - target:orbit:inclination.
set runmode to "Liftoff".
set fairing to "no".
rcs off.
sas on.
wait 0.5.
sas off.

until runmode = "Done" {
	if runmode = "Liftoff" {
		stage.
	  wait 1.
		set runmode to "Ascent".
	}
	else if runmode = "Ascent" {
		if alt:radar > 350 and alt:radar < 400 {
			sas on.
		}
		if alt:radar > 60000 and fairing = "no" {
			stage.
			set fairing to "yes".
		}
		if ship:apoapsis > target:orbit:apoapsis {
			lock throttle to 0.
			set runmode to "Done".
		}
		turn(inclination).
	}
	
	if ship:stagedeltav(ship:stagenum):current < 20 and fairing = "no" {
		sas off.
		wait 1.
		stage.
	}
	printVesselStats().
}

function printVesselStats {
	clearscreen.
	print "Telemetry:" at(1, 4).
	print "Altitude above sea level: " + round(ship:altitude) + "m" at(10, 5).
	print "Current apoapsis: " + round(ship:apoapsis) + "m" at (10, 6).
	print "Current periapsis: " + round(ship:periapsis) + "m" at (10, 7).
	print "Orbital velocity: " + round(ship:velocity:orbit:mag * 3.6) + "km/h" at(10, 9).
	print "Ship longitude: " + round(ship:longitude) + "º" at (10, 10).
	print "Target longitude: " + round(target:longitude) + "º" at (10, 11).
}

function turn {
	parameter heading.
	if alt:radar < 100 {
		lock angle to 90.
		lock steering to heading(heading, angle).
	}
	else if alt:radar < 1000 {
		lock angle to  (-1 * alt:radar) / 90 + 90.
		lock steering to heading(heading, angle).
	}
	else if alt:radar > 60000 {
		lock steering to prograde.
	}
	else{
		lock angle to 94 - 1.03287 * alt:radar^.4.
		lock steering to heading(heading, angle).
	}
}

