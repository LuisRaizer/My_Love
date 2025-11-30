import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LoveMessagesComponent extends StatelessWidget {
  const LoveMessagesComponent({super.key});

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

  @override
  Widget build(BuildContext context) {
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
            
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 16),
                      child: ElevatedButton(
                        onPressed: () => _sendMessage(
                          'Saudade de vc amor, teleporta aqui pf', 
                          context
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFe83f3f),
                          padding: EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.favorite, color: Colors.white, size: 28),
                            SizedBox(width: 12),
                            Text(
                              'Saudades?',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 16),
                      child: ElevatedButton(
                        onPressed: () => _sendMessage(
                          'Estou indo aí amor, prepara', 
                          context
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFe83f3f),
                          padding: EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.directions_run, color: Colors.white, size: 28),
                            SizedBox(width: 12),
                            Text(
                              'Indo me ver?',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 16),
                      child: ElevatedButton(
                        onPressed: () => _sendMessage(
                          'Eu to meio sla agr', 
                          context
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFe83f3f),
                          padding: EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.sentiment_neutral, color: Colors.white, size: 28),
                            SizedBox(width: 12),
                            Text(
                              'Meio sla?',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 16),
                      child: ElevatedButton(
                        onPressed: () => _sendMessage(
                          'Cuidado meu bem, avisa qlqr coisa', 
                          context
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFe83f3f),
                          padding: EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.warning_amber, color: Colors.white, size: 28),
                            SizedBox(width: 12),
                            Text(
                              'Cuidado meu amor',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 16),
                      child: ElevatedButton(
                        onPressed: () => _sendMessage(
                          'Pqp amor, que raiva agr', 
                          context
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFe83f3f),
                          padding: EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.mood_bad, color: Colors.white, size: 28),
                            SizedBox(width: 12),
                            Text(
                              'Raiva?',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 16),
                      child: ElevatedButton(
                        onPressed: () => _sendMessage(
                          'Te amo', 
                          context
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFe83f3f),
                          padding: EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.favorite_border, color: Colors.white, size: 28),
                            SizedBox(width: 12),
                            Text(
                              'Te amo',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 16),
                      child: ElevatedButton(
                        onPressed: () => _sendMessage(
                          'To muito cansada amor, vou dormir um pouco e volto já, te amo 🤍', 
                          context
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFe83f3f),
                          padding: EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.nightlight_round, color: Colors.white, size: 28),
                            SizedBox(width: 12),
                            Text(
                              'Vai dormir um pouco?',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}