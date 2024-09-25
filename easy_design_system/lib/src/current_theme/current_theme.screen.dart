import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CurrentThemeScreen extends StatefulWidget {
  static const String routeName = '/CurrentThemeScreen';
  const CurrentThemeScreen({super.key});

  @override
  State<CurrentThemeScreen> createState() => _CurrentThemeScreenState();
}

class _CurrentThemeScreenState extends State<CurrentThemeScreen> {
  @override
  Widget build(BuildContext context) {
    final List<
        ({
          String name,
          Color Function(BuildContext context) nameColor,
          String nameColorCode,
          String onName,
          Color Function(BuildContext context) onNameColor,
          String onNameColorCode,
        })> colorUnits = [
      (
        name: 'primary',
        nameColor: (context) => Theme.of(context).colorScheme.primary,
        nameColorCode: 'Theme.of(context).colorScheme.primary',
        onName: 'onPrimary',
        onNameColor: (context) => Theme.of(context).colorScheme.onPrimary,
        onNameColorCode: 'Theme.of(context).colorScheme.onPrimary'
      ),
      (
        name: 'primaryContainer',
        nameColor: (context) => Theme.of(context).colorScheme.primaryContainer,
        nameColorCode: 'Theme.of(context).colorScheme.primaryContainer',
        onName: 'onPrimaryContainer',
        onNameColor: (context) =>
            Theme.of(context).colorScheme.onPrimaryContainer,
        onNameColorCode: 'Theme.of(context).colorScheme.primaryContainer'
      ),
      (
        name: 'primaryFixed',
        nameColor: (context) => Theme.of(context).colorScheme.primaryFixed,
        nameColorCode: 'Theme.of(context).colorScheme.primaryFixed',
        onName: 'onPrimaryFixed',
        onNameColor: (context) => Theme.of(context).colorScheme.onPrimaryFixed,
        onNameColorCode: 'Theme.of(context).colorScheme.onPrimaryFixed'
      ),
      (
        name: 'primaryFixedDim',
        nameColor: (context) => Theme.of(context).colorScheme.primaryFixedDim,
        nameColorCode: 'Theme.of(context).colorScheme.primaryFixedDim',
        onName: 'onPrimaryFixedVariant',
        onNameColor: (context) =>
            Theme.of(context).colorScheme.onPrimaryFixedVariant,
        onNameColorCode: 'Theme.of(context).colorScheme.onPrimaryFixedVariant'
      ),
      (
        name: 'secondary',
        nameColor: (context) => Theme.of(context).colorScheme.secondary,
        nameColorCode: 'Theme.of(context).colorScheme.secondary',
        onName: 'onSecondary',
        onNameColor: (context) => Theme.of(context).colorScheme.onSecondary,
        onNameColorCode: 'Theme.of(context).colorScheme.onSecondary'
      ),
      (
        name: 'secondaryContainer',
        nameColor: (context) =>
            Theme.of(context).colorScheme.secondaryContainer,
        nameColorCode: 'Theme.of(context).colorScheme.secondaryContainer',
        onName: 'onSecondaryContainer',
        onNameColor: (context) =>
            Theme.of(context).colorScheme.onSecondaryContainer,
        onNameColorCode: 'Theme.of(context).colorScheme.onSecondaryContainer'
      ),
      (
        name: 'secondaryFixed',
        nameColor: (context) => Theme.of(context).colorScheme.secondaryFixed,
        nameColorCode: 'Theme.of(context).colorScheme.secondaryFixed',
        onName: 'onSecondaryFixed',
        onNameColor: (context) =>
            Theme.of(context).colorScheme.onSecondaryFixed,
        onNameColorCode: 'Theme.of(context).colorScheme.onSecondaryFixed'
      ),
      (
        name: 'secondaryFixedDim',
        nameColor: (context) => Theme.of(context).colorScheme.secondaryFixedDim,
        nameColorCode: 'Theme.of(context).colorScheme.secondaryFixedDim',
        onName: 'onSecondaryFixedVariant',
        onNameColor: (context) =>
            Theme.of(context).colorScheme.onSecondaryFixedVariant,
        onNameColorCode: 'Theme.of(context).colorScheme.onSecondaryFixedVariant'
      ),
      (
        name: 'tertiary',
        nameColor: (context) => Theme.of(context).colorScheme.tertiary,
        nameColorCode: 'Theme.of(context).colorScheme.tertiary',
        onName: 'onTertiary',
        onNameColor: (context) => Theme.of(context).colorScheme.onTertiary,
        onNameColorCode: 'Theme.of(context).colorScheme.onTertiary'
      ),
      (
        name: 'tertiaryContainer',
        nameColor: (context) => Theme.of(context).colorScheme.tertiaryContainer,
        nameColorCode: 'Theme.of(context).colorScheme.tertiaryContainer',
        onName: 'onTertiaryContainer',
        onNameColor: (context) =>
            Theme.of(context).colorScheme.onTertiaryContainer,
        onNameColorCode: 'Theme.of(context).colorScheme.onTertiaryContainer'
      ),
      (
        name: 'tertiaryFixed',
        nameColor: (context) => Theme.of(context).colorScheme.tertiaryFixed,
        nameColorCode: 'Theme.of(context).colorScheme.tertiaryFixed',
        onName: 'onTertiaryFixed',
        onNameColor: (context) => Theme.of(context).colorScheme.onTertiaryFixed,
        onNameColorCode: 'Theme.of(context).colorScheme.onTertiaryFixed'
      ),
      (
        name: 'tertiaryFixedDim',
        nameColor: (context) => Theme.of(context).colorScheme.tertiaryFixedDim,
        nameColorCode: 'Theme.of(context).colorScheme.tertiaryFixedDim',
        onName: 'onTertiaryFixedVariant',
        onNameColor: (context) =>
            Theme.of(context).colorScheme.onTertiaryFixedVariant,
        onNameColorCode: 'Theme.of(context).colorScheme.onTertiaryFixedVariant'
      ),
      (
        name: 'error',
        nameColor: (context) => Theme.of(context).colorScheme.error,
        nameColorCode: 'Theme.of(context).colorScheme.error',
        onName: 'onError',
        onNameColor: (context) => Theme.of(context).colorScheme.onError,
        onNameColorCode: 'Theme.of(context).colorScheme.onError'
      ),
      (
        name: 'errorContainer',
        nameColor: (context) => Theme.of(context).colorScheme.errorContainer,
        nameColorCode: 'Theme.of(context).colorScheme.errorContainer',
        onName: 'onErrorContainer',
        onNameColor: (context) =>
            Theme.of(context).colorScheme.onErrorContainer,
        onNameColorCode: 'Theme.of(context).colorScheme.onErrorContainer'
      ),
      (
        name: 'surfaceDim',
        nameColor: (context) => Theme.of(context).colorScheme.surfaceDim,
        nameColorCode: 'Theme.of(context).colorScheme.surfaceDim',
        onName: 'onSurface',
        onNameColor: (context) => Theme.of(context).colorScheme.onSurface,
        onNameColorCode: 'Theme.of(context).colorScheme.onSurface'
      ),
      (
        name: 'surface',
        nameColor: (context) => Theme.of(context).colorScheme.surface,
        nameColorCode: 'Theme.of(context).colorScheme.surface',
        onName: 'onSurface',
        onNameColor: (context) => Theme.of(context).colorScheme.onSurface,
        onNameColorCode: 'Theme.of(context).colorScheme.onSurface'
      ),
      (
        name: 'surfaceBright',
        nameColor: (context) => Theme.of(context).colorScheme.surfaceBright,
        nameColorCode: 'Theme.of(context).colorScheme.surfaceBright',
        onName: 'onSurface',
        onNameColor: (context) => Theme.of(context).colorScheme.onSurface,
        onNameColorCode: 'Theme.of(context).colorScheme.onSurface'
      ),
      (
        name: 'surfaceContainerLowest',
        nameColor: (context) =>
            Theme.of(context).colorScheme.surfaceContainerLowest,
        nameColorCode: 'Theme.of(context).colorScheme.surfaceContainerLowest',
        onName: 'onSurface',
        onNameColor: (context) => Theme.of(context).colorScheme.onSurface,
        onNameColorCode: 'Theme.of(context).colorScheme.onSurface'
      ),
      (
        name: 'surfaceContainerLow',
        nameColor: (context) =>
            Theme.of(context).colorScheme.surfaceContainerLow,
        nameColorCode: 'Theme.of(context).colorScheme.surfaceContainerLow',
        onName: 'onSurface',
        onNameColor: (context) => Theme.of(context).colorScheme.onSurface,
        onNameColorCode: 'Theme.of(context).colorScheme.onSurface'
      ),
      (
        name: 'surfaceContainer',
        nameColor: (context) => Theme.of(context).colorScheme.surfaceContainer,
        nameColorCode: 'Theme.of(context).colorScheme.surfaceContainer',
        onName: 'onSurface',
        onNameColor: (context) => Theme.of(context).colorScheme.onSurface,
        onNameColorCode: 'Theme.of(context).colorScheme.onSurface'
      ),
      (
        name: 'surfaceContainerHigh',
        nameColor: (context) =>
            Theme.of(context).colorScheme.surfaceContainerHigh,
        nameColorCode: 'Theme.of(context).colorScheme.surfaceContainerHigh',
        onName: 'onSurface',
        onNameColor: (context) => Theme.of(context).colorScheme.onSurface,
        onNameColorCode: 'Theme.of(context).colorScheme.onSurface'
      ),
      (
        name: 'surfaceContainerHighest',
        nameColor: (context) =>
            Theme.of(context).colorScheme.surfaceContainerHighest,
        nameColorCode: 'Theme.of(context).colorScheme.surfaceContainerHighest',
        onName: 'onSurface',
        onNameColor: (context) => Theme.of(context).colorScheme.onSurface,
        onNameColorCode: 'Theme.of(context).colorScheme.onSurface'
      ),
      (
        name: 'onSurface',
        nameColor: (context) => Theme.of(context).colorScheme.onSurface,
        nameColorCode: 'Theme.of(context).colorScheme.onSurface',
        onName: 'surface',
        onNameColor: (context) => Theme.of(context).colorScheme.surface,
        onNameColorCode: 'Theme.of(context).colorScheme.surface'
      ),
      (
        name: 'onSurfaceVariant',
        nameColor: (context) => Theme.of(context).colorScheme.onSurfaceVariant,
        nameColorCode: 'Theme.of(context).colorScheme.onSurfaceVariant',
        onName: 'surfaceContainerHighest',
        onNameColor: (context) =>
            Theme.of(context).colorScheme.surfaceContainerHighest,
        onNameColorCode: 'Theme.of(context).colorScheme.surfaceContainerHighest'
      ),
      (
        name: 'inverseSurface',
        nameColor: (context) => Theme.of(context).colorScheme.inverseSurface,
        nameColorCode: 'Theme.of(context).colorScheme.inverseSurface',
        onName: 'onInverseSurface',
        onNameColor: (context) =>
            Theme.of(context).colorScheme.onInverseSurface,
        onNameColorCode: 'Theme.of(context).colorScheme.onInverseSurface'
      ),
      (
        name: 'onInverseSurface',
        nameColor: (context) => Theme.of(context).colorScheme.onInverseSurface,
        nameColorCode: 'Theme.of(context).colorScheme.onInverseSurface',
        onName: 'inverseSurface',
        onNameColor: (context) => Theme.of(context).colorScheme.inverseSurface,
        onNameColorCode: 'Theme.of(context).colorScheme.inverseSurface'
      ),
      (
        name: 'inversePrimary',
        nameColor: (context) => Theme.of(context).colorScheme.inversePrimary,
        nameColorCode: 'Theme.of(context).colorScheme.inversePrimary',
        onName: 'primary',
        onNameColor: (context) => Theme.of(context).colorScheme.primary,
        onNameColorCode: 'Theme.of(context).colorScheme.primary'
      ),
      (
        name: 'surfaceTint',
        nameColor: (context) => Theme.of(context).colorScheme.surfaceTint,
        nameColorCode: 'Theme.of(context).colorScheme.surfaceTint',
        onName: '',
        onNameColor: (context) => Theme.of(context).colorScheme.onPrimary,
        onNameColorCode: ''
      ),
      (
        name: 'outline',
        nameColor: (context) => Theme.of(context).colorScheme.outline,
        nameColorCode: 'Theme.of(context).colorScheme.outline',
        onName: '',
        onNameColor: (context) => Theme.of(context).colorScheme.onPrimary,
        onNameColorCode: ''
      ),
      (
        name: 'outlineVariant',
        nameColor: (context) => Theme.of(context).colorScheme.outlineVariant,
        nameColorCode: 'Theme.of(context).colorScheme.outlineVariant',
        onName: '',
        onNameColor: (context) => Theme.of(context).colorScheme.onPrimary,
        onNameColorCode: ''
      ),
      (
        name: 'shadow',
        nameColor: (context) => Theme.of(context).colorScheme.shadow,
        nameColorCode: 'Theme.of(context).colorScheme.shadow',
        onName: '',
        onNameColor: (context) => Theme.of(context).colorScheme.onPrimary,
        onNameColorCode: ''
      ),
      (
        name: 'scrim',
        nameColor: (context) => Theme.of(context).colorScheme.scrim,
        nameColorCode: 'Theme.of(context).colorScheme.scrim',
        onName: '',
        onNameColor: (context) => Theme.of(context).colorScheme.onPrimary,
        onNameColorCode: ''
      ),
    ];

    final List<
        ({
          String name,
          TextStyle Function(BuildContext context) style,
        })> textUnits = [
      (
        name: 'displayLarge',
        style: (context) => Theme.of(context).textTheme.displayLarge!,
      ),
      (
        name: 'displayMedium',
        style: (context) => Theme.of(context).textTheme.displayMedium!,
      ),
      (
        name: 'displaySmall',
        style: (context) => Theme.of(context).textTheme.displaySmall!,
      ),
      (
        name: 'headlineLarge',
        style: (context) => Theme.of(context).textTheme.headlineLarge!,
      ),
      (
        name: 'headlineMedium',
        style: (context) => Theme.of(context).textTheme.headlineMedium!,
      ),
      (
        name: 'headlineSmall',
        style: (context) => Theme.of(context).textTheme.headlineSmall!,
      ),
      (
        name: 'titleLarge',
        style: (context) => Theme.of(context).textTheme.titleLarge!,
      ),
      (
        name: 'titleMedium',
        style: (context) => Theme.of(context).textTheme.titleMedium!,
      ),
      (
        name: 'titleSmall',
        style: (context) => Theme.of(context).textTheme.titleSmall!,
      ),
      (
        name: 'bodyLarge',
        style: (context) => Theme.of(context).textTheme.bodyLarge!,
      ),
      (
        name: 'bodyMedium',
        style: (context) => Theme.of(context).textTheme.bodyMedium!,
      ),
      (
        name: 'bodySmall',
        style: (context) => Theme.of(context).textTheme.bodySmall!,
      ),
      (
        name: 'labelLarge',
        style: (context) => Theme.of(context).textTheme.labelLarge!,
      ),
      (
        name: 'labelMedium',
        style: (context) => Theme.of(context).textTheme.labelMedium!,
      ),
      (
        name: 'labelSmall',
        style: (context) => Theme.of(context).textTheme.labelSmall!,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Color Scheme'),
      ),
      // Generate a body of Column having 4 rows with flutter color scheme based on the current theme in Material Design version 3
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text('Theme Fonts'),
            for (final textUnit in textUnits)
              TextUnit(name: textUnit.name, style: textUnit.style(context)),
            const Divider(
              height: 32,
            ),
            const Text('Theme Color'),
            const Text(
                'The background of the square box is the main color, and the color of the text is actually the color to be seen on that color'),
            const Text('Light Mode'),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              children: [
                for (final colorUnit in colorUnits)
                  ColorUnit(
                    keyColorName: colorUnit.name,
                    keyColor: colorUnit.nameColor(context),
                    keyColorCode: colorUnit.nameColorCode,
                    onKeyColorName: colorUnit.onName,
                    onKeyColor: colorUnit.onNameColor(context),
                    onKeyColorCode: colorUnit.onNameColorCode,
                  ),
              ],
            ),
            const Divider(height: 32),
            const Text('Dark Mode'),
            Theme(
              data: ThemeData.dark(useMaterial3: true),
              child: Builder(
                builder: (context) => GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  children: [
                    for (final colorUnit in colorUnits)
                      ColorUnit(
                        keyColorName: colorUnit.name,
                        keyColor: colorUnit.nameColor(context),
                        keyColorCode: colorUnit.nameColorCode,
                        onKeyColorName: colorUnit.onName,
                        onKeyColor: colorUnit.onNameColor(context),
                        onKeyColorCode: colorUnit.onNameColorCode,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TextUnit extends StatelessWidget {
  const TextUnit({
    super.key,
    required this.name,
    required this.style,
  });

  final String name;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = const TextStyle(fontSize: 9);
    return Column(
      children: [
        Text(name, style: style),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Weight: ${fontWeights[style.fontWeight.toString()]}',
              style: textStyle,
            ),
            const SizedBox(width: 8),
            Text(
              'Size: ${style.fontSize}',
              style: textStyle,
            ),
            const SizedBox(width: 8),
            Text(
              'height: ${style.height!} (Size*Height=${(style.height! * style.fontSize!).round()}) ',
              style: textStyle,
            ),
            const SizedBox(width: 8),
            Text(
              'LetterSpacing: ${style.letterSpacing}',
              style: textStyle,
            )
          ],
        )
      ],
    );
  }
}

Map<String, String> fontWeights = {
  "FontWeight.w100": "Thin w100",
  "FontWeight.w200": "Extra Light w200",
  "FontWeight.w300": "Light w300",
  "FontWeight.w400": "Regular w400",
  "FontWeight.w500": "Medium w500",
  "FontWeight.w600": "Semi Bold w600",
  "FontWeight.w700": "Bold w700",
  "FontWeight.w800": "Extra Bold w800",
  "FontWeight.w900": "Black w900",
};

class ColorUnit extends StatelessWidget {
  const ColorUnit({
    super.key,
    required this.keyColorName,
    required this.keyColor,
    required this.keyColorCode,
    required this.onKeyColorName,
    required this.onKeyColor,
    this.onKeyColorCode = '',
  });

  final String keyColorName;
  final Color keyColor;
  final String keyColorCode;
  final String onKeyColorName;
  final Color onKeyColor;
  final String onKeyColorCode;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        height: 100,
        color: keyColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                keyColorName,
                style: TextStyle(color: onKeyColor, fontSize: 9),
              ),
            ),
            if (onKeyColorName != '')
              const Divider(
                height: 1,
                indent: 16,
                endIndent: 16,
              ),
            Center(
              child: Text(
                onKeyColorName,
                style: TextStyle(color: onKeyColor, fontSize: 9),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      Positioned(
          right: 0,
          top: 0,
          child: Row(
            children: [
              if (onKeyColorCode.isNotEmpty)
                IconButton(
                  visualDensity:
                      const VisualDensity(horizontal: -3, vertical: -3),
                  iconSize: 12,
                  onPressed: () async {
                    await Clipboard.setData(
                      ClipboardData(text: onKeyColorCode),
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('$onKeyColorCode copied'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    }
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              IconButton(
                visualDensity:
                    const VisualDensity(horizontal: -3, vertical: -3),
                iconSize: 16,
                padding: const EdgeInsets.all(0),
                onPressed: () async {
                  await Clipboard.setData(
                    ClipboardData(text: keyColorCode),
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('$keyColorCode copied'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  }
                },
                icon: Icon(
                  Icons.palette,
                  color: onKeyColor,
                ),
              ),
            ],
          ))
    ]);
  }
}
