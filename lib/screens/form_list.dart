import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shimmer/shimmer.dart';
import '../widgets/bottombar.dart';

class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  bool isLoading = true;
  bool isAscending = true; // Flag to toggle between ascending and descending

  @override
  void initState() {
    super.initState();

    // Simulate loading state
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        // Check if the widget is still in the widget tree
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('formData');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Submitted Data'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              setState(() {
                isAscending = !isAscending; // Toggle sorting order
              });
            },
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box box, _) {
          List items = box.values.toList();

          if (isAscending) {
            items.sort((a, b) =>
                (a['title'] as String).compareTo(b['title'])); // Sort ascending
          } else {
            items.sort((b, a) => (a['title'] as String)
                .compareTo(b['title'])); // Sort descending
          }

          return isLoading
              ? _buildShimmerEffect() // Show shimmer effect when loading
              : items.isEmpty
                  ? const Center(child: Text('No Data Saved Yet!'))
                  : ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return Card(
                          margin: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: item['imagePath'] != null
                                ? Image.file(
                                    File(item['imagePath']),
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  )
                                : null,
                            title: Text(item['title'] ?? ''),
                            subtitle: Text(item['description'] ?? ''),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Color.fromARGB(255, 233, 99, 99),
                              ),
                              onPressed: () => _showDeleteConfirmationDialog(
                                context,
                                box,
                                index,
                              ),
                            ),
                          ),
                        );
                      },
                    );
        },
      ),
      bottomNavigationBar: CustomBottomBar(currentIndex: 1),
    );
  }

  // Show shimmer effect when no data is available or while loading
  Widget _buildShimmerEffect() {
    return ListView.builder(
      itemCount: 5, // Number of shimmer items
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: 50,
                height: 50,
                color: Colors.white,
              ),
            ),
            title: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: 150,
                height: 15,
                color: Colors.white,
              ),
            ),
            subtitle: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: 250,
                height: 15,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  // Show a confirmation dialog for deletion
  Future<void> _showDeleteConfirmationDialog(
    BuildContext context,
    Box box,
    int index,
  ) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this item?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                // Delete item from Hive box
                box.deleteAt(index);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Item deleted successfully!')),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
