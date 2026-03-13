# FlixFlutterDemo (Flutter App)

**FlixFlutterDemo** is a sample Flutter application that demonstrates how to integrate and use the **Flix InPage Flutter plugin**.  
It shows how to authenticate, load syndicated product content, and display it in multiple UI flows.

---

## Features
- Simple login flow with Flix credentials.
- Optional sandbox/test environment switch on login.
- Four-tab navigation built with Material 3:
  - **Home**: Loads a remote product list and opens product details.
  - **Browse**: Enter product parameters (MPN, EAN, distributor, locale, etc.) and open content on demand.
  - **Accordion**: Displays content inside an expandable accordion section.
  - **Settings**: Log out and clear local session state.
- Product details page with `FlixInpageHtmlView`.
- Event logging example from app to plugin (`callLogFromApp('cartButtonTapped')`).

---

## Requirements
- Flutter SDK compatible with Dart **3.9.0**
- Android Studio or Xcode (depending on target platform)
- iOS Simulator / Android Emulator or physical device

---

## Getting Started
1. Clone the repository.
2. Go to the demo app folder:
   ```bash
   cd FlixFlutterDemo
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

---

## Usage
1. Launch the app.
2. Sign in with Flix credentials.
3. Optionally enable **Use test environment** on the login screen.
4. Explore the app:
   - **Home**: Browse products loaded from a remote JSON endpoint.
   - **Browse**: Provide your own product parameters and open product content.
   - **Accordion**: Inspect in-page content rendered inside an accordion tile.
   - **Settings**: Log out to clear session and return to login.

---

## Notes
- This app is for demonstration purposes and is not production-ready.
- Product list in **Home** is fetched from:
  - `https://demo.flix360.io/mobile-api/supporting/home-product-list.json`
- Login session flag is stored locally using `shared_preferences`.
- The local dependency is configured as:
  - `flix_inpage: path: ../flix_inpage`

---

## License
© FlixMedia. All rights reserved.
