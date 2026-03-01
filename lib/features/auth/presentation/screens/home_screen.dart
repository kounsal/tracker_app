import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/theme/theme.extension.dart';
import '../provider/home_provider.dart';
import 'tabs/home_tab.dart';
import 'tabs/profile_tab.dart';

class HomeScreen extends StatefulWidget {
  final int? initialTab;
  final bool? refreshData;

  const HomeScreen({super.key, this.initialTab, this.refreshData});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> _tabs = const [HomeTab(), ProfileTab()];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialTab != null) {
        context.read<HomeProvider>().setBottomNavIndex(widget.initialTab!);
      }
      if (widget.refreshData == true) {
        context.read<HomeProvider>().fetchDashboardData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, child) {
        return Scaffold(
          backgroundColor: context.colors.background,
          body: IndexedStack(index: homeProvider.currentIndex, children: _tabs),
          bottomNavigationBar: _buildBottomNav(context, homeProvider),
        );
      },
    );
  }

  Widget _buildBottomNav(BuildContext context, HomeProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: BottomNavigationBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            currentIndex: provider.currentIndex,
            onTap: provider.setBottomNavIndex,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: context.colors.brandColor,
            unselectedItemColor: context.colors.textSecondary,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
