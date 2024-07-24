# Marriage Invitation WebSite

## Overview

This Flutter web application is designed for creating and managing marriage invitations. It allows users to customize and send invitations with various features and functionalities to enhance the invitation experience.

## Features

- **Audio Player**: Background music or audio messages for the invitation.
- **Google Fonts**: Customizable text styles with Google Fonts.
- **Cloud Firestore**: Real-time database for storing invitation details.
- **URL Launcher**: Launch URLs for sharing invitations or accessing additional resources.
- **Font Awesome**: Use of Font Awesome icons for enhanced UI design.

## Dependencies

This project uses the following dependencies:

- **url_launcher**: Version ^6.3.0
  - Allows launching URLs in a mobile browser or web view.
  
- **font_awesome_flutter**: (Version not specified)
  - Provides Font Awesome icons for Flutter applications.
  
- **google_fonts**: Version ^6.2.1
  - Integrates Google Fonts into the app for customizable typography.
  
- **cloud_firestore**: Version ^5.0.2
  - Provides a real-time NoSQL database to store and sync invitation data.
  
- **firebase_core**: Version ^3.1.1
  - Initializes Firebase services in the app.
  
- **intl**: Version ^0.19.0
  - Provides internationalization and localization support.
  
- **assets_audio_player**: Version ^3.1.1
  - Allows playing audio files from assets or network sources.

## Installation

### Prerequisites

- Flutter SDK installed
- A web browser for testing the application

### Steps

1. **Clone the Repository**

    ```bash
    git clone https://github.com/Toktarla/toi_invite.git
    ```

2. **Navigate to the Project Directory**

    ```bash
    cd toi_invite
    ```

3. **Get the Dependencies**

    Run the following command to install all the dependencies specified in the `pubspec.yaml` file:

    ```bash
    flutter pub get
    ```

4. **Run the Application**

    ```bash
    flutter run -d chrome
    ```

    This command will build and launch the Flutter web app in your default web browser.

## Usage

1. **Create Invitation**

   - Use the provided UI to enter invitation details and customize the appearance.

2. **Add Audio**

   - Use the audio player feature to attach background music or audio messages.

3. **Save and Share**

   - Save the invitation and use the URL launcher to share it via email or social media.

