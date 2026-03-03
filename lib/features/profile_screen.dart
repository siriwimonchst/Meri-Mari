// lib/features/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../providers/app_locale_provider.dart';
import '../providers/favorites_provider.dart';
import '../core/address_service.dart';
import '../models/address_model.dart';
import 'auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _addressService = AddressService();

  static const _purple = Color(0xFFAB9DC4);
  static const _deepPurple = Color(0xFF7B5EA7);

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

  Future<void> _showAddressForm({AddressModel? editing}) async {
    final result = await showModalBottomSheet<AddressModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddressFormSheet(existing: editing),
    );
    if (result == null) return;
    try {
      if (editing == null) {
        await _addressService.addAddress(result);
      } else {
        await _addressService.updateAddress(result);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            backgroundColor: const Color(0xFFC62828),
          ),
        );
      }
    }
  }

  Future<void> _deleteAddress(AddressModel address) async {
    final s = context.read<AppLocaleProvider>().strings;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(s.deleteAddressTitle),
        content: Text(s.deleteAddressConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(s.cancelLabel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFC62828),
            ),
            child: Text(s.deleteLabel),
          ),
        ],
      ),
    );
    if (ok == true) await _addressService.deleteAddress(address.id);
  }

  void _showLanguagePicker(BuildContext context, AppLocaleProvider locale) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'เลือกภาษา / Select Language',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _LangOption(
              flag: '🇬🇧',
              label: 'English UK',
              selected: !locale.isThai,
              onTap: () {
                if (locale.isThai) locale.toggle();
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 10),
            _LangOption(
              flag: '🇹🇭',
              label: 'ภาษาไทย',
              selected: locale.isThai,
              onTap: () {
                if (!locale.isThai) locale.toggle();
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? '-';
    final displayName = user?.displayName ?? '';
    final avatarLetter = displayName.isNotEmpty
        ? displayName[0].toUpperCase()
        : (email.isNotEmpty ? email[0].toUpperCase() : '?');
    final locale = context.watch<AppLocaleProvider>();
    final s = locale.strings;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // ── AppBar ────────────────────────────────────────────────────
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
                color: Color(0xFF1A1A2E),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // ── Avatar + Name ────────────────────────────────────
                  Row(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFEDE7F6),
                          border: Border.all(
                            color: const Color(0xFFD4C8E8),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            avatarLetter,
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              color: _deepPurple,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayName.isNotEmpty ? displayName : 'User',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF1A1A2E),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              email,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF9E9E9E),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),
                  Divider(height: 1, color: Colors.grey.shade100),
                  const SizedBox(height: 8),

                  // ── Menu Items ────────────────────────────────────────
                  _MenuItem(
                    icon: Icons.location_on_outlined,
                    label: s.myAddress,
                    onTap: () => _showAddressManager(context, s),
                  ),
                  _MenuItem(
                    icon: Icons.person_outline_rounded,
                    label: s.account,
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: Icons.phone_iphone_rounded,
                    label: s.devices,
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: Icons.lock_outline_rounded,
                    label: s.passwords,
                    onTap: () {},
                  ),

                  // Language row — shows current value, opens picker on tap
                  _MenuItem(
                    icon: Icons.language_rounded,
                    label: s.language,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          s.languageValue,
                          style: const TextStyle(
                            fontSize: 13,
                            color: _purple,
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
                    onTap: () => _showLanguagePicker(context, locale),
                  ),

                  const SizedBox(height: 24),
                  Divider(height: 1, color: Colors.grey.shade100),
                  const SizedBox(height: 24),

                  // ── Logout ────────────────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: _logout,
                      icon: const Icon(Icons.logout_rounded, size: 18),
                      label: Text(s.logout),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFC62828),
                        side: const BorderSide(
                          color: Color(0xFFFFCDD2),
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
  }

  void _showAddressManager(BuildContext context, dynamic s) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddressManagerSheet(
        addressService: _addressService,
        onAdd: () => _showAddressForm(),
        onEdit: (a) => _showAddressForm(editing: a),
        onDelete: _deleteAddress,
        onSetDefault: (id) => _addressService.setDefault(id),
      ),
    );
  }
}

