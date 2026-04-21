// lib/widgets/profile_widgets.dart
// ─── Profile Screen Sub-Widgets ───────────────────────────────────────────────
// Extracted from profile_screen.dart. Import this file in profile_screen.dart.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../models/address_model.dart';
import '../providers/app_locale_provider.dart';
import '../providers/orders_provider.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ProfileMenuItem
// ─────────────────────────────────────────────────────────────────────────────

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback onTap;
  final Color? color;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing,
    this.color,
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
            Icon(icon, size: 22, color: color ?? kPurpleLight),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: color ?? kText,
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


// ─────────────────────────────────────────────────────────────────────────────
// ProfileOrderSummary
// ─────────────────────────────────────────────────────────────────────────────

class ProfileOrderSummary extends StatelessWidget {
  final void Function(int tabIndex) onTabTap;

  const ProfileOrderSummary({super.key, required this.onTabTap});

  @override
  Widget build(BuildContext context) {
    final s = context.read<AppLocaleProvider>().strings;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kPurpleBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: kPurple.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              Text(
                s.orders,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: kText,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => onTabTap(0), // All tab
                child: Row(
                  children: [
                    Text(
                      s.viewPurchaseHistory,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 10,
                      color: Colors.grey.shade400,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Status Items
          Builder(
            builder: (context) {
              final orders = context.watch<OrdersProvider>();
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _StatusItem(
                    icon: Icons.receipt_long_outlined,
                    label: s.tabToPay,
                    badgeCount: orders.ordersForTab(OrderTab.toPay).length,
                    onTap: () => onTabTap(1),
                  ),
                  _StatusItem(
                    icon: Icons.inventory_2_outlined,
                    label: s.tabToShip,
                    badgeCount: orders.ordersForTab(OrderTab.toShip).length,
                    onTap: () => onTabTap(2),
                  ),
                  _StatusItem(
                    icon: Icons.local_shipping_outlined,
                    label: s.tabToReceive,
                    badgeCount: orders.ordersForTab(OrderTab.toReceive).length,
                    onTap: () => onTabTap(3),
                  ),
                  _StatusItem(
                    icon: Icons.star_outline_rounded,
                    label: s.rateLabel,
                    badgeCount: orders.ordersForTab(OrderTab.toRate).length,
                    onTap: () => onTabTap(4),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _StatusItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int badgeCount;
  final VoidCallback onTap;

  const _StatusItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(icon, size: 28, color: kText.withOpacity(0.8)),
              if (badgeCount > 0)
                Positioned(
                  top: -6,
                  right: -6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: kPurple,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '$badgeCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: kText,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Internal: _AddressRow
// ─────────────────────────────────────────────────────────────────────────────

class AddressRow extends StatelessWidget {
  final AddressModel address;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSetDefault;

  const AddressRow({
    super.key,
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
          // Radio dot
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
                      ? kPurpleLight
                      : Colors.grey.shade300,
                  width: 2,
                ),
                color: address.isDefault ? kPurpleLight : Colors.transparent,
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
                          color: kPurpleLight,
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
                    color: kText,
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
                        SmallBtn(
                          label: s.editLabel,
                          color: kPurple,
                          onTap: onEdit,
                        ),
                        const SizedBox(width: 12),
                        SmallBtn(
                          label: s.deleteLabel,
                          color: kErrorRed,
                          onTap: onDelete,
                        ),
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

class SmallBtn extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  const SmallBtn({
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

// ─────────────────────────────────────────────────────────────────────────────
// ProfileAddressFormSheet
// ─────────────────────────────────────────────────────────────────────────────

class ProfileAddressFormSheet extends StatefulWidget {
  final AddressModel? existing;
  const ProfileAddressFormSheet({super.key, this.existing});

  @override
  State<ProfileAddressFormSheet> createState() =>
      _ProfileAddressFormSheetState();
}

class _ProfileAddressFormSheetState extends State<ProfileAddressFormSheet> {
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
    final s = context.read<AppLocaleProvider>().strings;
    final isEditing = widget.existing != null;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Form(
          key: _formKey,
          child: Column(
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
              Text(
                isEditing ? s.editAddress : s.addNewAddress,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: kText,
                ),
              ),
              const SizedBox(height: 16),
              _buildField(_line1, s.addressLine1, required: true),
              const SizedBox(height: 12),
              _buildField(_line2, s.addressLine2),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildField(_city, s.cityLabel, required: true)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildField(
                      _zip,
                      s.zipCodeLabel,
                      required: true,
                      numeric: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildField(_country, s.countryLabel, required: true),
              const SizedBox(height: 12),
              Row(
                children: [
                  Switch(
                    value: _isDefault,
                    activeThumbColor: kPurple,
                    onChanged: (v) => setState(() => _isDefault = v),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    s.setAsDefault,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPurple,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    isEditing ? s.saveChanges : s.saveAddress,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    TextEditingController ctrl,
    String label, {
    bool required = false,
    bool numeric = false,
  }) {
    return TextFormField(
      controller: ctrl,
      keyboardType: numeric ? TextInputType.number : TextInputType.text,
      validator: required
          ? (v) => (v == null || v.trim().isEmpty) ? '${label} ${context.read<AppLocaleProvider>().strings.fieldRequired}' : null
          : null,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: kPurpleLight, fontSize: 13),
        filled: true,
        fillColor: kPurpleFaint,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kPurpleBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kPurpleBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kPurple, width: 2),
        ),
      ),
    );
  }
}
