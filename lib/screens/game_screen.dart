import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/categories.dart';
import '../data/countries.dart';
import '../models/game_item.dart';
import '../services/player_prefs.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';
import 'about_screen.dart';
import 'category_screen.dart';
import 'finished_screen.dart';
import 'game_over_screen.dart';
import 'player_info_screen.dart';
import 'round_intro_screen.dart';
import 'splash_screen.dart';
import 'start_screen.dart';
import 'update_profile_screen.dart';
import 'vocab_screen.dart';
import 'win_screen.dart';
import '../widgets/sky_decorations.dart';

enum GamePhase {
  splash,
  playerInfo,
  start,
  category,
  vocab,
  roundIntro,
  playing,
  roundWon,
  gameOver,
  finished,
}

/// Objek yang sedang jatuh di layar.
class _FallingObj {
  final int id;
  final GameItem item;
  final double x; // posisi horizontal, tetap selama jatuh
  double y;
  final DateTime startTime;
  final Duration fallDuration;
  bool caught = false;

  _FallingObj({
    required this.id,
    required this.item,
    required this.x,
    required this.startTime,
    required this.fallDuration,
  }) : y = -60;
}

/// Teks feedback melayang ("+10" / "-1 nyawa") saat menangkap objek.
class _FloatText {
  final int id;
  final double x;
  final double y;
  final String text;
  final Color color;

  _FloatText({
    required this.id,
    required this.x,
    required this.y,
    required this.text,
    required this.color,
  });
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  GamePhase _phase = GamePhase.splash;

  String _playerName = '';
  int _playerAge = 0;
  String _playerCountry = kDefaultCountry;
  int _highScore = 0;
  bool _isNewHighScore = false;

  int _score = 0;
  int _lives = 3;
  int _round = 0;
  int _caughtCorrect = 0;
  static const int _targetCount = 5;

  int _selectedCategoryIndex = 0;
  String _targetLetter = '';

  final Random _rand = Random();
  final List<_FallingObj> _items = [];
  final List<_FloatText> _floats = [];
  int _idCounter = 0;

  double _basketX = 0;
  double _screenW = 0;
  double _screenH = 0;
  double _uiScale = 1.0;

  Timer? _spawnTimer;
  late final Ticker _ticker;

  GameCategory get _currentCategory => kCategories[_selectedCategoryIndex];

