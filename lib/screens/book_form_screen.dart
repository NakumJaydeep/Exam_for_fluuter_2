import 'package:flutter/material.dart';
import '../models/book.dart';

class BookFormScreen extends StatefulWidget {
  final Function(Book) onSaveBook;
  final VoidCallback onBookSavedSuccess;

  const BookFormScreen({
    super.key,
    required this.onSaveBook,
    required this.onBookSavedSuccess,
  });

  @override
  State<BookFormScreen> createState() => _BookFormScreenState();
}

class _BookFormScreenState extends State<BookFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _selectedCategory;

  final List<String> _categories = [
    'Fiction',
    'Non-Fiction',
    'Technology',
    'Science',
    'History',
    'Biography',
    'Fantasy',
    'Self-Help',
    'Other',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newBook = Book(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        author: _authorController.text.trim(),
        price: double.parse(_priceController.text.trim()),
        category: _selectedCategory ?? 'Other',
        description: _descriptionController.text.trim().isEmpty
            ? 'No description provided.'
            : _descriptionController.text.trim(),
      );

      widget.onSaveBook(newBook);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Book "${newBook.title}" saved successfully!'),
          backgroundColor: Colors.green,
          action: SnackBarAction(
            label: 'VIEW GRID',
            textColor: Colors.white,
            onPressed: widget.onBookSavedSuccess,
          ),
        ),
      );

      _resetForm();
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _titleController.clear();
    _authorController.clear();
    _priceController.clear();
    _descriptionController.clear();
    setState(() {
      _selectedCategory = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Form Header
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.add_circle,
                      size: 36,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Add New Book',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const Text(
                            'Enter details below to record a new book.',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Book Title
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Book Title *',
                hintText: 'e.g. Clean Code',
                prefixIcon: const Icon(Icons.book),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter the book title';
                }
                if (value.trim().length < 2) {
                  return 'Title must be at least 2 characters long';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Author Name
            TextFormField(
              controller: _authorController,
              decoration: InputDecoration(
                labelText: 'Author Name *',
                hintText: 'e.g. Robert C. Martin',
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter the author name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Price & Category Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Price Field
                Expanded(
                  child: TextFormField(
                    controller: _priceController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Price (\$) *',
                      hintText: 'e.g. 29.99',
                      prefixIcon: const Icon(Icons.attach_money),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter price';
                      }
                      final price = double.tryParse(value.trim());
                      if (price == null) {
                        return 'Invalid price';
                      }
                      if (price <= 0) {
                        return 'Price > 0';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),

                // Category Dropdown
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: InputDecoration(
                      labelText: 'Category *',
                      prefixIcon: const Icon(Icons.category),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    items: _categories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(
                          category,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Select category';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Description / Extra Details Field
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Book Description / Notes',
                hintText: 'e.g. Brief summary or synopsis of the book...',
                prefixIcon: const Icon(Icons.description),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Submit & Reset Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _resetForm,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: _submitForm,
                    icon: const Icon(Icons.save),
                    label: const Text(
                      'Save Book',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
