import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../core/app_theme.dart';
import 'package:provider/provider.dart';
import '../providers/app_locale_provider.dart';
import '../providers/favorites_provider.dart';

/// A unified, premium product card for Meri-Mari.
/// Matches the proportions and design of the Pop Mart reference image.
class MeriMariProductCard extends StatelessWidget {
  final ItemModel item;
  final VoidCallback onTap;
  final bool isEditMode;
  final bool isSelected;
  final VoidCallback? onSelectToggle;

  const MeriMariProductCard({
    super.key,
    required this.item,
    required this.onTap,
    this.isEditMode = false,
    this.isSelected = false,
    this.onSelectToggle,
  });

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppLocaleProvider>().strings;
    final isFav = context.watch<FavoritesProvider>().isFavorite(item.id);

    return GestureDetector(
      onTap: isEditMode ? onSelectToggle : onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: kPurple.withValues(alpha: 0.10),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(color: kPurpleBorder.withValues(alpha: 0.5), width: 1),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Image Section ───────────────────────────────────────────
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          item.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: kPurpleFaint,
                            child: const Icon(Icons.image_not_supported, color: kPurpleBorder),
                          ),
                        ),

                        // Condition Tag (Bottom-Left)
                        if (item.tags.isNotEmpty)
                          Positioned(
                            bottom: 10,
                            left: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: kPurple.withValues(alpha: 0.85),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                s.tagLabel(item.tags.first),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),

                        // Heart Button (Top-Right) - Hide in Edit Mode
                        if (!isEditMode)
                          Positioned(
                            top: 10,
                            right: 10,
                            child: _HeartButton(
                              isFav: isFav,
                              onToggle: () => context.read<FavoritesProvider>().toggleFavorite(item),
                            ),
                          ),

                        // Sold Out Overlay
                        if (item.isSold)
                          Positioned.fill(
                            child: Container(
                              color: Colors.black.withValues(alpha: 0.4),
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    s.isThai ? 'ของหมด' : 'Sold Out',
                                    style: const TextStyle(
                                      color: kText,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // ── Info Section ────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: kText,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '฿${item.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: kPurple,
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // ── Edit Mode Selection Overlay ──────────────────────────────
            if (isEditMode)
              Positioned(
                bottom: 12,
                right: 12,
                child: Icon(
                  isSelected ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                  color: isSelected ? kPurple : kText.withValues(alpha: 0.4),
                  size: 28,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _HeartButton extends StatelessWidget {
  final bool isFav;
  final VoidCallback onToggle;

  const _HeartButton({required this.isFav, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: kPurple.withValues(alpha: 0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(
          isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          size: 18,
          color: isFav ? kPurple : kText.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}
