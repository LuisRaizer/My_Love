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
                'Com todo meu amor,\nRaizer 💚',
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

Era para ser para seu aniversário, porém... eu te deixei bastante ansiosa para ver.

Fiz o que pude para te entregar o mais rápido possível, passei algumas horas acordado mas acho que valeu apena, você merece tudo e muito mais do que posso oferecer.

Para começar, acho que nunca ngm me fez me sentir assim, é como um impulso ultra forte de te ver feliz que eu sinto todas as vezes que eu te vejo, c tem esse dom raro de me fazer sentir verdadeiramente visto, ouvido e importante.

É você, com toda certeza, quem está ao meu lado todos os dias, me dando forças pra aguentar todos os desafios que aparecem, não importa qual. Me lembrando o quanto é bom ser feliz do teu lado. Me fazendo sorrir com tuas brincadeiras que eu amo TANTO!

Obrigado por ser essa pessoa que enche a minha vida de alegria, carinho e amor. Obrigado por ser a minha parceira em tantos momentos únicos.

Você odeia homens né KSLKLSKLSKLS, de alguma forma eu consegui furar esse bloqueio e me tornei a exceção à regra. Isso me deixa tão confortável, é bom saber que não tenho concorrência, eu amo isso.

Eduarda Gadelha, tu é forte, determinada, carinhosa e tem uma personalidade única que me conquistou. Mas não é esse o principal motivo de eu te amar tanto

A forma como você me escuta, com toda atenção e carinho, sem julgamentos, é algo que eu nunca vou cansar de agradecer. Você não só ouve minhas palavras, você entende meus silêncios, meus medos, meu choro. Você me decifra tanto quanto eu mesmo

É gratificante estar ao lado de alguém que consegue pensar exatamente no que sinto, é como se eu não tivesse que me esforçar em explicar, vc consegue ver em mim aquilo que nem mesmo eu vejo exatamente.

Eu amo estar ao lado de alguém que consegue me entender e me sentir.

Eu amo estar ao teu lado, e somente TEU lado.

Não se esqueça que eu te amo e que quero cada vez mais isso, suas dores são minhas também, seus medos são os meus, suas angústias, seus inimigos e etc. São meus também.

Tenha em mente que eu quero sim construir um lar com você, eu quero com certeza isso mais do que ninguém (nossas vontades devem ser equivalentes), não quero ter impedimentos nesse meu objetivo de somente eu e minha mulher (talvez um cachorrinho ou um gatinho, dependendo os dois).

Você merece todo amor, toda felicidade e todas as coisas boas que a vida e eu podemos oferecer.

Te amo mais do que palavras podem expressar""";
  }
}
