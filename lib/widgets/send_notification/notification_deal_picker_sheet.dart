import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_coworkerlist_deal.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/utils/translations.dart';

/// Multi-select deals for send notification (from [CoworkerlistDealData]).
class NotificationDealPickerSheet extends StatefulWidget {
  const NotificationDealPickerSheet({
    super.key,
    required this.deals,
    required this.initialSelectedIds,
    required this.onApply,
  });

  final List<CoworkerlistDealData> deals;
  final List<int> initialSelectedIds;
  final void Function(List<int> ids) onApply;

  @override
  State<NotificationDealPickerSheet> createState() =>
      _NotificationDealPickerSheetState();
}

class _NotificationDealPickerSheetState
    extends State<NotificationDealPickerSheet> {
  late Set<int> _selected;
  final _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selected = Set<int>.from(
      widget.initialSelectedIds.where(
        (id) => widget.deals.any((d) => d.id == id),
      ),
    );
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<CoworkerlistDealData> get _filtered {
    final q = _search.text.trim().toLowerCase();
    if (q.isEmpty) return widget.deals;
    return widget.deals
        .where((d) => (d.dealName ?? '').toLowerCase().contains(q))
        .toList();
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
                    tr(LanguageKeys.sendNotifPickDealsTitle),
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
                hintText: tr(LanguageKeys.sendNotifSearchDeals),
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
                        tr(LanguageKeys.sendNotifNoDeals),
                        style: TextStyle(color: AppColors.k6B7280),
                      ),
                    )
                  : ListView.separated(
                      itemCount: _filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, i) {
                        final d = _filtered[i];
                        final id = d.id;
                        if (id == null) return const SizedBox.shrink();
                        final checked = _selected.contains(id);
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
                                    child: Text(
                                      d.dealName ?? '',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                        color: AppColors.slate900,
                                      ),
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
