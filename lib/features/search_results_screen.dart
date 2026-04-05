// lib/features/search_results_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/item_provider.dart';
import '../providers/app_locale_provider.dart';
import 'product_detail.dart';
import '../widgets/product_card.dart';
import '../core/app_theme.dart';

const _kPurple       = kPurple;
const _kPurpleLight  = kPurpleLight;
const _kPurpleFaint  = kPurpleFaint;
const _kPurpleBorder = kPurpleBorder;
const _kText         = kText;
const _kSubText      = Color(0xFF666666);

class SearchResultsScreen extends StatefulWidget {
  final String initialQuery;

  const SearchResultsScreen({super.key, required this.initialQuery});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
    // Ensure the ItemProvider has this initial query so it filters immediately.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ItemProvider>().setSearchQuery(widget.initialQuery);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submitSearch() {
    context.read<ItemProvider>().setSearchQuery(_controller.text);
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
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: _kText,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.tune_rounded, color: _kPurple),
                      const Spacer(),
                      if (tempTags.isNotEmpty)
                        TextButton(
                          onPressed: () {
                            setModalState(() {
                              tempTags.clear();
                            });
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red.shade400,
                            textStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          child: Text(s.clearFilter),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
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
    final s = context.watch<AppLocaleProvider>().strings;
    final hasActiveFilters = itemProvider.selectedTags.isNotEmpty;
    final items = itemProvider.filteredItems;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leadingWidth: 40,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: _kPurple, // Purple back icon
            size: 20,
          ),
          onPressed: () {
            // Unset query + tags when leaving so Home isn't filtered
            itemProvider.setSearchQuery('');
            itemProvider.clearTags();
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            Expanded(
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _kPurple, width: 1.5),
                ),
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(fontSize: 14, color: _kText),
                  textInputAction: TextInputAction.search,
                  onSubmitted: (_) => _submitSearch(),
                  decoration: InputDecoration(
                    hintText: s.searchHint,
                    hintStyle: const TextStyle(color: _kSubText, fontSize: 14),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _showFilterSheet(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                color: Colors.transparent,
                child: Row(
                  children: [
                    Icon(
                      Icons.filter_alt_outlined,
                      color: hasActiveFilters ? _kPurple : _kSubText,
                      size: 24,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      s.isThai ? 'ตัวกรอง' : 'Filters',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: hasActiveFilters ? _kPurple : _kSubText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: itemProvider.isLoading
          ? const Center(child: CircularProgressIndicator(color: _kPurple))
          : itemProvider.error != null
          ? Center(child: Text(itemProvider.error!))
          : items.isEmpty
          ? Center(
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
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.68,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return MeriMariProductCard(
                  item: item,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailScreen(item: item),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
