# Architecture

## Role in the Planovar system

The vendor app is one of four client surfaces that talk to the shared `planovar-api` backend:

```
┌───────────────────────────────────────────────────────────┐
│                     Client surfaces                       │
│                                                           │
│  Flutter Client   Flutter Vendor   Next.js Admin          │
│  (iOS/Android/    (iOS/Android/    (Web only)             │
│   Web)             Web)  ◄──── you are here               │
└──────────────────────────┬────────────────────────────────┘
                           │ HTTPS + WebSocket
                           ▼
                   ┌───────────────┐
                   │ Planovar API  │
                   │ (NestJS :3000)│
                   └───────────────┘
```

All user accounts with `role = VENDOR` use this app. It is entirely separate from the client app — different codebase, different App Store listing, different UX focus.

---

## Platform strategy

One Flutter codebase compiles to three targets:

| Target | Distribution | Notes |
|---|---|---|
| **iOS** | App Store | Native performance, push via APNs |
| **Android** | Google Play | Native performance, push via FCM |
| **Web** | Browser (URL) | Vendors who prefer desktop management |

Platform-specific code (camera, file picker, push registration) is isolated behind abstraction layers so the business logic and UI remain shared.

---

## State management — BLoC pattern

The app uses `flutter_bloc` throughout. Every feature follows the same three-layer structure:

```
feature/
├── bloc/
│   ├── feature_bloc.dart     # Business logic, calls repository
│   ├── feature_event.dart    # User actions (LoadListings, SubmitQuote…)
│   └── feature_state.dart    # UI states (Initial, Loading, Loaded, Error)
├── data/
│   ├── feature_repository.dart       # Abstracts data source
│   └── feature_remote_data_source.dart  # Dio API calls
└── ui/
    ├── feature_screen.dart   # BlocBuilder / BlocListener wrappers
    └── widgets/              # Screen-specific widgets
```

**Data flow:**

```
UI Event
  │
  ▼
BLoC (processes event, calls repository)
  │
  ▼
Repository (decides local vs remote)
  │
  ▼
RemoteDataSource (Dio → Planovar API)
  │
  ▼
BLoC emits new State
  │
  ▼
UI rebuilds via BlocBuilder
```

---

## Navigation — go_router

All routes are defined in `lib/core/router/`. The router uses `redirect` guards to enforce authentication:

- Unauthenticated users are redirected to `/login`
- Authenticated users with an incomplete vendor profile are redirected to `/onboarding`
- Fully onboarded vendors land on the dashboard

```dart
// Conceptual route structure
/
├── /login
├── /register
├── /verify-otp
├── /onboarding          # Vendor profile setup (first-time only)
└── /dashboard
    ├── /listings
    │   ├── /listings/new
    │   └── /listings/:id/edit
    ├── /bookings
    │   └── /bookings/:id
    ├── /quotes/:id
    ├── /messages
    │   └── /messages/:conversationId
    ├── /earnings
    ├── /reviews
    └── /profile
```

---

## HTTP client — Dio

The Dio instance lives in `lib/core/api/`. It is configured with:

- `BaseOptions.baseUrl` pointing to the API
- A **cookie interceptor** that attaches the Better Auth session cookie to every request
- A **401 interceptor** that redirects to `/login` when the session expires
- A **logging interceptor** (debug builds only) that prints request/response details

```dart
// Conceptual Dio setup
final dio = Dio(BaseOptions(
  baseUrl: AppConstants.apiBaseUrl,
  headers: {'Content-Type': 'application/json'},
));
dio.interceptors.add(CookieInterceptor());
dio.interceptors.add(AuthInterceptor(onUnauthorised: router.go('/login')));
```

---

## Authentication

The vendor app registers and signs in via the Planovar API (`/api/auth/*`), which is handled by Better Auth. The app always sends `role: "VENDOR"` during registration — the role is implicit from which app the user is in, never a UI choice.

Auth session is stored as an HTTP-only cookie managed by Better Auth. The app uses `flutter_secure_storage` to cache the session token locally so the user stays logged in across app restarts.

**Auth flow:**

```
1. User enters email + password
2. App calls POST /api/auth/sign-up/email (with role: "VENDOR")
3. API sends OTP to email
4. User enters OTP → POST /api/auth/email-otp/verify-email
5. User signs in → POST /api/auth/sign-in/email
6. Session cookie stored securely
7. All subsequent API calls include the cookie
8. If vendor profile is incomplete → redirect to /onboarding
```

---

## Vendor-specific features

These features exist in the vendor app but not the client app:

| Feature | Description |
|---|---|
| **Listing management** | Create, edit, deactivate listings with media, packages, and pricing |
| **Booking requests** | View incoming requests, accept or decline |
| **Quote builder** | Create a formal quote with line items, validity period, terms |
| **Earnings dashboard** | View completed payouts, pending amounts, commission breakdown per booking |
| **Review responses** | Reply publicly to client reviews |
| **Bank details** | Add bank account for Paystack payouts |
| **Subscription management** | Upgrade/downgrade subscription tier (Basic → Featured → Premium) |
| **Availability** | Set unavailable dates to block bookings |

---

## Folder depth rule

Keep feature folders flat. If a widget is only used in one screen, it lives in `features/<name>/ui/widgets/`. If it's used across two or more features, it moves to `shared/widgets/`.

---

## Web-specific considerations

When running as a Flutter web app:

- `flutter_secure_storage` falls back to `localStorage` encryption on web — this is acceptable for session tokens
- File picker for listing media uses `file_picker` (web-compatible) rather than the camera
- Deep links use standard URL paths — go_router handles these natively on web
- The web build is served as a static bundle; the API handles all data
