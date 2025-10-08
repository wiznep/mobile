# Supabase Setup Guide

## 1. Disable Email Confirmation (IMPORTANT!)

To avoid the `over_email_send_rate_limit` error during development:

1. Go to your Supabase Dashboard: https://bydbwypgqpofsqztmifh.supabase.co
2. Navigate to **Authentication** → **Providers** → **Email**
3. **Disable "Confirm email"** option
4. Click **Save**

This allows users to sign up and log in immediately without email verification.

## 2. Create Database Tables

Go to **SQL Editor** in your Supabase dashboard and run this SQL:

```sql
-- Create users table
CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT UNIQUE NOT NULL,
  full_name TEXT,
  phone_number TEXT,
  profile_image_url TEXT,
  role TEXT DEFAULT 'user' CHECK (role IN ('user', 'admin', 'merchant')),
  kyc_status TEXT DEFAULT 'not_submitted' CHECK (kyc_status IN ('not_submitted', 'pending', 'approved', 'rejected')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create wallets table
CREATE TABLE IF NOT EXISTS wallets (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  type TEXT NOT NULL CHECK (type IN ('web3', 'fiat', 'payment')),
  network TEXT,
  address TEXT,
  balance NUMERIC(20, 8) DEFAULT 0,
  currency TEXT DEFAULT 'USD',
  symbol TEXT,
  icon_url TEXT,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create transactions table
CREATE TABLE IF NOT EXISTS transactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  wallet_id UUID REFERENCES wallets(id) ON DELETE SET NULL,
  type TEXT NOT NULL CHECK (type IN ('send', 'receive', 'payment', 'reward', 'swap')),
  hash TEXT,
  amount NUMERIC(20, 8) NOT NULL,
  currency TEXT NOT NULL,
  from_address TEXT,
  to_address TEXT,
  recipient_name TEXT,
  description TEXT,
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'completed', 'failed', 'cancelled')),
  payment_method TEXT,
  fee NUMERIC(20, 8) DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_wallets_user_id ON wallets(user_id);
CREATE INDEX IF NOT EXISTS idx_transactions_user_id ON transactions(user_id);
CREATE INDEX IF NOT EXISTS idx_transactions_wallet_id ON transactions(wallet_id);
CREATE INDEX IF NOT EXISTS idx_transactions_status ON transactions(status);
CREATE INDEX IF NOT EXISTS idx_transactions_created_at ON transactions(created_at DESC);

-- Enable Row Level Security
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE wallets ENABLE ROW LEVEL SECURITY;
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;

-- RLS Policies for users table
CREATE POLICY "Users can view their own data"
  ON users FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "Users can update their own data"
  ON users FOR UPDATE
  USING (auth.uid() = id);

CREATE POLICY "Users can insert their own data"
  ON users FOR INSERT
  WITH CHECK (auth.uid() = id);

-- RLS Policies for wallets table
CREATE POLICY "Users can view their own wallets"
  ON wallets FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own wallets"
  ON wallets FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own wallets"
  ON wallets FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own wallets"
  ON wallets FOR DELETE
  USING (auth.uid() = user_id);

-- RLS Policies for transactions table
CREATE POLICY "Users can view their own transactions"
  ON transactions FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own transactions"
  ON transactions FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own transactions"
  ON transactions FOR UPDATE
  USING (auth.uid() = user_id);

-- Create updated_at trigger function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Add triggers for updated_at
CREATE TRIGGER update_users_updated_at
  BEFORE UPDATE ON users
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_wallets_updated_at
  BEFORE UPDATE ON wallets
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_transactions_updated_at
  BEFORE UPDATE ON transactions
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();
```

## 3. Update App Constants (if needed)

If you haven't already, update `lib/core/constants/app_constants.dart` with your credentials:

```dart
static const String supabaseUrl = 'https://bydbwypgqpofsqztmifh.supabase.co';
static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJ5ZGJ3eXBncXBvZnNxenRtaWZoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTk2NzM1NzksImV4cCI6MjA3NTI0OTU3OX0.28Ncip6GTLj0FQ0CgAqtBmasVgvSBSkGl94HFY1_4wU';
```

## 4. Test the App

1. **Hot Restart** the app: Press `Shift+F5` or run `flutter run`
2. **Register a new account** - should work without email confirmation
3. **Login** - should work and auto-create user profile if needed

## Troubleshooting

### Error: `over_email_send_rate_limit`
- **Solution**: Disable email confirmation in Supabase Auth settings (Step 1)

### Error: `PostgresException: PGRST116 - 0 rows`
- **Solution**: Make sure the `users` table exists (Step 2)
- **Auto-fix**: The app now auto-creates user profiles if they don't exist

### Error: `relation "users" does not exist`
- **Solution**: Run the SQL script in Step 2 to create all tables

### Can't sign in after registration
- **Check**: Email confirmation is disabled
- **Check**: RLS policies are created correctly
- **Try**: Use SQL Editor to check if user exists:
  ```sql
  SELECT * FROM auth.users;
  SELECT * FROM users;
  ```

## Production Setup (Later)

For production, you should:
1. **Enable email confirmation** in Auth settings
2. **Add email templates** in Authentication → Email Templates
3. **Update RLS policies** for stricter security
4. **Enable MFA** (Multi-Factor Authentication)
5. **Set up proper environment variables** (don't commit keys to git)

---

**Your Supabase Project**: https://bydbwypgqpofsqztmifh.supabase.co
