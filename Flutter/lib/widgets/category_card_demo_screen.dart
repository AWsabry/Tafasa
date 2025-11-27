import 'package:flutter/material.dart';
import 'package:tafasa/widgets/category_card_option1.dart';
import 'package:tafasa/widgets/category_card_option2.dart';
import 'package:tafasa/widgets/category_card_option3.dart';

/// Demo screen to showcase all three category card options
/// To test this, add a button in your home screen that navigates here:
///
/// Navigator.push(context, MaterialPageRoute(builder: (_) => CategoryCardDemoScreen()));
class CategoryCardDemoScreen extends StatelessWidget {
  const CategoryCardDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 2,
          title: const Text(
            'اختر تصميم البطاقة',
            style: TextStyle(
              fontFamily: 'FFKhallab',
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Option 1
                _buildOptionHeader('الخيار 1', 'طبقة شفافة خفيفة مع نص ملون'),
                const SizedBox(height: 12),
                SizedBox(
                  height: 200,
                  child: Row(
                    children: [
                      Expanded(
                        child: CategoryCardOption1(
                          category: 'فطور',
                          onTap: () => _showSelectedOption(context, 'الخيار 1'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CategoryCardOption1(
                          category: 'غداء',
                          onTap: () => _showSelectedOption(context, 'الخيار 1'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Option 2
                _buildOptionHeader('الخيار 2', 'إطار أبيض مع نص أسفل الصورة'),
                const SizedBox(height: 12),
                SizedBox(
                  height: 200,
                  child: Row(
                    children: [
                      Expanded(
                        child: CategoryCardOption2(
                          category: 'عشاء',
                          onTap: () => _showSelectedOption(context, 'الخيار 2'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CategoryCardOption2(
                          category: 'تحلية',
                          onTap: () => _showSelectedOption(context, 'الخيار 2'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Option 3
                _buildOptionHeader('الخيار 3', 'تأثير الزجاج المصنفر'),
                const SizedBox(height: 12),
                SizedBox(
                  height: 200,
                  child: Row(
                    children: [
                      Expanded(
                        child: CategoryCardOption3(
                          category: 'سناكس',
                          onTap: () => _showSelectedOption(context, 'الخيار 3'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CategoryCardOption3(
                          category: 'صحي',
                          onTap: () => _showSelectedOption(context, 'الخيار 3'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Instructions
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '📝 ملاحظة:',
                        style: TextStyle(
                          fontFamily: 'FFKhallab',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'اضغط على أي بطاقة لاختيار هذا التصميم. سيتم تطبيقه على جميع البطاقات في الشاشة الرئيسية.',
                        style: TextStyle(
                          fontFamily: 'FFKhallab',
                          fontSize: 14,
                          color: Colors.grey[600],
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionHeader(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'FFKhallab',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: TextStyle(
            fontFamily: 'FFKhallab',
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  void _showSelectedOption(BuildContext context, String option) {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'تم الاختيار',
            style: TextStyle(
              fontFamily: 'FFKhallab',
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'هل تريد استخدام $option في التطبيق؟',
            style: const TextStyle(
              fontFamily: 'FFKhallab',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'إلغاء',
                style: TextStyle(fontFamily: 'FFKhallab'),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'تم اختيار $option! أخبر المطور لتطبيق هذا التصميم.',
                      style: const TextStyle(fontFamily: 'FFKhallab'),
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text(
                'تأكيد',
                style: TextStyle(fontFamily: 'FFKhallab'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
