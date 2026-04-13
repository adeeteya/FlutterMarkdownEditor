import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markdown_editor/device_preference_notifier.dart';
import 'package:markdown_editor/home.dart';
import 'package:markdown_editor/l10n/generated/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: Colors.transparent,
    ),
  );
  final DevicePreferenceNotifier devicePreferenceNotifier =
      DevicePreferenceNotifier();
  await devicePreferenceNotifier.loadDevicePreferences();

  runApp(MarkdownEditorApp(devicePreferenceNotifier: devicePreferenceNotifier));
}

class MarkdownEditorApp extends StatelessWidget {
  final DevicePreferenceNotifier devicePreferenceNotifier;
  const MarkdownEditorApp({super.key, required this.devicePreferenceNotifier});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DevicePreferences>(
      valueListenable: devicePreferenceNotifier,
      builder: (context, devicePreference, _) {
        return DynamicColorBuilder(
          builder: (lightDynamic, darkDynamic) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Markdown Editor',
              themeMode: devicePreference.isDarkMode
                  ? ThemeMode.dark
                  : ThemeMode.light,
              theme: ThemeData(
                useMaterial3: true,
                textTheme: GoogleFonts.notoSansTextTheme(),
                colorScheme: lightDynamic,
                colorSchemeSeed: lightDynamic == null ? Colors.indigo : null,
              ),
              darkTheme: ThemeData(
                useMaterial3: true,
                textTheme: GoogleFonts.notoSansTextTheme(
                  ThemeData(brightness: Brightness.dark).textTheme,
                ),
                brightness: Brightness.dark,
                colorScheme: darkDynamic,
                colorSchemeSeed: darkDynamic == null ? Colors.indigo : null,
              ),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: Home(devicePreferenceNotifier: devicePreferenceNotifier),
            );
          },
        );
      },
    );
  }
}
