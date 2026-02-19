//โครงสร้างข้อมูลสินค้า
class ItemModel {
  final String id;
  final String name;
  final String collection;
  final double price;
  final String imageUrl;

  ItemModel({
    required this.id,
    required this.name,
    required this.collection,
    required this.price,
    required this.imageUrl,
  });
}

List<ItemModel> mockItems = [
  ItemModel(
    id: '1',
    name: 'Hirono V.1',
    collection: 'The Other One',
    price: 450.0,
    imageUrl: 'https://via.placeholder.com/150', 
  ),
  ItemModel(
    id: '2',
    name: 'Labubu Macaron',
    collection: 'The Monsters',
    price: 890.0,
    imageUrl: 'https://via.placeholder.com/150',
  ),
];