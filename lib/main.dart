import 'package:flutter/material.dart';
import 'navigation/app_routes.dart';

void main() {
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Container(
      color: const Color(0xFF202020),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFE0392B), size: 36),
          const SizedBox(height: 12),
          const Text('Something went wrong rendering this screen.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(details.exceptionAsString(),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 11),
              maxLines: 6,
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  };
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFF202020), useMaterial3: true),
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}