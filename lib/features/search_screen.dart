import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/item_provider.dart';
import '../providers/app_locale_provider.dart';
import '../core/app_theme.dart';
import '../widgets/product_card.dart';
import 'search_results_screen.dart';
import 'product_detail.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  
  List<String> _recommendedKeywords = [];
  List<dynamic> _recommendedItems = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generateRecommendations();
      _focusNode.requestFocus();
    });
  }

  void _generateRecommendations() {
    final itemProvider = context.read<ItemProvider>();
    final allItems = itemProvider.allItems;
    
    if (allItems.isEmpty) return;

    final random = Random();
    
    // 1. Generate unique random keywords (from names and collections)
    Set<String> keywords = {};
    for (var item in allItems) {
      String coll = item.collection.trim();
      if (coll.toLowerCase() == 'pop' || coll.toLowerCase() == 'popmart') {
        keywords.add('Pop Mart');
      } else {
        keywords.add(coll);
      }
      
      // Handle names
      final name = item.name.toLowerCase();
      if (name.contains('pop mart') || name.contains('popmart')) {
        keywords.add('Pop Mart');
      }

      // Split name and take first significant word
      final parts = item.name.split(' ');
      if (parts.isNotEmpty) {
        String first = parts[0];
        if (first.length > 2) {
          if (first.toLowerCase() == 'pop') {
             keywords.add('Pop Mart');
          } else {
             keywords.add(first);
          }
        }
      }
    }
    
    // Cleanup and remove fragments that are too generic
    keywords.removeWhere((k) => k.toLowerCase() == 'pop');
    
    var keywordList = keywords.toList();
    keywordList.shuffle(random);
    
    // 2. Select random items
    var itemList = [...allItems];
    itemList.shuffle(random);

    setState(() {
      _recommendedKeywords = keywordList.take(6).toList();
      _recommendedItems = itemList.take(4).toList();
    });
  }

  void _submitSearch(String query) {
    if (query.trim().isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SearchResultsScreen(initialQuery: query.trim()),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppLocaleProvider>().strings;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: kPurpleFaint,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kPurpleBorder.withValues(alpha: 0.5)),
            ),
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              onSubmitted: _submitSearch,
              textInputAction: TextInputAction.search,
              style: const TextStyle(fontSize: 15, color: kText),
              decoration: InputDecoration(
                hintText: s.searchHint,
                hintStyle: TextStyle(color: kSubText.withValues(alpha: 0.7), fontSize: 14),
                prefixIcon: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: kPurple, size: 20),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                suffixIcon: const Icon(Icons.search_rounded, color: kPurple, size: 22),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recommended Keywords Section
            if (_recommendedKeywords.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  s.recommendedKeywords,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: kText,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _recommendedKeywords.map((kw) {
                    return GestureDetector(
                      onTap: () => _submitSearch(kw),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: kPurpleFaint,
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: kPurpleBorder),
                        ),
                        child: Text(
                          kw,
                          style: const TextStyle(
                            fontSize: 13,
                            color: kPurple,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 32),
            ],

            // Recommended Products Grid
            if (_recommendedItems.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  s.searchRecommendationTitle, // Or do you want to search for this?
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: kText,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.7,
                ),
                itemCount: _recommendedItems.length,
                itemBuilder: (ctx, i) {
                  final item = _recommendedItems[i];
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
            ],
          ],
        ),
      ),
    );
  }
}
