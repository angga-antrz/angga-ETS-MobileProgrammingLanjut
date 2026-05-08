import 'dart:io'; 
import 'package:dio/dio.dart';
import 'package:dio/io.dart'; 
import 'package:logger/logger.dart';

class ApiClient {
  final Dio dio;
  final Logger logger = Logger(); // Logger untuk debugging profesional

  ApiClient() : dio = Dio() {
    // 1. Konfigurasi Dasar (Global)
    // Menggunakan API publik gratis sesuai standar praktikum
    dio.options.baseUrl = 'https://api.escuelajs.co/api/v1'; 
    
    // Konfigurasi Timeout (Penting untuk internet yang tidak stabil)
    dio.options.connectTimeout = const Duration(seconds: 30); 
    dio.options.receiveTimeout = const Duration(seconds: 30); 

    // SOLUSI SSL: Mengabaikan pemeriksaan sertifikat SSL (Penting untuk lingkungan dev/testing)
    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };

    // 2. Menambahkan Interceptor (Satpam Jaringan)
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Log Pengiriman Request oleh Angga
          logger.i('ANGGA-REQ: [${options.method}] ${options.uri}');
          
          // Bisa digunakan untuk menambahkan Header atau Auth Token secara otomatis
          options.headers['Content-Type'] = 'application/json';
          
          return handler.next(options); 
        },
        onResponse: (response, handler) {
          // Log Response Berhasil
          logger.i('ANGGA-SUCCESS [${response.statusCode}]: ${response.requestOptions.uri}');
          return handler.next(response); 
        },
        onError: (DioException e, handler) {
          // Log Penanganan Error Jaringan
          logger.e('ANGGA-ERROR [${e.response?.statusCode}]: ${e.requestOptions.uri}');
          logger.e('MESSAGE: ${e.message}');
          
          return handler.next(e); 
        },
      ),
    );
  }
}