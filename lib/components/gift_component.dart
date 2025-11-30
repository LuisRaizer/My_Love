import 'package:flutter/material.dart';
import 'package:app/controllers/app_controller.dart';

class GiftComponent extends StatelessWidget {
  final AppController appController;

  const GiftComponent({Key? key, required this.appController})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Colors.transparent,
          title: Text('Presente', style: TextStyle(fontFamily: 'FredokaOne')),
        ),
        SliverToBoxAdapter(child: _buildGiftCard()),
      ],
    );
  }

  Widget _buildGiftCard() {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              '🎁 Seu Presente',
              style: TextStyle(fontFamily: 'FredokaOne', fontSize: 20),
            ),
            SizedBox(height: 16),
            Text(
              'Toque na caixa para abrir seu presente especial!',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: appController.openGift,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Color(0xFFFFD700),
                  border: Border.all(color: Colors.black, width: 3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    // Fita vertical
                    Positioned(
                      left: 50,
                      child: Container(
                        width: 20,
                        height: 120,
                        color: Color(0xFFe83f3f),
                      ),
                    ),
                    // Fita horizontal
                    Positioned(
                      top: 50,
                      child: Container(
                        width: 120,
                        height: 20,
                        color: Color(0xFFe83f3f),
                      ),
                    ),
                    // Mensagem quando aberto
                    if (appController.state.giftOpened)
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'TE AMO!',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text('❤️', style: TextStyle(fontSize: 20)),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            if (appController.state.giftOpened)
              Text(
                'Obrigado por ser minha companhia favorita!',
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Color(0xFFe83f3f),
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}
