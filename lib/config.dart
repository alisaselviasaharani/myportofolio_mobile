/// Base URL of the Django REST Framework backend.
///
/// Defaults to `http://10.0.2.2:8000` (IP address of your local development
/// machine as seen from the Android emulator).
/// Override with `--dart-define=API_BASE_URL=http://localhost:8000` if you are
/// testing on Chrome (Flutter Web) or on a physical device via `adb reverse`.
const String apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://10.0.2.2:8000',
);

/// Versi aplikasi yang ditampilkan di Pengaturan > Tentang Aplikasi.
const String appVersion = '2.0.0';

/// Web Client ID dari Google Cloud Console untuk "Masuk dengan Google".
///
/// Nilainya harus sama dengan salah satu `GOOGLE_CLIENT_IDS` di backend.
/// Berikan lewat `--dart-define=GOOGLE_SERVER_CLIENT_ID=xxxx.apps.googleusercontent.com`.
const String googleServerClientId = String.fromEnvironment(
  'GOOGLE_SERVER_CLIENT_ID',
);
