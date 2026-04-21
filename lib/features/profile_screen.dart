// lib/features/profile_screen.dart
// ─── Screen-level logic only ───────────────────────────────────────────────────
// Sub-widgets live in lib/widgets/profile_widgets.dart — do NOT add new widget
// classes here.  Keep this file focused on: state (logout, address CRUD),
// and the Scaffold / SliverAppBar composition.
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../providers/app_locale_provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/notifications_provider.dart';
import '../widgets/profile_widgets.dart';
import 'account_settings_screen.dart';
import 'notifications_screen.dart';
import 'cart_screen.dart';
import 'auth.dart';
import 'orders.dart';
import 'account_info_screen.dart';
import 'change_password_screen.dart';
import 'favorite_screen.dart';
import 'address_screen.dart';
import 'language_screen.dart';
import 'shop_demo_screen.dart';
import 'notification_settings_screen.dart';
import 'help_center_screen.dart';
import 'policies_screen.dart';
import 'about_screen.dart';
import 'usage_rules_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  Future<void> _logout() async {
    context.read<FavoritesProvider>().clear();
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const AuthScreen()),
      (_) => false,
    );
  }

  Future<void> _deleteAccount() async {
    try {
      // Delete the Firebase Auth account
      await FirebaseAuth.instance.currentUser?.delete();
    } catch (e) {
      // If delete fails (e.g., requires recent authentication),
      // fallback to a standard sign-out.
      await FirebaseAuth.instance.signOut();
    }
    
    if (!mounted) return;
    // Clear favorites local provider storage.
    context.read<FavoritesProvider>().clear();
    
    // Route back to the unified AuthScreen
    Navigator.pushAndRemoveUntil(
      this.context,
      MaterialPageRoute(builder: (_) => const AuthScreen()),
      (_) => false,
    );
  }



  @override
  Widget build(BuildContext context) {
    final locale = context.watch<AppLocaleProvider>();
    final cartProvider = context.watch<CartProvider>();
    final notificationsProvider = context.watch<NotificationsProvider>();
    final s = locale.strings;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        final data = snapshot.data?.data();
        final displayName = data?['displayName'] ?? user.displayName ?? '';
        final photoUrl = data?['photoUrl'] ?? user.photoURL;
        final email = user.email ?? '-';

        final avatarLetter = displayName.isNotEmpty
            ? displayName[0].toUpperCase()
            : (email.isNotEmpty ? email[0].toUpperCase() : '?');

        return Scaffold(
          backgroundColor: Colors.white,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                elevation: 0,
                surfaceTintColor: Colors.transparent,
                pinned: true,
                title: Text(
                  s.profile,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: kText,
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: kPurpleFaint,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.notifications_none_rounded,
                              color: kPurple,
                              size: 20,
                            ),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const NotificationsScreen(),
                              ),
                            ),
                          ),
                          if (notificationsProvider.unreadCount > 0)
                            Positioned(
                              top: 4,
                              right: 4,
                              child: Container(
                                width: 14,
                                height: 14,
                                decoration: const BoxDecoration(
                                  color: kPurple,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${notificationsProvider.unreadCount}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 8,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: kPurpleFaint,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.shopping_bag_outlined,
                              color: kPurple,
                              size: 20,
                            ),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const CartScreen()),
                            ),
                          ),
                        ),
                        if (cartProvider.totalCount > 0)
                          Positioned(
                            top: -4,
                            right: -4,
                            child: Container(
                              width: 18,
                              height: 18,
                              decoration: const BoxDecoration(
                                color: kPurple,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${cartProvider.totalCount}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      // ── Avatar + Name (Premium Light Purple Header) ─────────────
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AccountSettingsScreen(),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: kPurpleLight,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: kPurpleLight.withOpacity(0.2),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.2),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.4),
                                    width: 2,
                                  ),
                                  image: photoUrl != null
                                      ? (photoUrl.startsWith('data:image')
                                            ? DecorationImage(
                                                image: MemoryImage(
                                                  base64Decode(
                                                    photoUrl.split(',')[1],
                                                  ),
                                                ),
                                                fit: BoxFit.cover,
                                              )
                                            : DecorationImage(
                                                image: NetworkImage(photoUrl),
                                                fit: BoxFit.cover,
                                              ))
                                      : null,
                                ),
                                child: photoUrl == null
                                    ? Center(
                                        child: Text(
                                          avatarLetter,
                                          style: const TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      displayName.isNotEmpty
                                          ? displayName
                                          : 'User',
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            s.editProfile,
                                            style: const TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          const Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            size: 10,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                      // ── Open Shop Bar ───────────────────────────────────────────
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ShopDemoScreen(),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                          decoration: BoxDecoration(
                            color: kPurpleFaint,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: kPurpleBorder, width: 1.5),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.storefront_outlined, color: kPurple, size: 24),
                              const SizedBox(width: 12),
                              Text(
                                s.openShop,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: kPurple,
                                ),
                              ),
                              const Spacer(),
                              const Icon(Icons.arrow_forward_ios_rounded, color: kPurple, size: 16),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      ProfileOrderSummary(
                        onTabTap: (tabIndex) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  OrdersScreen(initialTab: tabIndex),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 24),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          s.myInfo,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: kSubText,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // ── Favorites + Address (First Group) ──────────────────────
                      ProfileMenuItem(
                        icon: Icons.account_circle_outlined,
                        label: s.accountInfo,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AccountInfoScreen(),
                          ),
                        ),
                      ),
                      Divider(height: 1, color: Colors.grey.shade100),
                      ProfileMenuItem(
                        icon: Icons.favorite_outline_rounded,
                        label: s.favorites,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const FavoriteScreen(),
                          ),
                        ),
                      ),
                      Divider(height: 1, color: Colors.grey.shade100),
                      ProfileMenuItem(
                        icon: Icons.location_on_outlined,
                        label: s.myAddress,
                        onTap: () => _showAddressManager(context, s),
                      ),

                      const SizedBox(height: 32),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          s.settingsAndSecurity,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: kSubText,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      ProfileMenuItem(
                        icon: Icons.notifications_none_rounded,
                        label: s.notifications,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const NotificationSettingsScreen(),
                          ),
                        ),
                      ),
                      Divider(height: 1, color: Colors.grey.shade100),
                      ProfileMenuItem(
                        icon: Icons.lock_outline_rounded,
                        label: s.changePassword,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ChangePasswordScreen(),
                          ),
                        ),
                      ),
                      Divider(height: 1, color: Colors.grey.shade100),
                      ProfileMenuItem(
                        icon: Icons.language_rounded,
                        label: s.language,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              s.languageValue,
                              style: const TextStyle(
                                fontSize: 13,
                                color: kPurpleLight,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.chevron_right_rounded,
                              color: Colors.grey,
                              size: 20,
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const LanguageScreen()),
                          );
                        },
                      ),

                      const SizedBox(height: 24),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          s.support,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: kSubText,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      ProfileMenuItem(
                        icon: Icons.help_outline_rounded,
                        label: s.helpCentre,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const HelpCenterScreen(),
                          ),
                        ),
                      ),
                      Divider(height: 1, color: Colors.grey.shade100),
                      ProfileMenuItem(
                        icon: Icons.gavel_rounded,
                        label: s.communityRules,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const UsageRulesScreen(),
                          ),
                        ),
                      ),
                      Divider(height: 1, color: Colors.grey.shade100),
                      ProfileMenuItem(
                        icon: Icons.policy_outlined,
                        label: s.policies,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PoliciesScreen(),
                          ),
                        ),
                      ),
                      Divider(height: 1, color: Colors.grey.shade100),
                      ProfileMenuItem(
                        icon: Icons.info_outline_rounded,
                        label: s.about,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AboutScreen(),
                          ),
                        ),
                      ),
                      Divider(height: 1, color: Colors.grey.shade100),
                      ProfileMenuItem(
                        icon: Icons.person_remove_outlined,
                        label: s.requestAccountDeletion,
                        onTap: () => _showDeletionDialog(context, s),
                      ),
                      Divider(height: 1, color: Colors.grey.shade100),
                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton.icon(
                          onPressed: () => _showLogoutConfirmation(context, s),
                          icon: const Icon(Icons.logout_rounded, size: 18),
                          label: Text(s.logout),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: kErrorRedDark,
                            side: BorderSide(
                              color: kErrorRedDark.withOpacity(0.4),
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeletionDialog(BuildContext context, dynamic s) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            s.deleteAccountConfirmMsg,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              color: kText,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        actionsPadding: EdgeInsets.zero,
        actionsOverflowButtonSpacing: 0,
        actions: [
          Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                        ),
                      ),
                    ),
                    child: Text(
                      s.cancelLabel,
                      style: const TextStyle(
                        color: kText,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Container(width: 1, height: 50, color: Colors.grey.shade200),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                      _deleteAccount();
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                    ),
                    child: Text(
                      s.okLabel,
                      style: const TextStyle(
                        color: kPurple,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context, dynamic s) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                s.logoutConfirmTitle,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                  color: kText,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                s.logoutConfirmMsg,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  color: kText,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        actionsPadding: EdgeInsets.zero,
        actions: [
          Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                        ),
                      ),
                    ),
                    child: Text(
                      s.cancelLabel,
                      style: const TextStyle(
                        color: kText,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Container(width: 1, height: 50, color: Colors.grey.shade200),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _logout();
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                    ),
                    child: Text(
                      s.logout,
                      style: const TextStyle(
                        color: kPurple,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddressManager(BuildContext context, dynamic s) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddressScreen()),
    );
  }
}
