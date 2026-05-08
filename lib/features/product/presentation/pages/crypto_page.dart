import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

// 1. FUNGSI BERAT DI LUAR CLASS (Logika Isolate)
// Menggunakan top-level function agar bisa dijalankan di Isolate
int tugasMenghitungBerat(int jumlahLooping) {
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
    // MENGGUNAKAN API BINANCE (Live Trade BTC/USDT)
    // Sesuai permintaan, menggunakan wss://data-stream.binance.vision
    _channel = WebSocketChannel.connect(
      Uri.parse('wss://data-stream.binance.vision/ws/btcusdt@trade'),
    );
  }

  @override
  void dispose() {
    _channel.sink.close(); // Mencegah memory leak
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Palet warna Teal konsisten dengan UTD Store Angga
    const Color primaryColor = Colors.teal; 
    const Color darkBg = Color(0xFF0B1015); 

    return Scaffold(
      backgroundColor: darkBg,
      appBar: AppBar(
        title: const Text(
          'ANGGA CRYPTO MONITOR',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5, fontSize: 16),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            // Header Info Personal
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: primaryColor.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('LIVE MONITORING', style: TextStyle(color: Colors.tealAccent, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2)),
                      Text('BTC / USDT TRADE', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('OPERATOR', style: TextStyle(color: Colors.white38, fontSize: 10)),
                      Text('ANGGA - 02', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Kartu Harga Real-time (Binance Data)
                    _buildModernPriceCard(primaryColor),

                    const SizedBox(height: 40),

                    // Indikator Responsivitas UI (Penting untuk demo Isolate)
                    const Text('SYSTEM STABILITY CHECK', style: TextStyle(color: Colors.white38, fontSize: 10, letterSpacing: 2)),
                    const SizedBox(height: 15),
                    CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(_isCalculating ? Colors.redAccent : primaryColor),
                    ),

                    const SizedBox(height: 50),

                    // Tombol Kalkulasi Isolate (Logika NIM 02)
                    _buildNeonButton(primaryColor),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernPriceCard(Color accent) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: accent.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(color: accent.withOpacity(0.05), blurRadius: 40, spreadRadius: -10),
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.currency_bitcoin_rounded, size: 50, color: accent),
          const SizedBox(height: 20),
          StreamBuilder(
            stream: _channel.stream,
            builder: (context, snapshot) {
              if (snapshot.hasError) return const Text('CONNECTION ERROR', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold));
              if (!snapshot.hasData) return const CircularProgressIndicator(color: Colors.white24);

              // Decode JSON dari Binance Trade Stream
              final Map<String, dynamic> dataJson = jsonDecode(snapshot.data.toString());
              // Key 'p' pada Binance melambangkan 'Price'
              final String price = dataJson['p'] ?? '0.00';
              _currentPrice = double.parse(price).toStringAsFixed(2);

              return Column(
                children: [
                  Text(
                    '\$ $_currentPrice',
                    style: const TextStyle(fontSize: 38, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: -1),
                  ),
                  const SizedBox(height: 5),
                  Text('REAL-TIME FROM BINANCE WS', style: TextStyle(color: accent.withOpacity(0.6), fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNeonButton(Color accent) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _isCalculating ? Colors.transparent : accent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(color: accent, width: 2),
              ),
              elevation: _isCalculating ? 0 : 8,
            ),
            onPressed: _isCalculating ? null : () async {
              setState(() => _isCalculating = true);
              
              // LOGIKA PERSONAL: 02 (NIM) x 10.000.000 perulangan
              const int nimLoopFactor = 2 * 10000000; 
              
              // Menjalankan tugas di background menggunakan Isolate
              final result = await compute(tugasMenghitungBerat, nimLoopFactor);

              setState(() => _isCalculating = false);

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('ISOLATE 02 SUCCESS: $result'),
                    backgroundColor: accent,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: _isCalculating 
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : const Text('CALCULATE HEAVY TASK (NIM 02)', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
          ),
        ),
        const SizedBox(height: 12),
        const Text('ISOLATE ENSURES UI REMAINS RESPONSIVE', style: TextStyle(color: Colors.white24, fontSize: 9, letterSpacing: 1)),
      ],
    );
  } 
}