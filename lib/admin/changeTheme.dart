import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/themeProvider.dart';

class ChangeTheme extends StatelessWidget {
  final List<Color> themeColors = [
    Colors.deepOrange,
    Colors.blueGrey,
    Colors.deepPurple,
    Colors.green,
    Colors.orange,
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Change the theme color dynamically:',
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              children: themeColors
                  .map(
                    (color) => GestureDetector(
                      onTap: () {
                        final swatch = MaterialColor(
                          color.value,
                          <int, Color>{
                            50: color.withOpacity(0.1),
                            100: color.withOpacity(0.2),
                            200: color.withOpacity(0.3),
                            300: color.withOpacity(0.4),
                            400: color.withOpacity(0.5),
                            500: color.withOpacity(0.6),
                            600: color.withOpacity(0.7),
                            700: color.withOpacity(0.8),
                            800: color.withOpacity(0.9),
                            900: color.withOpacity(1),
                          },
                        );
                        themeProvider.setTheme(ThemeData(primarySwatch: swatch));
                      },
                      child: CircleAvatar(
                        backgroundColor: color,
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 20),
            const Text(
              'Change the bottom Nav Bar color dynamically:',
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              children: themeColors
                  .map(
                    (color) => GestureDetector(
                      onTap: () {
                        themeProvider.setColor(color);
                      },
                      child: CircleAvatar(
                        backgroundColor: color,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
