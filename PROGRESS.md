# planovar-vendor (Flutter) — Progress Log

Living log. Newest entries on top. Full plan: repo-root `PLANOVAR_BUILD_PLAN.md`.
**Prioritised first** (MoM #25 — vendor app leads the launch campaign).

## Status snapshot — ✅ PHASE 2 COMPLETE (vendor app wired to API)

### 2026-06-10 — Phase 2 wiring (part 2): order actions, quotes, reviews, home ✅
- **Order detail**: loads the live booking from OrdersCubit (loader if absent); status-driven bottom
  bar — PENDING → Decline / **Accept Inquiry**, CONFIRMED → **Mark as Completed** (green), both via
  cubit→API with SnackBar feedback; **Send Quote** button (PENDING/CONFIRMED) routes to the quote
  builder with `?bookingId=`. Old transactional payment-dialog text de-mocked.
- **Quote builder** (`create_quote_screen`): accepts optional `bookingId`; **Create Quote now POSTs
  /quotes** (line items from the editors, validUntil from the "valid for" picker, non-default payment
  terms folded into notes — terms are off-platform info). Without bookingId (chat flow) it explains
  in-chat quoting ships with messaging (Phase 4). New `messaging/data/quotes_repository.dart`.
- **Reviews** (`profile/ui/reviews_screen.dart`): fully rebuilt on live data — summary card (live avg +
  star breakdown computed from data), review cards w/ reviewer/title/body/time-ago, **Reply** bottom
  sheet → POST /reviews/:id/respond (one reply; reply shown under the review), empty/error/retry +
  pull-to-refresh. New `reviews/data/reviews_repository.dart` (resolves vendor id via /vendors/me).
- **Home dashboard**: real vendor profile (name/rating/reviewCount via VendorRepository), greeting from
  AuthBloc user, **Action-Needed banner + stats fed by /bookings/inbox/summary** (confirmed/pending);
  earnings stat replaced with bookings count (no platform earnings under subscription-only model).
  Today's Schedule still mock (needs calendar — later phase).
- `flutter analyze` → 0 errors.

## (previous) Status snapshot
- **Current phase:** ✅ Phase 1.5 complete & functional — auth UI now dispatches to AuthBloc →
  AuthRepository → real `/api/auth/*` (token stored in secure storage), which unblocks the onboarding
  wizard submit. Verified the endpoint contract at runtime (sign-up/sign-in/get-session 200,
  verify-email/send-otp routes exist). Remaining vendor-app work = Phase 2.
  `flutter analyze` → 0 errors / 0 warnings.
- **API base:** `--dart-define=API_BASE_URL` (default `http://localhost:3000`).
- **Auth transport:** Better Auth **bearer token** (`set-auth-token` header → `flutter_secure_storage`).

## Log

### 2026-06-18 — Paid-plan checkout step (in-app Paystack WebView) ✅
- New `features/setup/ui/payment_checkout_screen.dart` (`webview_flutter`): loads the Paystack
  `checkoutUrl`, watches navigation for the `callback_url`, pops `true` on payment / `false` on close.
- `SetupCubit` passes `paymentCallbackUrl` (`https://planovar.app/payment/complete`) to subscribe; backend
  Paystack adapter forwards it as Paystack `callback_url`.
- KYC screen's success listener now opens the checkout WebView when `state.checkoutUrl` is set (paid
  plans) before routing to the success screen; Basic (no checkoutUrl) goes straight through.
- **Post-checkout verification**: after the WebView returns, `SetupCubit.currentSubscriptionStatus()`
  re-fetches `/subscriptions/me`; a SnackBar surfaces the live status / "complete payment later" if the
  user closed without paying or the sub couldn't be confirmed. Then routes to success.
- Subscription is created `trialing` server-side at subscribe time, so the vendor is onboarded regardless
  of whether they finish the card capture. Added `webview_flutter` dep (needs a **full rebuild**).
- `flutter analyze` → no new issues. End-to-end paid payment still needs a valid `PAYSTACK_SECRET_KEY`.

### 2026-06-18 — Replaced ALL mock data across the vendor app ✅ — analyze: 0 errors/0 warnings
- **Wired to real backends:** profile + edit-profile (VendorRepository.getMe + AuthBloc), support greeting,
  listing detail / out-of-stock / edit-listing (ListingsCubit + `/listings/:id` update), action-needed
  (OrdersCubit PENDING), cancel-order (OrdersCubit.reject), create-quote / create-invoice / conversation
  quote-bubble (MessagingService + VendorRepository), analytics (real counts from listings/orders/rating),
  delete-account (AuthBloc). `VendorModel` gained `logoUrl`.
