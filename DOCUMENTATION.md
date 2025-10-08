# Aashish Wallet - Complete Project Documentation

## 📚 Table of Contents

1. [Project Overview](#project-overview)
2. [Features](#features)
3. [Architecture](#architecture)
4. [Getting Started](#getting-started)
5. [Database Schema](#database-schema)
6. [API Integration](#api-integration)
7. [State Management](#state-management)
8. [Navigation](#navigation)
9. [Deployment](#deployment)

## 🎯 Project Overview

Aashish Wallet is a production-ready Flutter mobile application that provides a comprehensive digital wallet solution. It's designed to handle multiple wallet types including Web3 wallets, fiat currencies, and payment gateway integrations.

### Technology Stack

- **Frontend**: Flutter 3.9.2+
- **Backend**: Supabase (PostgreSQL, Auth, Storage, Realtime)
- **State Management**: BLoC Pattern
- **Navigation**: go_router
- **Blockchain**: web3dart, WalletConnect
- **UI**: Material Design 3, Google Fonts, Custom Theme

## ✨ Features

### 1. Authentication System
- Email/Password authentication
- Biometric login (Fingerprint/Face ID)
- Forgot password functionality
- Auto sign-in persistence
- Role-based access control

### 2. Multi-Wallet Support

#### Web3 Wallets
- Ethereum (ETH)
- Binance Smart Chain (BNB)
- Polygon (MATIC)
- WalletConnect integration
- Private key management

#### Fiat Wallets
- NPR (Nepalese Rupee)
- USD (US Dollar)
- EUR (Euro)
- INR (Indian Rupee)

#### Payment Wallets
- eSewa (Nepal)
- Khalti (Nepal)
- IMEpay (Nepal)

### 3. Transaction Features
- Send money
- Receive money with QR code
- Transaction history
- Filtering by type
- Search transactions
- Transaction details
- Receipt generation
- Real-time updates

### 4. Dashboard
- Total balance overview
- Portfolio visualization
- Spending analytics
- Recent transactions
- Quick actions
- Interactive charts (fl_chart)

### 5. Profile & Settings
- User profile management
- KYC status tracking
- Security settings
- Notification preferences
- Theme customization
- Language selection
- Currency preferences

## 🏛️ Architecture

### Clean Architecture Layers

```
┌─────────────────────────────────────┐
│      Presentation Layer             │
│  (UI Components, BLoC, Screens)     │
├─────────────────────────────────────┤
│      Domain Layer                   │
│  (Business Logic, Use Cases)        │
├─────────────────────────────────────┤
│      Data Layer                     │
│  (Repositories, Data Sources, API)  │
└─────────────────────────────────────┘
```

### Folder Structure Explained

```
lib/
│
├── core/                          # Core app functionality
│   ├── constants/                 # App-wide constants
│   │   └── app_constants.dart    # API keys, limits, etc.
│   ├── models/                    # Data models
│   │   ├── user_model.dart
│   │   ├── wallet_model.dart
│   │   └── transaction_model.dart
│   ├── routes/                    # Navigation configuration
│   │   └── app_router.dart
│   ├── services/                  # Global services
│   │   └── supabase_service.dart
│   └── theme/                     # Theme configuration
│       ├── app_colors.dart
│       └── app_theme.dart
│
├── features/                      # Feature modules
│   ├── auth/                      # Authentication feature
│   │   ├── bloc/                  # State management
│   │   │   ├── auth_bloc.dart
│   │   │   ├── auth_event.dart
│   │   │   └── auth_state.dart
│   │   ├── repositories/          # Data layer
│   │   │   └── auth_repository.dart
│   │   └── screens/               # UI screens
│   │       ├── auth_screen.dart
│   │       ├── login_screen.dart
│   │       └── register_screen.dart
│   │
│   ├── dashboard/                 # Dashboard feature
│   │   └── screens/
│   │       └── dashboard_screen.dart
│   │
│   ├── wallet/                    # Wallet feature
│   │   ├── repositories/
│   │   │   └── wallet_repository.dart
│   │   └── screens/
│   │       ├── wallets_screen.dart
│   │       └── wallet_detail_screen.dart
│   │
│   ├── transactions/              # Transactions feature
│   │   ├── repositories/
│   │   │   └── transaction_repository.dart
│   │   └── screens/
│   │       └── transactions_screen.dart
│   │
│   ├── profile/                   # Profile feature
│   │   └── screens/
│   │       └── profile_screen.dart
│   │
│   └── settings/                  # Settings feature
│       └── screens/
│           └── settings_screen.dart
│
├── shared/                        # Shared components
│   └── widgets/                   # Reusable widgets
│       └── main_layout.dart
│
└── main.dart                      # App entry point
```

## 🚀 Getting Started

### Step 1: Install Dependencies

```bash
flutter pub get
```

### Step 2: Configure Supabase

1. Create a Supabase project at https://supabase.com
2. Get your project URL and anon key
3. Update `lib/core/constants/app_constants.dart`:

```dart
static const String supabaseUrl = 'YOUR_SUPABASE_URL';
static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
```

### Step 3: Set Up Database

Run the SQL scripts in Supabase SQL Editor:

```sql
-- See Database Schema section below
```

### Step 4: Run the App

```bash
# Debug mode
flutter run

# Release mode
flutter run --release

# Specific device
flutter run -d <device-id>
```

## 🗄️ Database Schema

### Users Table

```sql
CREATE TABLE users (
  id UUID PRIMARY KEY REFERENCES auth.users(id),
  email TEXT NOT NULL UNIQUE,
  full_name TEXT,
  phone_number TEXT,
  role TEXT DEFAULT 'user' CHECK (role IN ('user', 'merchant', 'admin')),
  kyc_status TEXT DEFAULT 'not_submitted' CHECK (kyc_status IN ('not_submitted', 'pending', 'approved', 'rejected')),
  profile_image_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Trigger to auto-update updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
```

### Wallets Table

```sql
CREATE TABLE wallets (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  type TEXT NOT NULL CHECK (type IN ('web3', 'fiat', 'payment')),
  network TEXT,
  address TEXT,
  balance DECIMAL(20, 8) DEFAULT 0 CHECK (balance >= 0),
  currency TEXT NOT NULL,
  symbol TEXT,
  icon_url TEXT,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_wallets_user_id ON wallets(user_id);
CREATE INDEX idx_wallets_type ON wallets(type);

CREATE TRIGGER update_wallets_updated_at BEFORE UPDATE ON wallets
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
```

### Transactions Table

```sql
CREATE TABLE transactions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  wallet_id UUID NOT NULL REFERENCES wallets(id) ON DELETE CASCADE,
  type TEXT NOT NULL CHECK (type IN ('send', 'receive', 'payment', 'reward', 'staking')),
  hash TEXT,
  amount DECIMAL(20, 8) NOT NULL,
  currency TEXT NOT NULL,
  from_address TEXT,
  to_address TEXT,
  recipient_name TEXT,
  description TEXT,
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'completed', 'failed')),
  payment_method TEXT,
  fee_amount DECIMAL(20, 8),
  fee_currency TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  completed_at TIMESTAMP WITH TIME ZONE
);

CREATE INDEX idx_transactions_user_id ON transactions(user_id);
CREATE INDEX idx_transactions_wallet_id ON transactions(wallet_id);
CREATE INDEX idx_transactions_status ON transactions(status);
CREATE INDEX idx_transactions_created_at ON transactions(created_at DESC);
```

### Row Level Security (RLS)

```sql
-- Enable RLS
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE wallets ENABLE ROW LEVEL SECURITY;
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;

-- Users policies
CREATE POLICY "Users can view own profile"
  ON users FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
  ON users FOR UPDATE
  USING (auth.uid() = id);

-- Wallets policies
CREATE POLICY "Users can view own wallets"
  ON wallets FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can create own wallets"
  ON wallets FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own wallets"
  ON wallets FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own wallets"
  ON wallets FOR DELETE
  USING (auth.uid() = user_id);

-- Transactions policies
CREATE POLICY "Users can view own transactions"
  ON transactions FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can create own transactions"
  ON transactions FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Admin policies
CREATE POLICY "Admins can view all users"
  ON users FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid() AND role = 'admin'
    )
  );
```

## 🔌 API Integration

### Supabase Client Usage

```dart
// Initialize
await SupabaseService.initialize();

// Get instance
final supabase = SupabaseService.client;

// Query
final data = await supabase
  .from('wallets')
  .select()
  .eq('user_id', userId);

// Insert
await supabase
  .from('wallets')
  .insert(walletData);

// Update
await supabase
  .from('wallets')
  .update({'balance': newBalance})
  .eq('id', walletId);

// Delete
await supabase
  .from('wallets')
  .delete()
  .eq('id', walletId);

// Realtime subscription
supabase
  .from('transactions')
  .stream(primaryKey: ['id'])
  .eq('user_id', userId)
  .listen((data) {
    // Handle real-time updates
  });
```

## 🔄 State Management

### BLoC Pattern Example

```dart
// Event
class AuthSignInRequested extends AuthEvent {
  final String email;
  final String password;
  
  const AuthSignInRequested({
    required this.email,
    required this.password,
  });
}

// State
class AuthState extends Equatable {
  final AuthStatus status;
  final UserModel? user;
  final String? errorMessage;
  
  const AuthState({
    this.status = AuthStatus.unknown,
    this.user,
    this.errorMessage,
  });
}

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  
  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AuthState()) {
    on<AuthSignInRequested>(_onSignInRequested);
  }
  
  Future<void> _onSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      
      final user = await _authRepository.signIn(
        email: event.email,
        password: event.password,
      );
      
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: e.toString(),
        isLoading: false,
      ));
    }
  }
}

// Usage in UI
BlocBuilder<AuthBloc, AuthState>(
  builder: (context, state) {
    if (state.isLoading) {
      return CircularProgressIndicator();
    }
    return LoginButton(
      onPressed: () {
        context.read<AuthBloc>().add(
          AuthSignInRequested(
            email: email,
            password: password,
          ),
        );
      },
    );
  },
)
```

## 🧭 Navigation

### go_router Configuration

```dart
final router = GoRouter(
  initialLocation: '/auth',
  routes: [
    GoRoute(
      path: '/auth',
      builder: (context, state) => const AuthScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) => MainLayout(child: child),
      routes: [
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/wallets',
          builder: (context, state) => const WalletsScreen(),
        ),
      ],
    ),
  ],
);

// Navigate
context.go('/dashboard');
context.push('/wallet/123');
context.pop();
```

## 📦 Deployment

### Android Release

```bash
# Create keystore
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload

# Configure signing in android/key.properties
storePassword=<password>
keyPassword=<password>
keyAlias=upload
storeFile=<location of the keystore file>

# Build
flutter build appbundle --release

# or APK
flutter build apk --split-per-abi --release
```

### iOS Release

```bash
# Install CocoaPods
cd ios && pod install

# Build
flutter build ios --release

# Open in Xcode for archive
open ios/Runner.xcworkspace
```

## 🧪 Testing

```bash
# Unit tests
flutter test

# Widget tests
flutter test test/widget_test.dart

# Integration tests
flutter test integration_test/

# Coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## 📱 Device-Specific Configuration

### Android (android/app/src/main/AndroidManifest.xml)

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.USE_BIOMETRIC"/>
```

### iOS (ios/Runner/Info.plist)

```xml
<key>NSCameraUsageDescription</key>
<string>Camera is required for QR code scanning</string>
<key>NSFaceIDUsageDescription</key>
<string>Face ID is required for biometric authentication</string>
```

## 🎨 Theming

The app uses a custom theme with support for both light and dark modes:

- Primary Color: Indigo (#6366F1)
- Secondary Color: Purple (#8B5CF6)
- Accent Color: Green (#10B981)
- Font Family: Inter (Google Fonts)

## 📊 Performance Optimization

1. **Image Caching**: cached_network_image for remote images
2. **Lazy Loading**: ListView.builder for long lists
3. **Code Splitting**: Lazy loading with go_router
4. **State Management**: Efficient rebuilds with BLoC
5. **Database Indexing**: Proper indexes on Supabase tables

## 🔒 Security Best Practices

1. **Never commit API keys** - Use environment variables
2. **Enable RLS** on all Supabase tables
3. **Validate input** on both client and server
4. **Use HTTPS** for all API calls
5. **Implement rate limiting** on Supabase
6. **Store tokens securely** using flutter_secure_storage
7. **Implement biometric authentication**
8. **Add certificate pinning** for production

## 📞 Support & Maintenance

- Regular dependency updates
- Security patches
- Bug fixes
- Feature enhancements
- Performance monitoring

---

**Last Updated**: October 6, 2025
**Version**: 1.0.0
**Status**: Production Ready ✅
