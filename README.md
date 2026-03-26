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
- Local **`flix_inpage`** module (required by path dependency)

---

## Required Module: `flix_inpage`

This demo app requires the **Flix InPage Flutter plugin** as a local module.

- Plugin repository: `https://github.com/FlixmediaTech/FlixmediaFlutterSDK`
- Expected local path (used in `pubspec.yaml`):
  - `flix_inpage:`
  - `  path: ../flix_inpage`

If the module is missing, run:

```bash
git clone https://github.com/FlixmediaTech/FlixmediaFlutterSDK.git flix_inpage
```

and place it next to the `FlixFlutterDemo` folder.

---

## Getting Started
1. Clone this repository (demo app).
2. Make sure `flix_inpage` exists next to `FlixFlutterDemo` (see section above).
3. Go to the demo app folder:
   ```bash
   cd FlixFlutterDemo
   ```
4. Install dependencies:
   ```bash
   flutter pub get
   ```
5. Run the app:
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
