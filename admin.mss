
@admin-boundaries: #ac46ac;
@admin-boundary-line: #6c216c;

#admin-boundaries-text {
  [zoom>=11][admin_level<=6],
  [zoom>=13][admin_level<=8],
  [zoom>=15] /* limites administratives locales (élément de relation) */
  {
    [zoom>=15][zoom<18][nom!=''] { text-name: "[nom]"; }
    [admin_level=7][insee!=''] /* traitement spécifique des noms d'arrondissements */
    {
     	text-name: '      '+[name]+' (arrond.)      ';
    }
    text-name: '      '+[name]+'      ';
    text-fill: @admin-boundaries;
    text-size: 10;
    text-placement: line;
    text-face-name: @oblique-fonts;
    text-halo-radius: 1.5;
    text-halo-fill: fadeout(white, 30%);
    text-min-padding: 50;
    text-min-distance: 50;
    text-max-char-angle-delta: 10;
    text-dy: -7;
    text-spacing: 500;
  }
}

