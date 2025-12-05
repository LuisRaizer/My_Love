import 'package:flutter/material.dart';
import 'package:app/controllers/app_controller.dart';
import 'package:app/controllers/timer_controller.dart';

class OurSpaceComponent extends StatelessWidget {
  final AppController appController;
  final TimerController timerController;

  const OurSpaceComponent({
    super.key,
    required this.appController,
    required this.timerController,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _buildTimerCard()),
        SliverToBoxAdapter(child: SizedBox(height: 16)),
        SliverToBoxAdapter(child: _buildStatsCard()),
        SliverToBoxAdapter(child: SizedBox(height: 16)),
        SliverToBoxAdapter(child: _buildPhotosCard()),
        SliverToBoxAdapter(child: SizedBox(height: 20)),
      ],
    );
  }

  Widget _buildTimerCard() {
    return ListenableBuilder(
      listenable: timerController,
      builder: (context, child) {
        return Card(
          margin: EdgeInsets.all(16),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  '⏰ Nosso Tempo Juntos',
                  style: TextStyle(fontFamily: 'FredokaOne', fontSize: 20),
                ),
                SizedBox(height: 16),
                Text(
                  timerController.getFormattedTime(),
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Desde nosso primeiro beijo ❤️',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatsCard() {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              '📊 Nossas Estatísticas',
              style: TextStyle(fontFamily: 'FredokaOne', fontSize: 20),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  appController.state.loveCount.toString(),
                  'Te Amo',
                  Icons.favorite,
                ),
                _buildStatItem('127', 'Horas Discord', Icons.chat),
                _buildStatItem('+1000', 'Cuidado', Icons.healing_outlined),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: appController.incrementLove,
              label: Text('+1 ❤️'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFe83f3f),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotosCard() {
    final List<Map<String, dynamic>> ourPhotos = [
      {
        'title': 'Primeiro encontro',
        'emoji': '❤️',
        'description': 'O começo de tudo',
      },
      {
        'title': 'Passeio juntos',
        'emoji': '🌳',
        'description': 'Momento especial',
      },
      {
        'title': 'Nosso jantar',
        'emoji': '🍽️',
        'description': 'Noite inesquecível',
      },
      {
        'title': 'Momentos felizes',
        'emoji': '😊',
        'description': 'Sempre sorrindo',
      },
      {
        'title': 'Selfie nossa',
        'emoji': '🤳',
        'description': 'Recordação eterna',
      },
      {
        'title': 'Noite estrelada',
        'emoji': '🌠',
        'description': 'Sob as estrelas',
      },
    ];

    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.photo_library, color: Color(0xFFe83f3f)),
                SizedBox(width: 10),
                Text(
                  '📸 Nossas Fotos',
                  style: TextStyle(fontFamily: 'FredokaOne', fontSize: 20),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Cada foto conta uma parte da nossa história',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.9,
              ),
              itemCount: ourPhotos.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _showPhotoDialog(context, ourPhotos[index]);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Color(0xFF87CEEB).withOpacity(0.3),
                      border: Border.all(color: Color(0xFFe83f3f), width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          ourPhotos[index]['emoji'],
                          style: TextStyle(fontSize: 30),
                        ),
                        SizedBox(height: 8),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            ourPhotos[index]['title'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Color(0xFFe83f3f)),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFFe83f3f),
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _showPhotoDialog(BuildContext context, Map<String, dynamic> photo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        content: Container(
          height: 350,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: Color(0xFF87CEEB).withOpacity(0.2),
                ),
                child: Center(
                  child: Text(
                    photo['emoji'],
                    style: TextStyle(fontSize: 80),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      photo['title'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      photo['description'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Essa memória ficará para sempre ❤️',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}