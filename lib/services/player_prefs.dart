import 'package:shared_preferences/shared_preferences.dart';

/// Nama & usia pemain yang tersimpan dari sesi sebelumnya.
class SavedPlayer {
  final String name;
  final int age;

  const SavedPlayer({required this.name, required this.age});
}

/// Menyimpan identitas pemain & skor tertinggi secara lokal, supaya
/// nama/usia hanya perlu diisi sekali dan skor tertinggi tetap ter-record
/// antar sesi permainan.
class PlayerPrefs {
  PlayerPrefs._();

  static const _keyName = 'player_name';
  static const _keyAge = 'player_age';
  static const _keyHighScore = 'high_score';

  static Future<SavedPlayer?> loadPlayer() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_keyName);
    final age = prefs.getInt(_keyAge);
    if (name == null || name.isEmpty || age == null) return null;
    return SavedPlayer(name: name, age: age);
  }

  static Future<void> savePlayer(String name, int age) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyName, name);
    await prefs.setInt(_keyAge, age);
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
}
