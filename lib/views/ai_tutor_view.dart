import 'package:flutter/material.dart';

class AiTutorView extends StatefulWidget {
  const AiTutorView({super.key});

  @override
  State<AiTutorView> createState() => _AiTutorViewState();
}

class _AiTutorViewState extends State<AiTutorView> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'isUser': false,
      'text': 'Hello Rein! 👋 I am your AI Study Tutor. Ask me any question, or send an image of a problem you want me to explain!',
    },
  ];

  void _sendMessage([String? textToSend]) {
    final text = textToSend ?? _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'isUser': true, 'text': text});
      _messageController.clear();
    });

    // Simulated AI response
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _messages.add({
            'isUser': false,
            'text': 'Got it! Let me break that down for you step-by-step...',
          });
        });
      }
    });
  }

  void _showAttachmentBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Text(
                'Upload Problem or Photo',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildAttachmentOption(
                    icon: Icons.camera_alt_rounded,
                    label: 'Take Photo',
                    color: const Color(0xFF1E5E2F),
                    onTap: () {
                      Navigator.pop(context);
                      _sendMessage("📸 [Uploaded a photo of a math problem]");
                    },
                  ),
                  _buildAttachmentOption(
                    icon: Icons.photo_library_rounded,
                    label: 'Gallery',
                    color: Colors.blue,
                    onTap: () {
                      Navigator.pop(context);
                      _sendMessage("🖼️ [Uploaded an image from gallery]");
                    },
                  ),
                  _buildAttachmentOption(
                    icon: Icons.insert_drive_file_rounded,
                    label: 'Document',
                    color: Colors.purple,
                    onTap: () {
                      Navigator.pop(context);
                      _sendMessage("📄 [Uploaded a document file]");
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAttachmentOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: color.withValues(alpha: 0.12),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F3),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF1E5E2F).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.smart_toy_rounded, color: Color(0xFF1E5E2F), size: 20),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Tutor',
                  style: TextStyle(color: Color(0xFF1E293B), fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Always online • Step-by-step help',
                  style: TextStyle(color: Color(0xFF166534), fontSize: 11, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // 1. MESSAGES LIST
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message['isUser'] as bool;

                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.78,
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isUser ? const Color(0xFF1E5E2F) : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(isUser ? 16 : 4),
                        bottomRight: Radius.circular(isUser ? 4 : 16),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      message['text'],
                      style: TextStyle(
                        color: isUser ? Colors.white : const Color(0xFF1E293B),
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // 2. SUGGESTED QUICK PROMPTS CHIPS
          if (_messages.length <= 2)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                children: [
                  _buildPromptChip('📸 Solve a problem photo'),
                  _buildPromptChip('🧮 Explain Balance Sheet formula'),
                  _buildPromptChip('📝 Quiz me on Chapter 3'),
                  _buildPromptChip('💡 Simplify SDLC phases'),
                ],
              ),
            ),

          // 3. INPUT BAR WITH ATTACHMENT & MIC
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Attach Button
                IconButton(
                  icon: const Icon(Icons.add_circle_outline_rounded, color: Color(0xFF64748B), size: 26),
                  onPressed: _showAttachmentBottomSheet,
                ),
                const SizedBox(width: 4),

                // Text Input
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Ask a question or describe a problem...',
                        hintStyle: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Send Button
                GestureDetector(
                  onTap: () => _sendMessage(),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1E5E2F),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromptChip(String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ActionChip(
        label: Text(text, style: const TextStyle(fontSize: 11, color: Color(0xFF1E5E2F), fontWeight: FontWeight.w600)),
        backgroundColor: const Color(0xFFE8F0E6),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () => _sendMessage(text),
      ),
    );
  }
}