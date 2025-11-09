import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class FavoritesManager {
  static const String _favoritesKey = 'favorite_meals';

  static Future<bool> addToFavorites(Map<String, dynamic> meal) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favorites = await getFavorites();

      final exists = favorites.any((fav) => fav['name'] == meal['name']);
      if (exists) return false;

      favorites.add(meal);
      final jsonString = jsonEncode(favorites);
      return await prefs.setString(_favoritesKey, jsonString);
    } catch (e) {
      print('Error adding to favorites: $e');
      return false;
    }
  }

  static Future<bool> removeFromFavorites(String mealName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favorites = await getFavorites();

      favorites.removeWhere((meal) => meal['name'] == mealName);
      final jsonString = jsonEncode(favorites);
      return await prefs.setString(_favoritesKey, jsonString);
    } catch (e) {
      print('Error removing from favorites: $e');
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> getFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_favoritesKey);

      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }

      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.map((item) => Map<String, dynamic>.from(item)).toList();
    } catch (e) {
      print('Error getting favorites: $e');
      return [];
    }
  }

  static Future<bool> isFavorite(String mealName) async {
    try {
      final favorites = await getFavorites();
      return favorites.any((meal) => meal['name'] == mealName);
    } catch (e) {
      print('Error checking favorite: $e');
      return false;
    }
  }

  static Future<bool> clearFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_favoritesKey);
    } catch (e) {
      print('Error clearing favorites: $e');
      return false;
    }
  }

  static Future<int> getFavoritesCount() async {
    final favorites = await getFavorites();
    return favorites.length;
  }
}