  bool get _showGameplayLayer => const {
        GamePhase.vocab,
        GamePhase.roundIntro,
        GamePhase.playing,
        GamePhase.roundWon,
        GamePhase.gameOver,
      }.contains(_phase);

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final saved = await PlayerPrefs.loadPlayer();
    final highScore = await PlayerPrefs.loadHighScore();
    if (!mounted) return;
    setState(() {
      _highScore = highScore;
      if (saved != null) {
        _playerName = saved.name;
        _playerAge = saved.age;
        _playerCountry = saved.country;
      }
    });
  }

  Future<void> _openProfile() async {
    final accountDeleted = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const UpdateProfileScreen()),
    );
    if (!mounted) return;
    if (accountDeleted == true) {
      setState(() {
        _playerName = '';
        _playerAge = 0;
        _playerCountry = kDefaultCountry;
        _highScore = 0;
        _phase = GamePhase.playerInfo;
      });
      return;
    }
    // Muat ulang data pemain — nama/usia/negara bisa saja baru diubah.
    await _bootstrap();
  }

  Future<void> _openAbout() async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AboutScreen()));
  }

  void _leaveSplash() {
    setState(() {
      _phase = _playerName.isNotEmpty ? GamePhase.start : GamePhase.playerInfo;
    });
  }

  @override
  void dispose() {
    _spawnTimer?.cancel();
    _ticker.dispose();
    super.dispose();
  }

  // ---------------- STATE TRANSITIONS ----------------

  void _submitPlayerInfo(String name, int age) {
    setState(() {
      _playerName = name;
      _playerAge = age;
      _phase = GamePhase.start;
    });
    PlayerPrefs.savePlayer(name, age);
  }

  void _startGame() {
    setState(() {
      _score = 0;
      _lives = 3;
      _round = 0;
      _phase = GamePhase.category;
    });
  }

  void _selectCategory(int index) {
    _selectedCategoryIndex = index;
    _startRound();
  }

  void _startRound() {
    final letters = _currentCategory.uniqueLetters;
    setState(() {
      _targetLetter = letters[_rand.nextInt(letters.length)];
      _caughtCorrect = 0;
      _phase = GamePhase.vocab;
    });
  }

  void _goRoundIntro() => setState(() => _phase = GamePhase.roundIntro);

  void _beginPlay() {
    setState(() {
      _phase = GamePhase.playing;
      _items.clear();
      _floats.clear();
      if (_basketX == 0) _basketX = _screenW / 2;
    });
    _spawnLoop();
    _ticker.start();
  }

  void _finishRound({required bool won}) {
    _spawnTimer?.cancel();
    _ticker.stop();
    setState(() {
      _items.clear();
      _phase = won ? GamePhase.roundWon : GamePhase.gameOver;
    });
  }

  void _nextRound() {
    _round++;
    _startRound();
  }

  /// Mengakhiri permainan dari titik manapun (menang ronde, kalah, atau
  /// diselesaikan langsung saat bermain), menyimpan skor tertinggi bila
  /// pecah rekor, lalu menampilkan layar "Selesai".
  Future<void> _endGame() async {
    _spawnTimer?.cancel();
    _ticker.stop();
    final isNewHighScore = await PlayerPrefs.saveHighScoreIfHigher(_score);
    if (!mounted) return;
    setState(() {
      _items.clear();
      _isNewHighScore = isNewHighScore;
      if (isNewHighScore) _highScore = _score;
      _phase = GamePhase.finished;
    });
  }

  Future<void> _confirmFinishDuringPlay() async {
    _ticker.stop();
    _spawnTimer?.cancel();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Selesai main?', style: GoogleFonts.baloo2(fontWeight: FontWeight.w800, color: AppColors.plum)),
        content: Text(
          'Skor kamu saat ini ($_score) akan disimpan.',
          style: GoogleFonts.fredoka(color: AppColors.ink),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Lanjut Main', style: GoogleFonts.fredoka(color: AppColors.subtitle)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Selesai', style: GoogleFonts.fredoka(fontWeight: FontWeight.w700, color: AppColors.coralDark)),
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (confirmed == true) {
      await _endGame();
    } else if (_phase == GamePhase.playing) {
      _spawnLoop();
      _ticker.start();
    }
  }

  void _chooseAgain() {
    setState(() {
      _score = 0;
      _lives = 3;
      _round = 0;
      _phase = GamePhase.category;
    });
  }

  /// Benar-benar mengakhiri sesi: kembali ke layar utama, bukan
  /// memaksa pemain memilih tema baru lagi.
  void _backToStart() {
    setState(() {
      _score = 0;
      _lives = 3;
      _round = 0;
      _phase = GamePhase.start;
    });
  }

  void _retry() {
    setState(() {
      _score = 0;
      _lives = 3;
      _round = 0;
      _phase = GamePhase.category;
    });
  }

  // ---------------- GAMEPLAY LOOP ----------------

  void _spawnLoop() {
    if (_phase != GamePhase.playing) return;
    _spawnItem();
    final baseDelay = max(450, 900 - _round * 40);
    final delay = baseDelay + _rand.nextInt(400);
    _spawnTimer = Timer(Duration(milliseconds: delay), _spawnLoop);
  }

  void _spawnItem() {
    if (_screenW == 0) return;
    final matching =
        _currentCategory.items.where((i) => i.letter == _targetLetter).toList();
    final others =
        _currentCategory.items.where((i) => i.letter != _targetLetter).toList();

    // 60% peluang item sesuai huruf target, sisanya distraktor.
    final favorTarget = matching.isNotEmpty && (others.isEmpty || _rand.nextDouble() < 0.6);
    final pool = favorTarget ? matching : others;
    final data = pool[_rand.nextInt(pool.length)];

    final x = 20 * _uiScale + _rand.nextDouble() * (_screenW - 80 * _uiScale);
    final durationMs = max(1600, 4200 - _round * 150);

    setState(() {
      _items.add(_FallingObj(
        id: _idCounter++,
        item: data,
        x: x,
        startTime: DateTime.now(),
        fallDuration: Duration(milliseconds: durationMs),
      ));
    });
  }

  void _onTick(Duration elapsed) {
    if (_phase != GamePhase.playing) return;
    final now = DateTime.now();
    final basketTop = _screenH * 0.94 - 70 * _uiScale;
    final toRemove = <_FallingObj>[];
    final toCatch = <_FallingObj>[];

    for (final obj in _items) {
      if (obj.caught) continue;
      final t = now.difference(obj.startTime).inMilliseconds /
          obj.fallDuration.inMilliseconds;
      if (t >= 1) {
        toRemove.add(obj);
        continue;
      }
      obj.y = -60 + t * (_screenH + 60);

      if (obj.y > basketTop - 20 * _uiScale && obj.y < basketTop + 40 * _uiScale) {
        final itemCenterX = obj.x + 26 * _uiScale;
        if ((itemCenterX - _basketX).abs() < 55 * _uiScale) {
          toCatch.add(obj);
        }
      }
    }

    if (toRemove.isNotEmpty || toCatch.isNotEmpty) {
      setState(() {
        for (final o in toRemove) {
          _items.remove(o);
        }
      });
    } else if (_items.isNotEmpty) {
      // Rebuild supaya posisi y ter-update meski tidak ada yang dihapus.
      setState(() {});
    }

    for (final obj in toCatch) {
      _tryCatch(obj);
    }
  }

  void _tryCatch(_FallingObj obj) {
    if (obj.caught || _phase != GamePhase.playing) return;
    obj.caught = true;
    final isCorrect = obj.item.letter == _targetLetter;

    final floatId = _idCounter++;
    setState(() {
      _items.remove(obj);
      _floats.add(_FloatText(
        id: floatId,
        x: obj.x,
        y: obj.y,
        text: isCorrect ? '+10' : '-1 ❤️',
        color: isCorrect ? AppColors.success : AppColors.coral,
      ));
    });
    Timer(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() => _floats.removeWhere((f) => f.id == floatId));
    });

    if (isCorrect) {
      _score += 10;
      _caughtCorrect++;
      if (_caughtCorrect >= _targetCount) {
        _finishRound(won: true);
        return;
      }
    } else {
      _lives--;
      if (_lives <= 0) {
        _finishRound(won: false);
        return;
      }
    }
    setState(() {});
  }

  void _updateBasketX(double dx) {
    final basketHalfWidth = 50 * _uiScale;
    final maxX = max(basketHalfWidth, _screenW - basketHalfWidth);
    setState(() {
      _basketX = dx.clamp(basketHalfWidth, maxX).toDouble();
    });
  }

  // ---------------- BUILD ----------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          _screenW = constraints.maxWidth;
          _screenH = constraints.maxHeight;
          _uiScale = context.uiScale;
          return GestureDetector(
            onPanDown: _phase == GamePhase.playing
                ? (d) => _updateBasketX(d.localPosition.dx)
                : null,
            onPanUpdate: _phase == GamePhase.playing
                ? (d) => _updateBasketX(d.localPosition.dx)
                : null,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
              child: Stack(
                children: [
                  const Positioned.fill(child: SkyDecorations()),
                  if (_showGameplayLayer) ..._buildGameplayLayer(),
                  _buildOverlay(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildGameplayLayer() {
    final s = _uiScale;
    return [
      // Falling items
      for (final obj in _items)
        Positioned(
          left: obj.x,
          top: obj.y,
          child: Text(obj.item.emoji, style: TextStyle(fontSize: 52 * s)),
        ),

      // Floating feedback text
      for (final f in _floats)
        Positioned(
          left: f.x,
          top: f.y,
          child: Text(
            f.text,
            style: GoogleFonts.baloo2(
              fontSize: 26 * s,
              fontWeight: FontWeight.w800,
              color: f.color,
            ),
          ),
        ),

      // Basket
      Positioned(
        left: _basketX - 50 * s,
        bottom: _screenH * 0.06,
        child: Text('🧺', style: TextStyle(fontSize: 56 * s)),
      ),

      // HUD: score & hearts
      Positioned(
        top: 14,
        left: 16,
        child: _pill('⭐ $_score'),
      ),
      Positioned(
        top: 14,
        right: 16,
        child: _pill('❤️' * max(_lives, 0) + '🖤' * (3 - max(_lives, 0))),
      ),

      // Tombol selesaikan permainan (hanya aktif saat benar-benar bermain)
      if (_phase == GamePhase.playing)
        Positioned(
          top: 62 * s,
          right: 16,
          child: GestureDetector(
            onTap: _confirmFinishDuringPlay,
            child: Container(
              width: 40 * s,
              height: 40 * s,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Color(0x26000000), offset: Offset(0, 6))],
              ),
              alignment: Alignment.center,
              child: Text('🏁', style: TextStyle(fontSize: 18 * s)),
            ),
          ),
        ),

      // Letter badge
      Positioned(
        top: 14,
        left: _screenW / 2 - 38 * s,
        child: Container(
          width: 76 * s,
          height: 76 * s,
          decoration: BoxDecoration(
            color: AppColors.coral,
            shape: BoxShape.circle,
            boxShadow: const [BoxShadow(color: AppColors.coralDark, offset: Offset(0, 8))],
          ),
          alignment: Alignment.center,
          child: Text(
            _targetLetter,
            style: GoogleFonts.baloo2(fontSize: 40 * s, fontWeight: FontWeight.w800, color: Colors.white),
          ),
        ),
      ),

      // Category label
      Positioned(
        top: 96,
        left: _screenW / 2 - 80 * s,
        child: Container(
          width: 160 * s,
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.circular(999),
          ),
          alignment: Alignment.center,
          child: Text(
            _currentCategory.name,
            style: GoogleFonts.baloo2(fontSize: 14 * s, fontWeight: FontWeight.w700, color: AppColors.plum),
          ),
        ),
      ),
    ];
  }

  Widget _pill(String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(999),
          boxShadow: const [BoxShadow(color: Color(0x26000000), offset: Offset(0, 8))],
        ),
        child: Text(
          text,
          style: GoogleFonts.fredoka(fontSize: 16 * _uiScale, fontWeight: FontWeight.w700, color: AppColors.ink),
        ),
      );

  Widget _buildOverlay() {
    switch (_phase) {
      case GamePhase.splash:
        return SplashScreen(onFinished: _leaveSplash);
      case GamePhase.playerInfo:
        return PlayerInfoScreen(onSubmit: _submitPlayerInfo);
      case GamePhase.start:
        return StartScreen(
          playerName: _playerName,
          playerAge: _playerAge,
          playerCountry: _playerCountry,
          highScore: _highScore,
          onStart: _startGame,
          onOpenProfile: _openProfile,
          onOpenAbout: _openAbout,
        );
      case GamePhase.category:
        return CategoryScreen(onSelect: _selectCategory);
      case GamePhase.vocab:
        return VocabScreen(category: _currentCategory, onNext: _goRoundIntro);
      case GamePhase.roundIntro:
        return RoundIntroScreen(
          category: _currentCategory,
          targetLetter: _targetLetter,
          targetCount: _targetCount,
          onStart: _beginPlay,
        );
      case GamePhase.playing:
        return const SizedBox.shrink();
      case GamePhase.roundWon:
        return WinScreen(
          score: _score,
          targetCount: _targetCount,
          onNextRound: _nextRound,
          onFinish: _endGame,
        );
      case GamePhase.gameOver:
        return GameOverScreen(
          score: _score,
          highScore: _highScore,
          onRetry: _retry,
          onFinish: _endGame,
        );
      case GamePhase.finished:
        return FinishedScreen(
          playerName: _playerName,
          score: _score,
          highScore: _highScore,
          isNewHighScore: _isNewHighScore,
          onChooseAgain: _chooseAgain,
          onBackToStart: _backToStart,
        );
    }
  }
}
