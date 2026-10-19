import 'package:flutter/material.dart';
import '../models/book.dart';
import 'home_screen.dart';
import 'book_form_screen.dart';
import 'book_grid_screen.dart';
import 'book_detail_dialog.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  // Pre-populated sample book collection
  final List<Book> _books = [
    Book(
      id: '1',
      title: 'Clean Code',
      author: 'Robert C. Martin',
      price: 34.99,
      category: 'Technology',
      description: 'A handbook of agile software craftsmanship for writing better and maintainable code.',
    ),
    Book(
      id: '2',
      title: 'The Great Gatsby',
      author: 'F. Scott Fitzgerald',
      price: 14.99,
      category: 'Fiction',
      description: 'A classic story of jazz age ambition, tragic romance, and the American dream.',
    ),
    Book(
      id: '3',
      title: '1984',
      author: 'George Orwell',
      price: 12.50,
      category: 'Fiction',
      description: 'A dystopian social science fiction novel and cautionary tale about totalitarianism.',
    ),
    Book(
      id: '4',
      title: 'Sapiens',
      author: 'Yuval Noah Harari',
      price: 22.00,
      category: 'History',
      description: 'A brief history of humankind exploring human evolutionary history.',
    ),
  ];

  void _addBook(Book book) {
    setState(() {
      _books.add(book);
    });
  }

  void _deleteBook(String bookId) {
    setState(() {
      _books.removeWhere((b) => b.id == bookId);
    });
  }

  void _showBookDetails(Book book) {
    BookDetailDialog.show(context, book, _deleteBook);
  }

  void _navigateToTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(
        books: _books,
        onNavigateTab: _navigateToTab,
        onBookSelected: _showBookDetails,
      ),
      BookFormScreen(
        onSaveBook: _addBook,
        onBookSavedSuccess: () => _navigateToTab(2), // go to GridView
      ),
      BookGridScreen(
        books: _books,
        onBookSelected: _showBookDetails,
        onDeleteBook: _deleteBook,
      ),
    ];

    final List<String> titles = [
      'Book Manager - Home',
      'Add New Book',
      'Book Collection Grid',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          titles[_currentIndex],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 2,
        actions: [
          if (_currentIndex == 2)
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Add Book',
              onPressed: () => _navigateToTab(1),
            ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: screens[_currentIndex],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline),
            selectedIcon: Icon(Icons.add_circle),
            label: 'Book Form',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view),
            label: 'Book Grid',
          ),
        ],
      ),
    );
  }
}
