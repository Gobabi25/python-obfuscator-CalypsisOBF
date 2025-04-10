import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationService {
  // Singleton
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal() {
    _loadInitialValue();
  }

  // Key de stockage
  static const _isNavigationVisibleKey = 'isNavigationVisible';

  // Valeur observable (en temps réel)
  final ValueNotifier<bool> isNavigationVisible = ValueNotifier(false);

  // Charger la valeur au lancement de l'app
  Future<void> _loadInitialValue() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getBool(_isNavigationVisibleKey) ?? false;
    isNavigationVisible.value = value;
  }

  // Modifier la valeur (et la sauvegarder)
  Future<void> setIsNavigationVisible(bool value) async {
    print("=== mettre à ${value ? 'visible' : 'invisible'}");
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isNavigationVisibleKey, value);
    isNavigationVisible.value = value;
  }
}
