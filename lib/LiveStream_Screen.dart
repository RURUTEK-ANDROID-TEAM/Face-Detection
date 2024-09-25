import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class LiveStreamScreen extends StatefulWidget {
  const LiveStreamScreen({super.key});

  @override
  State<LiveStreamScreen> createState() => _LiveStreamScreenState();
}

class _LiveStreamScreenState extends State<LiveStreamScreen> {
  VlcPlayerController? _videoPlayerController;
  bool _isPlaying = false;
  String? _errorMessage;

  // Controllers for input fields with default values
  final TextEditingController _ipController =
  TextEditingController(text: '172.16.0.123');
  final TextEditingController _portController =
  TextEditingController(text: '554');
  final TextEditingController _usernameController =
  TextEditingController(text: 'admin');
  final TextEditingController _passwordController =
  TextEditingController(text: 'Admin@123');

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _ipController.dispose();
    _portController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Function to start the stream using user input
  void _startStream() {
    try {
      // Get the values from the input fields
      final ipAddress = _ipController.text;
      final port = _portController.text;
      final username = _usernameController.text;
      final password = _passwordController.text;

      // Validate if inputs are provided
      if (ipAddress.isEmpty || port.isEmpty || username.isEmpty || password.isEmpty) {
        setState(() {
          _errorMessage = 'All fields are required';
        });
        return;
      }

      final rtspUrl =
          'rtsp://$username:${Uri.encodeComponent(password)}@$ipAddress:$port/ch01/0';


      _videoPlayerController?.dispose();


      _videoPlayerController = VlcPlayerController.network(
        rtspUrl,
        hwAcc: HwAcc.auto,
        autoPlay: true,
        options: VlcPlayerOptions(),
      );

      // Error handling for the controller
      _videoPlayerController!.addListener(() {
        if (!_videoPlayerController!.value.isInitialized) {
          setState(() {
            _errorMessage = 'Stream not initialized';
          });
        }

        if (_videoPlayerController!.value.hasError) {
          setState(() {
            _errorMessage =
            'Error: ${_videoPlayerController!.value.errorDescription}';
            print('Error ${_videoPlayerController!.value.errorDescription}');
          });
        }
      });

      setState(() {
        _isPlaying = true;
        _errorMessage = null; // Reset error message
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error starting stream: $e';
      });
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFd4f1f4),
      appBar: AppBar(
        title: Center(child: const Text('Live Stream')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(13.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Wrap all input fields within a single Container
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFb1d4e0), Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54.withOpacity(0.8),
                    offset: Offset(8, 8),
                    blurRadius: 16.0,
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.8),
                    offset: Offset(-8, -8),
                    blurRadius: 16.0,
                  ),
                ],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildTextField(
                    controller: _ipController,
                    label: 'IP Address',
                    icon: Icons.wifi,
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    controller: _portController,
                    label: 'Port',
                    icon: Icons.stream,
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    controller: _usernameController,
                    label: 'Username',
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    controller: _passwordController,
                    label: 'Password',
                    icon: Icons.password,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child:Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFb1d4e0), Colors.white],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black54.withOpacity(0.8),
                        offset: Offset(8, 8),
                        blurRadius: 16.0,
                      ),
                      BoxShadow(
                        color: Colors.white.withOpacity(0.8),
                        offset: Offset(-8, -8),
                        blurRadius: 16.0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                    //borderRadius: BorderRadius.circular(15),
                  ),
                  child: ElevatedButton(
                    onPressed: _startStream,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Start Stream',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),

              ),
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),

  //           Expanded(
  //             child: _isPlaying && _videoPlayerController != null
  //                 ? VlcPlayer(
  //               controller: _videoPlayerController!,
  //               aspectRatio: 16 / 9,
  //               placeholder: const Center(child: CircularProgressIndicator()),
  //             )
  //                 : const Center(
  //               child: Text('Enter camera details and start streaming'),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child:Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child:
                   _isPlaying && _videoPlayerController != null
                        ? VlcPlayer(
                      controller: _videoPlayerController!,
                      aspectRatio: 16 / 9,
                      placeholder: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                        : const Center(
                      child: Text(
                        'No stream available',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                   // Positioned(
                   //     bottom: 20,
                   //     right: 20,
                   //     child: IconButton(
                   //       onPressed: (){},
                   //       icon: Icon(
                   //         Icons.fullscreen,
                   //         color: Colors.white,
                   //         size: 25,),),)

                    ),
                   ),
                ),

          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,

  }) {
    return TextFormField(
      controller: controller,
      cursorColor: Colors.grey[500],
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.blueGrey),
        prefixIcon: Icon(icon, color: Colors.blueGrey),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blueGrey,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blueGrey,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      validator: validator,
    );
  }
}


