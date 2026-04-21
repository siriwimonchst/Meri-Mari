// lib/features/favorite_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/app_locale_provider.dart';
import '../providers/cart_provider.dart';
import '../models/item_model.dart';
import '../widgets/product_card.dart';
import '../core/app_theme.dart';
import 'product_detail.dart';
import 'cart_screen.dart';
import '../providers/orders_provider.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  bool _isEditMode = false;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _selectedIds = {};
  Set<String> _selectedTags = {};
  String? _selectedStatus; // 'available', 'sold', or null

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) _searchController.clear();
    });
  }

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
      _selectedIds.clear();
    });
  }

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _setSelectedTags(Set<String> tags) {
    setState(() {
      _selectedTags = tags;
    });
  }

  void _setSelectedStatus(String? status) {
    setState(() {
      _selectedStatus = status;
    });
  }

  Future<void> _handleRemoveSelected(FavoritesProvider fav) async {
    if (_selectedIds.isEmpty) return;
    await fav.removeMultiple(_selectedIds.toList());
    setState(() {
      _selectedIds.clear();
      _isEditMode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final fav = context.watch<FavoritesProvider>();
    final cartProvider = context.watch<CartProvider>();
    final ordersProvider = context.watch<OrdersProvider>();
    final locale = context.watch<AppLocaleProvider>();
    final s = locale.strings;
    final items = fav.favoriteItems;
    final canPop = Navigator.of(context).canPop();

    // Filter items locally based on tags, status, AND search search query
    final filteredItems = items.where((ItemModel item) {
      // Search filter
      final query = _searchController.text.toLowerCase();
      final matchSearch = query.isEmpty || item.name.toLowerCase().contains(query);
      
      // Tag filter
      final matchTags = _selectedTags.isEmpty || 
          item.tags.any((t) => _selectedTags.contains(s.normalizeTag(t)));
      
      // Status filter
      bool matchStatus = true;
      final isUnavailable = item.isSold || ordersProvider.isOrdered(item.id);
      if (_selectedStatus == 'available') matchStatus = !isUnavailable;
      if (_selectedStatus == 'sold') matchStatus = isUnavailable;
      
      return matchSearch && matchTags && matchStatus;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        toolbarHeight: 60,
        centerTitle: false,
        titleSpacing: _isSearching ? 0 : (canPop ? 0 : 20),
        leading: _isSearching || canPop
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: kText, size: 20),
                    onPressed: _isSearching ? _toggleSearch : () => Navigator.pop(context),
                  ),
                ),
              )
            : null,
        title: _isSearching
            ? Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(fontSize: 15, color: kText),
                  cursorColor: kPurple,
                  decoration: InputDecoration(
                    hintText: s.searchHint,
                    hintStyle: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.w400),
                    prefixIcon: const Icon(Icons.search_rounded, color: kPurple, size: 20),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              )
            : Text(
                s.myFavorites,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: kText),
              ),
        actions: [
          if (_isSearching)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: TextButton(
                onPressed: _toggleSearch,
                child: Text(
                  locale.isThai ? 'ยกเลิก' : 'Cancel',
                  style: const TextStyle(color: kPurple, fontWeight: FontWeight.w700, fontSize: 16),
                ),
              ),
            )
          else ...[
            _AppBarIcon(
              icon: Icons.search_rounded,
              onTap: _toggleSearch,
            ),
            const SizedBox(width: 8),
            _AppBarIcon(
              icon: Icons.shopping_bag_outlined,
              badgeCount: cartProvider.totalCount,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              ),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: _toggleEditMode,
              child: Text(
                _isEditMode ? s.done : s.edit,
                style: const TextStyle(color: kPurple, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const SizedBox(width: 12),
          ],
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Filter Bar ────────────────────────────────────────────────────
          const SizedBox(height: 8),
          _buildFilterBar(context, s, locale.isThai),
          const SizedBox(height: 12),

          Expanded(
            child: Stack(
              children: [
                filteredItems.isEmpty
                    ? _EmptyFavorites(s: s, isFiltered: _selectedTags.isNotEmpty || _selectedStatus != null)
                    : GridView.builder(
                        padding: EdgeInsets.fromLTRB(16, 8, 16, _isEditMode ? 120 : 100),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.68,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: filteredItems.length,
                        itemBuilder: (ctx, i) {
                          final item = filteredItems[i];
                          return MeriMariProductCard(
                            item: item,
                            isEditMode: _isEditMode,
                            isSelected: _selectedIds.contains(item.id),
                            onSelectToggle: () => _toggleSelection(item.id),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProductDetailScreen(item: item),
                              ),
                            ),
                          );
                        },
                      ),
                if (_isEditMode)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: _BottomEditBar(
                      s: s,
                      selectedCount: _selectedIds.length,
                      totalCount: items.length,
                      onRemove: () => _handleRemoveSelected(fav),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Filter Bar UI ─────────────────────────────────────────────────────────

  Widget _buildFilterBar(BuildContext context, dynamic s, bool isThai) {
    final allLabel = isThai ? 'ทั้งหมด' : 'All';
    final statusLabel = isThai ? 'สถานะ' : 'Status';
    final categoryLabel = isThai ? 'หมวดหมู่' : 'Category';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // "All" Chip
          Expanded(
            child: _FilterChip(
              label: allLabel,
              selected: _selectedTags.isEmpty && _selectedStatus == null,
              showCheck: true,
              onTap: () {
                _setSelectedTags({});
                _setSelectedStatus(null);
              },
            ),
          ),
          const SizedBox(width: 8),
          // "Status" Chip
          Expanded(
            child: _FilterChip(
              label: _selectedStatus == 'available'
                  ? (isThai ? 'ซื้อได้' : 'Available')
                  : _selectedStatus == 'sold'
                      ? (isThai ? 'ของหมด' : 'Sold Out')
                      : statusLabel,
              selected: _selectedStatus != null,
              showArrow: true,
              onTap: () => _showStatusPicker(context, s, isThai),
            ),
          ),
          const SizedBox(width: 8),
          // "Category" Chip
          Expanded(
            child: _FilterChip(
              label: _selectedTags.isEmpty
                  ? categoryLabel
                  : '${_selectedTags.length} $categoryLabel',
              selected: _selectedTags.isNotEmpty,
              showArrow: true,
              onTap: () => _showCategoryPicker(context, s),
            ),
          ),
        ],
      ),
    );
  }

  void _showStatusPicker(BuildContext context, dynamic s, bool isThai) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(4)),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              isThai ? 'เลือกสถานะสินค้า' : 'Select Status',
              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900, color: kText),
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(isThai ? 'สามารถซื้อได้' : 'Available', style: TextStyle(
                fontWeight: _selectedStatus == 'available' ? FontWeight.w800 : FontWeight.w500,
                color: _selectedStatus == 'available' ? kPurple : kText,
              )),
              trailing: _selectedStatus == 'available' ? const Icon(Icons.check_rounded, color: kPurple) : null,
              onTap: () {
                _setSelectedStatus('available');
                Navigator.pop(ctx);
              },
            ),
            Divider(color: Colors.grey.shade100, height: 1),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(isThai ? 'ไม่สามารถซื้อได้ (ของหมด)' : 'Sold Out', style: TextStyle(
                fontWeight: _selectedStatus == 'sold' ? FontWeight.w800 : FontWeight.w500,
                color: _selectedStatus == 'sold' ? kPurple : kText,
              )),
              trailing: _selectedStatus == 'sold' ? const Icon(Icons.check_rounded, color: kPurple) : null,
              onTap: () {
                _setSelectedStatus('sold');
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCategoryPicker(BuildContext context, dynamic s) {
    Set<String> tempTags = {..._selectedTags};

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    s.filterTitle ?? 'Filter',
                    style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900, color: kText),
                  ),
                  TextButton(
                    onPressed: () => setModalState(() => tempTags = {}),
                    child: Text(
                      s.clearFilter ?? 'Clear',
                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: (s.predefinedTags as List).map((tagMap) {
                  final key = tagMap['key']!;
                  final label = tagMap['label']!;
                  final isSelected = tempTags.contains(key);
                  return GestureDetector(
                    onTap: () {
                      setModalState(() {
                        if (isSelected) {
                          tempTags = {...tempTags}..remove(key);
                        } else {
                          tempTags = {...tempTags, key};
                        }
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? kPurple : kPurpleFaint,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: isSelected ? kPurple : kPurpleBorder,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isSelected)
                            const Padding(
                              padding: EdgeInsets.only(right: 6),
                              child: Icon(Icons.check_rounded, size: 14, color: Colors.white),
                            ),
                          Text(
                            label,
                            style: TextStyle(
                              color: isSelected ? Colors.white : kPurple,
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
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _setSelectedTags(tempTags);
                    Navigator.pop(ctx);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(s.applyFilter ?? 'Apply', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Custom Filter Chip Widget ──────────────────────────────────────────────

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final bool showCheck;
  final bool showArrow;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    this.showCheck = false,
    this.showArrow = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? kPurple : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? kPurple : Colors.grey.shade300,
            width: 1.5,
          ),
          boxShadow: selected ? [
            BoxShadow(
              color: kPurple.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ] : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showCheck && selected)
              const Padding(
                padding: EdgeInsets.only(right: 4),
                child: Icon(Icons.check_rounded, color: Colors.white, size: 14),
              ),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  color: selected ? Colors.white : kText.withOpacity(0.8),
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                  fontSize: 13,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (showArrow)
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: selected ? Colors.white : Colors.grey.shade600,
                  size: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── AppBar Icon Helper ──────────────────────────────────────────────────────

class _AppBarIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final int badgeCount;
  const _AppBarIcon({required this.icon, required this.onTap, this.badgeCount = 0});

  @override
  Widget build(BuildContext context) {
    return Stack(
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
            icon: Icon(icon, color: kPurple, size: 20),
            onPressed: onTap,
          ),
        ),
        if (badgeCount > 0)
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
                  '$badgeCount',
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
    );
  }
}

// ── Bottom Edit Bar ──────────────────────────────────────────────────────────

class _BottomEditBar extends StatelessWidget {
  final dynamic s;
  final int selectedCount;
  final int totalCount;
  final VoidCallback onRemove;

  const _BottomEditBar({
    required this.s,
    required this.selectedCount,
    required this.totalCount,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, -2),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${s.selectedCount} $selectedCount/$totalCount',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: kText),
          ),
          ElevatedButton(
            onPressed: selectedCount > 0 ? onRemove : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: kPurple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(s.unfavoriteSelected, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

// ── Empty Favorites ───────────────────────────────────────────────────────────

class _EmptyFavorites extends StatelessWidget {
  final dynamic s;
  final bool isFiltered;
  const _EmptyFavorites({required this.s, this.isFiltered = false});

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
              color: kPurpleFaint,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isFiltered ? Icons.search_off_rounded : Icons.favorite_border_rounded,
              size: 48,
              color: kPurpleLight,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            isFiltered ? (s.noProducts ?? 'No products found') : s.noFavorites,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: kText,
            ),
          ),
        ],
      ),
    );
  }
}

