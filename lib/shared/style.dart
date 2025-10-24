import 'dart:ui';

import 'package:dicionario/shared/color.dart';

class AppTextStyles {
  AppTextStyles._();

  static final TextStyle buttonWhite = TextStyle(
    color: WhiteTextColor,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  // text style for buttons with black text
  static final TextStyle buttonBlack = TextStyle(
    color: BlackTextColor,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
}

// text style for black text
TextStyle blackTextStyleSmall =  TextStyle(
  color: BlackTextColor,
  fontSize: 10,
  fontWeight: FontWeight.normal,
);
TextStyle blackTextStyleNormal = TextStyle(
  color: BlackTextColor,
  fontSize: 16,
  fontWeight: FontWeight.normal,
);
TextStyle blackTextStyleMedil = TextStyle(
  color: BlackTextColor,
  fontSize: 20,
  fontWeight: FontWeight.normal,
);
TextStyle blackTextStyleLarge = TextStyle(
  color: BlackTextColor,
  fontSize: 24,
  fontWeight: FontWeight.normal,
);

// text style for white text
TextStyle whiteTextStyleSmall = TextStyle(
  color: WhiteTextColor,
  fontSize: 10,
  fontWeight: FontWeight.normal,
);
TextStyle whiteTextStyleNormal = TextStyle(
  color: WhiteTextColor,
  fontSize: 16,
  fontWeight: FontWeight.normal,
);
TextStyle whiteTextStyleMedil = TextStyle(
  color: WhiteTextColor,
  fontSize: 20,
  fontWeight: FontWeight.normal,
);
TextStyle whiteTextStyleLarge = TextStyle(
  color: WhiteTextColor,
  fontSize: 24,
  fontWeight: FontWeight.normal,
);

// text alert style for red text
TextStyle textAlertStyleRed = TextStyle(
  color: RedTextColor,
  fontSize: 10,
  fontWeight: FontWeight.normal,
);