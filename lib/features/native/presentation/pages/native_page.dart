import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NativePage extends StatefulWidget {
  const NativePage({super.key});

  @override
  State<NativePage> createState() => _NativePageState();
}

class _NativePageState extends State<NativePage> {
  // SINKRONISASI: Harus sama persis dengan yang ada di MainActivity.kt
  static const platform = MethodChannel('utd.ac.id/native_jembatan');

  String _batteryDisplay = '--';
  int _batteryRawValue = 0;

  // 1. Fungsi mengambil data baterai dari Sistem Android (Kotlin)
  Future<void> _getBatteryLevel() async {
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      setState(() {
        _batteryRawValue = result;
        _batteryDisplay = '$result%';
      });
    } on PlatformException catch (e) {
      setState(() {
        _batteryDisplay = "Err";
      });
      debugPrint("Gagal mengambil baterai Angga: '${e.message}'.");
    }
  }

  // 2. Fungsi memunculkan Toast Native melalui Android OS
  Future<void> _showNativeToast() async {
    try {
      // Mengirim identitas Angga Antareza ke sistem Android
      await platform.invokeMethod('showToast', {
        "message": "Halo Pak, Saya Angga Antareza (20123002)! Native Toast Berhasil."
      });
    } on PlatformException catch (e) {
      debugPrint("Gagal memanggil Toast Angga: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Colors.teal; // Konsistensi dengan UTD Store Angga
    const Color darkColor = Color(0xFF101820); 

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'INTEGRASI NATIVE',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2, fontSize: 16),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Bagian Visual Baterai Kustom (Ciri Khas Angga)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40),
              decoration: BoxDecoration(
                color: darkColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha:0.1), blurRadius: 20, offset: const Offset(0, 10))
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    "HARDWARE MONITOR",
                    style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2),
                  ),
                  const SizedBox(height: 30),
                  // Visual Baterai Dinamis
                  _buildBatteryIcon(primaryColor),
                  const SizedBox(height: 20),
                  Text(
                    _batteryDisplay,
                    style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "BATTERY CAPACITY",
                    style: TextStyle(color: primaryColor, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Tombol Aksi Native
            _buildNativeActionCard(
              title: "REFRESH BATERAI",
              subtitle: "Ambil kapasitas daya langsung dari Sistem Android",
              icon: Icons.battery_charging_full_rounded,
              color: darkColor,
              onTap: _getBatteryLevel,
            ),
            
            const SizedBox(height: 16),
            
            _buildNativeActionCard(
              title: "TAMPILKAN TOAST",
              subtitle: "Kirim pesan identitas Angga ke Android Toast",
              icon: Icons.message_rounded,
              color: primaryColor,
              textColor: Colors.white,
              onTap: _showNativeToast,
            ),
            
            const SizedBox(height: 40),
            Text(
              "ANGGA ANTAREZA - 20123002",
              style: TextStyle(color: Colors.grey.shade400, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk menggambar Baterai Kustom
  Widget _buildBatteryIcon(Color color) {
    return Container(
      width: 120,
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white24, width: 3),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(4),
      child: Stack(
        children: [
          // Indikator Isi Baterai (Merespon Nilai Raw)
          FractionallySizedBox(
            widthFactor: _batteryRawValue / 100,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Ikon Petir (Indikator Hardware)
          const Center(
            child: Icon(
              Icons.bolt_rounded,
              color: Colors.white,
              size: 30,
            ),
          )
        ],
      ),
    );
  }

  // Widget untuk Kartu Aksi Native
  Widget _buildNativeActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    Color textColor = Colors.white,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, color: textColor, size: 32),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(color: textColor.withValues(alpha:0.6), fontSize: 11),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: textColor.withValues(alpha : 0.3), size: 16),
          ],
        ),
      ),
    );
  }
}