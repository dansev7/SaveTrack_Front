import 'package:go_router/go_router.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/register_screen.dart'; // <-- Add this import
import '../storage/storage_service.dart';
import 'main_layout.dart';
import '../../features/dashboard/dashboard_models.dart';
final appRouter = GoRouter(
  initialLocation: '/login',
  redirect: (context, state) {
    final token = StorageService.getToken();
    final isLoggedIn = token != null && token.isNotEmpty;
    
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