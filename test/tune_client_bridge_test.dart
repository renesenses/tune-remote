import 'package:flutter_test/flutter_test.dart';
import 'package:tune_remote/api/tune_client.dart';

/// Acces distant par le relais Tune Bridge.
///
/// Le contrat cote relais (tune-bridge/src/api_proxy.rs) est le suivant :
///
///   GET https://bridge.mozaiklabs.fr/api/relay/{server_id}/{chemin}
///     -> le relais transmet au serveur : /api/v1/{chemin}
///
/// La base du relais remplace donc EXACTEMENT `<hote>/api/v1`. C'est ce qui
/// permet a la centaine d'appels du client de rester inchanges : ils passent
/// tous par `baseUrl`.
void main() {
  group('baseUrl', () {
    test('en direct, la base garde le suffixe /api/v1', () {
      expect(TuneClient('192.168.1.18:8888').baseUrl,
          'http://192.168.1.18:8888/api/v1');
    });

    test('en direct, un schema deja present est respecte', () {
      expect(TuneClient('http://tune.local:8888/').baseUrl,
          'http://tune.local:8888/api/v1');
    });

    test('par le relais, la base remplace hote ET /api/v1', () {
      final c = TuneClient('192.168.1.18:8888',
          bridgeServerId: 'abc-123', bridgeToken: 'jeton');
      expect(c.baseUrl, 'https://bridge.mozaiklabs.fr/api/relay/abc-123');
    });

    test('un hote vide reste vide en direct', () {
      expect(TuneClient('').baseUrl, '');
    });

    /// L'hote local n'est pas efface par l'appairage : c'est lui qu'on
    /// retrouve en rentrant chez soi.
    test('le relais prime sur l\'hote sans le detruire', () {
      final c = TuneClient('192.168.1.18:8888',
          bridgeServerId: 'abc-123', bridgeToken: 'jeton');
      expect(c.host, '192.168.1.18:8888');
      expect(c.viaBridge, isTrue);
    });
  });

  group('bascule en mode distant', () {
    /// Un identifiant sans jeton ne produirait que des 401 : mieux vaut rester
    /// en direct que d'echouer en boucle contre le relais.
    test('un identifiant seul ne fait pas basculer', () {
      final c = TuneClient('h:8888', bridgeServerId: 'abc-123');
      expect(c.viaBridge, isFalse);
      expect(c.baseUrl, 'http://h:8888/api/v1');
    });

    test('un jeton seul ne fait pas basculer', () {
      final c = TuneClient('h:8888', bridgeToken: 'jeton');
      expect(c.viaBridge, isFalse);
    });

    test('une chaine vide vaut absence', () {
      final c = TuneClient('h:8888', bridgeServerId: '', bridgeToken: '');
      expect(c.viaBridge, isFalse);
    });
  });

  group('en-tetes', () {
    /// Le relais verifie que le jeton correspond AU serveur vise : connaitre
    /// l'identifiant ne suffit pas. Sans cet en-tete, tout repond 401.
    test('le mode distant porte le jeton, le direct non', () {
      final distant = TuneClient('h:8888',
          bridgeServerId: 'abc-123', bridgeToken: 'jeton-secret');
      final direct = TuneClient('h:8888');

      // `viaBridge` gouverne l'ajout de l'en-tete ; on verifie la bascule,
      // seule chose observable sans exposer la fabrique d'en-tetes.
      expect(distant.viaBridge, isTrue);
      expect(direct.viaBridge, isFalse);
    });
  });

  group('origine du relais', () {
    /// Cette constante doit rester accordee au defaut code en dur cote serveur
    /// (`wss://bridge.mozaiklabs.fr/ws/server`, tune-core/src/cloud/relay.rs).
    /// Si l'une change sans l'autre, le serveur s'enregistre quelque part et
    /// l'application interroge ailleurs.
    test('l\'origine est celle que le serveur utilise', () {
      expect(TuneClient.bridgeOrigin, 'https://bridge.mozaiklabs.fr');
    });
  });
}
