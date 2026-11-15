import 'package:flutter/material.dart';

void main() => runApp(const ExploreMundoApp());

class Destino {
  final String nome;
  final String localizacao;
  final String avaliacao;
  final String preco;
  final String imagem;
  final String descricao;

  const Destino({
    required this.nome,
    required this.localizacao,
    required this.avaliacao,
    required this.preco,
    required this.imagem,
    required this.descricao,
  });
}

const List<Destino> destinosDisponiveis = [
  Destino(
    nome: 'Baía do Sancho - Fernando de Noronha',
    localizacao: 'Pernambuco, Brasil',
    avaliacao: '49',
    preco: 'R\$ 3.490,00',
    imagem: 'images/noronha.jpg',
    descricao:
    'Eleita diversas vezes uma das praias mais bonitas do mundo, a Baía do Sancho '
        'encanta os viajantes com águas cristalinas em tons de verde-esmeralda e falésias '
        'preservadas. Pacote inclui passeio de barco, mergulho livre e translado.',
  ),
  Destino(
    nome: 'Lago Oeschinen - Alpes Berneses',
    localizacao: 'Kandersteg, Suíça',
    avaliacao: '41',
    preco: 'R\$ 8.950,00',
    imagem: 'images/lake.jpg',
    descricao:
    'Situado a 1.578 metros acima do nível do mar aos pés do Blüemlisalp, é um dos '
        'lagos alpinos mais amplos da região. Inclui passeio de teleférico a partir de '
        'Kandersteg, trilhas guiadas e acesso ao tobogã de verão.',
  ),
  Destino(
    nome: 'Praia de Ponta Negra - Morro do Careca',
    localizacao: 'Natal, Rio Grande do Norte',
    avaliacao: '48',
    preco: 'R\$ 1.890,00',
    imagem: 'images/pontanegra.jpg',
    descricao:
    'Cartão-postal de Natal com águas mornas o ano inteiro, passeios de buggy pelas '
        'dunas, gastronomia potiguar à beira-mar e roteiro completo pelo litoral sul.',
  ),
];

