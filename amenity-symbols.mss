.symbols {
  ::aeroway [zoom>=10] {
    [aeroway = 'helipad'][zoom >= 16] {
      point-file: url('symbols/helipad.svg');
      text-name: "[name]";
      text-size: 8;
      text-fill: #6692da;
      text-dy: -12;
      text-face-name: @bold-fonts;
      text-halo-radius: 1;
      text-placement: interior;
      text-wrap-width: 50;
    }

	  [aeroway = 'aerodrome'][aerodrome = 'international'],
	  [aeroway = 'aerodrome'][aerodrome = 'airport'],
	  [aeroway = 'aerodrome'][aerodrome = 'continental'],
	  [aerodrome =~ '(military|airfield)'],
	  [aeroway = 'airport'] {
  		[zoom >= 14] {
  			text-dy: 0;
  			[zoom>=16] { text-size: 20; }
  			text-size: 16;
  			text-name: "[name]";
  			text-fill: grey;
  			text-halo-radius: 1;
  			text-placement: interior;
  			text-face-name: @oblique-fonts;
  		}
  		point-file: url('symbols/airport2.svg');
  		[aerodrome =~ '(military|airfield)'] {
  			point-file: url('symbols/airport-red.svg');
  		}
  		[zoom>=11] {
  			text-dy: -12;
  			text-size: 9;
  			text-name: "[nom]";
  			text-fill: #6692da;
  			[aerodrome =~ '(military|airfield)'] {
          text-fill: black;
          text-face-name: @book-fonts;
        }
  			text-halo-radius: 1;
  			text-placement: interior;
  			text-face-name: @bold-fonts;
  		}
  		[zoom>=13] { text-size: 11; }
	  }

	  [aeroway = 'aerodrome'] {
  		point-file: url('symbols/aerodrome.svg');
  		[zoom>=12] {
  			text-dy: -12;
  			text-name: "[nom]";
  			[zoom>=15] { text-name: "[name]"; }
  			text-size: 9;
  			text-fill: #6692da;
  			text-face-name: @oblique-fonts;
  			text-halo-radius: 1;
  			text-placement: interior;
  		}
	  }
  }
}
