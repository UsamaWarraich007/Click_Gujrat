import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:get/get.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final emailController = TextEditingController(),
      messageController = TextEditingController(),
      subjectController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: const Text('Contact Us'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Row(
                children: const [
                  Text(
                    'Email',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (email) {
                  if (GetUtils.isNullOrBlank(email)! ||
                      !GetUtils.isEmail(email!)) {
                    return "Email valid email";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: const [
                  Text(
                    'Subject',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: subjectController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                validator: (subject) {
                  if (GetUtils.isNullOrBlank(subject)!) {
                    return "Subject can't be empty";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: const [
                  Text(
                    'Description',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: messageController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                maxLines: 6,
                validator: (description) {
                  if (GetUtils.isNullOrBlank(description)!) {
                    return "Description can't be empty";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.topRight,
                child: ElevatedButton(
                  onPressed: () async => await send(),
                  child: const Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(100, 50),
                      minimumSize: const Size(100, 50),
                      shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> send() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    FocusScope.of(context).unfocus();
    final Email email = Email(
      body: messageController.text,
      subject: subjectController.text,
      recipients: [emailController.text],
      isHTML: false,
    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
    } catch (error) {
      print(error);
      platformResponse = error.toString();
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(platformResponse),
      ),
    );
  }
}
