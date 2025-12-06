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
        'title': 'Bilhetinhos',
        'image': 'lib/assets/images/Bilhetinhos.jpg',
        'description': 'Ainda tenho foto KSKLSKL',
        'date': '04/04/2024',
      },
      {
        'title': 'O DIA',
        'image': 'lib/assets/images/The_day.jpg',
        'description': 'O início de tudo...',
        'date': '15/05/2025',
      },
      {
        'title': 'Bagunça insana',
        'image': 'lib/assets/images/Bagunça.jpg',
        'description': 'Esse dia foi insano, quase uma ocorrência da gorda',
        'date': '04/06/2025',
      },
      {
        'title': 'Eu ó',
        'image': 'lib/assets/images/eu.jpg',
        'description': 'Óia eu aí',
        'date': '11/06/2025',
      },
      {
        'title': 'Uma linda foto',
        'image': 'lib/assets/images/Hospt.jpg',
        'description': 'De uma linda mulher',
        'date': '14/07/2025',
      },
      {
        'title': 'A melhor amiga de minha mulher',
        'image': 'lib/assets/images/bff.jpg',
        'description': 'É minha "amiga" também... em tese',
        'date': '05/08/2025',
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
                  'Algumas fotinhas',
                  style: TextStyle(fontFamily: 'FredokaOne', fontSize: 20),
                ),
              ],
            ),
            SizedBox(height: 16),

            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.8,
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
                      color: Color(0xFF87CEEB).withOpacity(0.2),
                      border: Border.all(color: Color(0xFFe83f3f), width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            ourPhotos[index]['image'],
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Color(0xFF87CEEB).withOpacity(0.4),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.photo,
                                        size: 40,
                                        color: Color(
                                          0xFFe83f3f,
                                        ).withOpacity(0.6),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Foto ${index + 1}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFFe83f3f),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black.withOpacity(0.8),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                            height: 40,
                          ),
                        ),

                        Positioned(
                          bottom: 8,
                          left: 0,
                          right: 0,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6),
                            child: Text(
                              ourPhotos[index]['title'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    offset: Offset(1, 1),
                                    blurRadius: 3,
                                    color: Colors.black.withOpacity(0.8),
                                  ),
                                ],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
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
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFFe83f3f),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            photo['title'],
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: Colors.white,
                                size: 16,
                              ),
                              SizedBox(width: 6),
                              Text(
                                photo['date'] ?? 'Data especial',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close, color: Colors.white),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                  ],
                ),
              ),

              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.7,
                    ),
                    child: InteractiveViewer(
                      panEnabled: true,
                      scaleEnabled: true,
                      boundaryMargin: EdgeInsets.all(20),
                      minScale: 0.5,
                      maxScale: 3.0,
                      child: ClipRRect(
                        child: Image.asset(
                          photo['image'],
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Color(0xFF87CEEB).withOpacity(0.3),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.photo,
                                      size: 80,
                                      color: Color(0xFFe83f3f).withOpacity(0.5),
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      photo['title'],
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Color(0xFFe83f3f),
                                        fontWeight: FontWeight.bold,
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
                  ),

                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(Icons.zoom_in, color: Colors.white, size: 24),
                    ),
                  ),
                ],
              ),

              Container(
                margin: EdgeInsets.all(12),
                child: Column(
                  children: [
                    Text(
                      photo['description'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(height: 10),
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