// ── Menu Item ──────────────────────────────────────────────────────────────

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 22, color: const Color(0xFFAB9DC4)),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A2E),
                ),
              ),
            ),
            trailing ??
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.grey,
                  size: 20,
                ),
          ],
        ),
      ),
    );
  }
}

// ── Address Manager Bottom Sheet ───────────────────────────────────────────

class _AddressManagerSheet extends StatelessWidget {
  final AddressService addressService;
  final VoidCallback onAdd;
  final void Function(AddressModel) onEdit;
  final void Function(AddressModel) onDelete;
  final void Function(String) onSetDefault;

  const _AddressManagerSheet({
    required this.addressService,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
    required this.onSetDefault,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        left: 20,
        right: 20,
        top: 12,
      ),
      child: StreamBuilder<List<AddressModel>>(
        stream: addressService.streamAddresses(),
        builder: (ctx, snap) {
          final addresses = snap.data ?? [];
          final atMax = addresses.length >= AddressService.maxAddresses;
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Builder(
                builder: (ctx) {
                  final s = ctx.read<AppLocaleProvider>().strings;
                  return Row(
                    children: [
                      Text(
                        s.myAddressTitle,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4F0FA),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${addresses.length}/${AddressService.maxAddresses}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF7B5EA7),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 12),

              if (addresses.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    context.read<AppLocaleProvider>().strings.noAddress,
                    style: TextStyle(color: Colors.grey.shade400),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: addresses.length,
                  separatorBuilder: (_, __) =>
                      Divider(height: 1, color: Colors.grey.shade100),
                  itemBuilder: (_, i) => _AddressRow(
                    address: addresses[i],
                    onEdit: () => onEdit(addresses[i]),
                    onDelete: () => onDelete(addresses[i]),
                    onSetDefault: () => onSetDefault(addresses[i].id),
                  ),
                ),

              if (!atMax)
                TextButton.icon(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add_location_alt_outlined, size: 18),
                  label: Text(
                    context.read<AppLocaleProvider>().strings.addAddress,
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF7B5EA7),
                    textStyle: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _AddressRow extends StatelessWidget {
  final AddressModel address;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSetDefault;

  const _AddressRow({
    required this.address,
    required this.onEdit,
    required this.onDelete,
    required this.onSetDefault,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Radio
          GestureDetector(
            onTap: address.isDefault ? null : onSetDefault,
            child: Container(
              width: 22,
              height: 22,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: address.isDefault
                      ? const Color(0xFFAB9DC4)
                      : Colors.grey.shade300,
                  width: 2,
                ),
                color: address.isDefault
                    ? const Color(0xFFAB9DC4)
                    : Colors.transparent,
              ),
              child: address.isDefault
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (address.isDefault)
                  Builder(
                    builder: (ctx) {
                      final s = ctx.read<AppLocaleProvider>().strings;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFAB9DC4),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          s.currentAddress,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      );
                    },
                  ),
                Text(
                  address.addressLine1,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                if (address.addressLine2.isNotEmpty)
                  Text(
                    address.addressLine2,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                Text(
                  '${address.city}, ${address.country} ${address.zipCode}',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                ),
                const SizedBox(height: 6),
                Builder(
                  builder: (ctx) {
                    final s = ctx.read<AppLocaleProvider>().strings;
                    return Row(
                      children: [
                        _SmallBtn(
                          label: s.editLabel,
                          color: const Color(0xFF7B5EA7),
                          onTap: onEdit,
                        ),
                        const SizedBox(width: 12),
                        _SmallBtn(
                          label: s.deleteLabel,
                          color: const Color(0xFFC62828),
                          onTap: onDelete,
                        ),
                        if (!address.isDefault) ...[
                          const SizedBox(width: 12),
                          _SmallBtn(
                            label: s.setAsDefault,
                            color: Colors.orange.shade700,
                            onTap: onSetDefault,
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallBtn extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _SmallBtn({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ── Address Form Sheet (reused from existing implementation) ───────────────

class _AddressFormSheet extends StatefulWidget {
  final AddressModel? existing;
  const _AddressFormSheet({this.existing});

  @override
  State<_AddressFormSheet> createState() => _AddressFormSheetState();
}

class _AddressFormSheetState extends State<_AddressFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _line1, _line2, _city, _country, _zip;
  late bool _isDefault;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _line1 = TextEditingController(text: e?.addressLine1 ?? '');
    _line2 = TextEditingController(text: e?.addressLine2 ?? '');
    _city = TextEditingController(text: e?.city ?? '');
    _country = TextEditingController(text: e?.country ?? 'Thailand');
    _zip = TextEditingController(text: e?.zipCode ?? '');
    _isDefault = e?.isDefault ?? false;
  }

  @override
  void dispose() {
    _line1.dispose();
    _line2.dispose();
    _city.dispose();
    _country.dispose();
    _zip.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      AddressModel(
        id: widget.existing?.id ?? '',
        addressLine1: _line1.text.trim(),
        addressLine2: _line2.text.trim(),
        city: _city.text.trim(),
        country: _country.text.trim(),
        zipCode: _zip.text.trim(),
        isDefault: _isDefault,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 0,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                isEdit ? 'แก้ไขที่อยู่' : 'เพิ่มที่อยู่ใหม่',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 20),
              _FormField2(
                ctrl: _line1,
                hint: '123 Main Street',
                label: 'Address line 1',
                validator: (v) => v!.trim().isEmpty ? 'กรุณากรอกที่อยู่' : null,
              ),
              const SizedBox(height: 12),
              _FormField2(
                ctrl: _line2,
                hint: 'Apt, Suite…',
                label: 'Address line 2 (optional)',
              ),
              const SizedBox(height: 12),
              _FormField2(
                ctrl: _city,
                hint: 'Bangkok',
                label: 'City',
                validator: (v) => v!.trim().isEmpty ? 'กรุณากรอกเมือง' : null,
              ),
              const SizedBox(height: 12),
              _FormField2(
                ctrl: _country,
                hint: 'Thailand',
                label: 'Country',
                validator: (v) => v!.trim().isEmpty ? 'กรุณากรอกประเทศ' : null,
              ),
              const SizedBox(height: 12),
              _FormField2(
                ctrl: _zip,
                hint: '10110',
                label: 'ZIP / Postcode',
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v!.trim().isEmpty ? 'กรุณากรอกรหัสไปรษณีย์' : null,
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => setState(() => _isDefault = !_isDefault),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: _isDefault
                            ? const Color(0xFFAB9DC4)
                            : Colors.transparent,
                        border: Border.all(
                          color: _isDefault
                              ? const Color(0xFFAB9DC4)
                              : Colors.grey.shade400,
                          width: 2,
                        ),
                      ),
                      child: _isDefault
                          ? const Icon(
                              Icons.check,
                              size: 14,
                              color: Colors.white,
                            )
                          : null,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'ตั้งเป็นที่อยู่ปัจจุบัน',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF424242),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFAB9DC4),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child: Text(isEdit ? 'บันทึกการเปลี่ยนแปลง' : 'บันทึก'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FormField2 extends StatelessWidget {
  final TextEditingController ctrl;
  final String hint;
  final String label;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  const _FormField2({
    required this.ctrl,
    required this.hint,
    required this.label,
    this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Color(0xFF424242),
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: ctrl,
          validator: validator,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFFB0A8C4), fontSize: 14),
            filled: true,
            fillColor: const Color(0xFFF8F5FD),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFAB9DC4),
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFC62828),
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFC62828),
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Language Option Row ────────────────────────────────────────────────────

class _LangOption extends StatelessWidget {
  final String flag;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _LangOption({
    required this.flag,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF4F0FA) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? const Color(0xFFAB9DC4) : const Color(0xFFEEEEEE),
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: selected
                      ? const Color(0xFF7B5EA7)
                      : const Color(0xFF1A1A2E),
                ),
              ),
            ),
            if (selected)
              const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFFAB9DC4),
                size: 22,
              ),
          ],
        ),
      ),
    );
  }
}
