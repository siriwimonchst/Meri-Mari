// lib/features/favorite_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/app_locale_provider.dart';
import '../models/item_model.dart';
import 'product_detail.dart';

// Design tokens (matching home.dart)
const _kPurple = Color(0xFF7B5EA7);
const _kPurpleLight = Color(0xFFAB9DC4);
const _kPurpleFaint = Color(0xFFF4F0FA);
const _kPurpleBorder = Color(0xFFDDD6E8);
const _kText = Color(0xFF1A1A2E);
const _kSubText = Color(0xFFB0A8C4);

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fav = context.watch<FavoritesProvider>();
    final s = context.watch<AppLocaleProvider>().strings;
    final items = fav.favoriteItems;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 20,
        title: Text(
          s.myFavorites,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: _kText,
          ),
        ),
      ),
      body: items.isEmpty
          ? _EmptyFavorites(s: s)
          : GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.72,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              itemCount: items.length,
              itemBuilder: (ctx, i) => _FavoriteCard(
                item: items[i],
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductDetailScreen(item: items[i]),
                  ),
                ),
                onUnFavorite: () => fav.toggleFavorite(items[i]),
              ),
            ),
    );
  }
}

// ── Favorite Card (grid style, mirrors home ProductCard) ─────────────────────

class _FavoriteCard extends StatelessWidget {
  final ItemModel item;
  final VoidCallback onTap;
  final VoidCallback onUnFavorite;

  const _FavoriteCard({
    required this.item,
    required this.onTap,
    required this.onUnFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: _kPurple.withValues(alpha: 0.10),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
          border: Border.all(color: _kPurpleBorder, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image area
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Product image
                    Image.network(
                      item.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: _kPurpleFaint,
                        child: const Icon(
                          Icons.image_not_supported,
                          color: _kPurpleBorder,
                        ),
                      ),
                    ),
                    // Tag pill
                    if (item.tags.isNotEmpty)
                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _kPurple.withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            item.tags.first,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    // Heart (unfavorite) button
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: onUnFavorite,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: _kPurple.withValues(alpha: 0.15),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.favorite_rounded,
                            size: 16,
                            color: _kPurple,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Info area
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: _kText,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '฿${item.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: _kPurple,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Empty Favorites ───────────────────────────────────────────────────────────

class _EmptyFavorites extends StatelessWidget {
  final dynamic s;
  const _EmptyFavorites({required this.s});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              color: _kPurpleFaint,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite_border_rounded,
              size: 48,
              color: _kPurpleLight,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            s.emptyFavorites,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: _kText,
            ),
          ),
          const SizedBox(height: 8),
          const Text('❤️', style: TextStyle(fontSize: 22)),
          const SizedBox(height: 6),
          Text(
            s.favHint,
            style: const TextStyle(color: _kSubText, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
