import 'package:flutter/material.dart';

/// Thème PLACEHOLDER volontairement neutre.
///
/// ⚠️ Aucune identité visuelle ici (couleurs, typographie, formes) : tout sera
/// remplacé une fois le design Figma intégré. On garde juste Material 3 par
/// défaut pour que les écrans soient lisibles pendant le développement de la
/// logique. Ne pas investir dans le style tant que le design n'est pas branché.
class AppTheme {
  const AppTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
      );
}
