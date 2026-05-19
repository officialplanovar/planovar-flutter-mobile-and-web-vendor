# Development guide

## Prerequisites

| Tool | Version | Install |
|---|---|---|
| Flutter | 3.x | [flutter.dev/install](https://flutter.dev/docs/get-started/install) |
| Dart | 3.x | Bundled with Flutter |
| Xcode | 15+ | Mac App Store (iOS builds) |
| Android Studio | latest | [developer.android.com](https://developer.android.com/studio) |
| CocoaPods | latest | `sudo gem install cocoapods` (iOS) |
| Chrome | any | Required for web target |

Verify your setup:

```bash
flutter doctor
```

All items should show a green tick. Fix any reported issues before continuing.

---

## First-time setup

```bash
cd planovar-flutter-mobile-and-web-vendor
flutter pub get
```

For iOS, install native dependencies:

```bash
cd ios && pod install && cd ..
```

---

## Running the app

### In the browser (fastest for UI development)

```bash
flutter run -d web-server --web-port 3002
# or from the monorepo root:
make vendor-web
```

Opens at `http://localhost:3002`. Hot reload works — press `r` in the terminal.

### On iOS simulator

```bash
flutter run -d ios
# or:
make vendor-ios
```

Open Xcode → Simulator if no device is listed.

### On Android emulator

```bash
flutter run -d android
# or:
make vendor-android
```

Start an AVD in Android Studio first if no device is listed.

### On a physical device

Connect the device via USB, trust the computer, then:

```bash
flutter devices          # confirm your device is listed
flutter run -d <device-id>
```

---

## Hot reload vs hot restart

| Command | Key | Effect |
|---|---|---|
| Hot reload | `r` | Injects updated code, preserves state |
| Hot restart | `R` | Full restart, clears state |
| Quit | `q` | Stops the app |

Use hot reload for UI changes. Use hot restart when you change BLoC state or initialisation logic.

---

## Environment / API configuration

The API base URL is defined in `lib/core/constants/app_constants.dart` (to be created):

```dart
class AppConstants {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000',
  );
}
```

To point at a different API (staging, production) without changing code, pass it at build time:

```bash
# Dev (default)
flutter run

# Staging
flutter run --dart-define=API_BASE_URL=https://api.staging.planovar.ng

# Production
flutter build apk --dart-define=API_BASE_URL=https://api.planovar.ng
```

---

## Adding a new feature

1. **Create the feature folder:**
   ```
   lib/features/<name>/
   ├── bloc/
   │   ├── <name>_bloc.dart
   │   ├── <name>_event.dart
   │   └── <name>_state.dart
   ├── data/
   │   ├── <name>_repository.dart
   │   └── <name>_remote_data_source.dart
   └── ui/
       ├── <name>_screen.dart
       └── widgets/
   ```

2. **Define events and states first** — model what the user can do and what the UI needs to show before writing any logic.

3. **Write the repository** — it calls the remote data source and returns either data or a typed failure.

4. **Write the BLoC** — maps events to state transitions, calls the repository.

5. **Build the UI** — wrap screens in `BlocProvider` and use `BlocBuilder` / `BlocListener` for reactive updates.

6. **Register the route** in `lib/core/router/router.dart`.

7. **Add navigation** from wherever the feature is accessed (bottom nav, button, deep link).

---

## BLoC boilerplate example

```dart
// earnings_event.dart
abstract class EarningsEvent extends Equatable {
  const EarningsEvent();
}

class LoadEarnings extends EarningsEvent {
  const LoadEarnings();
  @override List<Object> get props => [];
}

// earnings_state.dart
abstract class EarningsState extends Equatable {
  const EarningsState();
}

class EarningsInitial extends EarningsState {
  @override List<Object> get props => [];
}

class EarningsLoading extends EarningsState {
  @override List<Object> get props => [];
}

class EarningsLoaded extends EarningsState {
  final List<Payout> payouts;
  final Decimal pendingAmount;
  const EarningsLoaded({required this.payouts, required this.pendingAmount});
  @override List<Object> get props => [payouts, pendingAmount];
}

class EarningsError extends EarningsState {
  final String message;
  const EarningsError(this.message);
  @override List<Object> get props => [message];
}

// earnings_bloc.dart
class EarningsBloc extends Bloc<EarningsEvent, EarningsState> {
  final EarningsRepository repository;

  EarningsBloc({required this.repository}) : super(const EarningsInitial()) {
    on<LoadEarnings>(_onLoadEarnings);
  }

  Future<void> _onLoadEarnings(
    LoadEarnings event,
    Emitter<EarningsState> emit,
  ) async {
    emit(const EarningsLoading());
    try {
      final result = await repository.getEarnings();
      emit(EarningsLoaded(payouts: result.payouts, pendingAmount: result.pending));
    } catch (e) {
      emit(EarningsError(e.toString()));
    }
  }
}
```

---

## Building for release

### Android APK

```bash
flutter build apk --release \
  --dart-define=API_BASE_URL=https://api.planovar.ng
# or:
make vendor-build-apk
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### iOS archive (for App Store)

```bash
flutter build ios --release \
  --dart-define=API_BASE_URL=https://api.planovar.ng
# or:
make vendor-build-ios
```

Then open Xcode → Product → Archive to submit to App Store Connect.

### Web bundle

```bash
flutter build web --release \
  --dart-define=API_BASE_URL=https://api.planovar.ng
# or:
make vendor-build-web
```

Output: `build/web/` — deploy as a static site.

---

## Code quality

```bash
# Analyse for warnings and errors
flutter analyze

# Run tests
flutter test

# Format code
dart format lib/
```

The linting rules are defined in `analysis_options.yaml`. Fix all warnings before opening a PR.

---

## Troubleshooting

**`flutter pub get` fails with dependency conflicts**
Run `flutter pub upgrade` to get the latest compatible versions. If a specific package is pinned, check `pubspec.lock` for the conflict.

**iOS build fails with CocoaPods error**
```bash
cd ios
pod deintegrate
pod install
```

**Web app shows blank screen**
Open browser DevTools → Console. Usually a missing `flutter_bootstrap.js` or a Dart exception. Check that `flutter build web` completed without errors.

**API calls fail with CORS errors in the browser**
The API's `main.ts` must list `http://localhost:3002` in both the NestJS CORS config and Better Auth's `trustedOrigins`. Verify and restart the API.

**App crashes on startup after adding a new package**
Run `flutter clean && flutter pub get` to clear the build cache, then re-run.

**Hot reload not reflecting changes**
Some changes (new routes, new BLoC providers) require a hot restart (`R`) rather than hot reload (`r`).
