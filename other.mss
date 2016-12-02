#area-text [zoom >= 8] {
  ::long {
    [way_area >= 150000][zoom >= 14],
    [way_area >= 50000][zoom >= 15],
    [way_area >= 25000][zoom >= 16],
    [zoom >= 17] {
      [zoom >= 17] { text-name: "[name]"; }
      text-name: "[nom]";
      text-halo-radius: 1;
      text-wrap-width: 30;
      text-face-name: @book-fonts;

      // variation de la texte du texte en fonction de la surface du polygone
      text-size: 10;
      [zoom>=14][way_area>100000],
      [zoom>=15][way_area>50000],
      [zoom>=16][way_area>25000],
      [zoom>=17][way_area>10000],
      [zoom>=18][way_area> 5000] {
        text-size: 12;
        text-label-position-tolerance: 6;
      }
      [zoom>=14][way_area>400000],
      [zoom>=15][way_area>200000],
      [zoom>=16][way_area>100000],
      [zoom>=17][way_area>25000],
      [zoom>=18][way_area>10000] {
        text-size: 14;
        text-label-position-tolerance: 7;
      }
      [zoom>=14][way_area>4000000],
      [zoom>=15][way_area>2000000],
      [zoom>=16][way_area>1000000] {
        text-size: 16;
        text-label-position-tolerance: 7;
      }

      [boundary!=''] {
      	text-face-name: @oblique-fonts;
      	[zoom >= 15]
      	{
      		text-fill: grey;
      		text-size: 12;
  	    }
  	    text-halo-radius: 2;
      	text-halo-fill: fadeout(white, 30%);
      	text-label-position-tolerance: 8;
      }

      // variation de la couleur en fonction du type
      text-fill: black;
      [landuse!=''] {
      	text-face-name: @oblique-fonts;
      	text-fill: #444;
      	[landuse='water'] {text-fill: #068;}
        [landuse='forest'] {text-fill: #040;}
        [landuse='retail'] {text-fill: @shop-icon;}
        [landuse='military'] {text-fill: #c00;}
      }
      [leisure!=''] {
        text-face-name: @oblique-fonts;
        text-fill: #060;
        [leisure='marina'] {text-fill: #068;}
      }
      [heritage!=''] {
        text-face-name: @bold-fonts;
    	 	text-fill: #734a08;
    	}
    }
  }


  /* placement du nom court si le long n'a pas pu trouver de place... et si il est différent ! */
  ::short {
    [way_area >= 150000][zoom >= 14],
    [way_area >= 80000][zoom >= 15],
    [way_area >= 20000][zoom >= 16],
    [zoom >= 17] {
      text-name: "[nom]";
    	text-face-name: @book-fonts;
    	text-size: 10;
      text-fill: #000;
    	text-halo-radius: 1;
    	text-wrap-width: 20;
      [zoom>=15][way_area>50000],
    	[zoom>=16][way_area>25000],
    	[zoom>=17][way_area>10000],
    	[zoom>=18][way_area> 5000] {
        text-size: 12;
        text-label-position-tolerance: 6;
      }

    	[boundary!=''] {
    		text-face-name: @oblique-fonts;
    		text-fill: #003;
    		text-halo-radius: 2;
    		text-halo-fill: fadeout(white, 30%);
    	}
    	[landuse!=''] {text-face-name: @oblique-fonts; text-fill: #444;} /* italique grisé pour les landuse */
    	[leisure!=''] {text-face-name: @oblique-fonts; text-fill: #060;} /* italique grisé pour leisure */
    }
  }

}



.text [zoom >= 8] {
  [place = 'island'][zoom >= 12]::place {
    text-name: "[name]";
    text-fill: #000;
    text-size: 9;
    text-face-name: @oblique-fonts;
    text-halo-radius: 1;
    text-placement: interior;
    // variation de la texte du texte en fonction de la surface du polygone
    [zoom>=15][way_area>50000],
    [zoom>=16][way_area>25000],
    [zoom>=17][way_area>10000],
    [zoom>=18][way_area> 5000] {
      text-size: 12;
    }
    [zoom>=15][way_area>250000],
    [zoom>=16][way_area>100000],
    [zoom>=17][way_area>25000],
    [zoom>=18][way_area>10000] {
      text-size: 14;
    }
  }

  [amenity = 'restaurant']::amenity {
    [zoom >= 17] {
      text-name: "[name]";
      text-fill: #734a08;
      text-size: 10;
      text-dy: 9;
      text-face-name: @bold-fonts;
      text-halo-radius: 1;
      text-wrap-width: 34;
      text-placement: interior;
    }
  }

  [amenity = 'pub']::amenity,
  [amenity = 'cafe']::amenity,
  [amenity = 'fast_food']::amenity,
  [amenity = 'beirgarten']::amenity {
    [zoom >= 17] {
      text-name: "[name]";
      text-fill: #734a08;
      text-size: 9;
      text-dy: 9;
      text-face-name: @book-fonts;
      text-halo-radius: 1;
      text-wrap-width: 34;
      text-placement: interior;
	  [zoom >= 19] {
		text-size: 10;
		text-dy: 10;
	  }
    }
  }

  [amenity = 'bar'][zoom >= 17]::amenity {
    text-name: "[name]";
    text-size: 10;
    text-fill: #734a08;
    text-dy: 11;
    text-face-name: @bold-fonts;
    text-halo-radius: 1;
    text-placement: interior;
  }

  [amenity = 'library']::amenity,
  [amenity = 'theatre']::amenity
   {
    [zoom >= 16] {
      [zoom >= 16][zoom<17] { text-name: "[nom]"; }
      text-name: "[name]";
      text-size: 10;
      text-fill: #734a08;
      text-dy: 12;
      text-face-name: @bold-fonts;
      text-halo-radius: 1;
      text-placement: interior;
      // variation de la texte du texte en fonction de la surface du polygone
      [zoom>=16][way_area>25000],
      [zoom>=17][way_area>10000],
      [zoom>=18][way_area> 5000] {
        text-size: 12;
      }
      [zoom>=16][way_area>100000],
      [zoom>=17][way_area>25000],
      [zoom>=18][way_area>10000] {
        text-size: 14;
      }
    }
  }

  [amenity = 'cinema'][zoom >= 17]::amenity {
    text-name: "[name]";
    text-size: 10;
    text-fill: #734a08;
    text-dy: 14;
    text-face-name: @bold-fonts;
    text-halo-radius: 1;
    text-placement: interior;
    // variation de la texte du texte en fonction de la surface du polygone
    [zoom>=17][way_area>10000],
    [zoom>=18][way_area> 5000] {
      text-size: 12;
    }
    [zoom>=17][way_area>25000],
    [zoom>=18][way_area>10000] {
      text-size: 14;
    }
  }

  [amenity = 'parking'][zoom >= 17]::amenity {
    text-name: "[name]";
    text-size: 9;
    text-fill: #0066ff;
    text-dy: 9;
    text-face-name: @book-fonts;
    text-halo-radius: 1;
    text-wrap-width: 34;
    text-placement: interior;
    [access != ''][access != 'public'][access != 'yes'] {
      text-fill: #66ccaf;
    }
	  [zoom >= 19] {
		text-size: 10;
		text-dy: 10;
	  }
  }

  [amenity = 'police'][zoom >= 17]::amenity,
  [amenity = 'fire_station'][zoom >= 17]::amenity {
    text-name: "[name]";
    text-size: 10;
    text-fill: #734a08;
    text-dy: 10;
    text-face-name: @book-fonts;
    text-halo-radius: 1;
    text-wrap-width: 40;
    text-placement: interior;
    // variation de la texte du texte en fonction de la surface du polygone
    [zoom>=15][way_area>50000],
    [zoom>=16][way_area>25000],
    [zoom>=17][way_area>10000],
    [zoom>=18][way_area> 5000] {
      text-size: 12;
    }
    [zoom>=15][way_area>250000],
    [zoom>=16][way_area>100000],
    [zoom>=17][way_area>25000],
    [zoom>=18][way_area>10000] {
      text-size: 14;
    }
  }

  [heritage = '1'][zoom >= 15]::amenity,
  [amenity = 'place_of_worship'][zoom >= 17]::amenity {
    text-name: "[name]";
    text-size: 10;
    text-fill: #000033;
    text-dy: 11;
    text-face-name: @book-fonts;
    text-halo-radius: 1;
    text-wrap-width: 40;
    text-placement: interior;
    [heritage != ''] {
    	text-face-name: @bold-fonts;
    	text-fill: #734a08;
    }
    // variation de la texte du texte en fonction de la surface du polygone
    [zoom>=15][way_area>50000],
    [zoom>=16][way_area>25000],
    [zoom>=17][way_area>10000],
    [zoom>=18][way_area> 5000] {
      text-size: 12;
    }
    [zoom>=15][way_area>250000],
    [zoom>=16][way_area>100000],
    [zoom>=17][way_area>25000],
    [zoom>=18][way_area>10000] {
      text-size: 14;
    }
  }

  [landuse = 'forest'][zoom >= 15]::landuse,
  [natural = 'wood'][zoom >= 15]::natural {
    text-name: "[name]";
    text-fill: #060;
    text-face-name: @oblique-fonts;
    text-halo-radius: 2;
    text-halo-fill: fadeout(white, 30%);
    text-wrap-width: 40;
    text-placement: interior;

    // variation de la texte du texte en fonction de la surface du polygone
    text-size: 10;
    [zoom>=15][way_area>50000],
    [zoom>=16][way_area>25000],
    [zoom>=17][way_area>10000],
    [zoom>=18][way_area> 5000] {
      text-size: 12;
      text-label-position-tolerance: 8;
    }
    [zoom>=15][way_area>250000],
    [zoom>=16][way_area>100000],
    [zoom>=17][way_area>25000],
    [zoom>=18][way_area>10000] {
      text-size: 14;
      text-label-position-tolerance: 10;
    }
  }

  [natural = 'peak']::natural,
  [natural = 'volcano']::natural {
    [zoom >= 13] {
      long/text-name: "[name]";
      long/text-size: 10;
      long/text-fill: brown;
      long/text-dy: 5;
      long/text-face-name: @book-fonts;
      long/text-halo-radius: 1;
      long/text-placement: interior;
      short/text-name: "[nom]";
      short/text-size: 10;
      short/text-fill: brown;
      short/text-dy: 5;
      short/text-face-name: @book-fonts;
      short/text-halo-radius: 1;
      short/text-placement: interior;
      ele/text-name: "[ele]";
      ele/text-size: 9;
      ele/text-fill: brown;
      ele/text-dy: 6;
      ele/text-face-name: @oblique-fonts;
      ele/text-halo-radius: 1;
      ele/text-placement: interior;
      [name != ''] {
        ele/text-dy: 18;
      }
    }
  }

  [mountain_pass = 'yes']::natural,
  [natural = 'saddle']::natural {
    [zoom >= 13] {
      long/text-name: "[name]";
      long/text-size: 10;
      long/text-fill: brown;
      long/text-face-name: @book-fonts;
      long/text-halo-radius: 1;
      long/text-placement: interior;
      short/text-name: "[nom]";
      short/text-size: 10;
      short/text-fill: brown;
      short/text-face-name: @book-fonts;
      short/text-halo-radius: 1;
      short/text-placement: interior;
      ele/text-name: "[ele]";
      ele/text-size: 9;
      ele/text-fill: brown;
      ele/text-face-name: @oblique-fonts;
      ele/text-halo-radius: 1;
      ele/text-placement: interior;
      [name != ''] {
        ele/text-dy: 9;
      }
    }
  }

  [natural = 'cave_entrance'][zoom >= 15]::natural {
    text-name: "[name]";
    text-size: 10;
    text-fill: brown;
    text-dy: 9;
    text-face-name: @book-fonts;
    text-halo-radius: 1;
    text-wrap-width: 20;
    text-placement: interior;
  }

  [historic = 'memorial']::historic,
  [historic = 'archaeological_site']::historic {
    [zoom >= 17] {
      text-name: "[name]";
      text-size: 9;
      text-fill: brown;
      text-dy: 12;
      text-face-name: @book-fonts;
      text-halo-radius: 1;
      text-wrap-width: 20;
      text-placement: interior;
  	  [zoom >= 19] {
    		text-size: 10;
    		text-dy: 13;
  	  }
    }
  }

  [historic = 'castle']::historic {
    [zoom >= 15] {
      text-name: "[name]";
      text-size: 9;
      text-fill: brown;
      text-dy: 9;
      text-face-name: @book-fonts;
      text-halo-radius: 1;
      text-wrap-width: 25;
      text-placement: interior;
  	  [zoom >= 19] {
    		text-size: 10;
    		text-dy: 10;
  	  }
    }
  }

  [natural = 'water']::natural,
  [natural = 'lake']::natural,
  [landuse = 'reservoir']::landuse,
  [landuse = 'basin']::landuse {
    [zoom >= 15] {
      text-name: "[name]";
      text-size: 10;
      text-fill: #6699cc;
      text-face-name: @book-fonts;
      text-halo-radius: 1;
      text-wrap-width: 20;
      text-placement: interior;
      // variation de la texte du texte en fonction de la surface du polygone
      [zoom>=15][way_area>50000],
      [zoom>=16][way_area>25000],
      [zoom>=17][way_area>10000],
      [zoom>=18][way_area> 5000] {
        text-size: 12;
      }
      [zoom>=15][way_area>250000],
      [zoom>=16][way_area>100000],
      [zoom>=17][way_area>25000],
      [zoom>=18][way_area>10000] {
        text-size: 14;
      }
    }
  }

  /* Hmmm */
  [point = 'yes'][leisure != '']::point,
  [point = 'yes'][landuse != '']::point {
    [zoom >= 15] {
      text-name: "[name]";
      text-size: 9;
      text-fill: #000;
      text-face-name: @book-fonts;
      text-halo-radius: 2;
      text-wrap-width: 10;
    }
  }

  [natural = 'bay'][zoom >= 14]::natural {
    text-name: "[name]";
    text-size: 10;
    text-fill: #6699cc;
    text-face-name: @book-fonts;
    text-halo-radius: 1;
    text-wrap-width: 20;
    text-placement: interior;
    // variation de la texte du texte en fonction de la surface du polygone
    [zoom>=15][way_area>50000],
    [zoom>=16][way_area>25000],
    [zoom>=17][way_area>10000],
    [zoom>=18][way_area> 5000] {
      text-size: 12;
    }
    [zoom>=15][way_area>250000],
    [zoom>=16][way_area>100000],
    [zoom>=17][way_area>25000],
    [zoom>=18][way_area>10000] {
      text-size: 14;
    }
  }

  [natural = 'spring'][zoom >= 16]::natural {
    text-name: "[name]";
    text-size: 10;
    text-fill: #6699cc;
    text-face-name: @book-fonts;
    text-halo-radius: 1;
    text-wrap-width: 20;
    text-placement: interior;
  }

  [tourism = 'alpine_hut'][zoom >= 15]::tourism {
    text-name: "[name]";
    text-size: 9;
    text-fill: #6699cc;
    text-dy: 10;
    text-face-name: @book-fonts;
    text-halo-radius: 1;
    text-placement: interior;
    [zoom >= 16] {
      ele/text-name: "[ele]";
      ele/text-size: 8;
      ele/text-fill: #6699cc;
      ele/text-dy: 22;
      ele/text-face-name: @oblique-fonts;
      ele/text-halo-radius: 1;
      ele/text-placement: interior;
    }
  }

  [amenity = 'shelter'][zoom >= 17]::amenity {
    text-name: "[name]";
    text-size: 9;
    text-fill: #6699cc;
    text-dy: 10;
    text-face-name: @book-fonts;
    text-halo-radius: 1;
    text-placement: interior;
    ele/text-name: "[ele]";
    ele/text-size: 8;
    ele/text-fill: #6699cc;
    ele/text-dy: 22;
    ele/text-face-name: @oblique-fonts;
    ele/text-halo-radius: 1;
    ele/text-placement: interior;
  }

  [amenity = 'bank'][zoom >= 17]::amenity {
    text-name: "[name]";
    text-size: 9;
    text-fill: black;
    text-dy: 9;
    text-halo-radius: 1;
    text-placement: interior;
    text-face-name: @book-fonts;
	  [zoom >= 19] {
		text-size: 10;
		text-dy: 10;
	  }
  }

  [tourism = 'hotel']::tourism,
  [tourism = 'hostel']::tourism,
  [tourism = 'chalet']::tourism {
    [zoom >= 17] {
      text-name: "[name]+'\n'+[stars]";
      text-size: 10;
      text-fill: #0066ff;
      text-dy: 11;
      text-face-name: @book-fonts;
      text-halo-radius: 1;
      text-placement: interior;
      text-wrap-width: 70;
    }
  }

  [amenity = 'embassy'][zoom >= 17]::amenity {
    text-name: "[name]";
    text-size: 9;
    text-fill: #0066ff;
    text-dy: 8;
    text-face-name: @book-fonts;
    text-halo-radius: 1;
    text-placement: interior;
    text-wrap-width: 70;
	  [zoom >= 19] {
		text-size: 10;
		text-dy: 10;
	  }
  }

  [tourism = 'guest_house'][zoom >= 17]::tourism {
    text-name: "[name]";
    text-size: 8;
    text-fill: #0066ff;
    text-dy: 9;
    text-face-name: @book-fonts;
    text-halo-radius: 1;
    text-placement: interior;
	  [zoom >= 19] {
		text-size: 10;
		text-dy: 10;
	  }
  }

  [tourism = 'bed_and_breakfast'][zoom >= 17]::tourism {
    text-name: "[name]";
    text-size: 8;
    text-fill: #0066ff;
    text-dy: 7;
    text-face-name: @book-fonts;
    text-halo-radius: 1;
    text-placement: interior;
	  [zoom >= 19] {
		text-size: 10;
		text-dy: 10;
	  }
  }

  [amenity = 'fuel']::amenity {
    [zoom >= 17] {
      text-name: "[name]";
      text-size: 9;
      text-fill: #0066ff;
      text-dy: 9;
      text-face-name: @book-fonts;
      text-halo-radius: 1;
	  [zoom >= 19] {
		text-size: 10;
		text-dy: 10;
	  }
    }
  }

  [tourism = 'camp_site'][zoom >= 17]::tourism {
    text-name: "[name]";
    text-size: 10;
    text-fill: #0066ff;
    text-dy: 15;
    text-face-name: @book-fonts;
    text-halo-radius: 1;
    text-wrap-width: 70;
    // variation de la texte du texte en fonction de la surface du polygone
    [zoom>=17][way_area>10000],
    [zoom>=18][way_area> 5000] {
      text-size: 12;
    }
    [zoom>=17][way_area>25000],
    [zoom>=18][way_area>10000] {
      text-size: 14;
    }
  }

  [tourism = 'caravan_site'][zoom >= 17]::tourism {
    text-name: "[name]";
    text-size: 10;
    text-fill: #0066ff;
    text-dy: 19;
    text-face-name: @book-fonts;
    text-halo-radius: 1;
    text-wrap-width: 70;
    // variation de la texte du texte en fonction de la surface du polygone
    [zoom>=17][way_area>10000],
    [zoom>=18][way_area> 5000] {
      text-size: 12;
    }
    [zoom>=17][way_area>25000],
    [zoom>=18][way_area>10000] {
      text-size: 14;
    }
  }

  [waterway = 'lock'][zoom >= 15]::waterway {
    text-name: "[name]";
    text-size: 9;
    text-dy: 10;
    text-fill: #0066ff;
    text-face-name: @book-fonts;
    text-halo-radius: 1;
    text-wrap-width: 70;
  }

  [leisure = 'marina'][zoom >= 15]::leisure {
    text-name: "[name]";
    text-size: 8;
    text-fill: blue;
    text-face-name: @book-fonts;
    text-halo-radius: 1;
    text-wrap-width: 30;
    text-placement: interior;
    [zoom >= 17] {
      text-size: 10;
    }
  }

  [leisure = 'golf_course'][zoom >= 14]::leisure {
    text-name: "[name]";
    // variation de la texte du texte en fonction de la surface du polygone
    text-size: 10;
    [zoom>=15][way_area>50000],
    [zoom>=16][way_area>25000],
    [zoom>=17][way_area>10000],
    [zoom>=18][way_area> 5000] {
      text-size: 12;
    }
    [zoom>=15][way_area>250000],
    [zoom>=16][way_area>100000],
    [zoom>=17][way_area>25000],
    [zoom>=18][way_area>10000] {
      text-size: 14;
    }
    text-fill: #060;
    text-face-name: @book-fonts;
    text-halo-radius: 1;
    text-wrap-width: 30;
    text-placement: interior;
    text-dy: 12;
    [zoom >= 16] {
      text-size: 12;
      text-fill: grey;
      text-face-name: @oblique-fonts;
      text-dy: 0;
    }
    // variation de la texte du texte en fonction de la surface du polygone
    [zoom>=15][way_area>50000],
    [zoom>=16][way_area>25000],
    [zoom>=17][way_area>10000],
    [zoom>=18][way_area> 5000] {
      text-size: 12;
    }
    [zoom>=15][way_area>250000],
    [zoom>=16][way_area>100000],
    [zoom>=17][way_area>25000],
    [zoom>=18][way_area>10000] {
      text-size: 14;
    }
  }

  [tourism = 'theme_park'][zoom >= 14]::tourism {
    text-name: "[name]";
    text-size: 8;
    text-fill: #734a08;
    text-face-name: @book-fonts;
    text-halo-radius: 1;
    text-wrap-width: 30;
    text-placement: interior;
    [zoom >= 16] {
      text-size: 10;
    }
    // variation de la texte du texte en fonction de la surface du polygone
    [zoom>=15][way_area>50000],
    [zoom>=16][way_area>25000],
    [zoom>=17][way_area>10000],
    [zoom>=18][way_area> 5000] {
      text-size: 12;
    }
    [zoom>=15][way_area>250000],
    [zoom>=16][way_area>100000],
    [zoom>=17][way_area>25000],
    [zoom>=18][way_area>10000] {
      text-size: 14;
    }
  }

  [amenity = 'townhall'][zoom >= 15]::amenity,
  [amenity = 'public_building'][zoom >= 16]::amenity,
  [amenity = 'courthouse'][zoom >= 16] {
    text-name: "[name]";
    text-size: 10;
    text-fill: #666;
    text-wrap-width: 30;
    text-face-name: @bold-fonts;
    text-halo-radius: 1;
    text-placement: interior;
    [amenity = 'townhall'],[amenity = 'courthouse'] { text-dy: 12; }
  }

  [tourism = 'zoo'][zoom >= 15]::tourism,
  [tourism = 'museum'][zoom >= 16]::tourism {
    text-name: "[name]";
    text-size: 10;
    text-dy: 10;
    text-fill: #734a08;
    text-face-name: @bold-fonts;
    text-halo-radius: 1;
    text-wrap-width: 70;
    text-placement: interior;
    // variation de la texte du texte en fonction de la surface du polygone
    [zoom>=16][way_area>25000],
    [zoom>=17][way_area>10000],
    [zoom>=18][way_area> 5000] {
      text-size: 12;
    }
    [zoom>=16][way_area>100000],
    [zoom>=17][way_area>25000],
    [zoom>=18][way_area>10000] {
      text-size: 14;
    }
  }

  [amenity = 'prison'][zoom >= 17]::amenity {
    text-name: "[name]";
    text-size: 10;
    text-fill: #734a08;
    text-dy: 16;
    text-face-name: @book-fonts;
    text-halo-radius: 1;
    text-placement: interior;
  }

  [tourism = 'attraction'][zoom >= 16]::tourism {
    text-name: "[name]";
    text-size: 10;
    text-fill: #660033;
    text-face-name: @book-fonts;
    text-halo-radius: 2;
    text-wrap-width: 10;
    text-placement: interior;
  }

  [amenity = 'university'][zoom >= 15]::amenity {
    [zoom >= 17] { text-name: "[name]"; }
	text-name: "[nom]";
    text-size: 9;
    text-fill: #000033;
    text-face-name: @book-fonts;
    text-halo-radius: 2;
    text-wrap-width: 16;
    text-placement: interior;
  }

  [amenity = 'kindergarten']::amenity,
  [amenity = 'school']::amenity,
  [amenity = 'college']::amenity {
    [zoom >= 15] {
      text-name: "[name]";
      [name =~ '^Section.*']{ text-name: "";} // pas de rendu des "Section d'enseignement..."
      [zoom=15] {
		    [ecole != '']
		    {
          text-name: "[ecole]";
          text-wrap-width: 0;
        }
      }
  	  text-size: 9;
      [zoom>=15][way_area>75000],
      [zoom>=16][way_area>25000],
      [zoom>=17][way_area>10000],
      [zoom>=18][way_area>5000] {
        text-size: 11;
        text-wrap-width: 20;
      }
  	  text-fill: #440;
  	  text-face-name: @book-fonts;
  	  text-halo-radius: 2;
  	  text-wrap-width: 14;
  	  text-placement: interior;
  		text-label-position-tolerance: 0;

    }
  }

	/* affichage du nom court si il n'y avait pas la place pour le nom complet */
  [amenity = 'kindergarten']::amenity2,
  [amenity = 'school']::amenity2,
  [amenity = 'college']::amenity2 {
    [zoom >= 15][ecole != ''] {
	  text-name: "[ecole]";
    [ecole =~ '^Section.*']{ text-name: "";} // pas de rendu des "Section d'enseignement..."
    [zoom>=15][way_area>75000],
    [zoom>=16][way_area>25000],
    [zoom>=17][way_area>10000],
    [zoom>=18][way_area>5000] {
      text-size: 11;
      text-wrap-width: 20;
    }
	  text-fill: #440;
	  text-face-name: @book-fonts;
	  text-halo-radius: 2;
	  text-wrap-width: 0;
	  text-placement: interior;
    }
  }


  [man_made = 'lighthouse'][zoom >= 15]::man_made {
    text-name: "[name]";
    text-size: 9;
    text-fill: #000033;
    text-dy: 16;
    text-face-name: @book-fonts;
    text-halo-radius: 2;
    text-wrap-width: 12;
    text-placement: interior;
  }

  [man_made = 'windmill'][zoom >= 17]::man_made {
    text-name: "[name]";
    text-size: 9;
    text-fill: #734a08;
    text-dy: 12;
    text-face-name: @book-fonts;
    text-halo-radius: 1;
    text-wrap-width: 20;
    text-placement: interior;
  }

  [amenity = 'clinic'][zoom >= 15][way_area>50000]::amenity,
  [amenity = 'clinic'][zoom >= 16]::amenity,
  [amenity = 'hospital'][zoom >= 15][way_area>50000]::amenity,
  [amenity = 'hospital'][zoom >= 16]::amenity {
    long/text-name: "[name]";
    long/text-fill: #3366cc;
    long/text-size: 9;
    long/text-dy: 12;
    long/text-face-name: @book-fonts;
    long/text-halo-radius: 2;
    long/text-wrap-width: 30;
    long/text-placement: interior;
    [zoom>=15][way_area>50000],
    [zoom>=16][way_area>25000],
    [zoom>=17][way_area>10000],
    [zoom>=18][way_area> 5000] {
      long/text-size: 12;
      long/text-wrap-width: 40;
    }

    short/text-name: "[nom]";
    short/text-fill: #3366cc;
    short/text-size: 9;
    short/text-dy: 12;
    short/text-face-name: @book-fonts;
    short/text-halo-radius: 2;
    short/text-wrap-width: 24;
    short/text-placement: interior;
    [zoom>=15][way_area>50000],
    [zoom>=16][way_area>25000],
    [zoom>=17][way_area>10000],
    [zoom>=18][way_area> 5000] {
      short/text-size: 12;
      short/text-wrap-width: 30;
    }
 }

  [amenity = 'pharmacy'][zoom >= 17]::amenity {
    text-name: "[name]";
    text-size: 9;
    text-dy: 12;
    text-fill: #008800;
    text-face-name: @book-fonts;
    text-halo-radius: 1;
    text-wrap-width: 12;
    text-placement: interior;
  }

  [amenity = 'vehicle_inspection'][zoom >= 16]::shop,
  [shop != ''][zoom >= 16]::shop {
		[zoom >= 17] {
			text-name: "[name]";
			text-size: 8;
			text-fill: #939;
			text-face-name: @book-fonts;
			text-halo-radius: 1;
		 	text-wrap-width: 15;
			text-placement: interior;
      text-dy: 6;

  		[amenity = 'vehicle_inspection'],
      [shop = 'bag'],
  		[shop = 'bakery'],
      [shop = 'beauty'],
  		[shop = 'beverages'],
  		[shop = 'bicycle'],
  		[shop = 'butcher'],
			[shop = 'car'],
      [shop = 'car_parts'],
      [shop = 'car_repair'],
			[shop = 'clothes'],
			[shop = 'confectionery'],
			[shop = 'convenience'],
  		[shop = 'computer'],
			[shop = 'copyshop'],
			[shop = 'doityourself'],
			[shop = 'dry_cleaning'],
      [shop = 'electronics'],
  		[shop = 'fishmonger'],
      [shop = 'florist'],
  		[shop = 'garden_centre'],
      [shop = 'gift'],
			[shop = 'greengrocer'],
			[shop = 'hifi'],
      [shop = 'ice_cream'],
			[shop = 'jewelry'],
			[shop = 'laundry'],
			[shop = 'motorcycle'],
			[shop = 'musical_instrument'],
  		[shop = 'optician'],
      [shop = 'perfumery'],
			[shop = 'photo_studio'],
			[shop = 'photo'],
  		[shop = 'seafood'],
  		[shop = 'shoes'],
      [shop = 'sports'],
      [shop = 'telephone'],
  		[shop = 'toys'] {
				text-dy: 9;
			}

  		[shop = 'furniture'],
  		[shop = 'interior_decoration'],
  		[shop = 'hairdresser'],
			[shop = 'mobile_phone'],
			[shop = 'travel_agency'] {
				text-dy: 10;
			}

	  	[shop = 'alcohol'] {
				text-dy: 12;
			}
	  }

		[zoom >= 19] {
			text-name: "[name]";
			text-size: 10;
			text-fill: #939;
			text-face-name: @book-fonts;
			text-halo-radius: 1;
		 	text-wrap-width: 15;
			text-placement: interior;

  		[amenity = 'vehicle_inspection'],
  		[shop = 'bakery'],
  		[shop = 'beverages'],
  		[shop = 'bicycle'],
  		[shop = 'butcher'],
			[shop = 'car_repair'],
			[shop = 'car'],
			[shop = 'clothes'],
			[shop = 'confectionery'],
			[shop = 'convenience'],
  		[shop = 'computer'],
			[shop = 'copyshop'],
			[shop = 'doityourself'],
			[shop = 'dry_cleaning'],
  		[shop = 'fishmonger'],
  		[shop = 'garden_centre'],
			[shop = 'greengrocer'],
			[shop = 'hifi'],
			[shop = 'jewelry'],
			[shop = 'laundry'],
			[shop = 'motorcycle'],
			[shop = 'musical_instrument'],
  		[shop = 'optician'],
			[shop = 'photo_studio'],
			[shop = 'photo'],
  		[shop = 'seafood'],
  		[shop = 'shoes'],
  		[shop = 'toys'] {
				text-dy: 10;
			}

  		[shop = 'alcohol'],
  		[shop = 'furniture'],
  		[shop = 'interior_decoration'],
  		[shop = 'hairdresser'],
			[shop = 'mobile_phone'],
			[shop = 'travel_agency'] {
				text-dy: 12;
			}
		}

	  [shop = 'supermarket'] {
  		[zoom >= 16] {
  		  text-name: "[name]";
  		  text-size: 9;
  		  text-dy: 10;
  		  text-fill: #939;
  		  text-face-name: @book-fonts;
  		  text-halo-radius: 1;
  		  text-wrap-width: 20;
  		  text-placement: interior;
  		}
  		[zoom >= 19] {
  		  text-name: "[name]";
  		  text-size: 11;
  		  text-dy: 12;
  		  text-fill: #939;
  		  text-face-name: @book-fonts;
  		  text-halo-radius: 1;
  		  text-wrap-width: 20;
  		  text-placement: interior;
  		}
	  }
	  [shop = 'mall'], [shop = 'department_store'] {
  		[zoom >= 16] {
  		  text-name: "[name]";
  		  text-size: 11;
  		  text-dy: 13;
  		  text-fill: #939;
  		  text-face-name: @book-fonts;
  		  text-halo-radius: 1.5;
  		  text-wrap-width: 20;
  		  text-placement: interior;
  		}
	  }
  }

  [military = 'danger_area'][zoom >= 12]::military {
    text-name: "[name]";
    text-size: 9;
    text-fill: pink;
    text-face-name: @bold-fonts;
    text-halo-radius: 1;
    text-wrap-width: 10;
    text-placement: interior;
  }

  [aeroway = 'gate'][zoom >= 17]::aeroway {
    text-name: "[ref]";
    text-size: 9;
    text-fill: #aa66cc;
    text-face-name: @bold-fonts;
    text-halo-radius: 1;
    text-wrap-width: 10;
    text-placement: interior;
    [zoom >= 18] {  text-size: 12; }
  }

  [amenity = 'recycling'][zoom >= 17]::amenity {
    text-name: "[name]";
    text-size: 9;
    text-face-name: @book-fonts;
    text-halo-radius: 1;
    text-wrap-width: 20;
    text-placement: interior;
    text-dy: 8;
  }

  [power = 'plant'][zoom >= 12]::power,
  [power != ''][zoom >= 15]::power {
    text-name: "[name]";
    text-size: 10;
    text-face-name: @book-fonts;
    text-halo-radius: 1;
    text-wrap-width: 70;
    text-placement: interior;
    [power != 'generator'] { text-dy: 12; }
  }
}

// ****************************************************** tunnels


// ****************************************************** links
#roads-text-ref-low-zoom {
	[way_len>10000][zoom>=10],
	[way_len>5000][zoom>=11],
	[way_len>2500][zoom>=12]
	{
	  [highway = 'motorway'][length < 9] {
		[zoom >= 10][zoom < 13] {
		  shield-name: "[ref]";
		  shield-size: 10;
		  shield-fill: #fff;
		  shield-placement: line;
		  shield-file: url("symbols/mot_shield[length].png");
		  shield-spacing: 500;
		  shield-min-distance: 15;
		  shield-face-name: @bold-fonts;
		  [length = 7] { shield-file: url('symbols/mot_shield6.png'); }
		  [length = 8] { shield-file: url('symbols/mot_shield7.png'); }
		}
	  }

	  [highway = 'trunk'][zoom >= 11][zoom < 13] {
		shield-name: "[ref]";
		shield-size: 10;
		shield-fill: #fff;
		shield-placement: line;
		shield-file: url("symbols/tru_shield[length].png");
		shield-spacing: 500;
		shield-min-distance: 15;
		shield-face-name: @bold-fonts;
	  }

	  [highway = 'primary'][zoom >= 11][zoom < 13] {
		shield-name: "[ref]";
		shield-size: 10;
		shield-fill: #fff;
		shield-placement: line;
		shield-file: url("symbols/pri_shield[length].png");
		shield-spacing: 500;
		shield-min-distance: 15;
		shield-face-name: @bold-fonts;
	  }

	  [highway = 'secondary'][zoom >= 12][zoom < 13] {
		shield-name: "[ref]";
		shield-size: 10;
		shield-fill: #fff;
		shield-placement: line;
		shield-file: url("symbols/sec_shield[length].png");
		shield-spacing: 500;
		shield-min-distance: 15;
		shield-face-name: @bold-fonts;
	  }
	}
}

#roads-text-ref {
  [highway = 'motorway'][length < 9] {
    [zoom >= 13] {
      shield-name: "[ref]";
      shield-size: 10;
      shield-fill: #fff;
      shield-placement: line;
      shield-file: url("symbols/mot_shield[length].png");
      shield-spacing: @shield_spacing;
      shield-min-distance: 20;
      shield-face-name: @bold-fonts;
      [length = 7] { shield-file: url('symbols/mot_shield6.png'); }
      [length = 8] { shield-file: url('symbols/mot_shield7.png'); }
    }
  }

  [highway = 'trunk'][zoom >= 13] {
    shield-name: "[ref]";
    shield-size: 10;
    shield-fill: #fff;
    shield-placement: line;
    shield-file: url("symbols/tru_shield[length].png");
    shield-spacing: @shield_spacing;
    shield-min-distance: 20;
    shield-face-name: @bold-fonts;
  }

  [highway = 'primary'][zoom >= 13] {
    shield-name: "[ref]";
    shield-size: 10;
    shield-fill: #fff;
    shield-placement: line;
    shield-file: url("symbols/pri_shield[length].png");
    shield-spacing: @shield_spacing;
    shield-min-distance: 20;
    shield-face-name: @bold-fonts;
  }

  [highway = 'secondary'][bridge = 'no'][zoom >= 13] {
    shield-name: "[ref]";
    shield-size: 10;
    shield-fill: #fff;
    shield-placement: line;
    shield-file: url("symbols/sec_shield[length].png");
    shield-spacing: @shield_spacing;
    shield-min-distance: 20;
    shield-face-name: @bold-fonts;
  }

  [highway = 'tertiary'][bridge = 'no'][zoom >= 13] {
    shield-name: "[ref]";
    shield-size: 10;
    shield-fill: #fff;
    shield-placement: line;
    shield-file: url("symbols/ter_shield[length].png");
    shield-spacing: @shield_spacing;
    shield-min-distance: 20;
    shield-face-name: @bold-fonts;
  }

  [highway = 'unclassified'],
  [highway = 'residential'] {
    [zoom >= 15][bridge = 'no'] {
      text-name: "[ref]";
      text-size: 10;
      text-fill: #000;
      text-face-name: @bold-fonts;
      text-min-distance: 18;
      text-halo-radius: 2;
      text-halo-fill: fadeout(white, 30%);
      text-spacing: @shield_spacing;
      text-placement: line;
      text-dy: 8;
    }
  }

  [highway = 'runway'],
  [highway = 'taxiway'],
  [highway = 'parking_position'][zoom>=16],
  [highway = 'taxipath'][zoom>=16] {
    [zoom >= 15][bridge = 'no'] {
      text-name: "[ref]";
      text-size: 10;
      text-fill: #333;
      // text-spacing: @shield_spacing;
      text-placement: line;
      // text-min-distance: 18;
      text-face-name: @book-fonts;
      text-halo-radius: 1;
    }
  }
}

#roads-text-name {

  [zoom >= 15] {
	text-name: "[nom]";
	text-size: 9;
	text-fill: black;
	text-placement: line;
	text-face-name: @book-fonts;
	text-halo-radius: 1.5;
	text-halo-fill: fadeout(white, 30%);
	[highway != '']  { text-spacing: 300; }
	[tunnel='yes'] { text-opacity: 0.5; }

	[zoom >= 15][zoom<17][railway!=''][way_len != ''][way_len < 1000] { text-name: ""; } /* pas d'affichage des nom des petites voies ferrées comme les quais avant le zoom 17 */

	[zoom>=17] {
		text-name: "[name]";
		text-size: 10;
	}

  	[way_type = ''],					/* masquage du "nom" des objets sans highway,railway,aeroway,route,boundary (cf SQL) */
  	[way_type = 'administrative'] {  /* masquage du "nom" des limites administratives */
		text-name: "";
  	}

  }


  [highway = 'motorway'],
  [highway = 'motorway_link'],
  [highway = 'trunk'],
  [highway = 'trunk_link'],
  [highway = 'primary'],
  [highway = 'primary_link'] {
	[zoom >= 13] {
	  [zoom>=17] { text-name: "[name]"; }
	  text-name: "[nom]";
	  text-size: 8;
	  text-fill: black;
	  text-placement: line;
	  text-face-name: @book-fonts;
	  text-halo-radius: 0;
	}
	[zoom >= 14] {
	  text-size: 9;
	}
	[zoom >= 15] {
	  text-size: 10;
	}
	[zoom >= 17] {
	  text-size: 11;
	}
	[zoom >= 19] {
	  text-size: 13;
	  text-min-path-length: 100;
	  text-fill: #444;
	}
  }
  [highway = 'secondary'],
  [highway = 'secondary_link'] {
	[zoom >= 13] {
	  [zoom>=17] { text-name: "[name]"; }
	  text-name: "[nom]";
	  text-size: 8;
	  text-fill: black;
	  text-placement: line;
	  text-face-name: @book-fonts;
	  text-halo-radius: 0;
	}
	[zoom >= 14] {
	  text-size: 9;
	}
	[zoom >= 15] {
	  text-size: 10;
	}
	[zoom >= 17] {
	  text-size: 11;
	}
	[zoom >= 19] {
	  text-size: 13;
	  text-min-path-length: 100;
	  text-fill: #444;
	}
  }
  [highway = 'tertiary'],
  [highway = 'tertiary_link'] {
	[zoom >= 15] {
	  [zoom>=17] { text-name: "[name]"; }
	  text-name: "[nom]";
	  text-size: 9;
	  text-fill: #000;
	  text-placement: line;
	  text-face-name: @book-fonts;
	  text-halo-radius: 0;
	}
	[zoom >= 17] {
	  text-size: 11;
	}
	[zoom >= 19] {
	  text-size: 13;
	  text-min-path-length: 100;
	  text-fill: #444;
	}
  }
  [highway = 'proposed'],
  [highway = 'construction'] {
	[zoom >= 13] {
	  [zoom>=17] { text-name: "[name]"; }
	  text-name: "[nom]";
	  text-size: 9;
	  text-fill: #000;
	  text-placement: line;
	  text-face-name: @book-fonts;
	  text-halo-radius: 1;
	}
	[zoom >= 16] {
	  text-size: 11;
	}
	[zoom >= 19] {
	  text-size: 13;
	  text-min-path-length: 100;
	  text-fill: #444;
	}
  }

  [highway = 'residential'],
  [highway = 'unclassified'] {
	[zoom >= 15] {
	  [zoom>=17] { text-name: "[name]"; }
	  text-name: "[nom]";
	  text-size: 8;
	  text-spacing: 200;
	  text-placement: line;
	  text-halo-radius: 1;
	  text-face-name: @book-fonts;
	}
	[zoom >= 16] {
	  text-size: 9;
	}
	[zoom >= 17] {
	  text-size: 10;
	}
	[zoom >= 19] {
	  text-size: 12;
	  text-min-path-length: 100;
	  text-fill: #444;
	}
  }

  [zoom >= 15][zoom < 17][railway='platform'],
  [zoom >= 15][railway='platform'][tunnel!=""] {
  	text-name: "";
  	text-face-name: @book-fonts;
  }


  /* Other roads */
#misc-boundaries {
  [zoom >= 7] {
    [zoom < 13] {
      polygon-opacity: 0.05;
      polygon-fill: green;
    }
    line-color: green;
    line-width: 1.5;
    line-dasharray: 4,2;
    line-opacity: 0.15;
    [zoom >= 10] {
      line-width: 3;
      line-dasharray: 6,2;
    }
  }
  [way_area > 200000000][zoom >= 8][zoom < 12],
  [zoom >= 11][zoom < 12] {
    text-name: "[name]";
    text-size: 8;
    text-fill: #9c9;
    text-face-name: @bold-fonts;
    text-halo-radius: 1;
    text-wrap-width: 14;
    [zoom >= 11] { text-size: 11; }
  }
}

#ski [zoom >= 14] {
  [ski_type='downhill'] {
	text-name: "[name]";
	text-placement: line;
	text-face-name: @book-fonts;
    text-halo-radius: 2;
  }
}

#crossroad_names [zoom>=15] {
    text-name: "[name]";
    text-size: 9;
    text-fill: black;
    text-face-name: @book-fonts;
    text-halo-radius: 2;
    text-halo-fill: fadeout(white, 30%);
    text-wrap-width: 20;
    [highway!=''][zoom>=17]	{ text-dy: -15; } /* leave space for the traffic-signal icon */
}
}