- **Backendless → honest states (no fake numbers):** payouts → "you keep 100%, subscription model" info
  screen (was fake ₦430k escrow); order-tracking list + detail → "coming soon" (no tracking API);
  leave-review → de-mocked (no vendor→client review endpoint, submit stays local); today's-schedule →
  empty state.
- **Result:** no `MockData.*` value renders anywhere. `mock_data.dart` is referenced only for the
  `ScheduleItem` type by home; `mock_auth_service.dart` is orphaned. Removed the fake "2 active events"
  delete warning. `flutter analyze` → 0 errors, 0 warnings (only pre-existing style infos remain).

### 2026-06-18 — Home dashboard: real vendor data (was falling back to mock) ✅
- Root cause of "dashboard still dummy after onboarding": `VendorRepository.getMe()` threw on the
  `ratingAvg` String→num cast (see fix below) and the home `.catchError((_){})` swallowed it →
  `_vendor` stayed null → `MockData.currentVendor`. With the parser fix, `getMe()` now resolves and the
  header/stats show the real vendor. (Verified `/vendors/me` returns `businessName`, `ratingAvg:"0"`.)
- Removed remaining hardcoded dummies on the dashboard: **location** now derived from
  `vendor.location` (city, country) instead of literal "Abuja, Nigeria"; **Today's Schedule** now shows
  its empty state (`No schedule for today`) instead of `MockData.todaySchedule` (no calendar backend yet).
- `flutter analyze` → clean.

### 2026-06-18 — Fix: VendorModel.fromJson crash on onboard response ✅
- `ratingAvg: (json['ratingAvg'] as num)` threw `String is not a subtype of num` — the API serializes
  Prisma **Decimal as a String** (`"0"`). This made `onboard()` appear to fail even though the server
  created the profile (the client crashed parsing the response), cascading into the "already exists" /
  cast errors during setup. Now parsed tolerantly via `_toDouble`/`_toInt` (num **or** String).
- Also made `SetupCubit.submit` swallow "active subscription already exists" so re-runs finish.

