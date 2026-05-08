import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

// 1. FUNGSI BERAT DI LUAR CLASS (Top-level Function untuk Isolate)
// Wajib berada di luar class agar bisa dijalankan oleh Isolate (Pekerja Background)
int hitungKalkulasiAngga(int jumlahLooping) {
  int hasil = 0;
  for (int i = 0; i < jumlahLooping; i++) {
    hasil += i;
  }
  return hasil;
}

class CryptoPage extends StatefulWidget {
  const CryptoPage({super.key});

  @override
  State<CryptoPage> createState() => _CryptoPageState();
}

class _CryptoPageState extends State<CryptoPage> {
  late WebSocketChannel _channel;
  String _currentPrice = '0.00';
  bool _isCalculating = false;

  @override
  void initState() {
    super.initState();
    // Menghubungkan ke WebSocket CoinCap untuk harga Bitcoin real-time
    _channel = WebSocketChannel.connect(
      Uri.parse('wss://data-stream.binance.vision/ws/btcusdt@trade'),
    );
  }

  @override
  void dispose() {
    // WAJIB: Tutup koneksi saat halaman ditinggalkan agar tidak bocor memori
    _channel.sink.close(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Colors.teal; // Konsisten dengan AppTheme Angga
    const Color btcColor = Colors.orange;

    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Dark Mode agar grafik terlihat premium
      appBar: AppBar(
        title: const Text(
          'CRYPTO HUB ANGGA',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Header Identitas Personal
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('REAL-TIME MONITORING', style: TextStyle(color: primaryColor, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                    Text('BITCOIN / USD', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('DEVELOPER', style: TextStyle(color: Colors.white38, fontSize: 10)),
                    Text('ANGGA - 02', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  // Kartu Harga Real-time (WebSocket)
                  _buildPriceDisplay(btcColor),

                  const SizedBox(height: 40),

                  // Indikator Stabilitas UI (Membuktikan UI tidak macet saat Isolate jalan)
                  const Text('UI THREAD STABILITY', style: TextStyle(color: Colors.white38, fontSize: 10, letterSpacing: 2)),
                  const SizedBox(height: 15),
                  CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(_isCalculating ? Colors.redAccent : primaryColor),
                  ),

                  const SizedBox(height: 50),

                  // Tombol Kalkulasi Isolate (Logika NIM 20.000.000)
                  _buildIsolateButton(primaryColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceDisplay(Color accent) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: accent.withValues(alpha:0.05),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: accent.withValues( alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(Icons.currency_bitcoin_rounded, size: 60, color: accent),
          const SizedBox(height: 20),
          StreamBuilder(
            stream: _channel.stream,
            builder: (context, snapshot) {
              if (snapshot.hasError) return const Text('CONNECTION ERROR', style: TextStyle(color: Colors.redAccent));
              if (!snapshot.hasData) return const CircularProgressIndicator(color: Colors.white24);

              final Map<String, dynamic> dataJson = jsonDecode(snapshot.data.toString());
              final String price = dataJson['bitcoin'] ?? '0.00';
              _currentPrice = double.parse(price).toStringAsFixed(2);

              return Column(
                children: [
                  Text(
                    '\$ $_currentPrice',
                    style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  const Text('LIVE DATA FROM WEBSOCKET', style: TextStyle(color: Colors.white24, fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildIsolateButton(Color primary) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _isCalculating ? Colors.grey : primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            onPressed: _isCalculating ? null : () async {
              setState(() => _isCalculating = true);
              
              // LOGIKA PERSONAL: 2 digit terakhir NIM (02) x 10.000.000 = 20.000.000
              const int loopTarget = 20000000;
              
              // Menjalankan Isolate (compute) agar UI tidak freeze
              final result = await compute(hitungKalkulasiAngga, loopTarget);

              setState(() => _isCalculating = false);

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('KALKULASI ANGGA BERHASIL: $result'),
                    backgroundColor: primary,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: _isCalculating 
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : const Text('KALKULASI PAJAK (NIM 02)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ),
        const SizedBox(height: 12),
        const Text('LOGIKA: 02 x 10.000.000 LOOPING', style: TextStyle(color: Colors.white24, fontSize: 10)),
      ],
    );
  }
}