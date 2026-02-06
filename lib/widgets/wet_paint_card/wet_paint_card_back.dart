import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class WetPaintCardBack extends StatelessWidget {
  final double height;

  const WetPaintCardBack({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [AppColors.platinumBase, AppColors.platinumDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 20, spreadRadius: 0),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Background overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.0),
                    Colors.white.withOpacity(0.4),
                    Colors.white.withOpacity(0.0),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Column(
              children: [
                const SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF303030),
                        Colors.black,
                        Colors.black,
                        const Color(0xFF303030),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.white, width: 1),
                          ),
                          padding: const EdgeInsets.only(left: 12),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Authorized Signature",
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.7),
                              fontSize: 10,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Row(
                        children: [
                          Text(
                            "CVC",
                            style: TextStyle(
                              color: AppColors.spaceStart.withOpacity(0.6),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            width: 64,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 2,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              "892",
                              style: TextStyle(
                                color: AppColors.electricAccent,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'monospace',
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "CARD HOLDER",
                        style: TextStyle(
                          color: AppColors.spaceStart.withOpacity(0.5),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "KYRIAKOS GEORGIOPOULOS",
                        style: TextStyle(
                          color: AppColors.spaceStart,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'serif',
                          letterSpacing: 0.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
