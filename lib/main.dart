import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coleta de Lixo Reciclável',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.grey[200],
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/userDashboard': (context) => UserDashboard(),
        '/adminDashboard': (context) => AdminDashboard(),
        '/registerWaste': (context) => RegisterWastePage(),
        '/createSchedule': (context) => CreateSchedulePage(),
        '/manageCollections': (context) => ManageCollectionsPage(),
        '/collectionSchedule': (context) => CollectionSchedulePage(),
      },
    );
  }
}

// Função para criar o menu de navegação com logout
Drawer buildDrawer(BuildContext context, bool isAdmin) {
  return Drawer(
    child: ListView(
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.green,
          ),
          child: Text(
            'Menu',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
        ListTile(
          title: Text('Dashboard'),
          onTap: () {
            Navigator.pushReplacementNamed(
                context, isAdmin ? '/adminDashboard' : '/userDashboard');
          },
        ),
        if (!isAdmin)
          ListTile(
            title: Text('Registro de Lixo'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/registerWaste');
            },
          ),
        if (isAdmin) ...[
          ListTile(
            title: Text('Gerenciar Coletas'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/manageCollections');
            },
          ),
          ListTile(
            title: Text('Criar Agenda de Coletas'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/createSchedule');
            },
          ),
          ListTile(
            title: Text('Agendas de Coletas'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/collectionSchedule');
            },
          ),
        ],
        ListTile(
          title: Text('Logout'),
          onTap: () {
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
      ],
    ),
  );
}

// Tela de Login com campos para usuário e senha
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username == 'admin' && password == '1234') {
      Navigator.pushReplacementNamed(context, '/adminDashboard');
    } else if (username == 'user' && password == '1234') {
      Navigator.pushReplacementNamed(context, '/userDashboard');
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erro de Login'),
          content: Text('Usuário ou senha incorretos. Tente novamente.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Usuário'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Entrar'),
            ),
          ],
        ),
      ),
    );
  }
}

// Dashboard de Usuário
class UserDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard do Usuário')),
      drawer: buildDrawer(context, false),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Indicadores principais
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildIndicatorCard('Lixo Reciclado (kg)', '1200'),
                _buildIndicatorCard('Lixo Registrado (kg)', '45')
              ],
            ),
            SizedBox(height: 20),
            // Gráficos
            Expanded(
              child: ListView(
                children: [
                  _buildChartCard('Volume de Lixo Reciclado por Mês',
                      Icons.bar_chart),
                  _buildChartCard('Categorias de Lixo Registrado', Icons.pie_chart),
                ],
                ),
            ),
          ],
        ),
      ),
    );
  }

  // Função auxiliar para criar cartões de indicadores
  Widget _buildIndicatorCard(String title, String value) {
    return Card(
      color: Colors.white,
      elevation: 3,
      child: Container(
        padding: EdgeInsets.all(16),
        width: 100,
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(fontSize: 24, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }

  // Função auxiliar para criar cartões de gráficos
  Widget _buildChartCard(String title, IconData icon) {
    return Card(
      color: Colors.white,
      elevation: 3,
      child: ListTile(
        leading: Icon(icon, size: 40, color: Colors.green),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Visualize o histórico de dados de reciclagem.'),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          // Navegar para a página do gráfico ou exibir gráfico modal
        },
      ),
    );
  }
}

// Tela de Registro de Lixo
class RegisterWastePage extends StatefulWidget {
  @override
  _RegisterWastePageState createState() => _RegisterWastePageState();
}

class _RegisterWastePageState extends State<RegisterWastePage> {
  final TextEditingController _wasteTypeController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  void _registerWaste() {
    final wasteType = _wasteTypeController.text;
    final quantity = _quantityController.text;

    if (wasteType.isNotEmpty && quantity.isNotEmpty) {
      // Aqui você pode adicionar a lógica para salvar os dados
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Sucesso'),
          content: Text('Lixo registrado com sucesso!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );

      // Limpa os campos após o registro
      _wasteTypeController.clear();
      _quantityController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registrar Lixo')),
      drawer: buildDrawer(context, false),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _wasteTypeController,
              decoration: InputDecoration(
                  labelText:
                      'Tipo de Lixo (Eletrônicos, Vidros, Metais, Papéis, Plásticos)'),
            ),
            TextField(
              controller: _quantityController,
              decoration: InputDecoration(labelText: 'Quantidade (kg)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _registerWaste,
              child: Text('Registrar Lixo'),
            ),
          ],
        ),
      ),
    );
  }
}

