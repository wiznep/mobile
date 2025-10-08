# Aashish Wallet - Flutter Mobile App

A comprehensive digital wallet solution built with Flutter, featuring Web3 integration, fiat currency support, and payment gateway integration.

## 🚀 Features

### ✅ Core Features
- **Multi-Wallet Support**
  - Web3 Wallets (Ethereum, BSC, Polygon)
  - Fiat Wallets (NPR, USD, EUR)
  - Payment Wallets (eSewa, Khalti, IMEpay)

- **Transaction Management**
  - Send & Receive funds
  - Transaction history with filtering
  - Real-time transaction tracking
  - Payment receipts

- **Dashboard & Analytics**
  - Portfolio overview
  - Spending analytics with charts
  - Quick actions (Send, Scan, Top Up)
  - Recent transactions

- **User Management**
  - Email/Password authentication
  - Profile management
  - KYC verification status
  - Role-based access control

- **Security**
  - Secure authentication with Supabase
  - Biometric login support
  - PIN protection
  - Two-factor authentication

### 🎨 UI/UX Features
- Modern, clean interface with Material Design 3
- Dark/Light theme support
- Smooth animations and transitions
- Responsive layouts
- Bottom navigation
- Pull-to-refresh

## 📋 Prerequisites

- Flutter SDK (3.9.2 or higher)
- Dart SDK (3.9.2 or higher)
- Android Studio / Xcode for mobile development
- Supabase account

## 🛠️ Installation

1. **Install dependencies**
   ```bash
   flutter pub get
   ```

2. **Configure Supabase**
   - Update Supabase URL and API key in `lib/core/constants/app_constants.dart`

3. **Run the app**
   ```bash
   flutter run
   ```

## 📁 Project Structure

```
lib/
├── core/
│   ├── constants/      # App-wide constants
│   ├── models/         # Data models
│   ├── routes/         # Navigation
│   ├── services/       # Services (Supabase)
│   └── theme/          # App theme & colors
├── features/
│   ├── auth/          # Authentication
│   ├── dashboard/     # Dashboard
│   ├── wallet/        # Wallets
│   ├── transactions/  # Transactions
│   ├── profile/       # Profile
│   └── settings/      # Settings
├── shared/
│   └── widgets/       # Reusable widgets
└── main.dart          # Entry point
```

## 🏗️ Architecture

- **Clean Architecture** with **BLoC** pattern
- Repository pattern for data abstraction
- Equatable for value equality

### Key Packages
- `supabase_flutter`: Backend & auth
- `flutter_bloc`: State management
- `go_router`: Navigation
- `fl_chart`: Charts
- `web3dart`: Web3 integration

## 🔐 Security

- Encrypted sensitive data
- Supabase authentication
- Row Level Security (RLS)
- Biometric authentication
- Secure token storage

## 📱 Build Commands

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

---

Made with ❤️ using Flutter
