// lib/features/home.dart
// ─── Screen-level logic only ───────────────────────────────────────────────────
// Sub-widgets live in lib/widgets/home_widgets.dart — do NOT add new widget
// classes here.  Keep this file focused on: state (banner timer, filter sheet),
// and the Scaffold / SliverAppBar composition.
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/item_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/app_locale_provider.dart';
import '../providers/address_provider.dart';
import '../providers/notifications_provider.dart';
import '../core/app_theme.dart';
import '../widgets/home_widgets.dart';
import '../widgets/product_card.dart';
import 'product_detail.dart';
import 'cart_screen.dart';
import 'notifications_screen.dart';

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
        final next = (_bannerPage + 1) % homeBanners.length;
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
                        color: kPurpleBorder,
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
                          color: kText,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => setModalState(() => tempTags = {}),
                        child: Text(
                          s.clearFilter,
                          style: const TextStyle(
                            color: Colors.black,
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
                            color: selected ? kPurple : kPurpleFaint,
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                              color: selected ? kPurple : kPurpleBorder,
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
                                  color: selected ? Colors.white : kPurple,
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
                        backgroundColor: kPurple,
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

  void _showAddressManager(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const HomeAddressSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final itemProvider = context.watch<ItemProvider>();
    final cartProvider = context.watch<CartProvider>();
    final locale = context.watch<AppLocaleProvider>();
    final addressProvider = context.watch<AddressProvider>();
    final notificationsProvider = context.watch<NotificationsProvider>();
    final s = locale.strings;
    final hasActiveFilters = itemProvider.selectedTags.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPurple,
        foregroundColor: Colors.white,
        onPressed: () => _showFilterSheet(context),
        tooltip: 'Filter',
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(Icons.filter_list_rounded, size: 22),
            if (hasActiveFilters)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
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
            title: HomeLocationBar(
              s: s,
              locationText: addressProvider.locationSummary,
              onTap: () => _showAddressManager(context),
            ),
            actions: [
              // Notification bell
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: kPurpleFaint,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.notifications_none_rounded,
                          color: kPurple,
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
                    if (notificationsProvider.unreadCount > 0)
                      Positioned(
                        top: -4,
                        right: -4,
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: const BoxDecoration(
                            color: kPurple,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${notificationsProvider.unreadCount}',
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
                        color: kPurpleFaint,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.shopping_bag_outlined,
                          color: kPurple,
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
                            color: kPurple,
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
                child: HomeSearchBar(
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
                      child: CircularProgressIndicator(color: kPurple),
                    ),
                  )
                : itemProvider.error != null
                ? SizedBox(
                    height: 300,
                    child: HomeErrorState(msg: itemProvider.error!),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      // Banner carousel
                      HomeBannerCarousel(
                        ctrl: _bannerCtrl,
                        currentPage: _bannerPage,
                        s: s,
                        onPageChanged: (p) => setState(() => _bannerPage = p),
                      ),
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
                                color: kText,
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
                                    color: kPurpleFaint,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: kPurpleBorder),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.filter_list_rounded,
                                        size: 14,
                                        color: kPurple,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${itemProvider.selectedTags.length}',
                                        style: const TextStyle(
                                          color: kPurple,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(
                                        Icons.close_rounded,
                                        size: 12,
                                        color: kPurple,
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
                ? SliverToBoxAdapter(child: HomeEmptyState(s: s))
                : SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate((ctx, i) {
                        final item = itemProvider.filteredItems[i];
                        return MeriMariProductCard(
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
                            childAspectRatio: 0.68,
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
