/// Satu objek yang bisa jatuh dan ditangkap (misal: satu buah atau satu hewan).
class GameItem {
  final String emoji;
  final String letter; // huruf awal nama, huruf besar
  final String name;

  const GameItem({
    required this.emoji,
    required this.letter,
    required this.name,
  });
}

/// Satu kategori/tema permainan, berisi kumpulan GameItem.
class GameCategory {
  final String name;
  final String icon;
  final List<GameItem> items;

  const GameCategory({
    required this.name,
    required this.icon,
    required this.items,
  });

  /// Daftar huruf unik yang tersedia di kategori ini (dipakai untuk memilih
  /// huruf target secara acak tiap ronde).
  List<String> get uniqueLetters =>
      items.map((e) => e.letter).toSet().toList();
}
