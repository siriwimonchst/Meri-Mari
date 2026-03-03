# Meri-Mari E-Commerce App

A modern, cross-platform e-commerce application built with Flutter, focused on a seamless shopping experience with a clean and elegant purple-themed UI.

## ✨ Features

- **📱 Cross-Platform**: Runs beautifully on both Android and iOS devices.
- **🎨 Modern UI/UX**: Clean, responsive, and visually appealing design with a signature purple color palette.
- **🌐 Bilingual Support**: Seamlessly switch between English and Thai (`[th, en]`) languages using a custom `AppLocaleProvider`.
- **🛒 Shopping Cart**: Fully functional cart system with dynamic price calculation, quantity management, and selected items processing (`CartProvider`).
- **💖 Favorites System**: Save items to a favorites list, integrated with Firebase Firestore and local caching (`FavoritesProvider`).
- **📦 Order Management**: Comprehensive order tracking with specific statuses:
  - 📝 **To Pay**: Real-time 24-hour countdown timers for pending payments. Auto-cancellation upon expiry.
  - 🚚 **To Ship**: Orders being prepared for delivery.
  - 🏡 **To Receive**: Orders in transit.
  - ⭐ **To Rate**: Completed orders awaiting user feedback.
  - Users can also cancel orders from the "To Pay" state, releasing reserved stock (`OrdersProvider`).
- **💳 Payment Integration**: Dedicated QR PromptPay payment flow with slip upload simulation (`QrPaymentScreen`).
- **🚫 Stock Management**: Intelligent "Out of Stock" lock mechanism preventing multiple users from purchasing an already reserved item while it's in a pending payment state.
- **👤 User Profiles & Addresses**: Manage user profiles and shipping addresses with Firestore integration.

## 🛠️ Tech Stack

- **Frontend**: Flutter (Dart)
- **State Management**: Provider (`package:provider`)
- **Backend/Database**: Firebase (Firestore, Authentication - *Planned/Integrated*)
- **Storage/Preferences**: SharedPreferences (for local caching of cart/language settings)
- **Image Handling**: `image_picker` (for payment slip uploads)

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (latest stable version)
- Dart SDK
- Android Studio / Xcode (for emulation/compilation)

### Installation

1. **Clone the repository** (if applicable) or navigate to the project root:
   ```bash
   cd Meri-Mari
   ```

2. **Fetch dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the app**:
   ```bash
   # Run on connected device or emulator
   flutter run
   
   # Run explicitly on Chrome (Web)
   flutter run -d chrome
   ```

## 📁 Project Structure

Key directories and their responsibilities:
- `lib/features/`: Contains the UI screens and their presentation logic (e.g., `home.dart`, `cart_screen.dart`, `orders.dart`, `product_detail.dart`).
- `lib/providers/`: Global state management classes (e.g., `cart_provider.dart`, `orders_provider.dart`, `favorites_provider.dart`, `app_locale_provider.dart`).
- `lib/models/`: Data models for parsing and handling app data (e.g., `item_model.dart`).
- `lib/l10n/`: Localization strings for multi-language support.

## 💡 Key Workflows

- **Checkout Flow**: 
  `Cart` -> `Checkout Screen` -> `QR Payment (Upload Slip or Pay Later)` -> `Orders (To Pay)`
- **Stock Lock**: 
  When an item is checked out (even if unpaid via "Pay Later"), the order ID is prefixed with `MRMR-` and the item ID is tracked. In the Product Detail screen, a purple "สินค้าหมด" (Out of Stock) overlay appears for other users until the 24h timer expires or the order is manually cancelled.

---
*Built with ❤️ using Flutter.*