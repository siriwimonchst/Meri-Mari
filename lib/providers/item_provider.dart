//จัดการข้อมูลสินค้าและการ Filter
import 'package:flutter/material.dart';
import '../models/item_model.dart';

class ItemProvider with ChangeNotifier {
  List<ItemModel> _items = [
    // ข้อมูลจำลอง (Mock Data)
    ItemModel(id: '1', name: 'Hirono V1 - Fox', collection: 'The Other One', condition: 'Check Card', price: 350, shippingCost: 40, imageUrl: 'https://down-th.img.susercontent.com/file/th-11134207-7r98z-lnsx1l54m2wg7c'),
    ItemModel(id: '2', name: 'Crybaby Bunny', collection: 'Powerpuff', condition: 'MISB', price: 590, shippingCost: 50, imageUrl: 'https://image.makewebeasy.net/makeweb/m_1920x0/c3teAI7nw/DefaultData/th_11134207_7r98o_lqlvjee0d89m76.jpg?v=202405291424'),
  ];

  String _searchQuery = '';
  String _selectedCondition = 'All';

  List<ItemModel> get filteredItems {
    return _items.where((item) {
      bool matchSearch = item.name.toLowerCase().contains(_searchQuery.toLowerCase());
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