import 'package:flutter/material.dart';
import 'coloring_pages_data.dart';
import 'flood_fill_coloring_screen.dart';
import 'sound_service.dart';

class CategoryPagesScreen extends StatelessWidget {
  final String category;

  const CategoryPagesScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final pages = coloringPages.where((p) => p.category == category).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      appBar: AppBar(
        title: Text(
          '$category Coloring',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFFF7043),
        foregroundColor: Colors.white,
      ),
      body: pages.isEmpty
          ? const Center(
              child: Text(
                'No pages yet in this category.',
                style: TextStyle(fontSize: 16, color: Color(0xFF37474F)),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(20),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isLandscape = constraints.maxWidth > constraints.maxHeight;
                  final crossAxisCount = isLandscape ? 4 : 2;

                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: pages.length,
                    itemBuilder: (context, index) {
                      final page = pages[index];
                      return _PageCard(
                        assetPath: page.assetPath,
                        name: page.name,
                        onTap: () {
                          SoundService.playClick();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FloodFillColoringScreen(
                                assetPath: page.assetPath,
                                title: page.name,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
    );
  }
}

class _PageCard extends StatelessWidget {
  final String assetPath;
  final String name;
  final VoidCallback onTap;

  const _PageCard({
    required this.assetPath,
    required this.name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      elevation: 3,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                child: Image.asset(
                  assetPath,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF37474F),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}