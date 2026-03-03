// lib/features/home.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/item_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/app_locale_provider.dart';
import '../providers/address_provider.dart';
import '../models/item_model.dart';
import 'product_detail.dart';
import 'cart_screen.dart';
import 'notifications_screen.dart';
import 'search_results_screen.dart';

// ─── Design tokens ────────────────────────────────────────────────────────────
const _kPurple = Color(0xFF7B5EA7);
const _kPurpleLight = Color(0xFFAB9DC4);
const _kPurpleFaint = Color(0xFFF4F0FA);
const _kPurpleBorder = Color(0xFFDDD6E8);
const _kText = Color(0xFF1A1A2E);
const _kSubText = Color(0xFFB0A8C4);

// ── Banner data ───────────────────────────────────────────────────────────────
class _BannerItem {
  final String title;
  final String subtitle;
  final Color accentColor;
  const _BannerItem({
    required this.title,
    required this.subtitle,
    required this.accentColor,
  });
}

const List<_BannerItem> _banners = [
  _BannerItem(
    title: 'New Arrivals',
    subtitle: 'ของใหม่มาแล้ว!\nเช็คก่อนใครได้เลย',
    accentColor: _kPurple,
  ),
  _BannerItem(
    title: 'Flash Sale',
    subtitle: 'ลดราคาพิเศษ\nวันนี้เท่านั้น!',
    accentColor: Color(0xFF9C6FD6),
  ),
  _BannerItem(
    title: 'Authentic Only',
    subtitle: 'สินค้าลิขสิทธิ์แท้\n100% ทุกชิ้น',
    accentColor: _kPurpleLight,
  ),
];

// ── Category data ─────────────────────────────────────────────────────────────
class _CategoryItem {
  final String thLabel;
  final String enLabel;
  final IconData icon;
  const _CategoryItem({
    required this.thLabel,
    required this.enLabel,
    required this.icon,
  });
}

const List<_CategoryItem> _categories = [
  _CategoryItem(
    thLabel: 'Pop Mart',
    enLabel: 'Pop Mart',
    icon: Icons.toys_rounded,
  ),
  _CategoryItem(
    thLabel: 'ตุ๊กตา',
    enLabel: 'Plush',
    icon: Icons.child_care_rounded,
  ),
  _CategoryItem(
    thLabel: 'กล่อง',
    enLabel: 'Blind Box',
    icon: Icons.inventory_2_rounded,
  ),
  _CategoryItem(thLabel: 'การ์ด', enLabel: 'Cards', icon: Icons.style_rounded),
  _CategoryItem(
    thLabel: 'อื่นๆ',
    enLabel: 'Others',
    icon: Icons.more_horiz_rounded,
  ),
];

