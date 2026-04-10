// lib/widgets/home_widgets.dart
// ─── Home Screen Sub-Widgets ──────────────────────────────────────────────────
// Extracted from home.dart to keep that file focused on screen-level logic only.
// Import this file in home.dart.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../models/item_model.dart';
import '../models/address_model.dart';
import '../core/address_service.dart';
import '../providers/app_locale_provider.dart';
import '../providers/item_provider.dart';
import '../providers/address_provider.dart';
import 'product_card.dart';
import '../features/search_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Internal data classes
// ─────────────────────────────────────────────────────────────────────────────

class HomeBannerItem {
  final String title;
  final String subtitle;
  final Color accentColor;
  final String? bannerAsset; // Dedicated field for a full-width local asset
  const HomeBannerItem({
    required this.title,
    required this.subtitle,
    required this.accentColor,
    this.bannerAsset,
  });
}

const List<HomeBannerItem> homeBanners = [
  HomeBannerItem(
    title: 'New Arrivals',
    subtitle: 'ของใหม่มาแล้ว!\nเช็คก่อนใครได้เลย',
    accentColor: kPurple,
    bannerAsset: 'assets/banner_01.jpg',
  ),
  HomeBannerItem(
    title: 'Flash Sale',
    subtitle: 'ลดราคาพิเศษ\nวันนี้เท่านั้น!',
    accentColor: Color(0xFF9C6FD6),
    bannerAsset: 'assets/banner_02.jpg',
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// HomeLocationBar
// ─────────────────────────────────────────────────────────────────────────────

class HomeLocationBar extends StatelessWidget {
  final dynamic s;
  final String locationText;
  final VoidCallback? onTap;
  const HomeLocationBar({
    super.key,
    required this.s,
    required this.locationText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            s.locationLabel,
            style: const TextStyle(
              fontSize: 11,
              color: kSubText,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              const Icon(Icons.location_on_rounded, size: 14, color: kPurple),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  locationText.isEmpty ? s.noLocation : locationText,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: kText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 16,
                color: kSubText,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HomeSearchBar
// ─────────────────────────────────────────────────────────────────────────────

class HomeSearchBar extends StatefulWidget {
  final ItemProvider itemProvider;
  final String hint;
  const HomeSearchBar({
    super.key,
    required this.itemProvider,
    required this.hint,
  });

  @override
  State<HomeSearchBar> createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends State<HomeSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goToSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SearchScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: _goToSearch,
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: kPurpleFaint,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: kPurpleBorder, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.hint,
                        style: const TextStyle(color: kSubText, fontSize: 14),
                      ),
                    ),
                    const Icon(
                      Icons.search_rounded,
                      color: kPurple,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HomeBannerCarousel
// ─────────────────────────────────────────────────────────────────────────────

class HomeBannerCarousel extends StatelessWidget {
  final PageController ctrl;
  final int currentPage;
  final dynamic s;
  final ValueChanged<int> onPageChanged;

  const HomeBannerCarousel({
    super.key,
    required this.ctrl,
    required this.currentPage,
    required this.s,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: ctrl,
            itemCount: homeBanners.length,
            onPageChanged: onPageChanged,
            itemBuilder: (ctx, i) {
              final banner = homeBanners[i];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        banner.accentColor.withValues(alpha: 0.15),
                        banner.accentColor.withValues(alpha: 0.05),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: banner.accentColor.withValues(alpha: 0.25),
                      width: 1,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Full width asset image
                      if (banner.bannerAsset != null)
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              banner.bannerAsset!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      // Overlay content
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 20, 20, 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (banner.bannerAsset == null) ...[
                                    Text(
                                      banner.title,
                                      style: TextStyle(
                                        color: banner.accentColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900,
                                        height: 1.2,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      banner.subtitle,
                                      style: TextStyle(
                                        color: kText.withValues(alpha: 0.65),
                                        fontSize: 12,
                                        height: 1.5,
                                      ),
                                    ),
                                    const SizedBox(height: 14),
                                  ],
                                  // Button is always there unless it's a pure image
                                  if (banner.bannerAsset == null)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: banner.accentColor,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Text(
                                        s.bannerShopNow,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            if (banner.bannerAsset == null)
                              Icon(
                                Icons.local_offer_rounded,
                                size: 80,
                                color: banner.accentColor.withValues(alpha: 0.15),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(homeBanners.length, (i) {
            final isActive = i == currentPage;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: isActive ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: isActive ? kPurple : kPurpleBorder,
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HomeProductCard
// ─────────────────────────────────────────────────────────────────────────────

class HomeProductCard extends StatelessWidget {
  final ItemModel item;
  final VoidCallback onTap;

  const HomeProductCard({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return MeriMariProductCard(item: item, onTap: onTap);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HomeEmptyState  &  HomeErrorState
// ─────────────────────────────────────────────────────────────────────────────

class HomeEmptyState extends StatelessWidget {
  final dynamic s;
  const HomeEmptyState({super.key, required this.s});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.search_off_rounded,
              size: 64,
              color: kPurpleBorder,
            ),
            const SizedBox(height: 16),
            Text(
              s.noProducts,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: kPurpleLight,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              s.tryOtherSearch,
              style: const TextStyle(fontSize: 14, color: kSubText),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeErrorState extends StatelessWidget {
  final String msg;
  const HomeErrorState({super.key, required this.msg});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_rounded, size: 64, color: kPurpleBorder),
            const SizedBox(height: 16),
            Text(
              msg,
              textAlign: TextAlign.center,
              style: const TextStyle(color: kSubText, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HomeAddressSheet
// ─────────────────────────────────────────────────────────────────────────────

class HomeAddressSheet extends StatefulWidget {
  const HomeAddressSheet({super.key});

  @override
  State<HomeAddressSheet> createState() => _HomeAddressSheetState();
}

class _HomeAddressSheetState extends State<HomeAddressSheet> {
  String? _selectedAddressId;
  final AddressService _service = AddressService();

  @override
  void initState() {
    super.initState();
    // Initialize with the current default address ID
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final addressProvider = context.read<AddressProvider>();
      if (mounted) {
        setState(() {
          _selectedAddressId = addressProvider.defaultAddress?.id;
        });
      }
    });
  }

  void _onConfirm(dynamic s) {
    if (_selectedAddressId != null) {
      _service.setDefault(_selectedAddressId!);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = context.read<AppLocaleProvider>().strings;
    final addressProvider = context.watch<AddressProvider>();
    final current = addressProvider.defaultAddress;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: kPurpleBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Title
          Text(
            s.myAddressTitle,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: kText,
            ),
          ),
          const SizedBox(height: 20),

          // Selection Area (Scrollable if many addresses)
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Full Address View (Prominent / Current Default)
                  if (current != null) ...[
                    GestureDetector(
                      onTap: () =>
                          setState(() => _selectedAddressId = current.id),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: _selectedAddressId == current.id
                              ? kPurpleFaint
                              : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _selectedAddressId == current.id
                                ? kPurple
                                : kPurpleBorder,
                            width: _selectedAddressId == current.id ? 2 : 1.5,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_rounded,
                                  size: 20,
                                  color: _selectedAddressId == current.id
                                      ? kPurple
                                      : kSubText,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  s.currentAddress,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: _selectedAddressId == current.id
                                        ? kPurple
                                        : kSubText,
                                  ),
                                ),
                                const Spacer(),
                                if (_selectedAddressId == current.id)
                                  const Icon(
                                    Icons.check_circle_rounded,
                                    color: kPurple,
                                    size: 20,
                                  ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              current.addressLine1,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: kText,
                              ),
                            ),
                            if (current.addressLine2.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                current.addressLine2,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: kText,
                                ),
                              ),
                            ],
                            const SizedBox(height: 4),
                            Text(
                              '${current.city}, ${current.country} ${current.zipCode}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: kSubText,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ] else
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        s.noAddress,
                        style: const TextStyle(color: kSubText),
                      ),
                    ),

                  // Other addresses / Switching
                  StreamBuilder<List<AddressModel>>(
                    stream: _service.streamAddresses(),
                    builder: (ctx, snap) {
                      final others =
                          snap.data
                              ?.where((a) => a.id != current?.id)
                              .toList() ??
                          [];
                      if (others.isEmpty) return const SizedBox.shrink();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Switch to another address',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: kSubText,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...others.map((addr) {
                            final isSelected = _selectedAddressId == addr.id;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: InkWell(
                                onTap: () => setState(
                                  () => _selectedAddressId = addr.id,
                                ),
                                borderRadius: BorderRadius.circular(16),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? kPurpleFaint
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isSelected
                                          ? kPurple
                                          : kPurpleBorder,
                                      width: isSelected ? 2 : 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.home_outlined,
                                        size: 18,
                                        color: isSelected ? kPurple : kSubText,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          '${addr.addressLine1}, ${addr.city}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: isSelected
                                                ? FontWeight.w700
                                                : FontWeight.w600,
                                            color: isSelected ? kPurple : kText,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      if (isSelected)
                                        const Icon(
                                          Icons.check_circle_rounded,
                                          color: kPurple,
                                          size: 18,
                                        )
                                      else
                                        const Icon(
                                          Icons.radio_button_unchecked_rounded,
                                          size: 18,
                                          color: kPurpleBorder,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Confirm Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _selectedAddressId == null
                  ? null
                  : () => _onConfirm(s),
              style: ElevatedButton.styleFrom(
                backgroundColor: kPurple,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                disabledBackgroundColor: kPurpleBorder.withValues(alpha: 0.5),
              ),
              child: Text(
                s.okLabel,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
