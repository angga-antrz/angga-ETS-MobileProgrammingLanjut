import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NativePage extends StatefulWidget {
  const NativePage({super.key});

  @override
  State<NativePage> createState() => _NativePageState();
}

class _NativePageState extends State<NativePage> {
  // SINKRONISASI: Nama channel ini harus sama persis dengan yang ada di MainActivity.kt [cite: 1035, 1128]
  static const platform = MethodChannel('utd.ac.id/native_jembatan');

  String _batteryDisplay = 'Belum dicek';
  int _batteryRawValue = 0;

  // 1. Fungsi mengambil data baterai dari sisi Native Kotlin [cite: 1039, 1134]
  Future<void> _getBatteryLevel() async {
    try {
      // Memanggil fungsi 'getBatteryLevel' di Kotlin [cite: 1043, 1135]
      final int result = await platform.invokeMethod('getBatteryLevel');
      setState(() {
        _batteryRawValue = result;
        _batteryDisplay = '$result%';
      });
    } on PlatformException catch (e) {
      setState(() {
        _batteryDisplay = "Gagal";
      });
      debugPrint("Gagal membaca baterai: '${e.message}'."); [cite: 1047]
    }
  }

  // 2. Fungsi memunculkan Toast melalui OS Android asli [cite: 1052, 1143]
  Future<void> _showNativeToast() async {
    try {
      // Mengirim data identitas Angga ke Kotlin untuk ditampilkan sebagai Toast [cite: 1055, 1147]
      await platform.invokeMethod('showToast', {
        "pesan": "Angga Antareza (20123002) - Native Toast Berhasil!"
      });
    } on PlatformException catch (e) {
      debugPrint("Gagal memanggil Toast Native: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Colors.teal; // Konsisten dengan AppTheme Angga

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'INTEGRASI NATIVE KOTLIN',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2, fontSize: 16),
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
            // Panel Informasi Baterai
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    "STATUS BATERAI PERANGKAT",
                    style: TextStyle(color: Colors.black38, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2),
                  ),
                  const SizedBox(height: 30),
                  // Visualisasi Baterai Kustom
                  _buildBatteryIcon(primaryColor),
                  const SizedBox(height: 20),
                  Text(
                    _batteryDisplay,
                    style: const TextStyle(color: Colors.black87, fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "KAPASITAS SAAT INI",
                    style: TextStyle(color: primaryColor, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Menu Tombol Aksi Native
            _buildNativeActionCard(
              title: "CEK STATUS BATERAI",
              subtitle: "Ambil data hardware via MethodChannel",
              icon: Icons.battery_charging_full_rounded,
              color: primaryColor,
              onTap: _getBatteryLevel,
            ),
            
            const SizedBox(height: 16),
            
            _buildNativeActionCard(
              title: "TAMPILKAN NATIVE TOAST",
              subtitle: "Panggil fungsi Toast dari OS Android",
              icon: Icons.message_rounded,
              color: Colors.orange.shade800,
              onTap: _showNativeToast,
            ),
            
            const SizedBox(height: 40),
            const Text(
              "ANGGA ANTAREZA - 20123002",
              style: TextStyle(color: Colors.black26, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Baterai Kustom yang Reaktif
  Widget _buildBatteryIcon(Color color) {
    return Container(
      width: 100,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12, width: 3),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(3),
      child: Stack(
        children: [
          FractionallySizedBox(
            widthFactor: _batteryRawValue / 100,
            child: Container(
              decoration: BoxDecoration(
                color: _batteryRawValue < 20 ? Colors.red : color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Center(
            child: Icon(
              Icons.bolt_rounded,
              color: _batteryRawValue > 50 ? Colors.white : Colors.black26,
              size: 24,
            ),
          )
        ],
      ),
    );
  }

  // Widget Kartu Menu Aksi
  Widget _buildNativeActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(color: color.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
          ]
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.black38, fontSize: 11),
                ),
              ],
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios_rounded, color: color.withOpacity(0.3), size: 16),
          ],
        ),
      ),
    );
  }
}