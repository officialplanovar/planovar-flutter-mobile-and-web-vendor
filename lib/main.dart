import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'core/router/router.dart';
import 'features/auth/bloc/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>.value(value: widget.themeCubit),
        BlocProvider<AuthBloc>(create: (_) => AuthBloc()),
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
