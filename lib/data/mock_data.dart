import '../models/product.dart';
import '../models/transaction_record.dart';

class MockData {
  static final List<Product> products = [
    const Product(
      id: 'p1',
      name: 'Nasi Goreng Spesial',
      category: 'Makanan',
      price: 22000,
      description: 'Nasi goreng dengan suwiran ayam, telur mata sapi, dan acar segar.',
      iconName: 'lunch_dining',
    ),
    const Product(
      id: 'p2',
      name: 'Ayam Bakar Madu',
      category: 'Makanan',
      price: 25000,
      description: 'Ayam bakar dengan bumbu kecap madu dan lalapan sambal terasi.',
      iconName: 'dinner_dining',
    ),
    const Product(
      id: 'p3',
      name: 'Mie Goreng Jawa',
      category: 'Makanan',
      price: 18000,
      description: 'Mie telur tumis bumbu tradisional dengan sayuran dan irisan bakso.',
      iconName: 'ramen_dining',
    ),
    const Product(
      id: 'p4',
      name: 'Soto Ayam Lamongan',
      category: 'Makanan',
      price: 20000,
      description: 'Soto ayam kuah kuning hangat dengan taburan koya gurih dan seledri.',
      iconName: 'soup_kitchen',
    ),
    const Product(
      id: 'p5',
      name: 'Es Teh Manis',
      category: 'Minuman',
      price: 5000,
      description: 'Teh melati seduh segar dengan gula pasir asli dan es batu.',
      iconName: 'local_drink',
    ),
    const Product(
      id: 'p6',
      name: 'Es Jeruk Peras',
      category: 'Minuman',
      price: 7000,
      description: 'Perasan jeruk asli murni manis dan menyegarkan.',
      iconName: 'local_bar',
    ),
    const Product(
      id: 'p7',
      name: 'Kopi Tubruk Robusta',
      category: 'Minuman',
      price: 6000,
      description: 'Seduhan biji kopi robusta pekat khas warung tradisional.',
      iconName: 'coffee',
    ),
    const Product(
      id: 'p8',
      name: 'Tahu Tempe Goreng',
      category: 'Camilan',
      price: 8000,
      description: 'Porsi tahu dan tempe goreng renyah disajikan dengan sambal kecap.',
      iconName: 'bakery_dining',
    ),
    const Product(
      id: 'p9',
      name: 'Kerupuk Putih Kaleng',
      category: 'Camilan',
      price: 2000,
      description: 'Kerupuk gurih renyah pendamping makan.',
      iconName: 'fastfood',
    ),
  ];

  static final List<TransactionRecord> transactions = [];
}
