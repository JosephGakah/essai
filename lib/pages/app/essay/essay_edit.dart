import 'package:essai/models/essay.dart';
import 'package:essai/pages/app/essay/essay.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../services/add_essay.dart';
import '../../../services/edit_essay.dart';
import '../widgets/snack_message.dart';

class EditEssay extends StatefulWidget {
  final EssayModel essay;
  const EditEssay({Key? key, required this.essay}) : super(key: key);

  @override
  EditEssayState createState() => EditEssayState();
}

// ignore: must_be_immutable
class EditEssayState extends State<EditEssay> {
  final editEssays = EssayEdit();

  final _formKey = GlobalKey<FormState>();
  final essayBody = TextEditingController();
  final essayTitle = TextEditingController();

  final Color primary = const Color.fromARGB(255, 0, 0, 77);
  final Color dark = const Color.fromARGB(156, 0, 0, 17);

  bool valuefirst = false;
  bool valuesecond = false;

  String title = '';
  final String title2 = 'Expository Essay';
  String _essay = '';

  submitEssay() async {
    if (_formKey.currentState!.validate()) {}
  }

  saveEssay() async {
    if (_formKey.currentState!.validate()) {
      var essay = EssayModel(
          id: widget.essay.id,
          essayCategory: widget.essay.essayCategory,
          essayBody: _essay,
          essayTitle: title);
      var res = await editEssays.editEssays(essay);
      SnackMessage(
        state: 'Loading',
        context: context,
      ).snackMessage();
      if (res.runtimeType == PostgrestException) {
        final PostgrestException resp = res;
        SnackMessage(
          state: 'Message',
          context: context,
          color: Colors.red,
          message: resp.message,
        ).snackMessage();
      } else {
        SnackMessage(
          state: 'Message',
          context: context,
          color: Colors.blue,
          message: "Essay Successfully edited",
        ).snackMessage();
        Get.to(Essay(essay: essay));
      }
    }
  }

  deleteEssay() async {
    if (_formKey.currentState!.validate()) {}
  }

  Widget essayActionButtons() {
    return Row(children: [
      //Edit Essay Button
      OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Save'),
              SizedBox(
                width: 10,
              ),
              Icon(
                Iconsax.save_add,
                size: 20,
              )
            ],
          )),
      const SizedBox(width: 10),

      //Submit Essay Button
      OutlinedButton(
          onPressed: saveEssay,
          style: OutlinedButton.styleFrom(foregroundColor: Colors.green),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Submit'),
              SizedBox(
                width: 10,
              ),
              Icon(
                Iconsax.document_upload,
                size: 20,
              )
            ],
          )),
      const SizedBox(width: 10),

      //Delete Essay Button
      OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Delete'),
              SizedBox(
                width: 10,
              ),
              Icon(
                Iconsax.document_upload,
                size: 20,
              )
            ],
          )),
    ]);
  }

  Widget essayDisplayArea() {
    return Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bg.jpg'),
              fit: BoxFit.cover,
              opacity: 0.3,
              filterQuality: FilterQuality.high),
        ),
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.lora(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  _essay,
                  style: GoogleFonts.lora(color: Colors.white, fontSize: 13),
                ),
              ]),
        ));
  }

  Widget essayInputArea() {
    double width = MediaQuery.of(context).size.width;
    var essay = widget.essay;
    return Expanded(
        flex: 5,
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.all(36),
            color: const Color.fromARGB(255, 255, 255, 255),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        title2,
                        style: GoogleFonts.ptSans(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      width >= 650 ? essayActionButtons() : Container(),
                    ],
                  ),
                  width >= 650
                      ? Container()
                      : Container(
                          padding: const EdgeInsets.only(top: 10),
                          child: essayActionButtons()),
                  const Divider(),

                  //Counter
                  Row(
                    children: [
                      Text(
                        '${_essay.split(' ').length} Words',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.ptSans(
                            fontSize: 16, color: Colors.blueAccent),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Text('|'),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        '${_essay.characters.length} Characters',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.ptSans(
                            fontSize: 16, color: Colors.blueAccent),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Form(
                      key: _formKey,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //Essay Title
                            TextFormField(
                              initialValue: essay.essayTitle,
                              //controller: essayTitle,
                              onChanged: (value) =>
                                  setState(() => title = value),
                              style: GoogleFonts.ptSans(
                                  color: primary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                              decoration: const InputDecoration(
                                labelText: 'Title',
                                hintText: 'Why Plastics Should be banned',
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        style: BorderStyle.none,
                                        width: 0,
                                        color: Colors.white)),
                                contentPadding: EdgeInsets.all(0),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        style: BorderStyle.none,
                                        width: 0,
                                        color: Colors.white)),
                              ),
                            ),

                            const SizedBox(
                              height: 15,
                            ),

                            //Essay Title
                            TextFormField(
                              initialValue: essay.essayBody,
                              maxLines: 40,
                              //controller: essayBody,
                              onChanged: (value) =>
                                  setState(() => _essay = value),
                              style: GoogleFonts.ptSans(
                                  color: primary, fontSize: 18),
                              decoration: const InputDecoration(
                                hintText: 'Essay Body',
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        style: BorderStyle.none,
                                        width: 0,
                                        color: Colors.white)),
                                contentPadding: EdgeInsets.all(0),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        style: BorderStyle.none,
                                        width: 0,
                                        color: Colors.white)),
                              ),
                            )
                          ]))
                ]),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Row(children: [
        //Essay Display
        width >= 840
            ? Expanded(flex: 3, child: essayDisplayArea())
            : Container(),

        //Essay Text Area
        essayInputArea()
      ]),
    );
  }
}
