import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:vcard_project/models/contact_model.dart';
import 'package:vcard_project/providers/contact_provider.dart';
import 'package:vcard_project/utils/helper_functions.dart';

class ContactDetailsPage extends StatefulWidget {
  static const String routeName = 'contact_details_page';
  final int id;

  const ContactDetailsPage({super.key, required this.id});

  @override
  State<ContactDetailsPage> createState() => _ContactDetailsPageState();
}

class _ContactDetailsPageState extends State<ContactDetailsPage> {
  late int id;

  @override
  void initState() {
    id = widget.id;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
      body: Consumer<ContactProvider>(
        builder: (context, provider, child) => FutureBuilder<ContactModel>(
          future: provider.getContactById(id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final contact = snapshot.data!;
              return ListView(
                padding: const EdgeInsets.all(8.0),
                children: [
                  Image.file(
                    File(contact.image),
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                  ListTile(
                    title: Text(contact.mobile),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            _callContact(contact.mobile);
                          },
                          icon: const Icon(Icons.call),
                        ),
                        IconButton(
                          onPressed: () {
                            _smsContact(contact.mobile);
                          },
                          icon: const Icon(Icons.sms),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text(contact.email),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            _emailContact(contact.email);
                          },
                          icon: const Icon(Icons.email),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text(contact.website),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            _goToWebContact(contact.website);
                          },
                          icon: const Icon(Icons.open_in_browser),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text(contact.address),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            _showOnMapContact(contact.address);
                          },
                          icon: const Icon(Icons.map_outlined),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text('Failed to load data'),
              );
            }
            return const Center(
              child: Text('Please wait'),
            );
          },
        ),
      ),
    );
  }

  void _callContact(String mobile) async {
    final url = 'tel:$mobile';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      showMsg(context, 'Cannot perform this action!');
    }
  }

  void _smsContact(String mobile) async {
    final url = 'sms:$mobile';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      showMsg(context, 'Cannot perform this action!');
    }
  }

  void _emailContact(String email) async {
    final url = 'mailto:$email';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      showMsg(context, 'Cannot perform this action!');
    }
  }

  void _goToWebContact(String website) async {
    final url = 'https:$website';
    if (await canLaunchUrlString(url)) {
    await launchUrlString(url);
    } else {
    showMsg(context, 'Cannot perform this action!');
    }
  }

  void _showOnMapContact(String address) async {
    String url = '';
    if(Platform.isAndroid) {
      url = 'geo:0,0?q=$address';
    } else {
      url = 'http://maps.apple.com/?q=$address';
    }
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      showMsg(context, 'Cannot perform this action!');
    }
  }
}
