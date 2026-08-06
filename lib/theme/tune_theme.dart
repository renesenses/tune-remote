import 'package:flutter/material.dart';

import 'tune_tokens.dart';

/// The app's Material theme, seeded from the shared Tune design tokens so the
/// accent stays in sync with the iPad app (both consume `tune-design-tokens`).
///
/// Lot 1 wires only the **accent** (amber `TuneTokens.accent`); deeper ground
/// and surface tokens land in a later lot to keep this change low-risk.
ThemeData tuneDarkTheme() => ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: TuneTokens.accent,
        brightness: Brightness.dark,
      ),
    );
