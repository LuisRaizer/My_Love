import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      'text': 'Cuidado meu bem, avisa qlqr coisa',
      'label': 'Cuidado meu amor',
      'icon': Icons.warning_amber,
      'isCustom': false,
    },
    {
      'text': 'Te amo',
      'label': 'Te amo',
      'icon': Icons.favorite_border,
      'isCustom': false,
    },
    {
      'text': 'To muito cansada amor, vou dormir um pouco e volto já, te amo 🤍',
      'label': 'Vai dormir um pouco?',
      'icon': Icons.nightlight_round,
      'isCustom': false,
    },
  ];

  final List<Map<String, dynamic>> _customMessages = [];
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadCustomMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _messageFocusNode.dispose();
    super.dispose();
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

  Future<void> _sendMessage(String message, BuildContext context) async {
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
    
    String phone = '5585997593344';
    
    String url = 'https://wa.me/$phone?text=${Uri.encodeComponent(message)}';
    
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
              width: double.infinity,
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'Mensagens automáticas para mim',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFe83f3f),
                      fontFamily: 'FredokaOne',
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Toque para enviar uma mensagem!',
                    style: TextStyle(
                      color: Color(0xFFe83f3f),
                      fontSize: 16,
                    ),
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
                                  onTap: () => _sendMessage(msg['text'] as String, context),
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