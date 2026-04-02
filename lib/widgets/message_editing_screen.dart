import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/utils/translations.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageEditingScreen extends StatefulWidget {
  final List<Contact> selectedContacts;
  final String link;
  final String defaultMessage;

  const MessageEditingScreen({
    Key? key,
    required this.selectedContacts,
    required this.link,
    required this.defaultMessage,
  }) : super(key: key);

  static void show(
    BuildContext context, {
    required List<Contact> selectedContacts,
    required String link,
    required String defaultMessage,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MessageEditingScreen(
        selectedContacts: selectedContacts,
        link: link,
        defaultMessage: defaultMessage,
      ),
    );
  }

  @override
  State<MessageEditingScreen> createState() => _MessageEditingScreenState();
}

class _MessageEditingScreenState extends State<MessageEditingScreen> {
  late TextEditingController _messageController;
  String _fullMessage = '';

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController(text: widget.defaultMessage);
    _updateFullMessage();
    _messageController.addListener(_updateFullMessage);
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _updateFullMessage() {
    setState(() {
      _fullMessage = '${_messageController.text} ${widget.link}';
    });
  }

  Future<void> _sendMessages() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a message'),
        ),
      );
      return;
    }

    var contactsWithPhones =
        widget.selectedContacts.where((c) => c.phones.isNotEmpty).toList();

    // On iOS, getContacts sometimes returns contacts without phone data; refetch by ID.
    if (contactsWithPhones.isEmpty &&
        widget.selectedContacts.isNotEmpty &&
        Platform.isIOS) {
      final refetched = <Contact>[];
      for (final c in widget.selectedContacts) {
        final full = await FlutterContacts.getContact(c.id,
            withProperties: true, withPhoto: false, withThumbnail: false);
        if (full != null && full.phones.isNotEmpty) refetched.add(full);
      }
      contactsWithPhones = refetched;
    }

    if (contactsWithPhones.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selected contacts do not have phone numbers'),
        ),
      );
      return;
    }

    final fullMessage = '$message ${widget.link}';

    // Build list of phone numbers (digits and + only)
    final phoneNumbers = <String>[];
    for (final contact in contactsWithPhones) {
      final num = contact.phones.first.number.replaceAll(RegExp(r'[^\d+]'), '');
      if (num.isNotEmpty) phoneNumbers.add(num);
    }

    if (phoneNumbers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No valid phone numbers found'),
        ),
      );
      return;
    }

    // Android: one URL with all recipients. iOS: open first contact only (sms: URL supports one recipient).
    if (Platform.isIOS) {
      final numberEncoded = phoneNumbers[0].replaceAll('+', '%2B');
      final encodedBody = Uri.encodeComponent(fullMessage);
      final smsUrl = 'sms:$numberEncoded;?&body=$encodedBody';
      try {
        if (await canLaunchUrl(Uri.parse(smsUrl))) {
          await launchUrl(Uri.parse(smsUrl),
              mode: LaunchMode.externalApplication);
        }
      } catch (_) {}
      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              phoneNumbers.length == 1
                  ? 'Message opened for 1 contact'
                  : 'Message opened for first of ${phoneNumbers.length} contacts. On iOS, add more recipients in Messages.',
            ),
            backgroundColor: AppColors.primary,
          ),
        );
      }
    } else {
      final recipients = phoneNumbers.join(',');
      final smsUrl = 'sms:$recipients?body=${Uri.encodeComponent(fullMessage)}';
      try {
        if (await canLaunchUrl(Uri.parse(smsUrl))) {
          await launchUrl(Uri.parse(smsUrl),
              mode: LaunchMode.externalApplication);
        }
      } catch (_) {}
      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              phoneNumbers.length == 1
                  ? 'Message opened for 1 contact'
                  : 'Message opened for all ${phoneNumbers.length} contacts',
            ),
            backgroundColor: AppColors.primary,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header Bar
          Container(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.black),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Text(
                  tr(LanguageKeys.editMessage),
                  style: stylePoppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                TextButton(
                  onPressed: _sendMessages,
                  child: Text(
                    tr(LanguageKeys.sendMessagesButton),
                    style: stylePoppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.grey.shade300,
            height: 1,
          ),
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Preview Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tr(LanguageKeys.preview),
                                style: stylePoppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  _fullMessage,
                                  style: stylePoppins(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Your Message Section
                  Text(
                    tr(LanguageKeys.yourMessage),
                    style: stylePoppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _messageController,
                      maxLines: 6,
                      decoration: const InputDecoration(
                        hintText: 'Enter your message...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                      ),
                      style: stylePoppins(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Default Link Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border:
                          Border.all(color: AppColors.primary.withOpacity(0.5)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.link,
                              color: AppColors.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                tr(LanguageKeys.defaultLink),
                                style: stylePoppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  color: AppColors.blackColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.link,
                          style: stylePoppins(
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          tr(LanguageKeys.linkAutoAdded),
                          style: stylePoppins(
                            fontWeight: FontWeight.normal,
                            fontSize: 11,
                            color: AppColors.blackColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
