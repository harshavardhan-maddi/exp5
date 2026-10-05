import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CatalogModel(),
      child: const MyApp(),
    ),
  );
}

class Item {
  final int id;
  final String name;
  bool isFavorite;

  Item({
    required this.id,
    required this.name,
    this.isFavorite = false,
  });
}

class CatalogModel extends ChangeNotifier {
  final List<Item> _items = [
    Item(id: 1, name: 'Laptop'),
    Item(id: 2, name: 'Smartphone'),
    Item(id: 3, name: 'Headphones'),
    Item(id: 4, name: 'Smart Watch'),
    Item(id: 5, name: 'Camera'),
    Item(id: 6, name: 'Tablet'),
    Item(id: 7, name: 'Keyboard'),
    Item(id: 8, name: 'Mouse'),
    Item(id: 9, name: 'Speaker'),
  ];

  List<Item> get items => _items;

  int get favoriteCount =>
      _items.where((item) => item.isFavorite).length;

  void toggleFavorite(int id) {
    final item = _items.firstWhere((item) => item.id == id);
    item.isFavorite = !item.isFavorite;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Responsive State Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final catalog = context.watch<CatalogModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Catalog'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                const Icon(Icons.favorite),
                const SizedBox(width: 5),
                Text(
                  '${catalog.favoriteCount}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 1024) {
            return const DesktopLayout();
          } else if (constraints.maxWidth >= 600) {
            return const TabletLayout();
          } else {
            return const MobileLayout();
          }
        },
      ),
    );
  }
}

// ---------------------------------------------------------
// MOBILE LAYOUT
// ---------------------------------------------------------

class MobileLayout extends StatelessWidget {
  const MobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final catalog = context.watch<CatalogModel>();

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: catalog.items.length,
      itemBuilder: (context, index) {
        return ItemCard(item: catalog.items[index]);
      },
    );
  }
}

// ---------------------------------------------------------
// TABLET LAYOUT
// ---------------------------------------------------------

class TabletLayout extends StatelessWidget {
  const TabletLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final catalog = context.watch<CatalogModel>();

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: catalog.items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 1.4,
      ),
      itemBuilder: (context, index) {
        return ItemCard(item: catalog.items[index]);
      },
    );
  }
}

// ---------------------------------------------------------
// DESKTOP LAYOUT
// ---------------------------------------------------------

class DesktopLayout extends StatelessWidget {
  const DesktopLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final catalog = context.watch<CatalogModel>();

    return Row(
      children: [
        NavigationRail(
          selectedIndex: 0,
          labelType: NavigationRailLabelType.all,
          destinations: const [
            NavigationRailDestination(
              icon: Icon(Icons.home),
              label: Text('Home'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.favorite),
              label: Text('Favorites'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.settings),
              label: Text('Settings'),
            ),
          ],
        ),

        const VerticalDivider(width: 1),

        Expanded(
          child: Column(
            children: [
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: catalog.items.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 1.4,
                  ),
                  itemBuilder: (context, index) {
                    return ItemCard(
                      item: catalog.items[index],
                    );
                  },
                ),
              ),

              const CounterWidget(),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------
// ITEM CARD
// ---------------------------------------------------------

class ItemCard extends StatelessWidget {
  final Item item;

  const ItemCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag,
              size: 55,
              color: Colors.blue,
            ),
            const SizedBox(height: 10),
            Text(
              item.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            IconButton(
              iconSize: 32,
              icon: Icon(
                item.isFavorite
                    ? Icons.star
                    : Icons.star_border,
                color: item.isFavorite
                    ? Colors.amber
                    : Colors.grey,
              ),
              onPressed: () {
                Provider.of<CatalogModel>(
                  context,
                  listen: false,
                ).toggleFavorite(item.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// LOCAL STATE - DESKTOP ONLY
// ---------------------------------------------------------

class CounterWidget extends StatefulWidget {
  const CounterWidget({super.key});

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _counter = 0;

  void _increment() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      color: Colors.grey.shade200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Local Counter: ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '$_counter',
            style: const TextStyle(
              fontSize: 20,
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 15),
          ElevatedButton(
            onPressed: _increment,
            child: const Text('Increment'),
          ),
        ],
      ),
    );
  }
}