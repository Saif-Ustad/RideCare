import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/configs/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

class HelpCenterPage extends StatefulWidget {
  const HelpCenterPage({Key? key}) : super(key: key);

  @override
  State<HelpCenterPage> createState() => _HelpCenterPageState();
}

class _HelpCenterPageState extends State<HelpCenterPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedCategory = 'All';
  String searchQuery = '';
  final _searchController = TextEditingController();

  final List<Map<String, String>> faqData = [
    {
      'category': 'Services',
      'question': 'What services do you offer?',
      'answer':
          'We offer car washing, interior vacuuming, waxing, polishing, and full detailing packages.',
    },
    {
      'category': 'General',
      'question': 'Can I cancel a booking?',
      'answer':
          'Yes—just go to “My Bookings” and cancel up to 2 hours before your slot with no fee.',
    },
    {
      'category': 'Services',
      'question': 'How do I schedule an appointment?',
      'answer':
          'Tap “Book Service”, pick your date/time and preferred location, then confirm.',
    },
    {
      'category': 'General',
      'question': 'How do I leave feedback?',
      'answer':
          'After each service, we’ll prompt you to rate and review right in the app.',
    },
    {
      'category': 'Account',
      'question': 'How do filters work?',
      'answer':
          'Use the category chips at the top to narrow down FAQs by topic.',
    },
    {
      'category': 'Account',
      'question': 'Is there chat or phone support?',
      'answer':
          'Yes—visit the “Contact Us” tab for live chat or call our 24/7 hotline.',
    },
    {
      'category': 'Account',
      'question': 'How do I add money to my wallet?',
      'answer':
          'Open “Wallet” in the menu, tap “Add Funds”, and follow the prompts.',
    },
  ];

  final List<Map<String, dynamic>> contactData = [
    {
      'icon': Icons.headset_mic,
      'iconColor': AppColors.primary,
      'title': 'Customer Service',
      'content': '24/7 support at (480) 555‑0103 or support@ridecare.com',
    },
    {
      'icon': FontAwesomeIcons.whatsapp,
      'iconColor': Colors.green,
      'title': 'WhatsApp',
      'content': 'Chat with us: +91 9146394986',
    },
    {
      'icon': Icons.language,
      'iconColor': Colors.blueGrey,
      'title': 'Website',
      'content': 'Visit: www.ridecare.com',
    },
    {
      'icon': FontAwesomeIcons.facebook,
      'iconColor': Color(0xFF3b5998),
      'title': 'Facebook',
      'content': 'facebook.com/ridecare',
    },
    {
      'icon': FontAwesomeIcons.twitter,
      'iconColor': Color(0xFF00acee),
      'title': 'Twitter',
      'content': '@RideCareApp',
    },
    {
      'icon': FontAwesomeIcons.instagram,
      'iconColor': Color(0xFFe4405f),
      'title': 'Instagram',
      'content': '@RideCareApp',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController.addListener(() {
      setState(() => searchQuery = _searchController.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: _buildLeadingIconButton(() => context.pop()),
        title: const Text(
          "Help Center",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // ── Search Bar ─────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search FAQs...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: AppColors.lightGray,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

          // ── Tabs ────────────────────────────────────────────────────────────
          TabBar(
            controller: _tabController,
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(fontWeight: FontWeight.w600),
            tabs: const [Tab(text: 'FAQ'), Tab(text: 'Contact Us')],
          ),

          // ── Tab Views ────────────────────────────────────────────────────────
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildFAQTab(),

                ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: contactData.length,
                  itemBuilder: (ctx, i) {
                    final item = contactData[i];
                    return Card(
                      color: AppColors.lightGray,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: Icon(item['icon'], color: item['iconColor']),
                        title: Text(
                          item['title'],
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(item['content']),
                      ),
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

  Widget _buildFAQTab() {
    final filtered =
        faqData.where((item) {
          final q = item['question']!.toLowerCase();
          final a = item['answer']!.toLowerCase();
          final matchesSearch =
              searchQuery.isEmpty ||
              q.contains(searchQuery) ||
              a.contains(searchQuery);
          final matchesCategory =
              selectedCategory == 'All' || item['category'] == selectedCategory;
          return matchesSearch && matchesCategory;
        }).toList();

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Chips
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children:
                  ['All', 'Services', 'General', 'Account'].map((cat) {
                    final sel = cat == selectedCategory;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(cat),
                        selected: sel,
                        selectedColor: AppColors.primary,
                        backgroundColor: Colors.grey.shade200,
                        labelStyle: TextStyle(
                          color: sel ? Colors.white : Colors.black,
                        ),
                        onSelected:
                            (_) => setState(() => selectedCategory = cat),
                      ),
                    );
                  }).toList(),
            ),
          ),
          const SizedBox(height: 12),

          // FAQ List
          Expanded(
            child:
                filtered.isEmpty
                    ? const Center(
                      child: Text(
                        "No FAQs match your search.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                    : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (ctx, i) {
                        final item = filtered[i];

                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 6,
                                spreadRadius: 1,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          margin: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 5,
                          ),
                          child: Theme(
                            data: Theme.of(
                              context,
                            ).copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              collapsedBackgroundColor: Colors.white,
                              backgroundColor: Colors.white,
                              tilePadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 5,
                              ),
                              childrenPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              title: Text(
                                item['question']!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    item['answer']!,
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeadingIconButton(VoidCallback onPressed) => Padding(
    padding: const EdgeInsets.only(left: 15),
    child: Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.darkGrey, width: 1),
        color: Colors.white,
      ),
      child: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
        onPressed: onPressed,
        constraints: const BoxConstraints(),
        padding: EdgeInsets.zero,
      ),
    ),
  );
}
