import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../widgets/custom_app_header.dart';

class AiTutorView extends StatefulWidget {
  const AiTutorView({super.key});

  @override
  State<AiTutorView> createState() => _AiTutorViewState();
}

class _AiTutorViewState extends State<AiTutorView>
    with SingleTickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final SpeechToText _speechToText = SpeechToText();
  bool _isRecording = false;
  late final AnimationController _micPulseController;
  late final Animation<double> _micPulseAnimation;
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
  void initState() {
    super.initState();
    _micPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _micPulseAnimation = Tween<double>(begin: 0.8, end: 1.3).animate(
      CurvedAnimation(parent: _micPulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _micPulseController.dispose();
    _speechToText.stop();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      await _speechToText.stop();
      _micPulseController.stop();
      if (mounted) setState(() => _isRecording = false);
      return;
    }

    final available = await _speechToText.initialize();
    if (!available) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Speech recognition is not available on this device.'),
        ),
      );
      return;
    }

    await _speechToText.listen(
      onResult: (result) {
        if (!mounted) return;
        setState(() {
          _messageController.text = result.recognizedWords;
          _messageController.selection = TextSelection.fromPosition(
            TextPosition(offset: _messageController.text.length),
          );
        });
      },
      listenOptions: SpeechListenOptions(
        listenFor: const Duration(seconds: 20),
        pauseFor: const Duration(seconds: 3),
        localeId: 'en_US',
        cancelOnError: true,
        partialResults: true,
      ),
    );

    _micPulseController.repeat(reverse: true);
    if (mounted) setState(() => _isRecording = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const CustomAppHeader(
        title: 'SPC Tutor',
        subtitle: 'Always online • Step-by-step help',
        leadingIcon: Icons.smart_toy_rounded,
        showBackButton: true,
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
                      color: isUser ? const Color(0xFF1E5E2F) : Theme.of(context).cardColor,
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
                        color: isUser
                            ? Colors.white
                            : Theme.of(context).colorScheme.onSurface,
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
              color: Theme.of(context).cardColor,
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
                  icon: Icon(
                    Icons.add_circle_outline_rounded,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 26,
                  ),
                  onPressed: _showAttachmentBottomSheet,
                ),
                const SizedBox(width: 4),

                // Voice Recording Button (Active Recall effect)
                AnimatedBuilder(
                  animation: _micPulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _isRecording ? _micPulseAnimation.value : 1.0,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isRecording
                              ? const Color(0xFFDC2626)
                              : Theme.of(context).cardColor,
                          border: Border.all(
                            color: _isRecording
                                ? Colors.red
                                : Theme.of(context).brightness == Brightness.dark
                                    ? const Color(0xFF2ECC71)
                                    : const Color(0xFF1E5E2F),
                            width: 1.5,
                          ),
                          boxShadow: _isRecording
                              ? [
                                  BoxShadow(
                                    color: Colors.red.withValues(alpha: 0.4),
                                    blurRadius: 12,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : null,
                        ),
                        child: IconButton(
                          onPressed: _toggleRecording,
                          tooltip: _isRecording
                              ? 'Stop recording'
                              : 'Record voice',
                          icon: Icon(
                            _isRecording
                                ? Icons.mic_off_rounded
                                : Icons.mic_rounded,
                            color: _isRecording
                                ? Colors.white
                                : Theme.of(context).brightness == Brightness.dark
                                    ? const Color(0xFF2ECC71)
                                    : const Color(0xFF1E5E2F),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 4),

                // Text Input
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _messageController,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Ask a question or describe a problem...',
                        hintStyle: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ActionChip(
        label: Text(
          text,
          style: TextStyle(
            fontSize: 11,
            color: isDark
                ? const Color(0xFFECEFF1)
                : const Color(0xFF1E5E2F),
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: isDark
            ? Theme.of(context).cardColor
            : const Color(0xFFE8F0E6),
        side: BorderSide(
          color: isDark
              ? const Color(0xFF2ECC71).withValues(alpha: 0.3)
              : Colors.transparent,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () => _sendMessage(text),
      ),
    );
  }
}