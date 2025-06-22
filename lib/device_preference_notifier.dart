import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum _SharedPreferencesKeys { isDarkMode, isVerticalLayout }

class DevicePreferences {
  final bool isDarkMode;
  final bool isVerticalLayout;

  DevicePreferences({this.isDarkMode = false, this.isVerticalLayout = false});

  DevicePreferences copyWith({bool? isDarkMode, bool? isVerticalLayout}) {
    return DevicePreferences(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      isVerticalLayout: isVerticalLayout ?? this.isVerticalLayout,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is DevicePreferences &&
        other.isDarkMode == isDarkMode &&
        other.isVerticalLayout == isVerticalLayout;
  }

  @override
  int get hashCode => Object.hash(isDarkMode, isVerticalLayout);

  @override
  String toString() {
    return 'DevicePreferences(isDarkMode: $isDarkMode, isVerticalLayout: $isVerticalLayout)';
  }
}

class DevicePreferenceNotifier extends ValueNotifier<DevicePreferences> {
  static late final SharedPreferencesWithCache _prefs;
  DevicePreferenceNotifier() : super(DevicePreferences());

  Future<void> loadDevicePreferences() async {
    _prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    final isDarkMode =
        _prefs.getBool(_SharedPreferencesKeys.isDarkMode.name) ??
        PlatformDispatcher.instance.platformBrightness == Brightness.dark;
    final isVerticalLayout =
        _prefs.getBool(_SharedPreferencesKeys.isVerticalLayout.name) ?? true;
    value = DevicePreferences(
      isDarkMode: isDarkMode,
      isVerticalLayout: isVerticalLayout,
    );
    notifyListeners();
  }

  void toggleTheme() {
    value = value.copyWith(isDarkMode: !value.isDarkMode);
    _prefs.setBool(_SharedPreferencesKeys.isDarkMode.name, value.isDarkMode);
    notifyListeners();
  }

  void toggleLayout() {
    value = value.copyWith(isVerticalLayout: !value.isVerticalLayout);
    _prefs.setBool(
      _SharedPreferencesKeys.isVerticalLayout.name,
      value.isVerticalLayout,
    );
    notifyListeners();
  }
}
