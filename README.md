# Flutter Form with Image Feature

This project demonstrates a Flutter application with a form that includes image selection functionality. Users can add details along with an image, save them, and view the submitted entries in a list.

## Features
- Capture or select an image using the device's camera or gallery.
- Submit form details (title, description, and image).
- Persist data locally for future access.
- Display submitted entries in a scrollable list.

---

## Project Structure

### Project Setup
1. **Set up the Flutter project:**
   - Initialize a new Flutter project.
   - Ensure the project builds and runs successfully.
2. **Add dependencies in `pubspec.yaml`:**
   - [`image_picker`](https://pub.dev/packages/image_picker): For image selection.
   - State management library (e.g., [Riverpod](https://pub.dev/packages/riverpod), [Provider](https://pub.dev/packages/provider)).

### Phase 2: UI Implementation
3. **Form Screen:**
   - Add input fields for:
     - Title
     - Description
   - Include an "Add Image" button.
   - Display the selected image below the button.
4. **List Screen:**
   - Show submitted items in a scrollable list.
   - Each list item includes:
     - Title and description.
     - Associated image.

### Phase 3: Image Handling
5. **Image Picker Integration:**
   - Allow users to:
     - Choose an image from the gallery.
     - Capture an image using the camera.
   - Save the selected image's path locally.

### Phase 4: Core Functionality
6. **Submit Form Data:**
   - Save form details (title, description, and image path) to local storage using a library such as [`sqflite`](https://pub.dev/packages/sqflite) or [`hive`](https://pub.dev/packages/hive).
7. **Display Submitted Data:**
   - Fetch and display saved items in the list view.

### Phase 5: Testing and Finalization
8. **Form Submission Flow:**
   - Validate that form details and images are saved correctly.
   - Confirm data persistence after restarting the app.
9. **Optimize List UI:**
   - Ensure smooth scrolling and accurate data display.
10. **Bug Fixes and Enhancements:**
    - Resolve any issues.
    - Polish the UI for a better user experience.
