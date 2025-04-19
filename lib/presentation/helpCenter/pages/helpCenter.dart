import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/configs/theme/app_colors.dart';

class HelpCenterPage extends StatefulWidget {
  const HelpCenterPage({super.key});

  @override
  State<HelpCenterPage> createState() => _HelpCenterPageState();
}

class _HelpCenterPageState extends State<HelpCenterPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<bool> faqExpansion = List.generate(7, (_) => false);
  List<bool> contactExpansion = List.generate(6, (_) => false);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text('Help Center', style: TextStyle(color: Colors.black)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                fillColor: Colors.white,
                filled: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          TabBar(
            controller: _tabController,
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(fontWeight: FontWeight.w600),
            tabs: const [
              Tab(text: 'FAQ'),
              Tab(text: 'Contact Us'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                /// FAQ TAB
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 40,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildCategoryChip('All', true),
                            _buildCategoryChip('Services', false),
                            _buildCategoryChip('General', false),
                            _buildCategoryChip('Account', false),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: ListView.builder(
                          itemCount: faqExpansion.length,
                          itemBuilder: (context, index) {
                            final questions = [
                              'What if I need to cancel a booking?',
                              'What services do you offer?',
                              'How do I schedule a car wash appointment?',
                              'How do I provide feedback about the service?',
                              'How Filter Work?',
                              'Is Voice call or Chat Feature there?',
                              'How to Add Money in Wallet?',
                            ];

                            return _buildExpansionTile(
                              index,
                              faqExpansion,
                              questions[index],
                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                /// CONTACT TAB
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: ListView.builder(
                    itemCount: contactExpansion.length,
                    itemBuilder: (context, index) {
                      final List<IconData> icons = [
                        Icons.headset_mic,
                        FontAwesomeIcons.whatsapp,
                        Icons.language,
                        FontAwesomeIcons.facebook,
                        FontAwesomeIcons.twitter,
                        FontAwesomeIcons.instagram,
                      ];

                      final List<Color> iconColors = [
                        AppColors.primary,
                        Colors.green,
                        Colors.blueGrey,
                        Color(0xFF3b5998),
                        Color(0xFF00acee),
                        Color(0xFFe4405f),
                      ];

                      final List<String> titles = [
                        'Customer Service',
                        'WhatsApp',
                        'Website',
                        'Facebook',
                        'Twitter',
                        'Instagram',
                      ];

                      final List<String?> content = [
                        'You can reach out to our customer care 24/7.',
                        '(480) 555-0103',
                        'Visit: www.example.com',
                        'Connect with us on Facebook.',
                        'Follow us on Twitter.',
                        'Follow us on Instagram.',
                      ];

                      return _buildExpansionTile(
                        index,
                        contactExpansion,
                        titles[index],
                        content[index],
                        icon: icons[index],
                        iconColor: iconColors[index],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: AppColors.primary,
        backgroundColor: Colors.grey.shade200,
        labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
        onSelected: (_) {},
      ),
    );
  }

  Widget _buildExpansionTile(
      int index,
      List<bool> expandedList,
      String title,
      String? content, {
        IconData? icon,
        Color iconColor = Colors.black,
      }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ExpansionPanelList(
        animationDuration: const Duration(milliseconds: 300),
        expandedHeaderPadding: EdgeInsets.zero,
        expansionCallback: (int itemIndex, bool isExpanded) {
          setState(() {
            expandedList[index] = !isExpanded;
          });
        },
        children: [
          ExpansionPanel(
            canTapOnHeader: true,
            isExpanded: expandedList[index],
            headerBuilder: (context, isExpanded) {
              return ListTile(
                leading: icon != null ? Icon(icon, color: iconColor) : null,
                title: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              );
            },
            body: content != null
                ? Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                content,
                style: TextStyle(color: Colors.grey[700]),
              ),
            )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
