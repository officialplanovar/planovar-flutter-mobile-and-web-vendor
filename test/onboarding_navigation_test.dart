import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:planovar_vendor/core/router/app_routes.dart';
import 'package:planovar_vendor/core/theme/app_theme.dart';
import 'package:planovar_vendor/features/auth/bloc/auth_bloc.dart';
import 'package:planovar_vendor/features/auth/ui/onboarding_screen.dart';
import 'package:planovar_vendor/features/auth/ui/register_screen.dart';

/// Reproduction test for the "List my business" freeze.
///
/// Drives onboarding → register through go_router (the real route paths, so the
/// screen's `context.go(AppRoutes.register)` works). A UI freeze (infinite
/// rebuild/animation) would make `pumpAndSettle` time out and fail here.
void main() {
  setUp(() {
    GoogleFonts.config.allowRuntimeFetching = false; // no network in tests
    SharedPreferences.setMockInitialValues({});
  });

  Widget harness() {
    final router = GoRouter(
      initialLocation: AppRoutes.onboarding,
      routes: [
        GoRoute(path: AppRoutes.onboarding, builder: (_, _) => const OnboardingScreen()),
        GoRoute(path: AppRoutes.register, builder: (_, _) => const RegisterScreen()),
      ],
    );
    return BlocProvider<AuthBloc>(
      create: (_) => AuthBloc(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        routerConfig: router,
      ),
    );
  }

  const settleTimeout = Duration(seconds: 20);
  Future<void> settle(WidgetTester t) => t.pumpAndSettle(
      const Duration(milliseconds: 100), EnginePhase.sendSemanticsUpdate, settleTimeout);

  testWidgets('onboarding → "List my business" navigates to register (no freeze)',
      (tester) async {
    // Use a realistic tall phone surface (default test view is 800×600).
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(harness());
    await settle(tester);

    expect(find.byType(OnboardingScreen), findsOneWidget);
    expect(find.byType(PageView), findsOneWidget);

    // Swipe to the last slide where the CTA lives.
    for (var i = 0; i < 2; i++) {
      await tester.fling(find.byType(PageView), const Offset(-500, 0), 1200);
      await settle(tester);
    }

    final cta = find.text('List my business');
    expect(cta, findsOneWidget);

    await tester.tap(cta);
    // If clicking froze the app, this would time out instead of settling.
    await settle(tester);

    expect(find.byType(RegisterScreen), findsOneWidget);
    expect(find.text('Create your vendor account'), findsOneWidget);
  });
}
