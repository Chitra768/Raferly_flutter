
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/resources/app_colors.dart';

import '../../controller/controller_archeivvelist.dart';
import '../../widgets/custom_app_bar.dart';

class ArchiveList extends GetView<ArcheiveListController>  {
  const ArchiveList({super.key});
  static String pageId = '/screenArcheiev';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: const CommonAppBar(
        title: 'Archive',
        actions: [
          Icon(Icons.upload, color: Colors.purple),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child:Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                color: const Color(0xFFF8FBFD),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration:  BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: AppColors.primary,
                              borderRadius: const BorderRadius.all(Radius.circular(8))
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Test Test', style: TextStyle(fontWeight: FontWeight.bold)),
                              Text('Hetal-- Patel&~+_', style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Row(
                        children: [
                          Text('Label:- ', style: TextStyle(fontWeight: FontWeight.bold)),
                          Icon(Icons.check_circle, color: Colors.green),
                          SizedBox(width: 4),
                          Text('Success', style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        children:  [
                          Text('Date:-   ', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('29/04/2025', style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side:  BorderSide(color: AppColors.primary,),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child:  Text('See description', style: TextStyle(color: AppColors.primary,fontSize: 16,fontWeight: FontWeight.w600)),
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
    );
  }
}
