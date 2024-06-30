# GeoMinder

GeoMinder is a location-based reminder application built using Swift, UIKit, and CoreData. The app allows users to create reminders that are triggered based on their geographical location.

## Features

- **Home Screen**: Displays all reminders in a table view with options to mark as completed or delete via swipe actions.
- **Add/Edit Reminder**: Users can add new reminders or edit existing ones. The form includes fields for the title, latitude, and longitude.
- **Map Integration**: Select a location on the Apple map, and the coordinates auto-populate in the form.
- **Background Updates**: The app correctly handles background location updates and notifications.
- **Notification**: Users receive notifications when they reach the location specified in a reminder.

## Installation

1. Clone the repository:
    ```sh
    git clone https://github.com/Sumit4482/GeoMinder.git
    ```

2. Open the project in Xcode:
    ```sh
    cd GeoMinder
    open GeoMinder.xcodeproj
    ```

3. Install dependencies (if any, e.g., using CocoaPods or Swift Package Manager).

4. Build and run the project on your simulator or device.

## Usage

1. **Adding a Reminder**:
    - Tap the add button on the home screen.
    - Enter the title, latitude, and longitude.
    - Optionally, select a location on the map to auto-fill the coordinates.
    - Save the reminder.

2. **Editing a Reminder**:
    - Tap on a reminder from the home screen.
    - Modify the details as needed and save.

3. **Completing or Deleting a Reminder**:
    - Swipe left on a reminder to mark it as completed or delete it.

4. **Receiving Notifications**:
    - Ensure location permissions are enabled.
    - You will receive notifications when you arrive at the location specified in a reminder.

## Screenshots

<img src="https://github.com/Sumit4482/GeoMinder/assets/61246873/a270ec8f-238c-4471-ad1e-6373c6d9f340" alt="image" style="width: 200px; height: 400px;">
<img src="https://github.com/Sumit4482/GeoMinder/assets/61246873/4de84129-4f35-4a57-8162-591eb77363ad" alt="image" style="width: 200px; height: 400px;">
<img src="https://github.com/Sumit4482/GeoMinder/assets/61246873/b4ed47ff-3279-4c01-ad34-292bd7067d8d" alt="image" style="width: 200px; height: 400px;">
<img src="https://github.com/Sumit4482/GeoMinder/assets/61246873/4325050b-917e-47e7-8937-2a5e98973f14" alt="image" style="width: 200px; height: 400px;">

##Test Coverage
![image](https://github.com/Sumit4482/GeoMinder/assets/61246873/f383a4b9-646f-45e7-adaf-bfd4e52983c6)
