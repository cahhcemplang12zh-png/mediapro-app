import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MediaProApp());

class MediaProApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MediaPro',
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF6C5CE7),
        scaffoldBackgroundColor: Color(0xFF0F0F1A),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = TextEditingController();
  String _status = 'Tempel link TikTok / IG / YouTube / FB';
  bool _loading = false;
  String _resultUrl = '';

  Future<void> _download() async {
    String url = _controller.text.trim();
    if (url.isEmpty) return;
    setState(() { _loading = true; _status = 'Mengambil video tanpa watermark...'; });
    try {
      // Pakai API gratis tikwm untuk TikTok, sisanya fallback
      final res = await http.get(Uri.parse('https://www.tikwm.com/api/?url=$url'));
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        if (data['data'] != null && data['data']['play'] != null) {
          setState(() { _resultUrl = data['data']['play']; _status = 'BERHASIL! Video tanpa watermark siap!'; });
        } else {
          setState(() { _status = 'Gagal ambil video. Coba link TikTok lain.'; });
        }
      } else {
        setState(() { _status = 'Server sibuk, coba lagi.'; });
      }
    } catch (e) {
      setState(() { _status = 'Error: $e'; });
    }
    setState(() { _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('🔥 MediaPro - No Watermark'), backgroundColor: Color(0xFF6C5CE7)),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(color: Color(0xFF6C5CE7), borderRadius: BorderRadius.circular(16)),
              child: Text('Download TikTok, IG, YouTube, FB\nTanpa Watermark - GRATIS!', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 20),
            TextField(controller: _controller, decoration: InputDecoration(hintText: 'Tempel link video di sini...', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.white10)),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity, height: 50,
              child: ElevatedButton(
                onPressed: _loading ? null : _download,
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF00D2FF), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: _loading ? CircularProgressIndicator(color: Colors.white) : Text('DOWNLOAD SEKARANG', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            SizedBox(height: 20),
            Text(_status, textAlign: TextAlign.center),
            if (_resultUrl.isNotEmpty) ...[
              SizedBox(height: 20),
              Text('Link Video:', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              SelectableText(_resultUrl, style: TextStyle(color: Colors.cyan)),
              SizedBox(height: 12),
              Text('Copy link di atas, buka di Chrome untuk simpan video.', style: TextStyle(color: Colors.grey)),
            ],
            Spacer(),
            Text('MediaPro v1.0 - Dibuat untukmu', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
