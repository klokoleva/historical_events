import 'package:flutter/material.dart';
import 'package:historical_events/httpservices.dart';
import 'package:historical_events/widgetlottie.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController monthCtrl = TextEditingController();
  TextEditingController dayCtrl = TextEditingController();
  ValueNotifier<String> historydata = ValueNotifier('');

  @override
  void initState() {
    monthCtrl.text = DateTime.now().month.toString();
    dayCtrl.text = DateTime.now().day.toString();
    getdata();
    super.initState();
  }

  getdata() async {
    historydata.value = await getdataservices(monthCtrl.text, dayCtrl.text);
  }

  @override
  Widget build(BuildContext context) {
    Widget breaks() {
      return SizedBox(height: 32);
    }

    Widget formfield(String label, TextEditingController? controller) {
      return TextFormField(
        style: TextStyle(color: Colors.white),
        keyboardType: TextInputType.number,
        controller: controller,
        decoration: InputDecoration(
          label: Text(
            label,
            style: TextStyle(color: Colors.white),
          ),
        ),
        onSaved: (newValue) {
          if (newValue!.isNotEmpty) {
            controller?.text = newValue;
          } else {
            controller?.text = '';
          }
        },
      );
    }

    Widget genhead() {
      return Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            formfield('Month', monthCtrl),
            formfield('Day', dayCtrl),
            breaks(),
            FilledButton(
                onPressed: () {
                  if (monthCtrl.text.isEmpty || dayCtrl.text.isEmpty) {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Form Validation'),
                          content: Text('Field must be fill !'),
                          actions: [
                            FilledButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Okaay'))
                          ],
                        );
                      },
                    );
                  } else {
                    FocusScope.of(context).unfocus();
                    historydata.value = '';
                    getdata();
                  }
                },
                child: Text('Get Event Now'))
          ],
        ),
      );
    }

    Widget generatedata() {
      return ValueListenableBuilder(
        valueListenable: historydata,
        builder: (context, value, child) {
          return Expanded(
            child: value.isEmpty
                ? lottieAsset()
                : Padding(
                    padding: EdgeInsets.all(24),
                    child: ExpansionTile(
                      trailing: Icon(Icons.history),
                      initiallyExpanded: true,
                      title: Text('Historical Events'),
                      subtitle: Text('${monthCtrl.text}, ${dayCtrl.text}'),
                      children: [Text(value)],
                    ),
                  ),
          );
        },
      );
    }

    return GestureDetector(
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [genhead(), generatedata()],
          ),
        ),
      ),
    );
  }
}
