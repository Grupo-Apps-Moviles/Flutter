import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waypass_app/core/di/dependency_injection.dart';
import 'package:waypass_app/features/auth/data/token_manager.dart';
import 'package:waypass_app/features/favorite/presentation/favorite_page.dart';
import 'package:waypass_app/features/favorite/presentation/favorite_view_model.dart';
import 'package:waypass_app/features/profile/presentation/profile_page.dart';
import 'package:waypass_app/features/reservation/presentation/reservation_page.dart';
import 'package:waypass_app/features/travel/presentation/travel_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    ProfilePage(),
    TravelPage(),
    ReservationPage(),
    FavoritePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final vm = getIt<FavoriteViewModel>();
        final userId = getIt<TokenManager>().getUserId() ?? 0;
        vm.loadFavorites(userId);
        return vm;
      },
      child: Scaffold(
        body: pages[selectedIndex],
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: (value) {
            setState(() {
              selectedIndex = value;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Profile',
            ),
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Travel',
            ),
            NavigationDestination(
              icon: Icon(Icons.receipt_long_outlined),
              selectedIcon: Icon(Icons.receipt_long),
              label: 'Reservation',
            ),
            NavigationDestination(
              icon: Icon(Icons.favorite_outline),
              selectedIcon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
          ],
        ),
      ),
    );
  }
}
