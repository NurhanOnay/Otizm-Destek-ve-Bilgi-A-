import 'package:flutter/material.dart';
import 'package:otizm_destek_ve_bilgi_agi/chat.dart';
import 'package:otizm_destek_ve_bilgi_agi/k%C4%B1s%C4%B1ler.dart';
import 'package:otizm_destek_ve_bilgi_agi/profile.dart';
import 'package:provider/provider.dart';


class WhatsAppMain extends StatefulWidget {
  @override
  _WhatsAppMainState createState() => _WhatsAppMainState();
}

class _WhatsAppMainState extends State<WhatsAppMain>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showMessage = true;



  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3, initialIndex: 0);
    _tabController.addListener(() {
      setState(() {
        _showMessage = _tabController.index != 2;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => WhatsappMainModel(),
      child: Consumer<WhatsappMainModel>(
        builder: (BuildContext context, model, Widget? child) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Bilgi Paylaşım Ağı'),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: () {},
                ),
              ],
              bottom: TabBar(
                controller: _tabController,
                tabs: <Widget>[
                  Tab(text: 'Mesajlar'),
                  Tab(text: 'Kişilerim'),
                  Tab(text: 'Profilim'),
                ],
              ),
            ),
            body: model != null && model.busy
                ? Center(child: CircularProgressIndicator())
                : TabBarView(
              controller: _tabController,
              children: <Widget>[
                  ChatScreen(
                  userId: 'currentUserId', // Mevcut kullanıcı ID'sini buraya ekleyin
                  username: 'currentUsername',
                    currentUserEmail:'currentEmail@gmail.com ',// Mevcut kullanıcı adını buraya ekleyin
                ),
                  UsersListScreen(),
                  ProfileScreen(),
              ],
            ),

            floatingActionButton: _showMessage
                ? FloatingActionButton(
              child: Icon(Icons.message, color: Colors.white),
              onPressed: () async => model.openContacts(),
            )
                : null,
          );
        },
      ),
    );
  }
}

class WhatsappMainModel with ChangeNotifier {
  bool _busy = false;

  bool get busy => _busy;

  void openContacts() {
    // Contacts opening logic
    notifyListeners();
  }
}
