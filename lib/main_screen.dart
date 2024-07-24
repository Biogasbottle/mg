import 'package:dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monitor/presentation/monitor_view.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final List<Widget> destinations;
  @override
  void initState() {
    destinations = [
      const MonitorView(),
      const DashboardView(),
      const PicturesView(),
      const SettingPage(),
      // Container()
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppMenuCubit, AppMenuState>(
      builder: (context, state) {
        return Scaffold(
          key: context.read<AppMenuCubit>().scaffoldKey,
          drawer: SideMenu(
            selected: state.index,
          ),
          body: SafeArea(
              child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // We want this side menu only for large screen
              if (Responsive.isDesktop(context))
                Expanded(
                  // default flex = 1
                  // and it takes 1/6 part of the screen
                  child: NavigationMenu(selected: state.index),
                ),
              Expanded(
                // It takes 5/6 part of the screen
                flex: 10,
                // child: DashboardScreen(),
                child: destinations[state.index],
              ),
            ],
          )),
        );
      },
    );
  }
}

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key, required this.selected});

  final int selected;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: DashboardColors.blockBackground,
      child: ListView(
        children: [
          SizedBox(
            height: 100,
            child: Image.asset(
              'assets/images/logo.png',
              package: DashboardTexts.dashboardPackageName,
            ),
          ),
          DrawerListTile(
              icon: Icons.monitor, index: 0, selected: selected == 0),
          DrawerListTile(
              icon: Icons.dashboard, index: 1, selected: selected == 1),
          DrawerListTile(icon: Icons.image, index: 2, selected: selected == 2),
          DrawerListTile(
              icon: Icons.settings, index: 3, selected: selected == 3),
        ],
      ),
    );
  }
}

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
