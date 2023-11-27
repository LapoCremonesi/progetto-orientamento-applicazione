import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Map<String, String> headers =  {
  "Access-Control-Allow-Origin": "*",
  'Content-Type': 'text/plain',
  'Accept': '*/*'
};

String url = "http://";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double temperature = 0.0;
  double humidity = 0.0;
  double pascal = 0.0;
  double altitude = 0.0;
  bool isInit = false;
  TextEditingController inputIP = TextEditingController();


  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Future.delayed(const Duration(milliseconds: 500), () {
      getData();
    });

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          height: height,
          width: width,
          color: Colors.deepPurple[200],
          child: Column(
            children: [
              Container(
                height: 150,
                width: width,
                decoration: const BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Home Assistant',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              isInit ? SizedBox(
                height: height - 170,
                child: RefreshIndicator(
                  onRefresh: () {
                    return Future.delayed(const Duration(seconds: 2), () {
                      getData();
                    });
                  },
                  child: ListView.builder(
                    itemCount: 1,
                    itemBuilder: (context, _) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 300,
                                width: width / 2 - 15,
                                margin: const EdgeInsets.only(left: 10, right: 5),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 100),
                                    const Text(
                                      'Temperature',
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    const Icon(
                                      Icons.thermostat,
                                      size: 20,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      '$temperature°',
                                      style: const TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 300,
                                width: width / 2 - 15,
                                margin: const EdgeInsets.only(left: 5, right: 10),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 100),
                                    const Text(
                                      'Humidity',
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    const Icon(
                                      Icons.water_drop_rounded,
                                      size: 20,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      '$humidity %',
                                      style: const TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Container(
                                height: 300,
                                width: width / 2 - 15,
                                margin: const EdgeInsets.only(left: 10, right: 5),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 100),
                                    const Text(
                                      'Altitude',
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    const Icon(
                                      Icons.arrow_upward_rounded,
                                      size: 20,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      '$altitude m',
                                      style: const TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 300,
                                width: width / 2 - 15,
                                margin: const EdgeInsets.only(left: 5, right: 10),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 100),
                                    const Text(
                                      'Pascal',
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Image.asset('assets/images/pressure_icon.png', scale: 3.5,),
                                    const SizedBox(height: 10),
                                    Text(
                                      '${pascal / 100} hPa',
                                      style: const TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
                    },
                  ),
                ),
              ) : SizedBox(
                    height: height - 170,
                    child: Column(
                      children: [
                        const SizedBox(height: 100),
                        Container(
                          height: 70,
                          width: width,
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Center(
                            child: TextField(
                              controller: inputIP,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'Insert IP address',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              url += inputIP.text;
                              isInit = true;
                            });
                          },
                          child: Container(
                            height: 70,
                            width: width,
                            margin: const EdgeInsets.only(left: 10, right: 10),
                            decoration: const BoxDecoration(
                              color: Colors.deepPurple,
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.check,
                                  size: 20,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Submit",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ), 
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  void getData() async {
    final temperatureResponse = await http.get(
      Uri.parse('$url/temperature'),
    );
    final pascalResponse = await http.get(
      Uri.parse('$url/pascal'),
    );
    final altitudeResponse = await http.get(
      Uri.parse('$url/altitude'),
    );
    final humidityResponse = await http.get(
      Uri.parse('$url/humidity'),
    );

    setState(() {
      temperature = parseText(temperatureResponse.body);
      pascal = parseText(pascalResponse.body).roundToDouble();
      altitude = parseText(altitudeResponse.body).roundToDouble();
      humidity = parseText(humidityResponse.body);
    });
  }

  double parseText(String text) {
    String value = '';
    if (text == 'nan') {
      return 0.0;
    }
    for (int i = 0; i < text.length; i++) {
      try {
        if (text[i] == '.') {
          value += text[i];
        } else {
          int.parse(text[i]);
          value += text[i];
        }
      } catch (e) {}
    }
    return double.parse(value);
  }
}


