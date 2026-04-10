import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/app_theme.dart';
import '../providers/app_locale_provider.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _pushNotifications = true;
  bool _orderUpdates = true;
  bool _promotions = false;
  bool _chatMessages = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _pushNotifications = prefs.getBool('pushNotifications') ?? true;
      _orderUpdates = prefs.getBool('orderUpdates') ?? true;
      _promotions = prefs.getBool('promotions') ?? false;
      _chatMessages = prefs.getBool('chatMessages') ?? true;
    });
  }

  Future<void> _saveSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<AppLocaleProvider>();
    final s = locale.strings;
    final isThai = locale.isThai;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F6FC),
      appBar: AppBar(
        title: Text(
          s.notificationSettings,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: kText,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: kText, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: ListView(
        children: [
          _buildHeader(isThai ? 'ระบบหลัก' : 'Main System'),
          _buildSwitch(
            title: s.pushNotifications,
            value: _pushNotifications,
            onChanged: (val) {
              setState(() => _pushNotifications = val);
              _saveSetting('pushNotifications', val);
            },
            isMain: true,
          ),
          _buildHeader(isThai ? 'หมวดหมู่การแจ้งเตือน' : 'Notification Categories'),
          Container(
            color: Colors.white,
            child: Column(
              children: [
                _buildSwitchInner(
                  title: s.orderUpdates,
                  value: _pushNotifications && _orderUpdates,
                  onChanged: !_pushNotifications
                      ? null
                      : (val) {
                          setState(() => _orderUpdates = val);
                          _saveSetting('orderUpdates', val);
                        },
                ),
                const Divider(height: 1, indent: 20, color: Color(0xFFF0EAF8)),
                _buildSwitchInner(
                  title: s.promotions,
                  value: _pushNotifications && _promotions,
                  onChanged: !_pushNotifications
                      ? null
                      : (val) {
                          setState(() => _promotions = val);
                          _saveSetting('promotions', val);
                        },
                ),
                const Divider(height: 1, indent: 20, color: Color(0xFFF0EAF8)),
                _buildSwitchInner(
                  title: s.chatMessages,
                  value: _pushNotifications && _chatMessages,
                  onChanged: !_pushNotifications
                      ? null
                      : (val) {
                          setState(() => _chatMessages = val);
                          _saveSetting('chatMessages', val);
                        },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }

  Widget _buildSwitch({
    required String title,
    required bool value,
    required ValueChanged<bool>? onChanged,
    bool isMain = false,
  }) {
    return Container(
      color: Colors.white,
      child: SwitchListTile(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isMain ? FontWeight.w700 : FontWeight.w500,
            color: onChanged == null ? kSubText : kText,
          ),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: Colors.white,
        activeTrackColor: kPurple,
        inactiveThumbColor: Colors.white,
        inactiveTrackColor: Colors.grey.shade200,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      ),
    );
  }

  Widget _buildSwitchInner({
    required String title,
    required bool value,
    required ValueChanged<bool>? onChanged,
  }) {
    return SwitchListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: onChanged == null ? kSubText : kText,
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.white,
      activeTrackColor: kPurple,
      inactiveThumbColor: Colors.white,
      inactiveTrackColor: Colors.grey.shade200,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }
}
