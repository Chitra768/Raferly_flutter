import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/message_editing_screen.dart';

class ContactSelectionScreen extends StatefulWidget {
  final String link;
  final String defaultMessage;

  const ContactSelectionScreen({
    Key? key,
    required this.link,
    required this.defaultMessage,
  }) : super(key: key);

  @override
  State<ContactSelectionScreen> createState() => _ContactSelectionScreenState();
}

class _ContactSelectionScreenState extends State<ContactSelectionScreen> {
  List<Contact> _allContacts = [];
  List<Contact> _filteredContacts = [];
  Set<String> _selectedContactIds = {};
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  bool _selectAll = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterContacts);
    // On iOS, request contacts after the first frame so permission runs on main thread
    // and the plugin callback is less likely to hang or not update UI.
    if (Platform.isIOS) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadContacts());
    } else {
      _loadContacts();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadContacts() async {
    const timeoutDuration = Duration(seconds: 30);
    try {
      final status = await FlutterContacts.requestPermission()
          .timeout(timeoutDuration, onTimeout: () => false);
      if (!status) {
        _safeSetState(() {
          _isLoading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(tr(LanguageKeys.contactPermissionDenied)),
            ),
          );
          Navigator.of(context).pop();
        }
        return;
      }

      final contacts = await FlutterContacts.getContacts(
        withProperties: true,
        withPhoto: true,
        withThumbnail: false,
      ).timeout(timeoutDuration);

      _safeSetState(() {
        _allContacts = contacts;
        _filteredContacts = contacts;
        _isLoading = false;
      });
    } on TimeoutException {
      _safeSetState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(tr(LanguageKeys.contactPermissionDenied)),
          ),
        );
      }
    } catch (e) {
      _safeSetState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading contacts: $e'),
          ),
        );
      }
    }
  }

  /// Ensures setState runs on the main thread (fixes iOS when plugin callbacks off main).
  void _safeSetState(VoidCallback fn) {
    if (!mounted) return;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(fn);
    });
  }

  void _filterContacts() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        _filteredContacts = _allContacts;
      } else {
        _filteredContacts = _allContacts.where((contact) {
          final name = contact.displayName.toLowerCase();
          final phone = contact.phones.isNotEmpty
              ? contact.phones.first.number.toLowerCase()
              : '';
          return name.contains(query) || phone.contains(query);
        }).toList();
      }
    });
  }

  void _toggleContactSelection(String contactId) {
    setState(() {
      if (_selectedContactIds.contains(contactId)) {
        _selectedContactIds.remove(contactId);
      } else {
        _selectedContactIds.add(contactId);
      }
      _updateSelectAllState();
    });
  }

  void _toggleSelectAll() {
    setState(() {
      _selectAll = !_selectAll;
      if (_selectAll) {
        _selectedContactIds = _filteredContacts.map((c) => c.id).toSet();
      } else {
        _selectedContactIds.clear();
      }
    });
  }

  void _updateSelectAllState() {
    if (_filteredContacts.isEmpty) {
      _selectAll = false;
    } else {
      _selectAll = _selectedContactIds.length == _filteredContacts.length &&
          _filteredContacts.every((c) => _selectedContactIds.contains(c.id));
    }
  }

  void _proceedToEditMessage() {
    if (_selectedContactIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select at least one contact'),
        ),
      );
      return;
    }

    final selectedContacts =
        _allContacts.where((c) => _selectedContactIds.contains(c.id)).toList();

    MessageEditingScreen.show(
      context,
      selectedContacts: selectedContacts,
      link: widget.link,
      defaultMessage: widget.defaultMessage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          tr(LanguageKeys.selectContacts),
          style: stylePoppins(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _toggleSelectAll,
            child: Text(
              _selectAll
                  ? tr(LanguageKeys.deselectAll)
                  : tr(LanguageKeys.selectAll),
              style: stylePoppins(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Search bar
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: tr(LanguageKeys.searchContacts),
                        hintStyle: stylePoppins(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                // Contact list
                Expanded(
                  child: _filteredContacts.isEmpty
                      ? Center(
                          child: Text(
                            tr(LanguageKeys.noDataFound),
                            style: stylePoppins(
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _filteredContacts.length,
                          itemBuilder: (context, index) {
                            final contact = _filteredContacts[index];
                            final isSelected =
                                _selectedContactIds.contains(contact.id);
                            final phoneNumber = contact.phones.isNotEmpty
                                ? contact.phones.first.number
                                : '';

                            return InkWell(
                              onTap: () => _toggleContactSelection(contact.id),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: isSelected,
                                      onChanged: (_) =>
                                          _toggleContactSelection(contact.id),
                                      activeColor: AppColors.primary,
                                      fillColor: WidgetStateProperty
                                          .resolveWith<Color>(
                                        (Set<WidgetState> states) {
                                          if (states
                                              .contains(WidgetState.selected)) {
                                            return AppColors.primary;
                                          }
                                          return Colors.transparent;
                                        },
                                      ),
                                      side: BorderSide(
                                        color: Colors.grey.shade400,
                                        width: 2,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    CircleAvatar(
                                      radius: 24,
                                      backgroundColor: AppColors.primary,
                                      backgroundImage: contact.photo != null
                                          ? MemoryImage(contact.photo!)
                                          : null,
                                      child: contact.photo == null
                                          ? Text(
                                              contact.displayName.isNotEmpty
                                                  ? contact.displayName[0]
                                                      .toUpperCase()
                                                  : '?',
                                              style: stylePoppins(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: Colors.white,
                                              ),
                                            )
                                          : null,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            contact.displayName,
                                            style: stylePoppins(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                          ),
                                          if (phoneNumber.isNotEmpty)
                                            Text(
                                              phoneNumber,
                                              style: stylePoppins(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 12,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
                // Bottom button
                if (_selectedContactIds.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _proceedToEditMessage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            '${tr(LanguageKeys.Continue)} (${_selectedContactIds.length})',
                            style: stylePoppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
