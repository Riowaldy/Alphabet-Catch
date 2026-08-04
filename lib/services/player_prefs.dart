import 'package:shared_preferences/shared_preferences.dart';
import '../data/countries.dart';

/// Nama, usia, & negara pemain yang tersimpan dari sesi sebelumnya.
class SavedPlayer {
  final String name;
  final int age;
  final String country;

  const SavedPlayer({
    required this.name,
    required this.age,
    this.country = kDefaultCountry,
  });
}

/// Menyimpan identitas pemain & skor tertinggi secara lokal, supaya
/// nama/usia hanya perlu diisi sekali dan skor tertinggi tetap ter-record
/// antar sesi permainan.
class PlayerPrefs {
  PlayerPrefs._();

  static const _keyName = 'player_name';
  static const _keyAge = 'player_age';
  static const _keyCountry = 'player_country';
  static const _keyHighScore = 'high_score';

  static Future<SavedPlayer?> loadPlayer() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_keyName);
    final age = prefs.getInt(_keyAge);
    if (name == null || name.isEmpty || age == null) return null;
    final country = prefs.getString(_keyCountry) ?? kDefaultCountry;
    return SavedPlayer(name: name, age: age, country: country);
  }

  static Future<void> savePlayer(
    String name,
    int age, {
    String country = kDefaultCountry,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyName, name);
    await prefs.setInt(_keyAge, age);
    await prefs.setString(_keyCountry, country);
  }

  static Future<int> loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyHighScore) ?? 0;
  }

  /// Menyimpan [score] sebagai skor tertinggi baru jika melebihi rekor
  /// sebelumnya. Mengembalikan `true` bila ini adalah rekor baru.
  static Future<bool> saveHighScoreIfHigher(int score) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt(_keyHighScore) ?? 0;
    if (score <= current) return false;
    await prefs.setInt(_keyHighScore, score);
    return true;
  }

  /// Menghapus seluruh data akun pemain (nama, usia, negara, & skor
  /// tertinggi) yang tersimpan secara lokal.
  static Future<void> clearPlayer() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyName);
    await prefs.remove(_keyAge);
    await prefs.remove(_keyCountry);
    await prefs.remove(_keyHighScore);
  }
}
