#aerialways [zoom >= 12] {
  [aerialway =~ '(cable_car|gondola|goods)'] {
  	line-pattern-file: url('symbols/cable_car.png');
  }

  [aerialway =~ '(chair_lift|drag_lift|t-bar|j-bar|platter|rope_tow)'] {
    line-pattern-file: url('symbols/chair_lift.png');
  }
}
