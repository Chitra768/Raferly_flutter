import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_network_response.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/utils/translations.dart';

String notificationReferrerLabel(BusinessReferrers b) {
  final name =
      '${b.firstName ?? ''} ${b.lastName ?? ''}'.trim();
  if (name.isNotEmpty) return name;
  if ((b.companyName ?? '').isNotEmpty) return b.companyName!.trim();
  return (b.email ?? '').trim();
}

/// Multi-select active (non-pending) network users with search.
class NotificationUserPickerSheet extends StatefulWidget {
  const NotificationUserPickerSheet({
    super.key,
    required this.referrers,
    required this.initialSelectedIds,
    required this.onApply,
  });

  final List<BusinessReferrers> referrers;
  final List<int> initialSelectedIds;
  final void Function(List<int> ids) onApply;

  @override
  State<NotificationUserPickerSheet> createState() =>
      _NotificationUserPickerSheetState();
}

class _NotificationUserPickerSheetState
    extends State<NotificationUserPickerSheet> {
  late Set<int> _selected;
  final _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selected = Set<int>.from(
      widget.initialSelectedIds.where(
        (id) => widget.referrers.any((r) => r.id == id),
      ),
    );
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<BusinessReferrers> get _filtered {
    final q = _search.text.trim().toLowerCase();
    if (q.isEmpty) return widget.referrers;
    return widget.referrers.where((b) {
      final name = notificationReferrerLabel(b).toLowerCase();
      final company = (b.companyName ?? '').toLowerCase();
      final email = (b.email ?? '').toLowerCase();
      return name.contains(q) || company.contains(q) || email.contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height * 0.88;
    return SafeArea(
      child: Container(
        height: h,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: AppColors.slate200,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    tr(LanguageKeys.sendNotifPickUsersTitle),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.slate900,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            TextField(
              controller: _search,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: tr(LanguageKeys.sendNotifSearchUsers),
                filled: true,
                fillColor: const Color(0xFFF9FAFB),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                prefixIcon: const Icon(Icons.search, color: AppColors.gray400),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _filtered.isEmpty
                  ? Center(
                      child: Text(
                        tr(LanguageKeys.sendNotifNoUsers),
                        style: TextStyle(color: AppColors.k6B7280),
                      ),
                    )
                  : ListView.separated(
                      itemCount: _filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, i) {
                        final b = _filtered[i];
                        final id = b.id;
                        if (id == null) return const SizedBox.shrink();
                        final checked = _selected.contains(id);
                        final subtitle = [
                          if ((b.companyName ?? '').isNotEmpty) b.companyName,
                          if ((b.email ?? '').isNotEmpty) b.email,
                        ].whereType<String>().join(' · ');
                        return Material(
                          color: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(12),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              setState(() {
                                if (checked) {
                                  _selected.remove(id);
                                } else {
                                  _selected.add(id);
                                }
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: checked,
                                    activeColor: AppColors.purple500,
                                    onChanged: (v) {
                                      setState(() {
                                        if (v == true) {
                                          _selected.add(id);
                                        } else {
                                          _selected.remove(id);
                                        }
                                      });
                                    },
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          notificationReferrerLabel(b),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                            color: AppColors.slate900,
                                          ),
                                        ),
                                        if (subtitle.isNotEmpty)
                                          Text(
                                            subtitle,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: AppColors.k6B7280,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.purple500,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  widget.onApply(_selected.toList());
                  Get.back();
                },
                child: Text(
                  tr(LanguageKeys.Continue),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
