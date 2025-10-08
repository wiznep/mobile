# 🚀 Quick Start Guide - Aashish Wallet Flutter App

## Overview
Your complete production Flutter wallet app is ready! This guide will help you launch it in minutes.

## ⚡ Quick Launch (5 Minutes)

### Step 1: Verify Installation (30 seconds)
```powershell
flutter doctor
```
Expected output: All checkmarks ✓

### Step 2: Get Dependencies (1 minute)
```powershell
cd d:\mobile-flutter\mobileapp
flutter pub get
```

### Step 3: Configure Supabase (2 minutes)

#### Option A: Use Existing Credentials (Already Configured!)
The app is pre-configured with your React app's Supabase credentials:
- URL: `https://unewkmiquzloruuqcwdn.supabase.co`
- Key: Already set in `app_constants.dart`

#### Option B: Use Your Own Supabase Project
1. Go to https://supabase.com and create a project
2. Get your URL and anon key from Settings > API
3. Update `lib/core/constants/app_constants.dart`:
```dart
static const String supabaseUrl = 'YOUR_URL';
static const String supabaseAnonKey = 'YOUR_KEY';
```

### Step 4: Set Up Database (2 minutes)

Copy and run this SQL in your Supabase SQL Editor:

```sql
-- Create users table
CREATE TABLE users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT NOT NULL UNIQUE,
  full_name TEXT,
  phone_number TEXT,
  role TEXT DEFAULT 'user',
  kyc_status TEXT DEFAULT 'not_submitted',
  profile_image_url TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create wallets table
CREATE TABLE wallets (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  type TEXT NOT NULL,
  network TEXT,
  address TEXT,
  balance DECIMAL(20, 8) DEFAULT 0,
  currency TEXT NOT NULL,
  symbol TEXT,
  icon_url TEXT,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create transactions table
CREATE TABLE transactions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  wallet_id UUID NOT NULL REFERENCES wallets(id) ON DELETE CASCADE,
  type TEXT NOT NULL,
  hash TEXT,
  amount DECIMAL(20, 8) NOT NULL,
  currency TEXT NOT NULL,
  from_address TEXT,
  to_address TEXT,
  recipient_name TEXT,
  description TEXT,
  status TEXT DEFAULT 'pending',
  payment_method TEXT,
  fee_amount DECIMAL(20, 8),
  fee_currency TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  completed_at TIMESTAMPTZ
);

-- Enable RLS
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE wallets ENABLE ROW LEVEL SECURITY;
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Users can view own profile" ON users FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can update own profile" ON users FOR UPDATE USING (auth.uid() = id);
CREATE POLICY "Users can view own wallets" ON wallets FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can create own wallets" ON wallets FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can view own transactions" ON transactions FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can create own transactions" ON transactions FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Indexes
CREATE INDEX idx_wallets_user_id ON wallets(user_id);
CREATE INDEX idx_transactions_user_id ON transactions(user_id);
CREATE INDEX idx_transactions_wallet_id ON transactions(wallet_id);
```

### Step 5: Run the App! (30 seconds)

```powershell
# Connect your Android device or start emulator
# Then run:
flutter run
```

Or use VS Code:
- Press `F5` (Start Debugging)
- Select your device
- Wait for build

## 🎯 First Launch Checklist

Once the app launches:

1. **✅ Test Registration**
   - Click "Create Account"
   - Enter email, password, full name
   - Submit form

2. **✅ Test Login**
   - Use the credentials you just created
   - Click "Sign In"
   - Should redirect to Dashboard

3. **✅ Explore Features**
   - View Dashboard with charts
   - Navigate to Wallets (bottom nav)
   - Navigate to Transactions
   - Navigate to Profile
   - Open Settings from Profile

## 🔧 Troubleshooting

### Issue: "Supabase URL is not defined"
**Solution**: Update `app_constants.dart` with your Supabase URL

### Issue: "Authentication failed"
**Solution**: 
1. Check Supabase project is running
2. Verify API key is correct
3. Check database tables are created

### Issue: "Cannot find module"
**Solution**: 
```powershell
flutter clean
flutter pub get
flutter run
```

### Issue: Build errors on Windows
**Solution**: Enable Developer Mode:
```powershell
start ms-settings:developers
```

### Issue: iOS build fails
**Solution**: 
```bash
cd ios
pod install
cd ..
flutter run
```

## 📱 Device Setup

### Android
1. Enable Developer Options
2. Enable USB Debugging
3. Connect device via USB
4. Run: `flutter devices`
5. Run: `flutter run`

### iOS (Mac only)
1. Open Xcode
2. Sign in with Apple ID
3. Select your team
4. Connect iPhone
5. Trust your Mac on iPhone
6. Run: `flutter run`

### Emulator
```powershell
# Android
flutter emulators --launch <emulator_id>

# iOS (Mac only)
open -a Simulator
```

## 🎨 Customization Quick Tips

### Change App Name
Edit `pubspec.yaml`:
```yaml
name: your_app_name
description: "Your app description"
```

### Change App Icon
1. Replace `assets/icons/app_icon.png` with your icon
2. Run: `flutter pub run flutter_launcher_icons:main`

### Change Colors
Edit `lib/core/theme/app_colors.dart`:
```dart
static const Color primary = Color(0xFF6366F1); // Your color
```

### Add More Languages
Edit `lib/features/settings/screens/settings_screen.dart`:
```dart
final languages = ['English', 'Your Language'];
```

## 📊 Test Accounts

For development, you can create test accounts:

```sql
-- Insert test user (run in Supabase SQL)
INSERT INTO users (id, email, full_name, role, kyc_status)
VALUES (
  'test-uuid-here',
  'test@example.com',
  'Test User',
  'user',
  'approved'
);
```

## 🚢 Production Build

### Android APK
```powershell
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Android App Bundle (Google Play)
```powershell
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

### iOS (Mac only)
```bash
flutter build ios --release
# Then open in Xcode and archive
```

## 📈 Performance Tips

1. **Run in Release Mode**: `flutter run --release`
2. **Enable Caching**: Already configured with cached_network_image
3. **Optimize Images**: Use WebP format in assets
4. **Monitor Performance**: Use Flutter DevTools

## 🔐 Security Checklist Before Production

- [ ] Change Supabase anon key if using public repo
- [ ] Enable RLS on all tables
- [ ] Set up proper authentication rules
- [ ] Add rate limiting on Supabase
- [ ] Enable 2FA for Supabase account
- [ ] Review all API policies
- [ ] Test with different user roles
- [ ] Enable SSL pinning
- [ ] Obfuscate code: `flutter build apk --obfuscate --split-debug-info=/<project-name>/<directory>`

## 📚 Learn More

- **Flutter Docs**: https://flutter.dev/docs
- **Supabase Docs**: https://supabase.com/docs
- **BLoC Pattern**: https://bloclibrary.dev
- **Material Design**: https://m3.material.io

## 🎉 You're All Set!

Your app is now ready for:
- ✅ Development
- ✅ Testing
- ✅ Production deployment

Need help? Check:
1. `PROJECT_SUMMARY.md` - Complete overview
2. `DOCUMENTATION.md` - Technical details
3. `README.md` - Quick reference

---

**Happy Coding! 🚀**

Last Updated: October 6, 2025
