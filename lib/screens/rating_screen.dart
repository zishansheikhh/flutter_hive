import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../widgets/bottombar.dart';

class RatingScreen extends StatefulWidget {
  @override
  _RatingScreenState createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  double userFriendlyRating = 0;
  double designRating = 0;
  double overallExperienceRating = 0;

  double get averageRating =>
      (userFriendlyRating + designRating + overallExperienceRating) / 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rate the App'),
      ),
      body: Center(
        // Center the entire column
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center vertically
            crossAxisAlignment:
                CrossAxisAlignment.center, // Center horizontally
            children: [
              const Text('User Friendly:'),
              RatingBar.builder(
                initialRating: userFriendlyRating,
                minRating: 0,
                itemSize: 40,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    userFriendlyRating = rating;
                  });
                },
              ),
              const SizedBox(height: 10),
              const Text('Design:'),
              RatingBar.builder(
                initialRating: designRating,
                minRating: 0,
                itemSize: 40,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    designRating = rating;
                  });
                },
              ),
              const SizedBox(height: 10),
              const Text('Overall Experience:'),
              RatingBar.builder(
                initialRating: overallExperienceRating,
                minRating: 0,
                itemSize: 40,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    overallExperienceRating = rating;
                  });
                },
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // If no ratings are provided, show a prompt to the user
                    if (userFriendlyRating == 0 &&
                        designRating == 0 &&
                        overallExperienceRating == 0) {
                      _showRatingAlert(context);
                    } else {
                      // Calculate average rating and show a dialog
                      _showRatingDialog(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade400,
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                  ),
                  child: const Text('Submit',
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(currentIndex: 2),
    );
  }

  // Show dialog with average rating and emoji
  void _showRatingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Thank you for your rating!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Average Rating: ${averageRating.toStringAsFixed(1)}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              // Show emoji based on the rating
              Icon(
                averageRating >= 4
                    ? Icons.sentiment_satisfied
                    : Icons.sentiment_dissatisfied,
                size: 60,
                color: averageRating >= 4 ? Colors.green : Colors.red,
              ),
              const SizedBox(height: 10),
              Text(
                averageRating >= 4
                    ? 'Thank you for your positive feedback!'
                    : 'Sorry I didn\'t meet your expectations.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // Show alert when no ratings are provided
  void _showRatingAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Please provide a rating'),
          content: const Text('You must give a rating for all categories.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
