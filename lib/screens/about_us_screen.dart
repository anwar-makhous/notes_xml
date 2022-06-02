import 'package:flutter/material.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text("About Us"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * .05,
            vertical: MediaQuery.of(context).size.width * .1,
          ),
          // height: MediaQuery.of(context).size.height - kToolbarHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  "images/logo-white-1.png",
                  fit: BoxFit.fitWidth,
                ),
              ),
              const Center(
                child: Text(
                  "تم بناء هذا التطبيق كجزء من متطلبات مقرر Advanced Concepts in Data Repository and Data Exchange\nضمن مقررات ماجستير علوم الويب MWS\nلإظهار مثال عملي حول استعمال XML في تخزين البيانات\nanwar_194763\nammar_198789",
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
