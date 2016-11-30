#dam {
  [zoom >= 13] {
    line-width: 2;
    line-color: #444;
    line-join: round;
    line-cap: round;
  }
  [zoom >= 15] {
    text-name: "[name]";
    text-halo-radius: 1;
    text-fill: #222;
    text-size: 8;
    text-face-name: @book-fonts;
  }
}

