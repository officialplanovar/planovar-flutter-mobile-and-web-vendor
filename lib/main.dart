import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/api/token_store.dart';
import 'core/router/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'core/router/router.dart';
import 'core/utils/deep_link_auth.dart';
import 'core/utils/oauth_redirect.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/setup/bloc/setup_cubit.dart';
import 'features/listings/bloc/listings_cubit.dart';
import 'features/orders/bloc/orders_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Google sign-in return trip. Web: the token relay appends the bearer token
  // to the app URL — capture it before boot, then scrub it from the address
  // bar. Native: the relay redirects to the planovarvendor:// deep link —
  // capture the cold-start token here (warm links handled in the app state).
  if (kIsWeb) {
    final relayToken = Uri.base.queryParameters['planovar_token'];
    if (relayToken != null && relayToken.isNotEmpty) {
      await TokenStore().save(relayToken);
      clearOAuthParams();
    }
  } else {
    final token = await DeepLinkAuth().initialToken();
    if (token != null) await TokenStore().save(token);
  }
  final themeCubit = ThemeCubit();
  await themeCubit.load();
  runApp(PlanovarVendorApp(themeCubit: themeCubit));
}

class PlanovarVendorApp extends StatefulWidget {
  final ThemeCubit themeCubit;

  const PlanovarVendorApp({super.key, required this.themeCubit});

  @override
  State<PlanovarVendorApp> createState() => _PlanovarVendorAppState();
}

class _PlanovarVendorAppState extends State<PlanovarVendorApp> {
  late final _router = createRouter();

  @override
  void initState() {
    super.initState();
    // Warm-start OAuth deep links (app already running): store the relayed
    // token and bounce through splash so the session check re-runs.
    if (!kIsWeb) {
      DeepLinkAuth().listen((token) async {
        await TokenStore().save(token);
        if (mounted) _router.go(AppRoutes.splash);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>.value(value: widget.themeCubit),
        BlocProvider<AuthBloc>(create: (_) => AuthBloc()),
        BlocProvider<SetupCubit>(create: (_) => SetupCubit()),
        BlocProvider<ListingsCubit>(create: (_) => ListingsCubit()),
        BlocProvider<OrdersCubit>(create: (_) => OrdersCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        bloc: widget.themeCubit,
        builder: (context, themeMode) {
          return MaterialApp.router(
            title: 'Planovar Vendor',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: themeMode,
            routerConfig: _router,
          );
        },
      ),
    );
  }
}
