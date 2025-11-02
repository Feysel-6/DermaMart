import 'package:flutter/material.dart';

class ECheckboxTheme{
  ECheckboxTheme._();

  static CheckboxThemeData lightCheckboxTheme = CheckboxThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    checkColor: WidgetStateProperty<Color>.fromMap(<WidgetStatesConstraint, Color>{
      WidgetState.selected: Colors.white,
      WidgetState.any: Colors.black,
    }),
    fillColor: WidgetStateProperty<Color>.fromMap(<WidgetStatesConstraint, Color>{
      WidgetState.selected: Colors.blue,
      WidgetState.any: Colors.transparent,
    })
  );

  static CheckboxThemeData darkCheckboxTheme = CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      checkColor: WidgetStateProperty<Color>.fromMap(<WidgetStatesConstraint, Color>{
        WidgetState.selected: Colors.white,
        WidgetState.any: Colors.black,
      }),
      fillColor: WidgetStateProperty<Color>.fromMap(<WidgetStatesConstraint, Color>{
        WidgetState.selected: Colors.blue,
        WidgetState.any: Colors.transparent,
      })
  );
}
