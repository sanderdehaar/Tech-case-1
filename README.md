# Tech Case 1: Media Player Application

## Introduction

I created a media player app with simple and useful features to improve user experience. The app lets users play, pause, stop, fast-forward, and rewind media easily. It also manages interruptions smoothly and allows background music playback when minimized.

## Table of Contents

- [Features](#features)
- [Technologies Used](#technologies-used)
- [Installation](#installation)
- [Usage](#usage)
- [Folder Structure](#folder-structure)
- [Dependencies](#dependencies)

## Features

- **Media Playback**: Users can play, pause, stop, fast-forward, and rewind media files.
- **Interruption Handling**: The app smoothly handles interruptions such as incoming calls, pausing playback and resuming afterward.
- **Background Music Support**: Music continues playing even when the app is minimized.

## Technologies Used

- **Flutter**: Used for building the cross-platform application.
- **Dart**: The primary programming language for Flutter development.

## Installation

To run the project locally, follow these steps:

1. Clone the repository:
   ```sh
   git clone https://github.com/sanderdehaar/Tech-case-1.git
   ```
2. Navigate to the project directory:
   ```sh
   cd your-app-folder
   ```
3. Install dependencies:
   ```sh
   flutter pub get
   ```
4. Run the application:
   ```sh
   flutter run
   ```

## Usage

1. Launch the app to access the media player.
2. Use the **Play** button to start playing media.
3. Use the **Pause** button to temporarily halt playback.
4. Use the **Stop** button to end media playback.
5. Use the **Forward** and **Rewind** buttons to navigate within the media file.
6. Minimize the app to test background music functionality.
7. Receive an interruption (e.g., a call) to observe how the app smoothly pauses and resumes playback.

## Folder Structure

```
lib/
 ├── main.dart          # Main entry point
 ├── screens/           # App screens
 ├── widgets/           # Reusable UI components
 ├── utils/             # Utility functions and helpers
 └── services/          # Media player service handling
```

## Dependencies

Here are the main dependencies used in the project:

```yaml
dependencies:
  flutter:
    sdk: flutter
  audioplayers: ^5.2.1
  provider: ^6.1.0
  permission_handler: ^11.0.0
```
