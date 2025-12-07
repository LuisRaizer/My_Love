class PersonalConfig {
// para alterar o nome do aplciativo, vá até android\app\src\main\AndroidManifest.xml e altere essa linha:
// <application
//     android:label="R Loves You" (altere entre as aspas)

// Número do WhatsApp (formato internacional sem + ou espaços)
  static const String whatsappNumber = '5511999999999';

  // Data do início do relacionamento (ano, mês, dia)
  static final DateTime relationshipStartDate = DateTime(2024, 1, 1);

  // Conteúdo da carta
  static const String letterContent = """Meu amor,

Esta é uma carta especial para você...

Use quantas linhas quiser, o aplicativo vai ajustar automaticamente.

Com amor,""";

  // Assinatura da carta
  static const String letterSignature = 'Seu nome';

  // Mensagens para balões normais
  static const List<String> normalBalloonMessages = [
    'mensagem',
  ];

  // Mensagens para balões de amor
  static const List<String> loveBalloonMessages = [
    'mensagem',
  ];

  // Galeria de fotos (adicione suas fotos)
  // IMPORTANTE: Coloque as imagens na pasta lib/assets/images/
  // e use o caminho correto como no exemplo abaixo
  static const List<Map<String, dynamic>> galleryPhotos = [
    {
      'title': 'titulo',
      'image': 'lib/assets/images/foto.jpg',
      'description': 'descrição',
      'date': '01/01/2024',
    },
    {
      'title': 'titulo',
      'image': 'lib/assets/images/foto.jpg',
      'description': 'descrição',
      'date': '01/01/2024',
    },
    {
      'title': 'titulo',
      'image': 'lib/assets/images/foto.jpg',
      'description': 'descrição',
      'date': '01/01/2024',
    },
    {
      'title': 'titulo',
      'image': 'lib/assets/images/foto.jpg',
      'description': 'descrição',
      'date': '01/01/2024',
    },
    {
      'title': 'titulo',
      'image': 'lib/assets/images/foto.jpg',
      'description': 'descrição',
      'date': '01/01/2024',
    },
    {
      'title': 'titulo',
      'image': 'lib/assets/images/foto.jpg',
      'description': 'descrição',
      'date': '01/01/2024',
    },
  ];

  // INSTRUÇÕES:
  // 1. Crie uma pasta "images" dentro de "lib/assets/"
  // 2. Coloque suas fotos nessa pasta
  // 3. Atualize os nomes das imagens acima
  // 4. Personalize os títulos, descrições e datas
  // 5. Ajuste as mensagens conforme seu gosto
  // 6. Não esqueça de atualizar a data do relacionamento
  // 7. Coloque seu número de WhatsApp correto
}