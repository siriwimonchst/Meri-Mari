//โครงสร้างข้อมูลสินค้า
class ItemModel {
  final String id;
  final String name;
  final String collection;
  final double price;
  final String imageUrl;
  final String condition;
  final double shippingCost;
  
  ItemModel({
    required this.id,
    required this.name,
    required this.collection,
    required this.price,
    required this.imageUrl,
    required this.condition,
    required this.shippingCost,
  });
}

List<ItemModel> mockItems = [
  ItemModel(
    id: '1',
    name: 'Hirono V.1',
    collection: 'The Other One',
    price: 450.0,
    condition: 'Check Card',
    shippingCost: 40.0,
    imageUrl: 'https://down-th.img.susercontent.com/file/th-11134207-7r98z-lnsx1l54m2wg7c', 
  ),
  ItemModel(
    id: '2',
    name: 'Labubu Macaron',
    collection: 'The Monsters',
    price: 890.0,
    condition: 'MISB',
    shippingCost: 50.0,
    imageUrl: 'https://image.makewebeasy.net/makeweb/m_1920x0/c3teAI7nw/DefaultData/th_11134207_7r98o_lqlvjee0d89m76.jpg?v=202405291424',
  ),
];