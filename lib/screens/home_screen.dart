import 'dart:math';

import 'package:flutter/material.dart';
import 'flood_fill_coloring_screen.dart';
import 'category_pages_screen.dart';
import 'coloring_pages_data.dart';
import 'sound_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _categories = [
    _Category(name: 'Animals', emoji: '🦁', color: Color(0xFFFFE082)),
    _Category(name: 'Vehicles', emoji: '🚗', color: Color(0xFF90CAF9)),
    _Category(name: 'Space', emoji: '🚀', color: Color(0xFFCE93D8)),
    _Category(name: 'Mix', emoji: '👑', color: Color(0xFFF48FB1)),
  ];

  void _openRandomPage(BuildContext context) {
    SoundService.playClick();
    if (coloringPages.isEmpty) return;
    final page = coloringPages[Random().nextInt(coloringPages.length)];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FloodFillColoringScreen(
          assetPath: page.assetPath,
          title: page.name,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = screenWidth * 0.06;
    final titleSize = screenWidth < 360 ? 28.0 : 34.0;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: constraints.maxHeight * 0.04),
                    _TitleSection(titleSize: titleSize),
                    SizedBox(height: constraints.maxHeight * 0.05),
                    _StartColoringButton(
                      onPressed: () => _openRandomPage(context),
                    ),
                    SizedBox(height: constraints.maxHeight * 0.06),
                    const Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF37474F),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _CategoryGrid(categories: _categories),
                    SizedBox(height: constraints.maxHeight * 0.04),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _TitleSection extends StatelessWidget {
  const _TitleSection({required this.titleSize});

  final double titleSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('🎨', style: TextStyle(fontSize: 56)),
        const SizedBox(height: 8),
        Text(
          'Coloring World',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: titleSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF5D4037),
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class _StartColoringButton extends StatelessWidget {
  const _StartColoringButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.shuffle),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF7043),
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: const Color(0xFFFF7043).withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        label: const Text(
          'Random Coloring',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  const _CategoryGrid({required this.categories});

  final List<_Category> categories;

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.orientationOf(context) == Orientation.landscape;
    final crossAxisCount = isLandscape ? 4 : 2;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: isLandscape ? 1.3 : 1.15,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];

        return _CategoryCard(
          category: category,
          onTap: () {
            SoundService.playClick();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategoryPagesScreen(category: category.name),
              ),
            );
          },
        );
      },
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.category,
    required this.onTap,
  });

  final _Category category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: category.color,
      borderRadius: BorderRadius.circular(20),
      elevation: 2,
      shadowColor: Colors.black26,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(category.emoji, style: const TextStyle(fontSize: 40)),
              const SizedBox(height: 10),
              Text(
                category.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
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

class _Category {
  const _Category({
    required this.name,
    required this.emoji,
    required this.color,
  });

  final String name;
  final String emoji;
  final Color color;
}