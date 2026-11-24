import 'package:flutter/material.dart';
import 'package:slope_net/Component/RiskBadgePill.dart';
import 'package:slope_net/Component/SlopeSurfaceCard.dart';

class RoutePlannerScreen extends StatelessWidget {
    RoutePlannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final segments = [
      ('Jaglot to Alam Bridge', '30 km', 'Safe',   Color(0xFF22C55E)),
      ('Alam Bridge to Shengus', '58 km', 'Moderate', Colors.amber),
      ('Shengus zone', '14 km', 'High', Colors.redAccent),
      ('Shengus to Skardu', '66 km', 'Safe',   Color(0xFF22C55E)),
    ];

    return Scaffold(
      backgroundColor:   Color(0xFF0B0F15),
      body: SafeArea(
        child: SingleChildScrollView(
          padding:   EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Text(
                'Safe route',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
                SizedBox(height: 14),
              // Origin & Destination card
              SlopeSurfaceCard(
                child: Column(
                  children:   [
                    Row(
                      children: [
                        Icon(Icons.radio_button_checked,
                            color: Color(0xFF22C55E), size: 18),
                        SizedBox(width: 10),
                        Text(
                          'Jaglot',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Divider(color: Colors.white12, height: 18),
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            color: Colors.redAccent, size: 18),
                        SizedBox(width: 10),
                        Text(
                          'Skardu',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
                SizedBox(height: 12),
              // Route overview & duration
              SlopeSurfaceCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:   [
                        Text(
                          'Jaglot',
                          style: TextStyle(color: Colors.white54, fontSize: 11),
                        ),
                        Text(
                          'Skardu',
                          style: TextStyle(color: Colors.white54, fontSize: 11),
                        ),
                      ],
                    ),
                      SizedBox(height: 8),
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient:   LinearGradient(
                          colors: [
                            Color(0xFF22C55E),
                            Colors.amber,
                            Colors.redAccent,
                            Color(0xFF22C55E),
                          ],
                        ),
                      ),
                    ),
                      SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:   [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '4 h 20 m',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              '168 km',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        RiskBadgePill(
                          label: '1 high-risk segment',
                          color: Colors.redAccent,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
                SizedBox(height: 12),
              // Segments list
              SlopeSurfaceCard(
                child: Column(
                  children: segments.map((seg) {
                    return Padding(
                      padding:   EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: seg.$4,
                              shape: BoxShape.circle,
                            ),
                          ),
                            SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              seg.$1,
                              style:   TextStyle(
                                color: Colors.white,
                                fontSize: 13.5,
                              ),
                            ),
                          ),
                          Text(
                            seg.$2,
                            style:   TextStyle(
                              color: Colors.white54,
                              fontSize: 12.5,
                            ),
                          ),
                            SizedBox(width: 10),
                          RiskBadgePill(label: seg.$3, color: seg.$4),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
                SizedBox(height: 12),
              // Travel advisory
              SlopeSurfaceCard(
                backgroundColor:   Color(0xFF292110),
                borderColor: Colors.amber.withValues(alpha: 0.45),
                child:   Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.warning_amber_rounded,
                            color: Colors.amber, size: 18),
                        SizedBox(width: 6),
                        Text(
                          'Travel advisory',
                          style: TextStyle(
                            color: Colors.amber,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Text(
                      'High risk near Shengus. Expect delays and avoid stopping below the slope.',
                      style: TextStyle(color: Colors.white70, fontSize: 12.5),
                    ),
                  ],
                ),
              ),
                SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor:   Color(0xFF10B981),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child:   Text(
                    'Start safe navigation',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}