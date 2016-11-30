#glaciers-text [zoom >= 8] {
  [way_area >= 10000000][zoom >= 10],
  [way_area >= 5000000][way_area < 10000000][zoom >= 11],
  [way_area < 5000000][zoom >= 12] {
    text-name: "[name]";
    text-size: 9;
    text-fill: #99f;
    text-face-name: @book-fonts;
    text-halo-radius: 1;
    text-wrap-width: 20;
  }
}

#water-lines-casing {
  [waterway =~ '(stream|ditch|drain)'] {
    [zoom >= 13] {
      line-width: 1.5;
      line-color: white;
      [waterway='stream'][zoom >= 15] {
        line-width: 2.5;
      }
    }
  }
}

#water-lines {
  ::rivernames {
    [waterway = 'river'][zoom >= 13] {
      text-name: "[name]";
      text-face-name: @oblique-fonts;
      [boat!='no'] { text-face-name: @bold-oblique-fonts;}
      text-placement: line;
      text-fill: #6699cc;
      text-spacing: 400;
      text-character-spacing: 2;
      text-size: 9;
      text-halo-radius: 1;
      [cemt=~'V'] {text-size: 12;} // larger river name for CEMT class IV and above...
      [zoom >= 14] {
        text-size: 10;
        [cemt='I'],[cemt='II'],[cemt='III'] {text-size: 12;}
        [cemt=~'V'] {text-size: 14;}
      }
      [zoom >= 17] {
        text-size: 12;
        [cemt='I'],[cemt='II'],[cemt='III'] {text-size: 14;}
        [cemt=~'V'] {text-size: 16;}
      }
    }

    [waterway = 'canal'][zoom >= 13] {
      text-name: "[name]";
      text-face-name: @book-fonts;
      [boat!='no'] { text-face-name: @bold-oblique-fonts;}
      text-halo-radius: 1;
      text-size: 8;
      text-placement: line;
      text-fill: #6699cc;
      [zoom >= 14] {
        text-size: 9;
        [lock = 'yes'][zoom >= 17] {
          text-placement: point;
          text-wrap-width: 20;
        }
      }
    }

    [waterway = 'stream'],
    [waterway = 'drain'],
    [waterway = 'ditch'] {
      [zoom >= 15] {
        text-name: "[name]";
        text-face-name: @book-fonts;
        text-size: 8;
        text-fill: #6699cc;
        text-spacing: 600;
        text-placement: line;
        text-halo-radius: 1;
      }
    }

    [waterway = 'derelict_canal'],
    [waterway = 'canal'][disused = 'yes'] {
      [zoom >= 13] {
        text-name: "[name]";
        text-size: 9;
        text-fill: #80d1ae;
        text-face-name: @book-fonts;
        text-placement: line;
        text-spacing: 600;
        text-halo-radius: 1;
      }
      [zoom >= 14] { text-size: 10; }
    }
  }
}

#waterway-bridges {
  [zoom >= 14] {
    line-width: 7;
    line-color: #000;
    line-join: round;
    b/line-width: 6;
    b/line-color: @water-color;
    b/line-cap: round;
    b/line-join: round;
    text-name: "[name]";
    text-size: 9;
    text-fill: #6699cc;
    text-face-name: @book-fonts;
    text-placement: line;
    text-halo-radius: 1;
    [zoom >= 17] {
      line-width: 11;
      b/line-width: 10;
    }
  }
}