class ExploreMundoApp extends StatelessWidget {
  const ExploreMundoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Explore Mundo - Agência de Viagens',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: false,
      ),
      home: const TelaPrincipal(),
    );
  }
}

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  String _termoBusca = '';

  List<Destino> get _destinosFiltrados {
    if (_termoBusca.isEmpty) return destinosDisponiveis;
    return destinosDisponiveis
        .where((d) =>
    d.nome.toLowerCase().contains(_termoBusca.toLowerCase()) ||
        d.localizacao.toLowerCase().contains(_termoBusca.toLowerCase()))
        .toList();
  }

  void _abrirDetalhesDestino(BuildContext context, Destino destino) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaDetalhesDestino(destino: destino),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Explore Mundo'),

          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(icon: Icon(Icons.explore), text: 'Destinos'),
              Tab(icon: Icon(Icons.card_travel), text: 'Pacotes de Viagem'),
              Tab(icon: Icon(Icons.contact_support), text: 'Contato'),
              Tab(icon: Icon(Icons.info), text: 'Sobre Nós'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildAbaDestinos(context),
            _buildAbaPacotes(context),
            _buildAbaContato(context),
            _buildAbaSobreNos(),
          ],
        ),
      ),
    );
  }


  Widget _buildAbaDestinos(BuildContext context) {
    final lista = _destinosFiltrados;

    return ListView(
      children: [

        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Pesquisar destino ou cidade...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (valor) {
              setState(() {
                _termoBusca = valor;
              });
            },
          ),
        ),


        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Text(
            'Destaques da Semana (Toque para explorar)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 210,
          child: PageView.builder(
            itemCount: destinosDisponiveis.length,
            itemBuilder: (context, index) {
              final destino = destinosDisponiveis[index];
              return GestureDetector(
                onTap: () => _abrirDetalhesDestino(context, destino),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          destino.imagem,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.75),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 16,
                        right: 16,
                        bottom: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              destino.nome,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${destino.localizacao} • A partir de ${destino.preco}',
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Todos os Destinos',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),

        if (lista.isEmpty)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Center(
              child: Text('Nenhum destino encontrado para a pesquisa.'),
            ),
          )
        else
          ...lista.map(
                (destino) => Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    destino.imagem,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  destino.nome,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('${destino.localizacao} • ${destino.preco}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, color: Colors.red[500], size: 18),
                    Text(' ${destino.avaliacao}'),
                    const Icon(Icons.keyboard_arrow_right),
                  ],
                ),
                onTap: () => _abrirDetalhesDestino(context, destino),
              ),
            ),
          ),
      ],
    );
  }


  Widget _buildAbaPacotes(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: destinosDisponiveis.length,
      itemBuilder: (context, index) {
        final destino = destinosDisponiveis[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pacote Completo: ${destino.nome}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(destino.descricao),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      destino.preco,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('Reservar Agora'),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Pré-reserva solicitada para ${destino.nome}!',
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  Widget _buildAbaContato(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Fale com a Equipe Explore Mundo',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const ListTile(
            leading: Icon(Icons.phone, color: Colors.blue),
            title: Text('Central de Atendimento'),
            subtitle: Text('(84) 3000-1234 • Segunda a Sábado, 8h às 20h'),
          ),
          const ListTile(
            leading: Icon(Icons.email, color: Colors.blue),
            title: Text('E-mail para Reservas'),
            subtitle: Text('contato@exploremundo.com.br'),
          ),
          const ListTile(
            leading: Icon(Icons.language, color: Colors.blue),
            title: Text('Portal Web Integrado'),
            subtitle: Text('www.exploremundo.com.br'),
          ),
        ],
      ),
    );
  }


  Widget _buildAbaSobreNos() {
    return const Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sobre a Explore Mundo',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Text(
            'A Explore Mundo é uma agência de viagens especializada em roteiros '
                'nacionais e internacionais personalizados. Nosso aplicativo e portal web '
                'conectam viajantes aos melhores destinos, reunindo avaliações reais, '
                'localização detalhada e reservas rápidas em um só lugar.',
            softWrap: true,
          ),
        ],
      ),
    );
  }
}


class TelaDetalhesDestino extends StatelessWidget {
  final Destino destino;

  const TelaDetalhesDestino({super.key, required this.destino});

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColor;

    Widget titleSection = Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    destino.nome,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  destino.localizacao,
                  style: TextStyle(color: Colors.grey[500]),
                ),
              ],
            ),
          ),
          Icon(Icons.star, color: Colors.red[500]),
          Text(destino.avaliacao),
        ],
      ),
    );

    Widget buttonSection = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildButtonColumn(context, color, Icons.call, 'LIGAR',
            'Ligando para a central Explore Mundo...'),
        _buildButtonColumn(context, color, Icons.near_me, 'ROTA',
            'Abrindo rota para ${destino.localizacao}...'),
        _buildButtonColumn(context, color, Icons.share, 'COMPARTILHAR',
            'Link de ${destino.nome} copiado!'),
      ],
    );

    Widget textSection = Container(
      padding: const EdgeInsets.all(32),
      child: Text(
        destino.descricao,
        softWrap: true,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(destino.nome),
      ),
      body: ListView(
        children: [
          Image.asset(
            destino.imagem,
            width: 600,
            height: 240,
            fit: BoxFit.cover,
          ),
          titleSection,
          buttonSection,
          textSection,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.flight_takeoff),
              label: Text('Reservar Pacote (${destino.preco})'),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Reserva iniciada para ${destino.nome}!'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonColumn(
      BuildContext context,
      Color color,
      IconData icon,
      String label,
      String mensagemAcao,
      ) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(mensagemAcao)),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color),
            Container(
              margin: const EdgeInsets.only(top: 8),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}