import 'package:flutter/material.dart';

void main() => runApp(WishAllApp());

class WishAllApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WISHALL',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [HomePage(), SearchPage(), CartPage()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
        ],
      ),
    );
  }
}

class CartModel extends ChangeNotifier {
  final List<Map<String, String>> _items = [];

  List<Map<String, String>> get items => _items;

  void addItem(Map<String, String> item) {
    _items.add(item);
    notifyListeners();
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

final CartModel cartModel = CartModel();

class HomePage extends StatelessWidget {
  final List<Map<String, String>> products = [
    {
      'name': 'Wireless Headphones',
      'image': 'https://images.pexels.com/photos/3394664/pexels-photo-3394664.jpeg'
    },
    {
      'name': 'Smart Watch',
      'image': 'https://images.pexels.com/photos/2774061/pexels-photo-2774061.jpeg'
    },
    {
      'name': 'Laptop Bag',
      'image': 'https://images.pexels.com/photos/19090/pexels-photo.jpg'
    },
    {
      'name': 'Sneakers',
      'image': 'https://images.pexels.com/photos/2529148/pexels-photo-2529148.jpeg'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WISHALL'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            return ProductCard(
              name: products[index]['name']!,
              imageUrl: products[index]['image']!,
            );
          },
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String name;
  final String imageUrl;

  ProductCard({required this.name, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(name: name, imageUrl: imageUrl),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                name,
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductDetailPage extends StatelessWidget {
  final String name;
  final String imageUrl;

  ProductDetailPage({required this.name, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(imageUrl),
            SizedBox(height: 20),
            Text(
              name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  cartModel.addItem({'name': name, 'image': imageUrl});
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$name added to cart')),
                  );
                },
                child: Text('Add to Cart'),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> allProducts = [
    {
      'name': 'Wireless Headphones',
      'image': 'https://images.pexels.com/photos/3394664/pexels-photo-3394664.jpeg'
    },
    {
      'name': 'Smart Watch',
      'image': 'https://images.pexels.com/photos/2774061/pexels-photo-2774061.jpeg'
    },
    {
      'name': 'Laptop Bag',
      'image': 'https://images.pexels.com/photos/19090/pexels-photo.jpg'
    },
    {
      'name': 'Sneakers',
      'image': 'https://images.pexels.com/photos/2529148/pexels-photo-2529148.jpeg'
    },
  ];

  List<Map<String, String>> filteredProducts = [];

  void _searchProducts(String query) {
    setState(() {
      filteredProducts = allProducts
          .where((product) => product['name']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search Products')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Search here...',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => _searchProducts(_controller.text),
                ),
              ),
              onChanged: _searchProducts,
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return ListTile(
                    leading: Image.network(product['image']!, width: 50, height: 50, fit: BoxFit.cover),
                    title: Text(product['name']!),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailPage(
                            name: product['name']!,
                            imageUrl: product['image']!,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    final items = cartModel.items;

    return Scaffold(
      appBar: AppBar(title: Text('Your Cart')),
      body: items.isEmpty
          ? Center(child: Text('Cart is empty', style: TextStyle(fontSize: 20)))
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  leading: Image.network(item['image']!, width: 50, height: 50, fit: BoxFit.cover),
                  title: Text(item['name']!),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        cartModel.removeItem(index);
                      });
                    },
                  ),
                );
              },
            ),
    );
  }
}
