import 'package:flutter/material.dart';
import 'package:app/controllers/app_controller.dart';

class LetterComponent extends StatelessWidget {
  final AppController appController;

  const LetterComponent({super.key, required this.appController});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _buildLetterCard()),
      ],
    );
  }

  Widget _buildLetterCard() {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📝 Uma Carta Especial para Ti',
              style: TextStyle(fontFamily: 'FredokaOne', fontSize: 20),
            ),
            SizedBox(height: 16),
            Text(_getLetterContent()),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Com todo meu amor,\nRaizer ❤️',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Color(0xFFe83f3f),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getLetterContent() {
    return """Minha querida Gadelha,

Hoje é um dia especial, não só porque você está completando mais um ano de vida, mas porque é uma celebração de quem você é...

Desde que te conheci, percebi algo único em você. O jeito que você me trata me faz sentir especial de um jeito que eu nunca imaginei ser possível. Você tem esse dom raro de me fazer sentir verdadeiramente visto, ouvido e importante.

Como é singular a sensação deliciosa de dividir os dias contigo. É reconfortante saber que você está lá em todos os momentos, no bom e também no ruim.

É você, meu amor, quem está ao meu lado todos os dias, me dando forças pra aguentar todos os desafios que aparecem. Me lembrando o quanto é bom ser feliz do teu lado. Me fazendo sorrir com tuas brincadeiras que eu amo TANTO!

Obrigado por ser essa pessoa que enche a minha vida de alegria, carinho e amor. Obrigado por ser a minha parceira em tantos momentos únicos e tão memoráveis...

E sabe o que é engraçado? Você odeia homens (risos), mas de alguma forma eu consegui furar esse bloqueio e me tornar a exceção à regra. Isso me faz valorizar ainda mais cada momento ao seu lado.

A forma como você me escuta, com toda atenção e carinho, sem julgamentos, é algo que eu nunca vou cansar de agradecer. Você não só ouve minhas palavras, você entende meus silêncios, meus medos, meus sonhos.

Gadelha, você é forte, determinada, carinhosa e tem uma personalidade única que me conquistou completamente, admiro tanto sua autenticidade.

Que este novo ano seja repleto de realizações, alegrias e tudo aquilo que seu coração deseja.

Você merece todo amor, toda felicidade e todas as coisas boas que a vida e eu podemos oferecer.

Te amo mais do que palavras podem expressar!

Feliz Aniversário, Delha! 🎂""";
  }
}
