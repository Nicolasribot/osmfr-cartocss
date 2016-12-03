.stations {
  [railway = 'subway_entrance'][zoom >= 18] {
    point-file: url('symbols/walking.n.12.png');
    point-placement: interior;
  }

  [railway = 'station'] {
  	[zoom >= 12] {
    point-file: url('symbols/halt.png');
    point-placement: interior;

    [zoom >= 13] {
      point-file: url('symbols/station_small.png');
    }

/* logos spécifiques aux réseaux et opérateurs */

    [zoom >= 11] [operator = 'SNCF'][type_ratp = ''][usage!='freight'] {
      point-file: url('symbols/fr/Logo_SNCF.svg');
      point-transform: 'scale(0.10)';
      [zoom>=14] { point-transform: 'scale(0.15)'; }
      [disused = 'yes'] { point-file: url('symbols/station_disused.png'); point-transform: 'scale(1)';}
    }

    [zoom >= 13] {
    	[type_ratp = 'rer'],
    	[type_ratp = 'metro;rer'],
		[type_ratp = 'rer;metro'] {
      		point-file: url('symbols/fr/logo-ratp-rer.svg');
      		point-transform: 'scale(0.04)';
		}
	}

    [zoom >= 14] {
		[l_operator = 'STAR']{
    		point-file: url('symbols/fr/metro_rennes.png');
   		}
 		[l_operator = 'Tisséo']{
    		point-file: url('symbols/fr/toulouse_metro.png');
   		}
 		[l_operator = 'Transpole']{
    		point-file: url('symbols/fr/Lille_Metro_Logo.png');
   		}
    	[l_operator = 'TCL'],[network='TCL']{
    		[l_ref1 = 'F'] {point-file: url('symbols/fr/tcl-funi.png');}
    		point-file: url('symbols/fr/tcl-metro.png');
    	}

   		[type_ratp = 'metro']{
   	 		point-file: url('symbols/fr/logo-ratp-metro.svg');
   	 		point-transform: 'scale(0.04)';
   		}
    }

    [zoom >= 15] {
      point-file: url('symbols/station.png');
      [disused = 'yes'] { point-file: url('symbols/station_disused.png'); }
    }
    /*
    [disused = 'yes'] {
      point-file: url('symbols/station_disused.png'); // 14 and above
    }
    */
  }
  }

  [railway = 'halt'],
  [railway = 'tram_stop'],
  [aerialway = 'station']::aerialway {
    [zoom >= 13] {
      point-file: url('symbols/halt.png');
    }
    [zoom >= 15] {
      point-file: url('symbols/station_small.png');
    }
    [zoom >= 15] {
    	[l_operator = 'TCL'],[network='TCL']{
    	  point-file: url('symbols/fr/tcl-tram.png');
    	}

    	[type_ratp = 'tram']{
			point-file: url('symbols/fr/logo-ratp-tram.svg');
   	 		point-transform: 'scale(0.04)';
    	}

 		[operator = 'Viacités'],
 		[l_operator = 'Viacités']{
    		point-file: url('symbols/fr/Twisto_Logo.png');
   		}
   	}
  }


  [amenity = 'bus_stop']::amenity,
  [highway = 'bus_stop']::highway {
    [zoom >= 16] {
      point-file: url('symbols/bus_stop_small.png');
      point-placement: interior;
    }
    [zoom >= 17] {
    	[type_ratp = 'bus'],[operator='RATP'],[l_operator='RATP'] {
   	 		point-file: url('symbols/fr/logo-ratp-bus.svg');
   	 		point-transform: 'scale(0.04)';
      	}
 		[l_operator = 'TCL'],[network='TCL']{
    		[l_ref1="C"] {point-file: url('symbols/fr/tcl-c.png');}
    		point-file: url('symbols/fr/tcl-bus.png');
   		}
 		[l_operator = 'STAR']{
    		point-file: url('symbols/fr/rennes_bus.png');
    		point-transform: "scale(0.5)";
   		}
 		[operator = 'Viacités'],
 		[l_operator = 'Viacités']{
    		point-file: url('symbols/fr/Twisto_Logo.png');
   		}
		[operator = 'Optymo'],
		[l_operator = 'Optymo'],
		[network = 'Optymo']{
			point-file: url('symbols/fr/bus-belfort-optymo.png');
		}
		point-file: url('symbols/bus_stop.svg');
    }
  }

  [amenity = 'bus_station'][zoom >= 16]::amenity {
    [zoom >= 17] {
    	[type_ratp = 'bus'],[operator='RATP'],[l_operator='RATP'] {
   	 		point-file: url('symbols/fr/logo-ratp-bus.svg');
   	 		point-transform: 'scale(0.06)';
      	}
 		[l_operator = 'TCL'],[network='TCL']{
    	  point-file: url('symbols/fr/tcl-bus.png');
   		}
 		[l_operator = 'STAR']{
    		point-file: url('symbols/fr/rennes_bus.png');
   		}
		[operator = 'Optymo'],
		[l_operator = 'Optymo'],
		[network = 'Optymo']{
			point-file: url('symbols/fr/bus-belfort-optymo.png');
		}
		point-file: url('symbols/bus_stop.svg');
    }

    [type_ratp = 'bus'],[operator='RATP'],[l_operator = 'RATP'] {
   	 	point-file: url('symbols/fr/logo-ratp-bus.svg');
   	 	point-transform: 'scale(0.04)';
    }
    point-file: url('symbols/bus_station.svg');
    point-placement: interior;
  }


}
