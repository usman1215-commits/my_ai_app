import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../screens/ozzi_widgets.dart';

const kGreenColor = Color(0xFF4CAF50);

/// Top section of the Home screen — PURE UI, no backend/API calls.
///
/// - Profile picture: pass a URL once backend gives you one.
/// - Weather: pass values in from wherever your backend/API call
///   ends up living. For now these default to placeholders so the
///   layout is visible without wiring up real data.
/// - Date: uses the device's own current date (this is just local
///   device info, not a backend call).
class HomeTopBar extends StatelessWidget {
  /// Pass the logged-in user's avatar URL here once your backend
  /// gives it to you, e.g. NetworkImage(user.avatarUrl).
  final String? profileImageUrl;

  /// Which weather icon should be highlighted green.
  /// null = none highlighted yet (no data available).
  /// Set this from wherever your backend/weather call's result ends up.
  final WeatherIcon? activeWeather;

  /// Temperature text to display, e.g. "13°C". Pass null to hide it
  /// until real data is available.
  final String? temperatureText;

  const HomeTopBar({
    super.key,
    this.profileImageUrl,
    this.activeWeather,
    this.temperatureText,
  });

  @override
  Widget build(BuildContext context) {
    final todayStr = DateFormat('EEEE, d MMM').format(DateTime.now());

    return Row(
      children: [
        // Profile picture — from backend once user uploads a DP.
        CircleAvatar(
          radius: 24,
          backgroundColor: kFieldColor,
          backgroundImage: profileImageUrl != null ? NetworkImage(profileImageUrl!) : null,
          child: profileImageUrl == null
              ? const Icon(Icons.person, color: Colors.white, size: 24)
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hello 👋',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Text(
                todayStr,
                style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
              ),
            ],
          ),
        ),

        // Placeholder temperature text — pass temperatureText once
        // your backend/weather API gives you a real value.
        if (temperatureText != null) ...[
          Text(
            temperatureText!,
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 10),
        ],

        _weatherIcon(Icons.wb_sunny_rounded, isActive: activeWeather == WeatherIcon.sun),
        const SizedBox(width: 6),
        _weatherIcon(Icons.cloud_rounded, isActive: activeWeather == WeatherIcon.cloud),
        const SizedBox(width: 6),
        _weatherIcon(Icons.water_drop_rounded, isActive: activeWeather == WeatherIcon.rain),
      ],
    );
  }

  Widget _weatherIcon(IconData icon, {required bool isActive}) {
    return Icon(
      icon,
      size: 20,
      color: isActive ? kGreenColor : Colors.grey.shade600,
    );
  }
}

/// The 3 simplified weather categories shown in the design.
enum WeatherIcon { sun, cloud, rain }