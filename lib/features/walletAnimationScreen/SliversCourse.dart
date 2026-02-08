import 'package:bank/features/walletAnimationScreen/widgets/visa_card/visa_card.dart';
import 'package:flutter/material.dart';

class SliversCourse extends StatelessWidget {
  const SliversCourse({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ===============================
          // 1️⃣ CINEMATIC PARALLAX HEADER
          // ===============================
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            stretch: true,
            backgroundColor: Colors.black,
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                final progress = (constraints.maxHeight - kToolbarHeight) / 260;

                return FlexibleSpaceBar(
                  title: const Text('My Wallet'),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Background
                      Transform.scale(
                        scale: 1.2 - progress * 0.2,
                        child: Image.asset('assets/wallet_bg.jpg', fit: BoxFit.cover),
                      ),

                      // Dark overlay
                      Container(color: Colors.black.withOpacity(0.4)),

                      // Floating Visa Card
                      Positioned(
                        bottom: 32,
                        left: 24,
                        right: 24,
                        child: Transform.translate(
                          offset: Offset(0, 40 * (1 - progress)),
                          child: Transform.scale(scale: 0.9 + 0.1 * progress, child: VisaCard()),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // ===============================
          // 2️⃣ STACKED VISA CARDS (DEPTH)
          // ===============================
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return Transform.translate(
                  offset: Offset(0, -index * 24),
                  child: Transform.scale(
                    scale: 1 - index * 0.03,
                    child: Opacity(opacity: 1 - index * 0.15, child: VisaCard()),
                  ),
                );
              }, childCount: 3),
            ),
          ),

          // ===============================
          // 3️⃣ PINNED SECTION HEADER
          // ===============================
          SliverPersistentHeader(
            pinned: true,
            delegate: _PinnedHeaderDelegate(
              minHeight: 60,
              maxHeight: 60,
              child: Container(
                color: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Your Cards',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),

          // ===============================
          // 4️⃣ HORIZONTAL VISA CAROUSEL
          // ===============================
          SliverToBoxAdapter(
            child: SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: SizedBox(width: 300, child: Card()),
                  );
                },
              ),
            ),
          ),

          // ===============================
          // 5️⃣ VISA CARD FEED
          // ===============================
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: VisaCard(),
              );
            }, childCount: 8),
          ),

          // ===============================
          // 6️⃣ END FILL (CTA / SUMMARY)
          // ===============================
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.lock, size: 48),
                  SizedBox(height: 16),
                  Text('Your cards are secure', style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PinnedHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _PinnedHeaderDelegate({required this.minHeight, required this.maxHeight, required this.child});

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant _PinnedHeaderDelegate oldDelegate) => false;
}
