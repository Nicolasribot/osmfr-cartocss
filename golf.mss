#golf [zoom>=16] {
  ::line [geo='line'] {
    [golf = 'hole'] {
    	line-color: black;
    	line-width: 0.5;
    	[name!=''] {
    		text-placement: line;
    		text-name: "[name]";
    		text-face-name: @book-fonts;
    		text-halo-radius: 1;
    		text-halo-fill: fadeout(white, 30%);
    	}
    }
  }

  ::point [geo='point'] {
    [golf = 'hole'],
    [golf='pin'] {
  	point-file: url('symbols/fr/golf.svg');
  	point-transform: "scale(0.4)";
  	[ref!=''] {
  		text-fill: #444;
  		text-name: "[ref]";
  		text-face-name: @book-fonts;
  		text-dy: -10;
  		text-halo-radius: 1;
  		text-halo-fill: fadeout(white, 30%);
  	}
    }
    [golf='tee'] {
    	marker-fill: grey;
    	marker-width: 3;
    	marker-height: 3;
    	[ref!=''] {
    		text-name: "[ref]";
    		text-face-name: @book-fonts;
    		text-dy: 6;
    		text-halo-radius: 1;
    		text-halo-fill: fadeout(white, 30%);
    	}
    }
  }
}
