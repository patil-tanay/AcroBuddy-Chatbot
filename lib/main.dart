import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/material.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Acro Buddy',
      theme: ThemeData(
        primaryColor: Colors.deepPurple, // Set primary color
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(
          elevation: 0, // Remove app bar shadow
        ),
      ),
      home: const SplashScreen(),
      routes: {
        '/home': (context) => const Home(),
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome to Acro Chat',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/home');
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepPurple, // Set the button background color
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Set the button padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Set the button border radius
                  ),
                  elevation: 2, // Add a slight elevation to the button
                ),
                child: const Text(
                  'Start Chat',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late DialogFlowtter dialogFlowtter;
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    DialogFlowtter.fromFile().then((instance) => dialogFlowtter = instance);
    super.initState();

    // Add welcome message to the beginning of the messages list
    messages.add({
      'message': Message(
          text: DialogText(text: ['Welcome to the Acropolis chatbot! How can I help you?'])),
      'isUserMessage': false,
    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Acro Buddy'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              end: Alignment.topCenter,
              begin: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(120, 146, 187, 227),
                Color.fromARGB(255, 28, 115, 142),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/chat_bg.jpg'),
            fit: BoxFit.cover,
            opacity: 0.8,

          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: MessagesScreen(messages: messages, scrollController: _scrollController),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color.fromARGB(90, 120, 157, 195).withOpacity(0.8),
                    const Color.fromARGB(255, 21, 73, 90).withOpacity(0.8),
                  ],
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(
                          color: Colors.white54,
                          fontFamily: 'Cera Pro',
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      sendMessage(_controller.text);
                      _controller.clear();
                    },
                    icon: const Icon(Icons.send_rounded),
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  sendMessage(String text) async {
    if (text.isEmpty) {
      // print('Message is empty');
    } else {
      setState(() {
        addMessage(Message(text: DialogText(text: [text])), true);
      });

      DetectIntentResponse response = await dialogFlowtter.detectIntent(
        queryInput: QueryInput(text: TextInput(text: text)),
      );
      if (response.message == null) return;
      setState(() {
        addMessage(response.message!);
      });

      // Delay the scroll to the latest message to allow the ListView to rebuild
      Future.delayed(Duration(milliseconds: 300), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  addMessage(Message message, [bool isUserMessage = false]) {
    messages.add({'message': message, 'isUserMessage': isUserMessage});
  }
}

class MessagesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> messages;
  final ScrollController scrollController;

  const MessagesScreen({Key? key, required this.messages, required this.scrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index]['message'] as Message;
        final isUserMessage = messages[index]['isUserMessage'] as bool;

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            mainAxisAlignment:
            isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isUserMessage)
                const CircleAvatar(
                  radius: 20,
                  // Replace with chatbot avatar image
                  backgroundImage: AssetImage('assets/chatbot_avatar.png'),
                )
              else
                const Spacer(), // Adds space on the left for user messages
              const SizedBox(width: 10),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isUserMessage ? Colors.green[100] : Colors.blue[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    message.text!.text![0],
                    style: TextStyle(
                      color: isUserMessage ? Colors.green[900] : Colors.blue[900],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              if (isUserMessage)
                const CircleAvatar(
                  radius: 20,
                  // Replace with user avatar image
                  backgroundImage: AssetImage('assets/user_avatar.png'),
                )
              else
                const Spacer(), // Adds space on the right for chatbot messages

            ],
          ),
        );
      },
    );
  }
}
