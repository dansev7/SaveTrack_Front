import 'package:go_router/go_router.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/register_screen.dart'; // <-- Add this import
import '../../core/di/service_locator.dart';
import '../../features/auth/auth_notifier.dart';
import 'main_layout.dart';
import '../../features/dashboard/dashboard_models.dart';
final appRouter = GoRouter(
  initialLocation: '/login',
  refreshListenable: getIt<AuthNotifier>(),
  redirect: (context, state) {
    final authNotifier = getIt<AuthNotifier>();
    final isLoggedIn = authNotifier.isLoggedIn;
    
    // Check if the user is on ANY auth screen
    final isAuthRoute = state.matchedLocation == '/login' || state.matchedLocation == '/register';

    // If not logged in, AND trying to access a protected route -> Send to Login
    if (!isLoggedIn && !isAuthRoute) {
      return '/login';
    }
    // If logged in, AND trying to access Login/Register -> Send to Dashboard
    if (isLoggedIn && isAuthRoute) {
      return '/dashboard';
    }
    return null; // Let them proceed normally
  },
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    // 👇 Add the Register Route
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const MainLayout(),
    ),

  ],
);