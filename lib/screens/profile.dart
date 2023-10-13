import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:srm_connect/dataProvider/app_data.dart';
import 'package:srm_connect/screens/login_student.dart';

class Send_Msg extends StatefulWidget {
  const Send_Msg({super.key});

  @override
  State<Send_Msg> createState() => _Send_MsgState();
}

class _Send_MsgState extends State<Send_Msg> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppData>(context, listen: false);
    var student = provider.getCurrentStudent;
    return Scaffold(
        backgroundColor: Color(0xFFE8EEFA),
        appBar: AppBar(
          backgroundColor: Color(0xff7C60DB),
          elevation: 0,
          title: Text(" SRMConnect",
              style:
                  GoogleFonts.libreFranklin(fontSize: 24, color: Colors.white)),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Row(
                  //   children: [
                  //     Icon(
                  //       Icons.notifications_sharp,
                  //       color: Color(0xff656565),
                  //     ),
                  //     Text("Turn off notification",
                  //         style: GoogleFonts.libreFranklin(
                  //             fontSize: 14, color: Color(0xff656565)))
                  //   ],
                  // ),
                  InkWell(
                    onTap: () async {
                      // provider.dispose();
                      await FirebaseAuth.instance.signOut();
                      await Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginStudent()),
                          (route) => false);
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.logout,
                          color: Color(0xff656565),
                        ),
                        Text("Logout",
                            style: GoogleFonts.libreFranklin(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff656565)))
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Center(
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://www.woolha.com/media/2020/03/eevee.png'),
                  radius: 50,
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Center(
                child: Text(
                  provider.getParent.name,
                  style: GoogleFonts.libreFranklin(
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Primary Details",
                    style: GoogleFonts.libreFranklin(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  //     Row(
                  //       children: [
                  //         Text(
                  //           "Request Edit",
                  //           style: GoogleFonts.libreFranklin(
                  //             fontSize: 14,
                  //             color: Colors.black,
                  //             fontWeight: FontWeight.w500,
                  //           ),
                  //         ),
                  //         Icon(
                  //           Icons.edit_sharp,
                  //           color: Colors.black,
                  //         ),
                  //       ],
                  //     )
                ],
              ),
              SizedBox(height: 14),
              Container(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Email:",
                            style: GoogleFonts.libreFranklin(
                              fontSize: 14,
                              color: Color(0xff150050),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Phone No:",
                            style: GoogleFonts.libreFranklin(
                              fontSize: 14,
                              color: Color(0xff150050),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Address:",
                            style: GoogleFonts.libreFranklin(
                              fontSize: 14,
                              color: Color(0xff150050),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// INPUTTTT
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            provider.getParent.email,
                            style: GoogleFonts.libreFranklin(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            provider.getParent.whatsappNumber,
                            style: GoogleFonts.libreFranklin(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Address wydbdefb",
                            style: GoogleFonts.libreFranklin(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 54),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: provider.getStudents.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Text(
                          provider.getStudents[index].name,
                          style: GoogleFonts.libreFranklin(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 14),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Relation:",
                                          style: GoogleFonts.libreFranklin(
                                            fontSize: 14,
                                            color: Color(0xff150050),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          "Dept:",
                                          style: GoogleFonts.libreFranklin(
                                            fontSize: 14,
                                            color: Color(0xff150050),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          "Batch:",
                                          style: GoogleFonts.libreFranklin(
                                            fontSize: 14,
                                            color: Color(0xff150050),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          "FA:",
                                          style: GoogleFonts.libreFranklin(
                                            fontSize: 14,
                                            color: Color(0xff150050),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  /// INPUTTTT
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Father",
                                          style: GoogleFonts.libreFranklin(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          provider
                                              .getStudents[index].department,
                                          style: GoogleFonts.libreFranklin(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          provider.getStudents[index].batch,
                                          style: GoogleFonts.libreFranklin(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          provider.getStudents[index]
                                              .facultyAdvisor,
                                          style: GoogleFonts.libreFranklin(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  })
            ],
          ),
        ));
  }
}
