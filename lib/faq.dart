import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme_provider.dart';

class FAQPage extends ConsumerStatefulWidget {
  const FAQPage({super.key});

  @override
  ConsumerState<FAQPage> createState() => _FAQPageState();
}

class _FAQPageState extends ConsumerState<FAQPage> {
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
    final isDarkMode = ref.watch(themeProvider);
    final Color primaryPurple = isDarkMode ? const Color(0xFF7B2FF7) : const Color(0xFF7B2CBF);
    final Color backgroundTint = isDarkMode ? const Color(0xFF120A2A) : const Color(0xFFF3EEFD);
    final Color cardBackground = isDarkMode ? const Color(0xFF221A4A) : Colors.white;
    final Color textColor = isDarkMode ? Colors.white : const Color(0xFF2D2D2D);
    final Color subTextColor = isDarkMode ? Colors.white70 : const Color(0xFF555555);
    final Color fieldColor = isDarkMode ? const Color(0xFF1E163A) : const Color(0xFFF3EEFD);

    return Scaffold(
      backgroundColor: backgroundTint,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryPurple, size: 26),
          onPressed: () {
            Navigator.pop(context);
          },
   
      ),
        title: Text(
          'FAQ',
          style: TextStyle(
            color: textColor,
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
                  color: cardBackground,
                  borderRadius: BorderRadius.circular(16),
                
),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How can we help?',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: textColor,
 
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
            
                    Text(
                      'Everything you need to know about buying and selling on campus.',
                      style: TextStyle(
                        fontSize: 14,
           
                        fontWeight: FontWeight.w500,
                        color: subTextColor,
                        height: 1.4,
                      ),
              
       ),
                    const SizedBox(height: 14),
                    // Search bar
                    Container(
                      decoration: BoxDecoration(
       
                        color: fieldColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
           
                        controller: _searchController,
                        onChanged: (value) => setState(() => _searchQuery = value),
                        style: TextStyle(fontSize: 14, color: textColor),
                        decoration: InputDecoration(
 
                          hintText: 'Search for answers...',
                          hintStyle: TextStyle(color: isDarkMode ? Colors.white60 : Colors.grey[400], fontSize: 14),
                          prefixIcon: Icon(Icons.search_rounded, color: isDarkMode ? Colors.white60 : Colors.grey[400], size: 20),
           
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
              _buildSectionHeader('Frequently Asked Questions', isDarkMode),
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
                      isDarkMode: isDarkMode,
                      cardBackground: cardBackground,
                      textColor: textColor,
                      subTextColor: subTextColor,
                    )),

              const SizedBox(height: 40),
   
          ],
          ),
        ),
      ),
    );
 }

  Widget _buildSectionHeader(String title, bool isDarkMode) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: isDarkMode ? Colors.white70 : const Color(0xFF3A3A3A),
      ),
    );
 }
}

class _FAQTile extends StatefulWidget {
  final String question;
  final String answer;
  final List<String> highlights;
  final Color primaryPurple;
  final bool isDarkMode;
  final Color cardBackground;
  final Color textColor;
  final Color subTextColor;
 const _FAQTile({
    required this.question,
    required this.answer,
    required this.highlights,
    required this.primaryPurple,
    required this.isDarkMode,
    required this.cardBackground,
    required this.textColor,
    required this.subTextColor,
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
        color: widget.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: _toggle,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, 
 vertical: 14),
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
                        color: _isExpanded ?
 widget.primaryPurple : (widget.isDarkMode ? Colors.white : Colors.black87),
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
                      style: TextStyle(
                     
    fontSize: 14,
                        color: widget.subTextColor,
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