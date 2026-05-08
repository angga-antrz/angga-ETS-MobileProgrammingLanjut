import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // LOGIKA PERSONAL (ANTI-AI): 
    // Delay persis selama X detik (X = digit terakhir NIM 20123002)
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) context.go('/');
    });
  }

  @override
  Widget build(BuildContext context) {
    // Menggunakan warna Teal sesuai identitas UTD Store Angga
    const Color primaryColor = Colors.teal;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Dekorasi Background (Lingkaran halus khas UTD)
          Positioned(
            top: -50,
            right: -50,
            child: CircleAvatar(
              radius: 100,
              backgroundColor: primaryColor.withValues(alpha:0.1),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // LOGO: Menggunakan Container dengan aksen UTD
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withValues(alpha:0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.shopping_bag_outlined, 
                    size: 80,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),
                // IDENTITAS PEMILIK PROYEK
                const Text(
                  'UTD STORE',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    letterSpacing: 2,
                  ),
                ),
                const Text(
                  'ANGGA ANTAREZA',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 50),
                // LOADING INDICATOR
                const SizedBox(
                  width: 50,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.black12,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 25),
                // IDENTITAS NIM 20123002
                const Text(
                  'NIM: 20123002',
                  style: TextStyle(
                    color: Colors.black38,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          // FOOTER
          const Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'MOBILE PROGRAMMING LANJUT',
                style: TextStyle(
                  color: Colors.black26, 
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}