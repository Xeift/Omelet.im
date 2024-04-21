import 'package:flutter/material.dart';

class DeveloperPage extends StatelessWidget {
  const DeveloperPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color.fromARGB(255, 188, 139, 112),
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Omelet Team',
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              _buildFlippableDeveloperCard(
                frontImagePath: 'assets/xeift.png',
                backImagePath: 'assets/xeift.png',
                developerName: 'Xeift',
                developerType: 'Backend Developer',
                hideText:'nothing',
                hideSecText:'nothing'
              ),
              _buildFlippableDeveloperCard(
                frontImagePath: 'assets/thomas.png',
                backImagePath: 'assets/thomas.png',
                developerName: 'Thomas',
                developerType: 'Feature Developer',
                hideText:'nothing',
                hideSecText:'nothing'
              ),
              _buildFlippableDeveloperCard(
                frontImagePath: 'assets/maple.png',
                backImagePath: 'assets/nini.png',
                developerName: 'Maple',
                developerType: 'Frontend Developer',
                hideText:'咩～',
                hideSecText:'咩～'
              ),
              _buildFlippableDeveloperCard(
                frontImagePath: 'assets/nini.png',
                backImagePath: 'assets/maple.png',
                developerName: 'Wendy',
                developerType: 'App UI Design',
                hideText:'nothing',
                hideSecText:'nothing'
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFlippableDeveloperCard({
    required String frontImagePath,
    required String backImagePath,
    required String developerName,
    required String developerType,
    required String hideText,
    required String hideSecText,
  }) {
    return DeveloperCard(
      frontImagePath: frontImagePath,
      backImagePath: backImagePath,
      developerName: developerName,
      developerType: developerType,
      hideText: hideText,
      hideSecText: hideSecText
    );
  }
}

class DeveloperCard extends StatefulWidget {
  final String frontImagePath;
  final String backImagePath;
  final String developerName;
  final String developerType;
  final String hideText;
  final String hideSecText;

  const DeveloperCard({
    Key? key,
    required this.frontImagePath,
    required this.backImagePath,
    required this.developerName,
    required this.developerType, required this.hideText, required this.hideSecText,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DeveloperCardState createState() => _DeveloperCardState();
}

class _DeveloperCardState extends State<DeveloperCard> {
  bool _showFront = true;

  void _toggleCard() {
    setState(() {
      _showFront = !_showFront;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleCard,
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: _showFront
            ? _buildFront()
            : _buildBack(),
      ),
    );
  }

  Widget _buildFront() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _flipImage(widget.frontImagePath, 90, 90),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.developerName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              widget.developerType,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w300,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBack() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _flipImage(widget.backImagePath, 90, 90),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.hideText,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              widget.hideSecText,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w300,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _flipImage(String imagePath, double height, double width) {
    return Stack(
      children: [
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(_showFront ? 0 : 3.14),
          child: Image.asset(
            imagePath,
            height: height,
            width: width,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}
