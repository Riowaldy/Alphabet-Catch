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
  bool _deleting = false;

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

  Future<void> _handleDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          'Hapus Akun?',
          style: GoogleFonts.baloo2(fontWeight: FontWeight.w800, color: AppColors.ink),
        ),
        content: Text(
          'Semua data (nama, usia, negara, & skor tertinggi) akan dihapus dan tidak bisa dikembalikan.',
          style: GoogleFonts.fredoka(color: const Color(0xFF665E7A)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text('Batal', style: GoogleFonts.fredoka(color: AppColors.plum)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text('Hapus', style: GoogleFonts.fredoka(color: AppColors.coralDark)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _deleting = true);
    await PlayerPrefs.clearPlayer();
    if (!mounted) return;
    Navigator.pop(context, true);
  }

  InputDecoration _fieldDecoration({
    required String label,
    required IconData icon,
    required double scale,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.fredoka(color: AppColors.subtitle, fontWeight: FontWeight.w600),
      prefixIcon: Icon(icon, color: AppColors.plum, size: 20 * scale),
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(vertical: 14 * scale, horizontal: 12 * scale),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.plum.withOpacity(0.12)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.plum.withOpacity(0.12)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.plum, width: 2),
      ),
    );
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
                _LogoBadge(scale: scale),
                const SizedBox(height: 10),
                Text(
                  'Ubah Profil',
                  style: GoogleFonts.baloo2(
                    fontSize: 24 * scale,
                    fontWeight: FontWeight.w800,
                    color: AppColors.plum,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Perbarui nama, usia, atau negaramu.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.fredoka(fontSize: 14 * scale, color: const Color(0xFF665E7A)),
                ),
                SizedBox(height: 18 * scale),
                TextField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  style: GoogleFonts.fredoka(fontSize: 16 * scale, color: AppColors.ink),
                  decoration: _fieldDecoration(
                    label: 'Nama',
                    icon: Icons.person_rounded,
                    scale: scale,
                  ),
                ),
                SizedBox(height: 12 * scale),
                TextField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: GoogleFonts.fredoka(fontSize: 16 * scale, color: AppColors.ink),
                  decoration: _fieldDecoration(
                    label: 'Usia',
                    icon: Icons.cake_rounded,
                    scale: scale,
                  ),
                ),
                SizedBox(height: 12 * scale),
                DropdownButtonFormField<String>(
                  initialValue: _country,
                  isExpanded: true,
                  icon: const Icon(Icons.expand_more, color: AppColors.plum),
                  style: GoogleFonts.fredoka(fontSize: 16 * scale, color: AppColors.ink),
                  decoration: _fieldDecoration(
                    label: 'Negara',
                    icon: Icons.public_rounded,
                    scale: scale,
                  ),
                  items: kCountries
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => _country = value);
                  },
                ),
                if (_errorText != null) ...[
                  SizedBox(height: 12 * scale),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 12 * scale, vertical: 10 * scale),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF0F0),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline_rounded, size: 18 * scale, color: AppColors.coralDark),
                        SizedBox(width: 8 * scale),
                        Expanded(
                          child: Text(
                            _errorText!,
                            style: GoogleFonts.fredoka(fontSize: 13 * scale, color: AppColors.coralDark),
                          ),
                        ),
                      ],
                    ),
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
                SizedBox(height: 18 * scale),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 14 * scale, vertical: 4 * scale),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.coral.withOpacity(0.3), width: 1.5),
                  ),
                  child: TextButton.icon(
                    onPressed: _deleting ? null : _handleDelete,
                    icon: Icon(Icons.delete_outline, size: 18 * scale, color: AppColors.coralDark),
                    label: Text(
                      _deleting ? 'Menghapus...' : 'Hapus Akun',
                      style: GoogleFonts.fredoka(
                        fontSize: 14 * scale,
                        fontWeight: FontWeight.w600,
                        color: AppColors.coralDark,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

/// Lencana bulat bergradasi khas maskot, dipakai sebagai ikon layar ini.
class _LogoBadge extends StatelessWidget {
  final double scale;

  const _LogoBadge({required this.scale});

  @override
  Widget build(BuildContext context) {
    final size = 62 * scale;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(colors: [AppColors.coral, AppColors.plum]),
        boxShadow: [
          BoxShadow(color: AppColors.plumDark.withOpacity(0.35), blurRadius: 14, offset: const Offset(0, 6)),
        ],
      ),
      alignment: Alignment.center,
      child: Text('✏️', style: TextStyle(fontSize: 28 * scale)),
    );
  }
}