// ─────────────────────────────────────────────────────────────────────────────

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _bannerCtrl = PageController();
  int _bannerPage = 0;
  Timer? _bannerTimer;

  @override
  void initState() {
    super.initState();
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (_bannerCtrl.hasClients) {
        final next = (_bannerPage + 1) % _banners.length;
        _bannerCtrl.animateToPage(
          next,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _bannerCtrl.dispose();
    _bannerTimer?.cancel();
    super.dispose();
  }

  void _showFilterSheet(BuildContext context) {
    final itemProvider = context.read<ItemProvider>();
    final s = context.read<AppLocaleProvider>().strings;
    Set<String> tempTags = {...itemProvider.selectedTags};

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
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
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: _kPurpleBorder,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        s.filterTitle,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: _kText,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => setModalState(() => tempTags = {}),
                        child: Text(
                          s.clearFilter,
                          style: const TextStyle(
                            color: _kPurpleLight,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: s.predefinedTags.map((tagMap) {
                      final key = tagMap['key']!;
                      final label = tagMap['label']!;
                      final selected = tempTags.contains(key);
                      return GestureDetector(
                        onTap: () {
                          setModalState(() {
                            if (selected) {
                              tempTags = {...tempTags}..remove(key);
                            } else {
                              tempTags = {...tempTags, key};
                            }
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: selected ? _kPurple : _kPurpleFaint,
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                              color: selected ? _kPurple : _kPurpleBorder,
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (selected)
                                const Padding(
                                  padding: EdgeInsets.only(right: 6),
                                  child: Icon(
                                    Icons.check_rounded,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              Text(
                                label,
                                style: TextStyle(
                                  color: selected ? Colors.white : _kPurple,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        itemProvider.setTags(tempTags);
                        Navigator.pop(ctx);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _kPurple,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      child: Text(s.applyFilter),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final itemProvider = context.watch<ItemProvider>();
    final cartProvider = context.watch<CartProvider>();
    final locale = context.watch<AppLocaleProvider>();
    final addressProvider = context.watch<AddressProvider>();
    final s = locale.strings;
    final hasActiveFilters = itemProvider.selectedTags.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // ── Top App Bar ──────────────────────────────────────────────────
          SliverAppBar(
            automaticallyImplyLeading: false,
            floating: true,
            snap: true,
            backgroundColor: Colors.white,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            toolbarHeight: 60,
            title: _LocationBar(
              s: s,
              locationText: addressProvider.locationSummary,
            ),
            actions: [
              // Notification bell
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: _kPurpleFaint,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.notifications_none_rounded,
                      color: _kPurple,
                      size: 20,
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const NotificationsScreen(),
                      ),
                    ),
                  ),
                ),
              ),
              // Cart
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: _kPurpleFaint,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.shopping_bag_outlined,
                          color: _kPurple,
                          size: 20,
                        ),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const CartScreen()),
                        ),
                      ),
                    ),
                    if (cartProvider.totalCount > 0)
                      Positioned(
                        top: -4,
                        right: -4,
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: const BoxDecoration(
                            color: _kPurple,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${cartProvider.totalCount}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(58),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                child: _SearchBar(
                  itemProvider: itemProvider,
                  hint: s.searchHint,
                ),
              ),
            ),
          ),

          // ── Body content ─────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: itemProvider.isLoading
                ? const SizedBox(
                    height: 300,
                    child: Center(
                      child: CircularProgressIndicator(color: _kPurple),
                    ),
                  )
                : itemProvider.error != null
                ? SizedBox(
                    height: 300,
                    child: _ErrorState(msg: itemProvider.error!),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      // Banner carousel
                      _BannerCarousel(
                        ctrl: _bannerCtrl,
                        currentPage: _bannerPage,
                        s: s,
                        onPageChanged: (p) => setState(() => _bannerPage = p),
                      ),
                      const SizedBox(height: 24),

                      // Category section
                      _CategorySection(s: s),
                      const SizedBox(height: 24),

                      // Products header
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Text(
                              s.productsLabel,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: _kText,
                              ),
                            ),
                            const Spacer(),
                            if (hasActiveFilters)
                              GestureDetector(
                                onTap: () => itemProvider.clearTags(),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _kPurpleFaint,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: _kPurpleBorder),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.filter_list_rounded,
                                        size: 14,
                                        color: _kPurple,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${itemProvider.selectedTags.length}',
                                        style: const TextStyle(
                                          color: _kPurple,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(
                                        Icons.close_rounded,
                                        size: 12,
                                        color: _kPurple,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
          ),

          // ── Product Grid ─────────────────────────────────────────────────
          if (!itemProvider.isLoading && itemProvider.error == null)
            itemProvider.filteredItems.isEmpty
                ? SliverToBoxAdapter(child: _EmptyState(s: s))
                : SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate((ctx, i) {
                        final item = itemProvider.filteredItems[i];
                        return _ProductCard(
                          item: item,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductDetailScreen(item: item),
                            ),
                          ),
                        );
                      }, childCount: itemProvider.filteredItems.length),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.72,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                          ),
                    ),
                  ),
        ],
      ),
    );
  }
}

// ── Location Bar ──────────────────────────────────────────────────────────────

class _LocationBar extends StatelessWidget {
  final dynamic s;
  final String locationText;
  const _LocationBar({required this.s, required this.locationText});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          s.locationLabel,
          style: const TextStyle(
            fontSize: 11,
            color: _kSubText,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            const Icon(Icons.location_on_rounded, size: 14, color: _kPurple),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                locationText.isEmpty ? s.noLocation : locationText,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: _kText,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 16,
              color: _kSubText,
            ),
          ],
        ),
      ],
    );
  }
}

// ── Search Bar ────────────────────────────────────────────────────────────────

class _SearchBar extends StatefulWidget {
  final ItemProvider itemProvider;
  final String hint;

  const _SearchBar({required this.itemProvider, required this.hint});

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
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

