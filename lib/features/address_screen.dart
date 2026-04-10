// lib/features/address_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../providers/app_locale_provider.dart';
import '../models/address_model.dart';
import '../core/address_service.dart';
import '../widgets/profile_widgets.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _addressService = AddressService();

  Future<void> _showAddressForm(BuildContext context, {AddressModel? editing}) async {
    final result = await showModalBottomSheet<AddressModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ProfileAddressFormSheet(existing: editing),
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
            backgroundColor: kErrorRed,
          ),
        );
      }
    }
  }

  Future<void> _deleteAddress(BuildContext context, AddressModel address) async {
    final s = context.read<AppLocaleProvider>().strings;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            s.deleteAddressConfirm,
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
        actions: [
          Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
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
                    onPressed: () => Navigator.pop(ctx, true),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                    ),
                    child: Text(
                      s.deleteLabel,
                      style: const TextStyle(
                        color: kErrorRedDark,
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

    if (ok == true) {
      await _addressService.deleteAddress(address.id);
    }
  }

  Future<void> _confirmSetDefault(BuildContext context, String addressId) async {
    final s = context.read<AppLocaleProvider>().strings;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            s.confirmSetDefault,
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
        actions: [
          Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
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
                    onPressed: () => Navigator.pop(ctx, true),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                    ),
                    child: Text(
                      s.confirmLabel,
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

    if (ok == true) {
      await _addressService.setDefault(addressId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = context.read<AppLocaleProvider>().strings;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          s.myAddressTitle,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 20,
            color: kText,
          ),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: kText, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<List<AddressModel>>(
        stream: _addressService.streamAddresses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final addresses = snapshot.data ?? [];
          final atMax = addresses.length >= AddressService.maxAddresses;

          if (addresses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_off_outlined, size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text(
                    s.noAddress,
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(24),
                  itemCount: addresses.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final address = addresses[index];
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: address.isDefault ? kPurpleLight : Colors.grey.shade200,
                          width: address.isDefault ? 1.5 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: AddressRow(
                        address: address,
                        onEdit: () => _showAddressForm(context, editing: address),
                        onDelete: () => _deleteAddress(context, address),
                        onSetDefault: () => _confirmSetDefault(context, address.id),
                      ),
                    );
                  },
                ),
              ),
              if (!atMax)
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () => _showAddressForm(context),
                      icon: const Icon(Icons.add_location_alt_outlined, size: 20),
                      label: Text(s.addNewAddress),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPurple,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
