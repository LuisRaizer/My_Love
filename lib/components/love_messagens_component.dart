import 'package:app/utils/personal_content.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/services/store_balloon_service.dart';

class LoveMessagesComponent extends StatefulWidget {
  const LoveMessagesComponent({super.key});

  @override
  State<LoveMessagesComponent> createState() => _LoveMessagesComponentState();
}

class _LoveMessagesComponentState extends State<LoveMessagesComponent> {
  final List<Map<String, dynamic>> _defaultMessages = [
    {
      'text': 'Saudade amor, teleporta aqui pf',
      'label': 'Saudades?',
      'icon': Icons.favorite,
      'isCustom': false,
    },
    {
      'text': 'Te amo',
      'label': 'Te amo',
      'icon': Icons.favorite_border,
      'isCustom': false,
    },
    {
      'text': '',
      'label': 'Ver balões',
      'icon': Icons.ballot,
      'isCustom': false,
      'isBalloonMessage': true,
    },
  ];

  final List<Map<String, dynamic>> _customMessages = [];
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();
  
  int _totalPoppedBalloons = 0;

  @override
  void initState() {
    super.initState();
    _loadCustomMessages();
    _loadBalloonCount();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _messageFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadBalloonCount() async {
    try {
      final total = await StorageService.getTotalPopped();
      setState(() {
        _totalPoppedBalloons = total;
      });
    } catch (e) {
      print('Erro ao carregar contagem de balões: $e');
    }
  }

  Future<void> _loadCustomMessages() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getStringList('custom_messages') ?? [];
      
      setState(() {
        _customMessages.clear();
        for (var text in saved) {
          _customMessages.add({
            'text': text,
            'label': text.length > 15 ? '${text.substring(0, 15)}...' : text,
            'icon': Icons.add_circle,
            'isCustom': true,
          });
        }
      });
    } catch (e) {
      print('Erro ao carregar mensagens: $e');
    }
  }

  Future<void> _saveCustomMessages() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final messages = _customMessages.map((msg) => msg['text'] as String).toList();
      await prefs.setStringList('custom_messages', messages);
    } catch (e) {
      print('Erro ao salvar mensagens: $e');
    }
  }

  Future<void> _addCustomMessage() async {
    if (_messageController.text.trim().isEmpty) {
      _showErrorSnackBar('Amor, digita algo primeiro para ser salvo aqui bele?');
      return;
    }

    if (_messageController.text.trim().length > 100) {
      _showErrorSnackBar('Mensagem muito longa meu amor, vai travar tudo (máx: 100 caracteres)');
      return;
    }

    final newMessage = _messageController.text.trim();
    
    setState(() {
      _customMessages.add({
        'text': newMessage,
        'label': newMessage.length > 15 ? '${newMessage.substring(0, 15)}...' : newMessage,
        'icon': Icons.add_circle,
        'isCustom': true,
      });
    });

    await _saveCustomMessages();
    
    _messageController.clear();
    _messageFocusNode.unfocus();
    
    _showSuccessSnackBar('Mensagem adicionada, perfeito amor!');
  }

  Future<void> _removeCustomMessage(int index) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remover mensagem?'),
        content: Text('Tem certeza que deseja remover esta mensagem?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              setState(() {
                _customMessages.removeAt(index);
              });
              await _saveCustomMessages();
              _showSuccessSnackBar('Mensagem removida!');
            },
            child: Text('Remover', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage(String message, BuildContext context, {bool isBalloonMessage = false}) async {
    String finalMessage = message;
    int balloonCount = 0; 
    
    if (isBalloonMessage) {
      balloonCount = await StorageService.getTotalPopped();
      finalMessage = 'Olha amor, estourei $balloonCount balões no app! 🎈💥';
    }
    
    final shouldSend = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.ballot, color: Color(0xFFe83f3f)),
            SizedBox(width: 10),
            Text('Enviar mensagem'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Você vai enviar:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                finalMessage,
                style: TextStyle(fontSize: 14),
              ),
            ),
            SizedBox(height: 10),
            if (isBalloonMessage)
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade300, width: 1),
                ),
                child: Row(
                  children: [
                    Icon(Icons.celebration, size: 20, color: Colors.orange),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '🎉 Você já estourou $balloonCount balões!',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange.shade800,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFe83f3f),
              foregroundColor: Colors.white,
            ),
            child: Text('Enviar'),
          ),
        ],
      ),
    );
    
    if (shouldSend != true) {
      return;
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 2,
            ),
            SizedBox(width: 12),
            Text('💌 Abrindo WhatsApp...'),
          ],
        ),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green[600],
      ),
    );

    await Future.delayed(Duration(milliseconds: 500));
    
    String phone = PersonalConfig.whatsappNumber;
    
    String url = 'https://wa.me/$phone?text=${Uri.encodeComponent(finalMessage)}';
    
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(
          Uri.parse(url),
          mode: LaunchMode.externalApplication,
        );
      }
    } catch (e) {
      print('Erro: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Erro ao abrir WhatsApp'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xC0F44336),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allMessages = [..._defaultMessages, ..._customMessages];
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF87CEEB),
            Color(0xFFD7EFFF),
            Colors.white,
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                children: [
                  SizedBox(height: 6),
                  Text(
                    'Toque para enviar uma mensagem para mim, c pode adicionar!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    fontStyle: FontStyle.italic,
                  ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            Card(
              margin: EdgeInsets.all(16),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _messageController,
                      focusNode: _messageFocusNode,
                      maxLines: 2,
                      maxLength: 100,
                      decoration: InputDecoration(
                        labelText: 'Digite uma nova mensagem...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: 'Ex: Vou alí na Ohana, volto já',
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _addCustomMessage,
                      icon: Icon(Icons.add_circle_outline),
                      label: Text('Criar Novo Botão'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF4CAF50),
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: allMessages.length,
                  itemBuilder: (context, index) {
                    final msg = allMessages[index];
                    final isCustom = msg['isCustom'] as bool;
                    final isBalloonMessage = msg['isBalloonMessage'] == true;
                    
                    return GestureDetector(
                      onLongPress: isCustom
                          ? () => _removeCustomMessage(index - _defaultMessages.length)
                          : null,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFe83f3f),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () => _sendMessage(
                                    msg['text'] as String, 
                                    context, 
                                    isBalloonMessage: isBalloonMessage
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    padding: EdgeInsets.all(12),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          msg['icon'] as IconData,
                                          color: Colors.white,
                                          size: 28,
                                        ),
                                        SizedBox(height: 10),
                                        Flexible(
                                          child: Text(
                                            msg['label'] as String,
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            
                            if (isCustom)
                              Positioned(
                                top: 6,
                                right: 6,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(7),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 2,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    'Novo',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFe83f3f),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            
            if (_customMessages.isNotEmpty)
              Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                color: Colors.white.withOpacity(0.3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.info_outline, size: 16, color: Color(0x6CE83F3F)),
                    SizedBox(width: 8),
                    Text(
                      'Mantenha pressionado para remover mensagens personalizadas',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0x6CE83F3F),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}