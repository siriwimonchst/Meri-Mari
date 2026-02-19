//จัดการข้อมูลสินค้าและการ Filter
import 'package:flutter/material.dart';
import '../models/item_model.dart';

class ItemProvider with ChangeNotifier {
  List<Item> _items = [
    // ข้อมูลจำลอง (Mock Data)
    Item(id: '1', title: 'Hirono V1 - Fox', series: 'The Other One', condition: 'Check Card', price: 350, shippingCost: 40, imageUrl: 'https://via.placeholder.com/150'),
    Item(id: '2', title: 'Crybaby Bunny', series: 'Powerpuff', condition: 'MISB', price: 590, shippingCost: 50, imageUrl: 'https://via.placeholder.com/150'),
  ];

  String _searchQuery = '';
  String _selectedCondition = 'All';

  List<Item> get filteredItems {
    return _items.where((item) {
      bool matchSearch = item.title.toLowerCase().contains(_searchQuery.toLowerCase());
      bool matchCondition = _selectedCondition == 'All' || item.condition == _selectedCondition;
      return matchSearch && matchCondition;
    }).toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCondition(String condition) {
    _selectedCondition = condition;
    notifyListeners();
  }
}