  void _submitSearch() {
    if (_controller.text.trim().isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              SearchResultsScreen(initialQuery: _controller.text.trim()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: _kPurpleFaint,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _kPurpleBorder, width: 1),
            ),
            child: TextField(
              controller: _controller,
              style: const TextStyle(fontSize: 14, color: _kText),
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _submitSearch(),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: const TextStyle(color: _kSubText, fontSize: 14),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 16,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.search_rounded,
                    color: _kPurpleLight,
                    size: 20,
                  ),
                  onPressed: _submitSearch,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Banner Carousel ───────────────────────────────────────────────────────────

class _BannerCarousel extends StatelessWidget {
  final PageController ctrl;
  final int currentPage;
  final dynamic s;
  final ValueChanged<int> onPageChanged;

  const _BannerCarousel({
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
            itemCount: _banners.length,
            onPageChanged: onPageChanged,
            itemBuilder: (ctx, i) {
              final banner = _banners[i];
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
                  padding: const EdgeInsets.fromLTRB(24, 20, 20, 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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
                                color: _kText.withValues(alpha: 0.65),
                                fontSize: 12,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 14),
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
                      Icon(
                        Icons.local_offer_rounded,
                        size: 80,
                        color: banner.accentColor.withValues(alpha: 0.15),
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
          children: List.generate(_banners.length, (i) {
            final isActive = i == currentPage;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: isActive ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: isActive ? _kPurple : _kPurpleBorder,
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }
}

// ── Category Section ──────────────────────────────────────────────────────────

class _CategorySection extends StatelessWidget {
  final dynamic s;
  const _CategorySection({required this.s});

  @override
  Widget build(BuildContext context) {
    final isThai = context.watch<AppLocaleProvider>().isThai;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                s.categoryLabel,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: _kText,
                ),
              ),
              const Spacer(),
              Text(
                s.seeAll,
                style: const TextStyle(
                  fontSize: 13,
                  color: _kPurple,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: _categories.length,
            itemBuilder: (ctx, i) {
              final cat = _categories[i];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Column(
                  children: [
                    Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        color: _kPurpleFaint,
                        shape: BoxShape.circle,
                        border: Border.all(color: _kPurpleBorder, width: 1.5),
                      ),
                      child: Icon(cat.icon, color: _kPurple, size: 32),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isThai ? cat.thLabel : cat.enLabel,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _kText,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ── Product Card ──────────────────────────────────────────────────────────────

class _ProductCard extends StatefulWidget {
  final ItemModel item;
  final VoidCallback onTap;
  const _ProductCard({required this.item, required this.onTap});

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _heartCtrl;
  final List<_HeartParticle> _particles = [];
  bool _animating = false;

  @override
  void initState() {
    super.initState();
    _heartCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _heartCtrl.addStatusListener((s) {
      if (s == AnimationStatus.completed) {
        _heartCtrl.reset();
        if (mounted) {
          setState(() {
            _particles.clear();
            _animating = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _heartCtrl.dispose();
    super.dispose();
  }

  void _onHeartTap() {
    final fav = context.read<FavoritesProvider>();
    final wasFav = fav.isFavorite(widget.item.id);
    fav.toggleFavorite(widget.item);

    if (!wasFav) {
      setState(() {
        _animating = true;
        _particles.clear();
        for (int i = 0; i < 7; i++) {
          _particles.add(_HeartParticle(index: i, total: 7));
        }
      });
      _heartCtrl.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFav = context.watch<FavoritesProvider>().isFavorite(widget.item.id);
    final s = context.watch<AppLocaleProvider>().strings;

    return GestureDetector(
      onTap: widget.onTap,
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
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      widget.item.imageUrl,
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
                    if (widget.item.tags.isNotEmpty)
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
                            s.tagLabel(widget.item.tags.first),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    // Heart button
                    Positioned(
                      top: 8,
                      right: 8,
                      child: SizedBox(
                        width: 60,
                        height: 60,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            if (_animating)
                              ..._particles.map(
                                (p) => AnimatedBuilder(
                                  animation: _heartCtrl,
                                  builder: (_, __) {
                                    final t = _heartCtrl.value;
                                    return Positioned(
                                      left: 30 + p.dx * t * 22,
                                      top: 30 + p.dy * t * 22,
                                      child: Opacity(
                                        opacity: (1 - t).clamp(0.0, 1.0),
                                        child: Transform.scale(
                                          scale: (1 - t * 0.6),
                                          child: const Icon(
                                            Icons.favorite,
                                            size: 9,
                                            color: _kPurple,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            GestureDetector(
                              onTap: _onHeartTap,
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
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 250),
                                  transitionBuilder: (child, anim) =>
                                      ScaleTransition(
                                        scale: anim,
                                        child: child,
                                      ),
                                  child: Icon(
                                    isFav
                                        ? Icons.favorite_rounded
                                        : Icons.favorite_border_rounded,
                                    key: ValueKey(isFav),
                                    size: 16,
                                    color: isFav ? _kPurple : Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.item.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: _kText,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '฿${widget.item.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: _kPurple,
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
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

class _HeartParticle {
  final double dx;
  final double dy;
  _HeartParticle({required int index, required int total})
    : dx = _cos(index / total),
      dy = _sin(index / total);

  static double _cos(double t) {
    const List<double> vals = [
      1.0,
      0.623,
      -0.223,
      -0.901,
      -0.623,
      0.223,
      0.901,
    ];
    return vals[t ~/ (1 / 7) % 7];
  }

  static double _sin(double t) {
    const List<double> vals = [
      0.0,
      0.781,
      0.975,
      0.434,
      -0.434,
      -0.975,
      -0.781,
    ];
    return vals[t ~/ (1 / 7) % 7];
  }
}

// ── Empty / Error States ──────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final dynamic s;
  const _EmptyState({required this.s});

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
              color: _kPurpleBorder,
            ),
            const SizedBox(height: 16),
            Text(
              s.noProducts,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: _kPurpleLight,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              s.tryOtherSearch,
              style: const TextStyle(fontSize: 14, color: _kSubText),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String msg;
  const _ErrorState({required this.msg});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              size: 64,
              color: _kPurpleBorder,
            ),
            const SizedBox(height: 16),
            Text(
              msg,
              textAlign: TextAlign.center,
              style: const TextStyle(color: _kSubText, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