### 2026-06-18 — KYC step: NIN + CAC uploads wired ✅
- `SetupKycScreen` → StatefulWidget; both boxes now pick a file (`file_picker`, JPG/PNG/**PDF**, ≤5 MB) and
  upload via `POST /upload/attachment` with per-box loading + "✓ filename / Tap to replace" states.
- On **Finish setup** the URLs flow through `SetupCubit.setKyc(ninUrl, cacUrl)` → `submitKyc` (NIN required,
  CAC optional). Preserves the profile-step proof if no CAC uploaded here (`cacUrl ?? cubit.cacUrl`).
- Reuses the `file_picker` + `UploadService` added for the profile step (no new native dep). `flutter
  analyze` → no new issues.

### 2026-06-19 — Checkout: open in device browser (WebView didn't render) ✅
- The in-app WebView never rendered Paystack's checkout SPA (esp. on emulators). Switched
  `PaymentCheckoutScreen` to **`url_launcher`** (external browser) + an "I've completed payment" /
  "Cancel" prompt; takes `(checkoutUrl, reference)` and pops the reference on confirm → caller verifies.
- Subscription screen + setup KYC flow pass the Paystack `reference` (now captured in `SetupState`).
  Added `url_launcher` dep (needs a **full rebuild**). `webview_flutter` no longer used by checkout.
- Paystack adapter now logs the initialize request + response (with checkout URL) and verify result in
  dev (`NODE_ENV != production`), minus the secret-bearing header.

### 2026-06-19 — Paid upgrade: payment-gated + verify wired ✅
- Paid plan now opens Paystack checkout, the WebView returns the **reference** (from the callback query),
  and the app calls `POST /subscriptions/verify` before activating (subscription screen + setup KYC flow).
  Closing checkout without paying leaves the plan unchanged. Plan model shows ₦/$ per currency.
- WebView: clears the loading overlay on `onPageFinished`/`onWebResourceError` (fixes the stuck spinner).

### 2026-06-19 — Plan upgrade flow (Subscription & Plan screen) ✅ — verified E2E
- **Profile → "Subscription & Plan"** (new menu item) opens a real `SubscriptionPlanScreen` (was a
  placeholder): loads `/subscriptions/plans` + `/subscriptions/me`, shows each plan with price/limit/
  features, marks the **Current/On-trial** plan, and offers **Upgrade/Switch** on the others.
- Selecting a plan calls new `SubscriptionRepository.changePlan` → `POST /subscriptions/change`; paid
  plans open the Paystack checkout WebView, then the screen refreshes.
- **API** `changePlan`: ends the current sub then subscribes to the chosen plan; **no-op** if same plan;
  **rolls the old plan back** if the new one fails to start (e.g. payment init error) so the vendor is
  never left planless. Verified E2E (same-plan no-op; paid upgrade 503 → still BASIC/ACTIVE via rollback).

### 2026-06-19 — Create-service & create-product: photo upload wired ✅ — verified E2E
- The 4 photo boxes in **Add a Service** and **Add a Product** now pick (`image_picker`) → upload
  (`POST /upload/listing/image`) → show a preview with a remove ✕ + per-slot spinner (was a
  "coming soon" SnackBar). New `UploadService.uploadListingImage`.
- `ListingsRepository.create` gained `mediaUrls`; passed on publish. **API:** `CreateListingDto.mediaUrls`
  + `ListingsService.create` nested-creates `ListingMedia` rows (type IMAGE, ordered).
- **Verified E2E**: upload → Cloudinary URL; create listing with `mediaUrls` → 201 with `media` persisted.

### 2026-06-18 — Business Setup: live categories + real uploads ✅
- **Category tags** now load from the backend (`GET /categories` via `ListingsRepository.categories()`)
  instead of a hardcoded list — with loading / empty / error+Retry states. Selected names → vendor `tags`.
- **Business logo upload**: tap → `image_picker` → `POST /upload/vendor/logo` → preview in the circle;
  URL threaded through `SetupCubit.logoUrl` → `vendors.onboard(logoUrl:)`.
- **Proof of ownership upload**: tap → `file_picker` (JPG/PNG/**PDF**, ≤5 MB) → `POST /upload/attachment`
  → "uploaded ✓ filename" state; URL stored as `SetupCubit.cacUrl` (flows to KYC submit).
- New `core/services/upload_service.dart` (Dio multipart, sends bytes → web + mobile safe); removed the
  "Coming soon" sheet. Added `file_picker` dep. Uploads verified hitting Cloudinary. `flutter analyze`
  → no new issues.

### 2026-06-17 — Glossy buttons + "List my business" freeze investigation ✅
- **Glossy buttons**: ported the client's gloss to vendor `AppButton` primary — coloured glow `boxShadow`
  + a `ClipRRect` Stack with a top white sheen + upper-left specular highlight (disabled state dims both).
  Every primary button across the app now matches the client's glassy look.
- **Freeze investigation** (`test/onboarding_navigation_test.dart`): automated widget test drives the real
  router onboarding → "List my business" → register. **Result: navigates in ~1s, NO infinite loop** — so
  the "freeze" is not a logic hang in that flow. The test only surfaced a layout **overflow** at
  `register_screen.dart:323` (the "Already have an account? Sign in" Row) → fixed by switching it to a
  `Wrap`. Test now green.
- **Most likely real cause + fix**: the logo I'd just added decoded the 1280×1280 PNG at full size on the
  onboarding screen (~6.5 MB bitmap) — heavy enough to stall a simulator. Added `cacheWidth: 720` +
  `errorBuilder` to `PlanovarLogo`, cutting its decode footprint ~70%. `flutter analyze` clean.

### 2026-06-17 — Brand logo applied (splash + onboarding) ✅
- Added the real Planovar lockup assets (`assets/images/logo/planovar_logo_{light,dark}.png`) to pubspec
  (the `logo/` subfolder wasn't declared — Flutter asset dirs aren't recursive).
- New `core/widgets/planovar_logo.dart` (`PlanovarLogo`) — theme-aware (light artwork on light surfaces,
  dark on dark); `dark:` overridable.
- **Splash**: replaced the "P" box + "PLANOVAR"/"VENDOR" text with the full logo (light variant on the
  white splash) + a "VENDOR" sub-label.
- **Onboarding header**: replaced the small "P" box + "Planovar" text with `PlanovarLogo(height: 40)`.
- These were the only two logo marks in the app (login/register/home have none). `flutter analyze` → clean.
- ⚠️ New assets require a **full restart** (not hot reload) to bundle. Native launch screen (pre-Flutter
  white screen) is separate and untouched — say the word to set it via flutter_native_splash.

### 2026-06-16 — Phase 4: vendor real-time chat + notifications wired ✅
- (voice) Added `core/services/call_service.dart` + `features/calls/call_screen.dart` + call button in
  conversation header + socket call:invite/incoming; mic perms (iOS+Android). Gold-gated server-side.
- New `core/services/chat_socket.dart` (Socket.io `/chat`, bearer via auth.token) +
  `core/services/messaging_service.dart` (maps the CLIENT as the other party; computes `isMe`).
- `conversation_screen` (thread) loads history via REST + sends/receives **live over the socket**;
  `messages_screen` (list) loads real conversations. `_currentUserId` from AuthBloc.
- New `core/services/notification_service.dart`; notifications screen loads `GET /notifications`,
  mark-read + mark-all-read wired.
- **Live client↔vendor socket round-trip verified** end-to-end (Node socket.io test: client emits →
  vendor receives via gateway). `flutter analyze` (messaging+notifications) → 0 errors/0 warnings.
- ⏭️ Phase 4 voice (LiveKit) NOT started — greenfield + blocked (no LiveKit creds, no call-screen design).

### 2026-06-15 — Fix: onboarding freeze after images bundled ✅
- Symptom: app froze on the onboarding/"List my business" screen — started exactly when the hero
  PNGs began loading (after the pubspec asset fix); before that the errorBuilder showed icons (no freeze).
- Diagnosis: large source PNGs (1179×1280, ~6MB decoded each ×3) — heavy to decode/upload on slower
  runtimes. (Headless web preview loaded fine with no Dart errors, ruling out a code crash.)
- Fix: downscaled onboarding_{1,2,3}.png to 820px wide + added `cacheWidth: 820` /
  `filterQuality.medium` to the `Image.asset`. Needs a FULL restart (new asset bytes) to take effect.

### 2026-06-15 — Onboarding hero illustrations (stopgap from designs) ✅
- Cropped the hero region (phone mockup + swooshes + sticker + pills) from the 3 design mockups
  (`designs/vendor/onboarding.zip`) → `assets/images/onboarding/onboarding_{1,2,3}.png` (1179×1280).
- `onboarding_screen.dart`: `_OnboardingSlide` now uses `image` (+`fallbackIcon`); the 120px icon
  circle replaced by `Image.asset(..., height 320, errorBuilder→icon fallback)`.
- Copy de-payouted (subscription-only): slide 2 "inquiries/bookings/conversations"; slide 3
  "Showcase your work, get discovered" (list products/services/rentals → subscribe → ranking).
- Slide 3 image: replaced the old Escrow/Auto-Payouts mockup with the real **"My Listings"** in-app
  screen (cropped from Listtings.png, rounded-corner transparent PNG) — now matches the copy + model.
- Remaining art polish: slides 1–2 still have the design's light bg baked in (not dark-mode adaptive);
  swap for transparent Figma exports when available. No code change needed (same paths).

### 2026-06-10 — Phase 2 wiring (part 1): Listings + Orders on real API ✅
- **Shared:** `core/api/api_utils.dart` (`ensureOk` — surfaces API error messages incl. tier-limit 403s).
- **ListingModel.fromJson** made API-tolerant: Prisma Decimal-as-string (`basePrice` etc.), nested
  `category` → categoryId/categoryName, `media[]` → mediaUrls. (Old parser would crash on real data.)
- **Listings:** `listings_repository.dart` (listMine/getById/create/update/setActive/delete/categories) +
  `listings_cubit.dart`; `listings_screen` now loads from API (loading/error/retry + pull-to-refresh,
  tabs/counts off live data). `add_product_screen` + `add_service_screen` **Publish now calls the API**
  (loading state; backend tier-limit 403 shown as SnackBar; category = picker/tag best-effort match —
  TODO: real category picker for products). ListingsCubit refreshes after create.
- **Orders/Inquiries:** `bookings_repository.dart` (listMine/inboxSummary/confirm/reject/complete;
  maps API bookings → OrderModel; statuses pass through UPPERCASE) + `orders_cubit.dart`;
  `orders_screen` filters/counts now off live data ("Upcoming" = PENDING+CONFIRMED, PENDING chip =
  "Awaiting response"). Tracking tab still mock (rental delivery tracking is post-MVP).
- Cubits registered in main.dart. `flutter analyze` → 0 errors.
- **Remaining wiring:** order-detail accept/decline/complete buttons, quotes screens, reviews screen,
  home dashboard ("Action Needed" ← inbox/summary).

### 2026-06-10 — Phase 1.5d: auth UI screens wired to AuthBloc ✅
- register/login/verify-email/forgot-password now dispatch to AuthBloc via localized `BlocConsumer`
  (loading state + error SnackBars + state-driven navigation) instead of navigating blindly:
  register→AuthSignUpRequested (now incl. phone, +234) →AuthOtpSent→verify; verify→AuthOtpVerifyRequested
  →AuthOtpVerified→setup; login→AuthSignInRequested→AuthAuthenticated→home; forgot→AuthForgotPasswordRequested.
- Removed the mock `_signIn`/`_sendResetLink` delays; threaded `phone` through signUp event→repo→data source.
- Runtime-verified the Better Auth endpoint contract on :3010 (sign-up/sign-in/get-session 200;
  verify-email + send-verification-otp routes return 400 not 404). Token captured via `set-auth-token`.
- This makes the full vendor vertical functional: register → OTP → onboarding wizard → onboard/subscribe.

### 2026-06-10 — Phase 1.5c: onboarding wizard wired end-to-end ✅
- New `features/setup/bloc/setup_cubit.dart` — collects businessType/profile/location/plan/KYC across
  the wizard and submits **onboard → subscribe → submitKyc**; provided at app root.
- Wizard screens now write into the cubit on Proceed (business type, profile desc+tags, location
  country/city/vendorType, plan selection).
- New **`SetupKycScreen`** (NIN/CAC; upload "coming soon") whose "Finish setup" calls `submit()`
  (businessName from AuthBloc) → success on completion, SnackBar on error. Added `setupKyc` route.
- Flow is now: business-type → profile → location → plan(live) → **KYC** → submit → success.
  The payout step is bypassed (legacy, kept but unrouted — subscription-only model).
- `flutter analyze` → 0 errors.

### 2026-06-10 — Phase 1.5b: vendor + subscription data layer; plan screen live ✅
- New `shared/models/subscription_plan_model.dart` (handles Prisma Decimal-as-string; price labels).
- New `features/subscription/data/subscription_repository.dart` (listPlans, getMySubscription, subscribe
  with `x-device-id`, cancel) and `features/vendor/data/vendor_repository.dart` (onboard, getMe, submitKyc).
- `SetupPlanScreen` now loads **live plans from the API** (Basic/Premium/Gold, USD) via FutureBuilder +
  retry, replacing the hardcoded NGN Featured/Premium cards. Premium flagged POPULAR.
- Remaining 1.5: SetupCubit to thread businessType/profile/location/plan/KYC and call
  onboard→subscribe→submitKyc on completion; add a KYC screen; remove the (now-irrelevant) payout step.
- `flutter analyze` → 0 errors.

### 2026-06-10 — Phase 1.5a: API foundation + auth wired ✅
- Added `core/api/api_client.dart` (Dio + bearer-token interceptor, 4xx pass-through) and
  `core/api/token_store.dart` (secure-storage token).
- Added `features/auth/data/auth_remote_data_source.dart` (Better Auth /api/auth/* calls; captures
  `set-auth-token`) + `auth_repository.dart` (same method shapes as the old mock → drop-in).
- `AuthBloc` now uses `AuthRepository` instead of `MockAuthService`; sign-out clears the token.
- Backend dependency: enabled Better Auth `bearer()` plugin so mobile uses tokens, not cookies.
- Verified: `flutter pub get` ok, `flutter analyze` 0 errors.

### (superseded) — initial mock-backed UI

### 2026-06-09 — Phase 0 touch-points
- No code changes this phase. Noted: API base URL must point at port **3000**.
- Design audit confirmed scope: subscription tiers (Basic/Premium/Gold USD, 45-day trial), listings
  (products/services/rentals), KYC (NIN+CAC), inquiry/booking (payment-free), chat, quotes, reviews,
  language preference EN/FR/ES, voice (Gold-only). Vendor designs still show escrow/payout/commission —
  those are dropped under subscription-only mode.

## Next (Phase 1–2)
- Stand up real API client + repository layer (Dio + interceptors + secure storage); add i18n (EN/FR/ES).
- Phase 1: wire onboarding → OTP → business profile → category tags → location → choose plan → KYC → dashboard.
  Fix tier button labels to Basic/Premium/Gold.
- Phase 2: listings CRUD (products/services/rentals, tier limits), storefront customisation, inquiry inbox,
  quotes (price proposal), reviews. Remove payout/escrow screens.
