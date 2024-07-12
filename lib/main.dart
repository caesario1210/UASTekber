import 'package:flutter/material.dart';
import 'package:input_mahasiswa/login.dart';
import 'package:path/path.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://nwoxqruhpiqrsbjxpnlc.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im53b3hxcnVocGlxcnNianhwbmxjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTg5MzE0NzUsImV4cCI6MjAzNDUwNzQ3NX0.q_80Mxtrv4lWneVAXQkfcGce57XvcAev-P9EeIsBxKs',
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Login(),

    );
  }
  
  
}
