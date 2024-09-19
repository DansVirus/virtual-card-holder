import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vcard_project/pages/contact_details_page.dart';
import 'package:vcard_project/pages/scan_page.dart';
import 'package:vcard_project/providers/contact_provider.dart';
import 'package:vcard_project/utils/helper_functions.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  @override
  void didChangeDependencies() {
    Provider.of<ContactProvider>(context, listen: false).getAllContacts();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact List'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          context.goNamed(ScanPage.routeName);
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.zero,
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        clipBehavior: Clip.antiAlias,
        child: BottomNavigationBar(
          selectedItemColor: Colors.deepPurpleAccent,
          backgroundColor: Colors.cyan,
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
            _fetchData();
          },
          currentIndex: selectedIndex,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'All'),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite), label: 'Favorites'),
          ],
        ),
      ),
      body: Consumer<ContactProvider>(
        builder: (context, provider, child) => ListView.builder(
          itemCount: provider.contactList.length,
          itemBuilder: (context, index) {
            final contact = provider.contactList[index];
            return Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.endToStart,
              background: Container(
                padding: const EdgeInsets.only(right: 20),
                alignment: FractionalOffset.centerRight,
                color: Colors.red,
                child: const Icon(
                  Icons.delete,
                  size: 25,
                  color: Colors.white,
                ),
              ),
              confirmDismiss: _showConfirmationDialog,
              onDismissed: (_)  async {
                await provider.deleteContact(contact.id);
                showMsg(context, 'Deleted');
              },
              child: ListTile(
                onTap: () => context.goNamed(ContactDetailsPage.routeName, extra: contact.id),
                title: Text(contact.name),
                trailing: IconButton(
                  onPressed: () {
                    provider.updateFavorite(contact);
                  },
                  icon: Icon(
                    contact.favorite ? Icons.favorite : Icons.favorite_border,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<bool?> _showConfirmationDialog(DismissDirection direction) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Contact'),
        content: const Text('Do you want to delete this contact?'),
        actions: [
          OutlinedButton(
            onPressed: () {
              context.pop(false);
            },
            child: const Text('NO'),
          ),
          OutlinedButton(
            onPressed: () {
              context.pop(true);
            },
            child: const Text('YES'),
          ),
        ],
      ),
    );
  }

  void _fetchData() {
    switch(selectedIndex) {
      case 0:
        Provider.of<ContactProvider>(context, listen: false).getAllContacts();
        break;
      case 1:
        Provider.of<ContactProvider>(context, listen: false).getAllFavoriteContacts();
        break;
    }
  }
}
