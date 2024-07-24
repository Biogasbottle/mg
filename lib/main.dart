import 'package:dashboard/cubits/pictures_cubit.dart';
import 'package:dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:monitor/bloc/monitor_cubit.dart';
import 'package:monitor/bloc/scheduler_cubit.dart';
import 'package:monitor/bloc/socket_cubit.dart';
import 'package:monitor/bloc/theme_cubit.dart';
import 'package:monitor/socket_api/socket_api.dart';

import 'log.dart';
import 'main_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();

  runApp(MgVisionApp(socketApi: SocketApi()));
}

class SimpleBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    logger.d('BlocObserver onChange ${bloc.runtimeType} ');
  }

  @override
  void onTransition(
      Bloc<dynamic, dynamic> bloc, Transition<dynamic, dynamic> transition) {
    super.onTransition(bloc, transition);
    logger.d('SimpleBlocObserver onTransition ${bloc.runtimeType} ');
  }
}

class MgVisionApp extends StatelessWidget {
  const MgVisionApp({super.key, required SocketApi socketApi})
      : _socketApi = socketApi;
  final SocketApi _socketApi;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _socketApi,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => ThemeCubit(),
          ),
          BlocProvider<MonitorCubit>(
            create: (BuildContext context) => MonitorCubit(_socketApi),
          ),
          BlocProvider<SchedulerCubit>(
            create: (BuildContext context) => SchedulerCubit(_socketApi),
          ),
          BlocProvider<SocketCubit>(
            create: (BuildContext context) => SocketCubit(_socketApi),
          ),
          BlocProvider(
            create: (_) => DashboardCubit(),
          ),
          BlocProvider(
            create: (_) => PicturesCubit(),
          ),
          BlocProvider(
            create: (_) => AppMenuCubit(),
          ),
        ],
        child: const MgVisionAppView(),
      ),
    );
  }
}

class MgVisionAppView extends StatelessWidget {
  const MgVisionAppView({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, Color>(
      builder: (context, color) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          // title: 'MgVision Detector',
          theme: ThemeData(
              colorScheme: const ColorScheme.light(
                surface: DashboardColors.background,
              ),
              scaffoldBackgroundColor: DashboardColors.background,
              useMaterial3: true,
              scrollbarTheme: ScrollbarThemeData(
                thumbVisibility: WidgetStateProperty.all<bool>(true),
              )),
          supportedLocales: const [Locale('en', ''), Locale('zh', '')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const MainScreen(),
        );
      },
    );
  }
}
