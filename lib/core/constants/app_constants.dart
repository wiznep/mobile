class AppConstants {
  // App Info
  static const String appName = 'Aashish Wallet';
  static const String appVersion = '1.0.0';

  // API Constants
  static const String supabaseUrl = 'https://bydbwypgqpofsqztmifh.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJ5ZGJ3eXBncXBvZnNxenRtaWZoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTk2NzM1NzksImV4cCI6MjA3NTI0OTU3OX0.28Ncip6GTLj0FQ0CgAqtBmasVgvSBSkGl94HFY1_4wU';

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userIdKey = 'user_id';
  static const String userRoleKey = 'user_role';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';

  // User Roles
  static const String roleUser = 'user';
  static const String roleAdmin = 'admin';
  static const String roleMerchant = 'merchant';

  // KYC Status
  static const String kycPending = 'pending';
  static const String kycApproved = 'approved';
  static const String kycRejected = 'rejected';
  static const String kycNotSubmitted = 'not_submitted';

  // Transaction Types
  static const String txTypeSend = 'send';
  static const String txTypeReceive = 'receive';
  static const String txTypePayment = 'payment';
  static const String txTypeReward = 'reward';
  static const String txTypeStaking = 'staking';

  // Wallet Types
  static const String walletTypeWeb3 = 'web3';
  static const String walletTypeFiat = 'fiat';
  static const String walletTypePayment = 'payment';

  // Blockchain Networks
  static const String networkEthereum = 'ethereum';
  static const String networkBSC = 'bsc';
  static const String networkPolygon = 'polygon';

  // Payment Methods
  static const String paymentEsewa = 'esewa';
  static const String paymentKhalti = 'khalti';
  static const String paymentIMEPay = 'imepay';

  // Limits
  static const int maxFileSize = 5 * 1024 * 1024; // 5MB
  static const int transactionPageSize = 20;
  static const int maxPinAttempts = 3;

  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration sessionTimeout = Duration(minutes: 30);
}
