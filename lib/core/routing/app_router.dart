import 'package:go_router/go_router.dart';
import '../../features/auth/login_screen.dart';
import '../../features/transactions/create_transaction_screen.dart';
import '../storage/storage_service.dart';
import 'main_layout.dart'; // <-- This must be imported

final appRouter = GoRouter(
  initialLocation: '/login',
  redirect: (context, state) {
    final token = StorageService.getToken();
    final isLoggedIn = token != null && token.isNotEmpty;
    final isLoggingIn = state.matchedLocation == '/login';

    if (!isLoggedIn && !isLoggingIn) {
      return '/login';
    }
    if (isLoggedIn && isLoggingIn) {
      return '/dashboard'; 
    }
    return null; 
  },
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      // 👇 CRITICAL: This must be MainLayout, not DashboardScreen
      builder: (context, state) => const MainLayout(),
    ),
    GoRoute(
      path: '/create-transaction',
      builder: (context, state) => const CreateTransactionScreen(),
    ),
  ],
);