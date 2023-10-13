import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:srm_connect/dataProvider/app_data.dart';
import 'package:srm_connect/dataProvider/mail_provider.dart';
import 'package:srm_connect/helpers/student_helper.dart';
import 'package:srm_connect/model/srm_mail.dart';

class MailChat extends StatefulWidget {
  const MailChat({Key? key}) : super(key: key);

  @override
  State<MailChat> createState() => _MailChatState();
}

class _MailChatState extends State<MailChat> {
  final FocusNode _textFieldFocusNode = FocusNode();
  var textController = TextEditingController();
  DataHelper dataHelper = DataHelper();
  bool showReplyField = false;
  String replyto = '';
  String studentid = '';
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppData>(context);
    var mailProvider = Provider.of<MailProvider>(context);

    var mailIds = mailProvider.mailIds;
    var parent = provider.getParent;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: RefreshIndicator(
                onRefresh: () async {
                  dataHelper.updateMessages(context);
                },
                child: ListView.separated(
                    itemBuilder: (context, index) {
                      return FutureBuilder<SRMMail>(
                          future: dataHelper
                              .getMailDetails(mailProvider.mailIds[index]),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              var mailDetails = snapshot.data!;
                              studentid = mailDetails.studentId;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 15,
                                            backgroundColor: Colors.grey,
                                          ),
                                          SizedBox(
                                            width: 7,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.baseline,
                                            textBaseline:
                                                TextBaseline.alphabetic,
                                            children: [
                                              Text(
                                                mailDetails.senderId,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 19),
                                              ),
                                              RichText(
                                                  text: TextSpan(
                                                      text: 'to ',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 15),
                                                      children: [
                                                    TextSpan(
                                                        text: mailDetails
                                                                    .directedTo ==
                                                                parent.email
                                                            ? 'me'
                                                            : mailDetails
                                                                .directedTo,
                                                        style: TextStyle(
                                                            decoration:
                                                                TextDecoration
                                                                    .underline))
                                                  ]))
                                            ],
                                          )
                                        ],
                                      ),
                                      Text(
                                        DateFormat('MMMM dd, yyyy \n   hh:mm a')
                                            .format(mailDetails.time),
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  SelectableText(
                                    mailDetails.body,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        showReplyField = true;
                                        replyto = mailDetails.senderId;
                                      });

                                      // Show the keyboard
                                      FocusScope.of(context)
                                          .requestFocus(_textFieldFocusNode);
                                      FocusScope.of(context).unfocus();
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          'Reply',
                                          style: TextStyle(
                                            color: Color(0xFF8865E4),
                                            fontSize: 16,
                                          ),
                                        ),
                                        Icon(Icons.reply,
                                            color: Color(0xFF8865E4))
                                      ],
                                    ),
                                  )
                                ],
                              );
                            }
                            return Container();
                          });
                    },
                    separatorBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Divider(
                          thickness: 1,
                        ),
                      );
                    },
                    itemCount: mailProvider.mailIds.length),
              ),
            ),
            showReplyField == true
                ? Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(color: Colors.white),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.reply),
                                    Text(
                                      'Replying To:  ',
                                      style: TextStyle(
                                        fontSize: 17,
                                      ),
                                    ),
                                    Text(
                                      '$replyto',
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ],
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      showReplyField = false;
                                      replyto = '';
                                    });

                                    FocusScope.of(context).unfocus();
                                  },
                                  child: Icon(
                                    Icons.close,
                                    size: 27,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10, left: 5),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    focusNode: _textFieldFocusNode,
                                    keyboardType: TextInputType.multiline,
                                    textInputAction: TextInputAction.newline,
                                    maxLines: null,
                                    controller: textController,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      hintStyle:
                                          TextStyle(color: Color(0xFF98A2B3)),
                                      hintText: 'Reply...',
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              20)), // Remove TextField border
                                      // Remove content padding
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: InkWell(
                                    onTap: () async {
                                      SRMMail mail = SRMMail(
                                          body: textController.text,
                                          senderId: parent.email,
                                          time: DateTime.now(),
                                          directedTo: replyto,
                                          studentId: studentid);
                                      var thread = mailProvider.currentThread;
                                      await dataHelper.addMail(
                                          mail, context, thread!.id!);
                                      await dataHelper.updateMessages(context);
                                      setState(() {
                                        showReplyField = false;
                                        replyto = '';
                                        textController.text = '';
                                      });

                                      FocusScope.of(context).unfocus();
                                    },
                                    child: Icon(
                                      Icons.send,
                                      color: Color(0xFF8865E4),
                                      size: 35,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
