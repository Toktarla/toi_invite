import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toi_invite/constants.dart';
import 'package:toi_invite/widgets/circular_text_painter.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({Key? key}) : super(key: key);

  @override
  _WebScreenLayoutState createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Duration _timeUntilEvent;
  late Timer _timer;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _wishesController = TextEditingController();
  final player = AudioPlayer();
  late final UrlSource urlSource;
  bool _isPlaying = false;
  late ByteData _audioFileBytes;

  @override
  void initState() {
    super.initState();
    _calculateTimeUntilEvent();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _calculateTimeUntilEvent();
    });
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
    loadAudioFile();
  }
  void loadAudioFile() async {
    _audioFileBytes = await rootBundle.load('assets/musics/music.mp3');

    Uint8List soundbytes = _audioFileBytes.buffer.asUint8List(_audioFileBytes.offsetInBytes, _audioFileBytes.lengthInBytes);

    urlSource = UrlSource(Uri.dataFromBytes(soundbytes, mimeType:'audio/mpeg').toString());

  }
  String _selectedRadio = '';

  void _handleRadioChange(String? value) {
    setState(() {
      _selectedRadio = value!;
    });
  }

  void _toggleMusic() async {
    if (player.state == PlayerState.playing) {
      await player.stop();
    }
    else {
      await player.play(urlSource);
    }
  }
  String _formatDuration(Duration duration) {
    return '${duration.inDays} күн ${duration.inHours.remainder(24)} сағат ${duration.inMinutes.remainder(60)} минут ${duration.inSeconds.remainder(60)} секунд';
  }

  void _calculateTimeUntilEvent() {
    DateTime eventDate = DateTime(2024, 8, 25, 19, 0);
    DateTime now = DateTime.now();
    _timeUntilEvent = eventDate.difference(now);
    if (_timeUntilEvent.isNegative) {
      _timeUntilEvent = Duration.zero;
      _timer.cancel();
    }
    setState(() {});
  }


  void _submitForm() async {
    if (_nameController.text.isEmpty || _selectedRadio.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text('Аты-жөніңізді енгізіп, қатысу опциясын таңдаңыз.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK',style: garamondStyle,),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    try {
      // Add current timestamp
      final Timestamp now = Timestamp.now();

      await _firestore.collection('responses').add({
        'name': _nameController.text,
        'wishes': _wishesController.text.isEmpty ? null : _wishesController.text,
        'participation': _selectedRadio,
        'createdAt': now, // Add createdAt field with current timestamp
      });

      _nameController.clear();
      _wishesController.clear();
      setState(() {
        _selectedRadio = '';
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text('Жауабыңыз сәтті жіберілді.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK',style: garamondStyle,),
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                },
              ),
            ],
          );
        },
      );

    } catch (e) {
      print('Error submitting form: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              width: width,
              height: height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/bg-wedding-image.jpg'),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: height / 6),
                  Text(
                    "Мадияр & Венера",
                    style: greatVibesStyle.copyWith(
                        fontSize: 50, color: Colors.white,fontStyle: FontStyle.italic
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "25.08.2024",
                    style: greatVibesStyle.copyWith(
                        fontSize: 50, color: Colors.white),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40,right: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: _toggleMusic,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              RotationTransition(
                                turns: _controller,
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromRGBO(36, 117, 218, 1.0),
                                  ),
                                  child: const Icon(
                                    FontAwesomeIcons.music,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              RotationTransition(
                                turns: _controller,
                                child: CustomPaint(
                                  painter: CircularTextPainter(
                                    text:
                                    '  музыка қосу үшін кнопканы басыңыз  ⬤  музыка қосу үшін кнопканы басыңыз  ⬤',
                                    textStyle: const TextStyle(
                                      color:
                                      Color.fromRGBO(36, 117, 218, 1.0),
                                      fontSize: 8,
                                    ),
                                  ),
                                  size: const Size(140,
                                      140), // Slightly larger size for closer text
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            const SizedBox(
                              height: 50,
                            ),
                            Container(
                              width: 80,
                              height: 80,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromRGBO(60, 87, 48, 1.0),
                              ),
                              child: const Icon(
                                FontAwesomeIcons.arrowDown,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'ТӨМЕН\nТҮСІРІҢІЗ',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/white-bg.jpg'),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      height: 70,
                      width: 150,
                      child: Image.asset(
                          'assets/images/—Pngtree—beautiful vintage white flower ornament_5541289.png')),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'ҚҰРМЕТТІ АҒАЙЫН-ТУЫС,\nБАУЫРЛАР,\nҚҰДА-ЖЕКЖАТ, НАҒАШЫЛАР,\nБӨЛЕ-ЖИЕНДЕР,ДОС-ЖАРАНДАР,\nКӨРШІЛЕР\nЖӘНЕ ӘРІПТЕСТЕР! ',
                    style: garamondStyle.copyWith(),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                      height: 100,
                      width: 200,
                      child: Image.asset(
                          'assets/images/—Pngtree—white rose watercolor wedding flower_6690705.PNG')),
                  Text(
                    'СІЗ(ДЕР)ДІ БАЛАЛАРЫМЫЗ',
                    style: garamondStyle.copyWith(),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'МАДИЯР',
                    style: goldStyle,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'МЕН',
                    style: garamondStyle.copyWith(),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    'ВЕНЕРАНЫҢ',
                    style: goldStyle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'ҮЙЛЕНУ ТОЙЫНА АРНАЛҒАН\nСАЛТАНАТТЫ АҚ \nДАСТАРХАНЫМЫЗДЫҢ \nҚАДІРЛІ ҚОНАҒЫ БОЛУҒА \nШАҚЫРАМЫЗ',
                    style: garamondStyle.copyWith(),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                      height: 100,
                      width: 200,
                      child: Image.asset(
                          'assets/images/—Pngtree—white rose watercolor wedding flower_6690705.PNG')),
                  Text(
                    'ТОЙ САЛТАНАТЫ',
                    style: garamondStyle.copyWith(color: goldColor),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '25 ТАМЫЗ 2024 ЖЫЛ',
                    style: garamondStyle.copyWith(
                        color: goldColor, fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'САҒАТ 19:00 БАСТАЛАДЫ',
                    style: garamondStyle.copyWith(color: goldColor),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                      height: 100,
                      width: 200,
                      child: Image.asset(
                          'assets/images/—Pngtree—white rose watercolor wedding flower_6690705.PNG')),
                  Text(
                    'Той йелері',
                    style: heyheyStyle.copyWith(fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'ТЕМІРХАН - АЙНҰР',
                    style: heyheyStyle.copyWith(
                        color: goldColor, fontStyle: FontStyle.italic,fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Тойға дейін',
                    style:
                    heyheyStyle.copyWith(fontStyle: FontStyle.italic,fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5,),
                  Container(
                    width: width,
                    height: height / 1.5,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/cake.jpg'),
                          fit: BoxFit.cover),
                    ),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        '${_formatDuration(_timeUntilEvent)}',
                        style: heyheyStyle.copyWith(color: Colors.white,fontSize: 30),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Мекен-жайымыз:',
                    style: heyheyStyle.copyWith(fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Қызылорда қаласы',
                    style:
                    heyheyStyle.copyWith(fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '\"Арай\"',
                    style:
                    heyheyStyle.copyWith(fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'мейрамханасы',
                    style:
                    heyheyStyle.copyWith(fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            launchUrlString(
                                'https://instagram.com/araypark.kz');
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: const DecorationImage(
                                    image:
                                    AssetImage('assets/images/insta.jpg'),
                                    fit: BoxFit.cover)),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            launchUrlString(
                                'https://2gis.kz/kyzylorda/geo/70000001062409197');
                          },
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: const DecorationImage(
                                    image:
                                    AssetImage('assets/images/2gis.png'),
                                    fit: BoxFit.cover)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48),
                    child: Column(
                      children: [
                        Text(
                          'ТОЙҒА КЕЛЕТІНІҢІЗДІ \nРАСТАУЫҢЫЗДЫ СҰРАЙМЫЗ',
                          style: garamondStyle,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8.0),
                        TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            hintText: 'Есіміңіз (есімдеріңіз)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Тойға тілектеріңіз:',
                            style: garamondStyle.copyWith(fontSize: 12),
                          ),
                        ),
                        TextField(
                          controller: _wishesController,
                          maxLines: 6,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Қатысуыңыз:',
                            style: garamondStyle.copyWith(fontSize: 12),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        RadioListTile(
                          title: Text('Қатысамын',style: garamondStyle),
                          value: 'Қатысамын',
                          groupValue: _selectedRadio,
                          onChanged: _handleRadioChange,
                        ),
                        RadioListTile(
                          title: Text('Жұбайыммен барамын',style: garamondStyle,),
                          value: 'Жұбайыммен барамын',
                          groupValue: _selectedRadio,
                          onChanged: _handleRadioChange,
                        ),
                        RadioListTile(
                          title: Text('Өкінішке орай келе алмаймын',style: garamondStyle,),
                          value: 'Өкінішке орай келе алмаймын',
                          groupValue: _selectedRadio,
                          onChanged: _handleRadioChange,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Center(
                    child: Container(
                      width: width / 2,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: goldColor,
                        ),
                        onPressed: _submitForm,
                        child: Text(
                          'Жіберу',
                          style: garamondStyle.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  GestureDetector(
                    onTap: () {
                      launchUrlString('https://wa.link/bkh8pe');
                    },
                    child: Center(
                      child: Container(
                        width: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            Text(
                              "СВЯЖИТЕСЬ С НАМИ, ЧТОБЫ ЗАКАЗАТЬ ТАКОЙ ЖЕ САЙТ С ПРИГЛАШЕНИЕМ",
                              style: garamondStyle,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Icon(
                              FontAwesomeIcons.whatsapp,
                              size: 30,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