// Dashboard de Administração
class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard do Administrador')),
      drawer: buildDrawer(context, true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Indicadores principais
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildIndicatorCard('Coletas Realizadas', '45'),
                _buildIndicatorCard('Lixo Reciclado (kg)', '1200'),
                _buildIndicatorCard('Usuários Cadastrados', '89'),
              ],
            ),
            SizedBox(height: 20),
            // Gráficos
            Expanded(
              child: ListView(
                children: [
                  _buildChartCard('Volume de Coletas por Mês', Icons.bar_chart),
                  _buildChartCard('Categoria de Lixo Reciclado', Icons.pie_chart),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Função auxiliar para criar cartões de indicadores
  Widget _buildIndicatorCard(String title, String value) {
    return Card(
      color: Colors.white,
      elevation: 3,
      child: Container(
        padding: EdgeInsets.all(16),
        width: 100,
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(fontSize: 24, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }

  // Função auxiliar para criar cartões de gráficos
  Widget _buildChartCard(String title, IconData icon) {
    return Card(
      color: Colors.white,
      elevation: 3,
      child: ListTile(
        leading: Icon(icon, size: 40, color: Colors.green),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Visualize o histórico de dados de coleta.'),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          // Navegar para a página do gráfico ou exibir gráfico modal
        },
      ),
    );
  }
}

// Tela de Gerenciamento de Coletas
class ManageCollectionsPage extends StatefulWidget {
  @override
  _ManageCollectionsPageState createState() => _ManageCollectionsPageState();
}

class _ManageCollectionsPageState extends State<ManageCollectionsPage> {
  final List<Map<String, dynamic>> _mockedCollections = List.generate(
      20,
      (index) => {
            'id': index + 1,
            'wasteType': [
              'Eletrônicos',
              'Vidros',
              'Metais',
              'Papéis',
              'Plásticos'
            ][index % 5],
            'quantity': (index + 1) * 2,
            'assignedEmployee':
                null, // Campo para armazenar o nome do funcionário atribuído.
          });

  final List<String> _mockedEmployees = ['João', 'Carlos', 'Diego'];

  int _currentPage = 0;
  static const int _itemsPerPage = 5;

  @override
  Widget build(BuildContext context) {
    final totalPages = (_mockedCollections.length / _itemsPerPage).ceil();
    final startIndex = _currentPage * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage < _mockedCollections.length
        ? startIndex + _itemsPerPage
        : _mockedCollections.length;

    return Scaffold(
      appBar: AppBar(title: Text('Gerenciar Coletas')),
      drawer: buildDrawer(context, true),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: endIndex - startIndex,
              itemBuilder: (context, index) {
                final collection = _mockedCollections[startIndex + index];
                return ListTile(
                  title: Text(
                      'Coleta ${collection['id']} - ${collection['wasteType']} (${collection['quantity']} kg)'),
                  subtitle: Text(collection['assignedEmployee'] != null
                      ? 'Funcionário: ${collection['assignedEmployee']}'
                      : 'Nenhum Funcionário Atribuído'),
                  trailing: DropdownButton<String>(
                    hint: Text('Atribuir Funcionário'),
                    value: collection['assignedEmployee'],
                    onChanged: (String? selectedEmployee) {
                      setState(() {
                        collection['assignedEmployee'] = selectedEmployee;
                      });
                    },
                    items: _mockedEmployees
                        .map((employee) => DropdownMenuItem<String>(
                              value: employee,
                              child: Text(employee),
                            ))
                        .toList(),
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: _currentPage > 0
                    ? () {
                        setState(() {
                          _currentPage--;
                        });
                      }
                    : null,
                child: Text('Anterior'),
              ),
              Text('Página ${_currentPage + 1} de $totalPages'),
              ElevatedButton(
                onPressed: _currentPage < totalPages - 1
                    ? () {
                        setState(() {
                          _currentPage++;
                        });
                      }
                    : null,
                child: Text('Próxima'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Tela de Criação de Agenda de Coletas
class CreateSchedulePage extends StatelessWidget {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void _createSchedule(BuildContext context) {
    // Implementar a lógica para criar a agenda
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sucesso'),
        content: Text('Agenda criada com sucesso!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
    _dateController.clear();
    _timeController.clear();
    _descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Criar Agenda de Coletas')),
      drawer: buildDrawer(context, true),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _dateController,
              decoration: InputDecoration(labelText: 'Data (DD/MM/AAAA)'),
            ),
            TextField(
              controller: _timeController,
              decoration: InputDecoration(labelText: 'Hora (HH:MM)'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Descrição'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _createSchedule(context),
              child: Text('Criar Agenda'),
            ),
          ],
        ),
      ),
    );
  }
}

// Tela de Agendas de Coletas
class CollectionSchedulePage extends StatelessWidget {
  // Mock de agendas de coleta
  final List<Map<String, dynamic>> _mockedSchedules = [
    {
      'date': '01/11/2024',
      'time': '08:00',
      'description': 'Coleta de Lixo Orgânico'
    },
    {
      'date': '02/11/2024',
      'time': '09:00',
      'description': 'Coleta de Lixo Eletrônico'
    },
    {'date': '03/11/2024', 'time': '10:00', 'description': 'Coleta de Vidros'},
    {
      'date': '04/11/2024',
      'time': '11:00',
      'description': 'Coleta de Plásticos'
    },
    {'date': '05/11/2024', 'time': '12:00', 'description': 'Coleta de Metais'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Agendas de Coletas')),
      drawer: buildDrawer(context, true),
      body: ListView.builder(
        itemCount: _mockedSchedules.length,
        itemBuilder: (context, index) {
          final schedule = _mockedSchedules[index];
          return ListTile(
            title: Text('Data: ${schedule['date']}'),
            subtitle: Text(
                'Hora: ${schedule['time']}\nDescrição: ${schedule['description']}'),
          );
        },
      ),
    );
  }
}
