# Flutter Task

# Overview

- This Flutter app displays a list of items fetched from an API, where each item has a countdown timer.
-  The app also incorporates local storage using SharedPreferences for data persistence, allowing the app to maintain state even after it's restarted.
-  When a user navigates to the detail screen, the corresponding item's timer is paused, and when they return to the home screen, the timer resumes.



  # Features

  1. Data is stored locally using SharedPreferences and retrieved on app startup. This ensures that the app state is saved between sessions.
     
  2. The app initially displays data from local storage, while also fetching updated data from the API in the background.
     
  3. Each list item has a countdown timer. When the user interacts with an item (e.g., navigating to a detail screen), its timer is paused. The timer resumes when the user returns to the home screen.
     
  4. If the user scrolls the list, all active timers are paused to improve performance.



# Architectural Choices

- The app uses StatefulWidget and internal state management to track changes in data and timers.
- SharedPreferences is used for local storage as it provides a lightweight solution to store simple key-value pairs persistently. Since the app doesn't require complex data structures or encryption, SharedPreferences is a good fit for this use case.
- Timer from Dart's dart:async package is used to manage countdowns. Each list item has its own timer, which is started, paused, and resumed based on user interactions.
