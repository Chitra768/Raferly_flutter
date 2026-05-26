import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/models/model_categories.dart';

class SelectJobsController extends GetxController {
  final searchController = TextEditingController();
  final RxList<CategoryData> categories = <CategoryData>[].obs;
  final RxList<CategoryData> filteredCategories = <CategoryData>[].obs;
  final RxSet<int> selectedJobIds = <int>{}.obs;
  final RxMap<int, bool> expandedCategories = <int, bool>{}.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final bool isSingleSelection;
  final int? initialJobId;

  SelectJobsController({this.isSingleSelection = false, this.initialJobId});

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(_filterCategories);
    fetchCategories();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> fetchCategories() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await RESTAuth.getCategories();

      if (result is ApiSuccess<ModelCategories>) {
        final data = result.data;
        if (data.status == true && data.data != null) {
          categories.value = data.data!;
          filteredCategories.value = data.data!;
          _trySelectInitialJobId();
        } else {
          errorMessage.value = data.message ?? 'Failed to load categories';
        }
      } else if (result is ApiFailure) {
        errorMessage.value =
            result.error.message ?? 'Failed to load categories';
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void _trySelectInitialJobId() {
    final id = initialJobId;
    if (id == null || !isSingleSelection) return;
    for (final category in categories) {
      for (final sub in category.subCategories ?? []) {
        if (sub.id == id) {
          selectedJobIds
            ..clear()
            ..add(id);
          selectedJobIds.refresh();
          return;
        }
      }
    }
  }

  void _filterCategories() {
    final query = searchController.text.toLowerCase().trim();
    if (query.isEmpty) {
      filteredCategories.value = categories;
      return;
    }

    filteredCategories.value = categories.where((category) {
      // Check if category title matches
      if (category.title?.toLowerCase().contains(query) ?? false) {
        return true;
      }

      // Check if any subcategory matches
      return category.subCategories?.any((subCategory) =>
              subCategory.title?.toLowerCase().contains(query) ?? false) ??
          false;
    }).toList();
  }

  void toggleCategory(int categoryId) {
    final isCurrentlyExpanded = expandedCategories[categoryId] ?? false;
    
    // If clicking on an already expanded category, collapse it
    if (isCurrentlyExpanded) {
      expandedCategories[categoryId] = false;
    } else {
      // Collapse all other categories first
      expandedCategories.clear();
      // Then expand the selected category
      expandedCategories[categoryId] = true;
    }
    expandedCategories.refresh();
  }

  bool isCategoryExpanded(int categoryId) {
    return expandedCategories[categoryId] ?? false;
  }

  void toggleJobSelection(int jobId) {
    if (selectedJobIds.contains(jobId)) {
      // In single selection mode, don't allow deselection - just return
      if (isSingleSelection) {
        return;
      }
      selectedJobIds.remove(jobId);
    } else {
      // If single selection mode, clear previous selection
      if (isSingleSelection) {
        selectedJobIds.clear();
      }
      selectedJobIds.add(jobId);
      
      // If single selection mode, automatically return the result
      if (isSingleSelection) {
        done();
        return;
      }
    }
    selectedJobIds.refresh();
  }

  bool isJobSelected(int jobId) {
    return selectedJobIds.contains(jobId);
  }

  int get selectedJobsCount => selectedJobIds.length;

  List<String> getSelectedJobTitles() {
    final titles = <String>[];
    for (final category in categories) {
      if (category.subCategories != null) {
        for (final subCategory in category.subCategories!) {
          if (selectedJobIds.contains(subCategory.id)) {
            titles.add(subCategory.title ?? '');
          }
        }
      }
    }
    return titles;
  }

  Map<int, String> getSelectedJobsMap() {
    final map = <int, String>{};
    for (final category in categories) {
      if (category.subCategories != null) {
        for (final subCategory in category.subCategories!) {
          if (selectedJobIds.contains(subCategory.id) && subCategory.id != null) {
            map[subCategory.id!] = subCategory.title ?? '';
          }
        }
      }
    }
    return map;
  }

  void clearAllSelections() {
    selectedJobIds.clear();
    selectedJobIds.refresh();
  }

  void done() {
    if (isSingleSelection && selectedJobIds.isNotEmpty) {
      final jobId = selectedJobIds.first;
      final jobTitle = getSelectedJobsMap()[jobId] ?? '';
      Get.back(result: {
        'id': jobId,
        'title': jobTitle,
      });
    } else {
      Get.back(result: {
        'ids': selectedJobIds.toList(),
        'titles': getSelectedJobsMap(),
      });
    }
  }
}

