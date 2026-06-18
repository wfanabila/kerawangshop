import 'package:flutter/material.dart';

class FAQPage extends StatefulWidget {
  const FAQPage({super.key});

  @override
  State<FAQPage> createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> _allFaqs = [
    {
      'question': 'Where to meet on campus?',
      'answer': 'We will deliver your orders straight to your room or can meet on popular spots include the Main Lobby, campus laundry or campus cafe.',
      'highlights': ['straight to your room', 'the Main Lobby, campus laundry or campus cafe'],
    },
    {
      'question': 'What payment methods are supported?',
      'answer': 'We support online banking (FPX), e-wallets such as TNG, as well as cash on delivery (COD) for on-campus meetups.',
      'highlights': ['online banking (FPX)','cash on delivery (COD)' ],
    },
    {
      'question': 'How do I report a suspicious seller?',
      'answer': 'Go to the seller\'s profile, select "Contact Us". You can submit your report there.',
      'highlights': ['"Contact Us"'],
    },
    {
      'question': 'Can I return items if I\'m not satisfied?',
      'answer': 'Yes, you may request a return within 3 days of receiving your item. The item must be unused and in its original condition. Contact the seller first to arrange the return.',
      'highlights': [],
    },
    {
      'question': 'How do I track my order?',
      'answer': 'You can track your order under "My Purchases" in your profile.',
      'highlights': ['"My Purchases"'],
    },
    {
      'question': 'Is my personal information safe?',
      'answer': 'Yes, we encrypt all personal data and never share it with third parties. Please review our Privacy Policy for full details.',
      'highlights': [],
    },
  ];

  List<Map<String, dynamic>> get _filteredFaqs {
    if (_searchQuery.isEmpty) return _allFaqs;
    return _allFaqs.where((faq) {
      return faq['question'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          faq['answer'].toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryPurple = Color(0xFF7B2CBF);
    const Color backgroundTint = Color(0xFFF3EEFD);

    return Scaffold(
      backgroundColor: backgroundTint,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryPurple, size: 26),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'FAQ',
          style: TextStyle(
            color: Color(0xFF2D2D2D),
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0), // same as settings.dart
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'How can we help?',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF2D2D2D),
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Everything you need to know about buying and selling on campus.',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF555555),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 14),
                    // Search bar
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3EEFD),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) => setState(() => _searchQuery = value),
                        style: const TextStyle(fontSize: 14, color: Color(0xFF2D2D2D)),
                        decoration: InputDecoration(
                          hintText: 'Search for answers...',
                          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                          prefixIcon: Icon(Icons.search_rounded, color: Colors.grey[400], size: 20),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 13),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),
              
              // header section
              _buildSectionHeader('Frequently Asked Questions'),
              const SizedBox(height: 10),

              if (_filteredFaqs.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Text(
                      'No results found for "$_searchQuery"',
                      style: TextStyle(color: Colors.grey[500], fontSize: 18),
                    ),
                  ),
                )
              else
                ..._filteredFaqs.map((faq) => _FAQTile(
                      question: faq['question'],
                      answer: faq['answer'],
                      highlights: List<String>.from(faq['highlights']),
                      primaryPurple: primaryPurple,
                    )),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF3A3A3A),
      ),
    );
  }
}

class _FAQTile extends StatefulWidget {
  final String question;
  final String answer;
  final List<String> highlights;
  final Color primaryPurple;

  const _FAQTile({
    required this.question,
    required this.answer,
    required this.highlights,
    required this.primaryPurple,
  });

  @override
  State<_FAQTile> createState() => _FAQTileState();
}

class _FAQTileState extends State<_FAQTile> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 220),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
      _isExpanded ? _controller.forward() : _controller.reverse();
    });
  }

  List<TextSpan> _buildAnswerSpans() {
    if (widget.highlights.isEmpty) {
      return [TextSpan(text: widget.answer)];
    }
    List<TextSpan> spans = [];
    String remaining = widget.answer;
    for (final highlight in widget.highlights) {
      final idx = remaining.indexOf(highlight);
      if (idx == -1) continue;
      if (idx > 0) spans.add(TextSpan(text: remaining.substring(0, idx)));
      spans.add(TextSpan(
        text: highlight,
        style: TextStyle(color: widget.primaryPurple, fontWeight: FontWeight.w500),
      ));
      remaining = remaining.substring(idx + highlight.length);
    }
    if (remaining.isNotEmpty) spans.add(TextSpan(text: remaining));
    return spans;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: _toggle,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      widget.question,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: _isExpanded ? widget.primaryPurple : Colors.black87,
                      ),
                    ),
                  ),

                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 20,
                    color: widget.primaryPurple,
                  ),
                ],
              ),
              SizeTransition(
                sizeFactor: _animation,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, left: 44), // indent under icon
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF555555),
                        height: 1.5,
                      ),
                      children: _buildAnswerSpans(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}