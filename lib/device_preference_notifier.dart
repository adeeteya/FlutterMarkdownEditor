import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum _SharedPreferencesKeys { isDarkMode, isSplitLayout }

class DevicePreferences {
  final bool isDarkMode;
  final bool isSplitLayout;

  DevicePreferences({this.isDarkMode = false, this.isSplitLayout = false});

  DevicePreferences copyWith({bool? isDarkMode, bool? isSplitLayout}) {
    return DevicePreferences(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      isSplitLayout: isSplitLayout ?? this.isSplitLayout,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is DevicePreferences &&
        other.isDarkMode == isDarkMode &&
        other.isSplitLayout == isSplitLayout;
  }

  @override
  int get hashCode => Object.hash(isDarkMode, isSplitLayout);

  @override
  String toString() {
    return 'DevicePreferences(isDarkMode: $isDarkMode, isSplitLayout: $isSplitLayout)';
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
    final isSplitLayout =
        _prefs.getBool(_SharedPreferencesKeys.isSplitLayout.name) ?? true;
    value = DevicePreferences(
      isDarkMode: isDarkMode,
      isSplitLayout: isSplitLayout,
    );
    notifyListeners();
  }

  void toggleTheme() {
    value = value.copyWith(isDarkMode: !value.isDarkMode);
    _prefs.setBool(_SharedPreferencesKeys.isDarkMode.name, value.isDarkMode);
    notifyListeners();
  }

  void toggleLayout() {
    value = value.copyWith(isSplitLayout: !value.isSplitLayout);
    _prefs.setBool(
      _SharedPreferencesKeys.isSplitLayout.name,
      value.isSplitLayout,
    );
    notifyListeners();
  }
}
