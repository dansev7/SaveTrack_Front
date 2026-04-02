import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../auth/auth_provider.dart';
import 'profile_provider.dart';
import 'edit_profile_sheet.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Logout', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to log out?', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel', style: TextStyle(color: Colors.grey))),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ref.read(authControllerProvider.notifier).logout();
              context.go('/login');
            },
            child: const Text('Logout', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        title: const Text('My Profile', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: Colors.tealAccent)),
        error: (err, stack) => Center(child: Text(err.toString(), style: const TextStyle(color: Colors.redAccent))),
        data: (profile) {
          if (profile == null) return const Center(child: Text("No profile data."));
          
          final initial = profile.name.isNotEmpty ? profile.name[0].toUpperCase() : '?';

          return RefreshIndicator(
            color: Colors.tealAccent, backgroundColor: const Color(0xFF1E1E1E),
            onRefresh: () async => ref.invalidate(profileControllerProvider),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                // Avatar
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.tealAccent.withOpacity(0.1),
                    child: Text(initial, style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.tealAccent)),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Details Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.person, color: Colors.white54),
                        title: const Text("Name", style: TextStyle(color: Colors.white54, fontSize: 14)),
                        subtitle: Text(profile.name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.tealAccent),
                          onPressed: () => showModalBottomSheet(
                            context: context, isScrollControlled: true,
                            backgroundColor: const Color(0xFF1E1E1E),
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
                            builder: (context) => EditProfileSheet(currentName: profile.name),
                          ),
                        ),
                      ),
                      const Divider(color: Colors.white12, height: 1),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.email, color: Colors.white54),
                        title: const Text("Email", style: TextStyle(color: Colors.white54, fontSize: 14)),
                        subtitle: Text(profile.email, style: const TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                
                // Logout Button
                OutlinedButton.icon(
                  onPressed: () => _showLogoutDialog(context, ref),
                  icon: const Icon(Icons.logout, color: Colors.redAccent),
                  label: const Text("Log Out", style: TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Colors.redAccent),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}