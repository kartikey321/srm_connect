import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:srm_connect/dataProvider/app_data.dart';
import 'package:srm_connect/dataProvider/mail_provider.dart';
import 'package:srm_connect/helpers/student_helper.dart';
import 'package:srm_connect/model/srm_mail.dart';
import 'package:srm_connect/screens/mail_chat.dart';
import 'package:srm_connect/screens/write_msg.dart';

import '../model/thread.dart';

class MailScreen extends StatefulWidget {
  const MailScreen({Key? key}) : super(key: key);

  @override
  State<MailScreen> createState() => _MailScreenState();
}

class _MailScreenState extends State<MailScreen> {
  DataHelper dataHelper = DataHelper();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppData>(context);
    var user = provider.getParent;
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Color(0xFF8865E4),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Write_Msg()));
            },
            label: Row(
              children: [
                Icon(Icons.add),
                SizedBox(
                  width: 7,
                ),
                Text(
                  'New Chat',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            )),
        appBar: AppBar(
          backgroundColor: Color(0xFF8865E4),
          title: Text('Conversations'),
        ),
        body: ListView.separated(
          itemCount: user.threads == null ? 0 : user.threads!.length,
          itemBuilder: (context, index) {
            return FutureBuilder<Thread>(
                future: dataHelper.getThreadDetails(user.threads![index]),
                builder: (context, snapshot) {
                  var thread = snapshot.data;
                  if (snapshot.hasData) {
                    if (thread!.messageIds != null ||
                        thread!.messageIds!.isNotEmpty) {
                      var mailId = thread!.messageIds!.last;
                      return FutureBuilder<SRMMail>(
                          future: dataHelper.getMailDetails(mailId),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              var mail = snapshot.data!;
                              return ListTile(
                                onTap: () {
                                  Provider.of<MailProvider>(context,
                                          listen: false)
                                      .setCurrentThread = thread;
                                  Provider.of<MailProvider>(context,
                                          listen: false)
                                      .updateMailIds = thread.messageIds;
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MailChat()));
                                },
                                title: Text(
                                  mail.directedTo,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                trailing: Text(
                                    '${mail.time.hour}:${mail.time.minute}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text(
                                  mail.body,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }
                            return Container();
                          });
                    }
                  }
                  return Container();
                });
          },
          separatorBuilder: (BuildContext context, int index) => Divider(
            thickness: 2,
            color: Colors.grey,
          ),
        ));
  }
}
