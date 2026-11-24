import 'package:flutter/material.dart';
import 'package:slope_net/Component/RiskBadgePill.dart';
import 'package:slope_net/Component/SlopeSurfaceCard.dart';

class AlertsFeedScreen extends StatelessWidget {
  const AlertsFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final todayItems = [
      (
      'Entered Shengus alert zone',
      'You are inside the 10 km radius of an active high-risk area.',
      '2m',
      Colors.redAccent,
      ),
      (
      'NDMA / PDMA advisory',
      'Heavy rain expected over Gilgit-Baltistan. Skardu Road may close at short notice.',
      '1h',
      Colors.amber,
      ),
      (
      'Rockfall report verified',
      'An authority confirmed rockfall near Shengus, 4.2 km ahead.',
      '3h',
      Colors.lightBlueAccent,
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0B0F15),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Alerts',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  RiskBadgePill(
                    label: '10 km radius',
                    color: Colors.lightBlueAccent,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              // Critical warning card
              SlopeSurfaceCard(
                backgroundColor: const Color(0xFF7F1D1D),
                borderColor: Colors.redAccent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'ACTIVE WARNING',
                          style: TextStyle(
                            color: Colors.amberAccent,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Sound on',
                          style: TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Critical landslide warning, 3 km ahead',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Heavy 3-hour rainfall and 4 verified rockfall reports near Shengus. Pull over away from the slope if you cannot turn back.',
                      style: TextStyle(color: Colors.white70, fontSize: 12.5),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF7F1D1D),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'View on map',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'TODAY',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 8),
              ...todayItems.map(
                    (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SlopeSurfaceCard(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.notifications_active,
                            color: item.$4, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.$1,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13.5,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    item.$3,
                                    style: const TextStyle(
                                      color: Colors.white38,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.$2,
                                style: const TextStyle(
                                  color: Colors.white60,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'YESTERDAY',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 8),
              const SlopeSurfaceCard(
                child: Row(
                  children: [
                    Icon(Icons.check_circle,
                        color: Color(0xFF22C55E), size: 20),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Segment marked Cleared',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 13.5,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'Jaglot to Alam Bridge is open again.',
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '1d',
                      style: TextStyle(color: Colors.white38, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}