#aerialways [zoom >= 12] {
  [aerialway =~ '(cable_car|gondola|goods)'] {
  	line-pattern-file: url('symbols/cable_car.png');
   	text-name: [name];
  	text-placement: line;
  	text-face-name: @book-fonts;
	  text-halo-fill: fadeout(white, 50%);
  	text-halo-radius: 2;
  }
}
