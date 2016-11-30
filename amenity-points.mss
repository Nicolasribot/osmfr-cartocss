.points {
  ::amenity {
    [amenity = 'post_office'][zoom >= 16][operator='bpost'] {
      [indoor='yes'] { point-opacity: 0.5; }
      point-file: url('symbols/fr/logo_bpost.png');
      point-placement: interior;
      point-transform: "scale(0.5)";
        text-name: "[name]";
        text-face-name: @book-fonts;
        text-fill: black;
        text-halo-radius: 1;
        text-wrap-width: 0;
        text-placement: interior;
        text-size: 8;
        text-dy: 10;
    }

  } // ::amenity



  [entrance != ''][zoom >= 17]::entrance {
    marker-fill: black;
    marker-width: 3;
    marker-line-width: 0;
    [entrance='main'] { text-fill: black; marker-width: 3; }
    [entrance='emergency'] { marker-fill: #080; text-fill: #080; } // sorties de secours en vert foncé
  	[ref!=''][nom!=''] { text-name: [nom]+" / "+[ref]; }
  	[nom!=''] { text-name: [nom]; }
  	text-name: "[ref]";
    text-fill: #666;
    text-face-name: @book-fonts;
    text-halo-radius: 1;
    text-placement: interior;
    text-size: 9;
    text-dy: -4;
  }

}
