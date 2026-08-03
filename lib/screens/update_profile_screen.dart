import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/countries.dart';
import '../services/player_prefs.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';
import '../widgets/big_button.dart';
import '../widgets/game_route_scaffold.dart';

/// Form untuk mengubah nama, usia, & negara pemain yang sudah tersimpan.
class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  String _country = kDefaultCountry;
  String? _errorText;
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final saved = await PlayerPrefs.loadPlayer();
    if (!mounted) return;
    setState(() {
      _nameController.text = saved?.name ?? '';
      _ageController.text = saved != null ? '${saved.age}' : '';
      _country = saved?.country ?? kDefaultCountry;
      _loading = false;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final name = _nameController.text.trim();
    final age = int.tryParse(_ageController.text.trim());

    if (name.isEmpty) {
      setState(() => _errorText = 'Nama tidak boleh kosong ya!');
      return;
    }
    if (age == null || age < 1 || age > 99) {
      setState(() => _errorText = 'Usia harus berupa angka yang benar (1-99).');
      return;
    }

    setState(() {
      _errorText = null;
      _saving = true;
    });
    await PlayerPrefs.savePlayer(name, age, country: _country);
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final scale = context.uiScale;
    return GameRouteScaffold(
      child: _loading
          ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: CircularProgressIndicator(color: AppColors.plum),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('✏️', style: TextStyle(fontSize: 40 * scale)),
                const SizedBox(height: 6),
                Text(
                  'Ubah Profil',
                  style: GoogleFonts.baloo2(
                    fontSize: 24 * scale,
                    fontWeight: FontWeight.w800,
                    color: AppColors.plum,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Perbarui nama, usia, atau negaramu.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.fredoka(fontSize: 14 * scale, color: const Color(0xFF665E7A)),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  style: GoogleFonts.fredoka(fontSize: 16 * scale, color: AppColors.ink),
                  decoration: InputDecoration(
                    labelText: 'Nama',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: GoogleFonts.fredoka(fontSize: 16 * scale, color: AppColors.ink),
                  decoration: InputDecoration(
                    labelText: 'Usia',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _country,
                  isExpanded: true,
                  icon: const Icon(Icons.expand_more, color: AppColors.plum),
                  style: GoogleFonts.fredoka(fontSize: 16 * scale, color: AppColors.ink),
                  decoration: InputDecoration(
                    labelText: 'Negara',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  items: kCountries
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => _country = value);
                  },
                ),
                if (_errorText != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    _errorText!,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.fredoka(fontSize: 13 * scale, color: AppColors.coralDark),
                  ),
                ],
                BigButton(
                  label: _saving ? 'Menyimpan...' : 'Simpan',
                  onTap: _saving ? () {} : _handleSave,
                ),
                BigButton(
                  label: 'Batal',
                  onTap: () => Navigator.pop(context),
                  secondary: true,
                ),
              ],
            ),
    );
  }
}
