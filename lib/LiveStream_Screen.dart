// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_vlc_player/flutter_vlc_player.dart';
//
// class LiveStreamScreen extends StatefulWidget {
//   const LiveStreamScreen({super.key});
//
//   @override
//   State<LiveStreamScreen> createState() => _LiveStreamScreenState();
// }
//
// class _LiveStreamScreenState extends State<LiveStreamScreen> {
//   VlcPlayerController? _videoPlayerController;
//   bool _isPlaying = false;
//   String? _errorMessage;
//   List<String> _cameraList=[];
//   String? _selectedCamera;
//
//   // Controllers for input fields with default values
//   final TextEditingController _ipController =
//   TextEditingController(text: '172.16.0.123');
//   final TextEditingController _portController =
//   TextEditingController(text: '554');
//   final TextEditingController _usernameController =
//   TextEditingController(text: 'admin');
//   final TextEditingController _passwordController =
//   TextEditingController(text: 'Admin@123');
//
//   @override
//   void initState(){
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _videoPlayerController?.dispose();
//     _ipController.dispose();
//     _portController.dispose();
//     _usernameController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }
//
//   void _startStream() {
//     try {
//
//       final ipAddress = _ipController.text;
//       final port = _portController.text;
//       final username = _usernameController.text;
//       final password = _passwordController.text;
//
//       // Validate if inputs are provided
//       if (ipAddress.isEmpty || port.isEmpty || username.isEmpty || password.isEmpty) {
//         setState(() {
//           _errorMessage = 'All fields are required';
//         });
//         return;
//       }
//
//       final rtspUrl =
//           'rtsp://$username:${Uri.encodeComponent(password)}@$ipAddress:$port/ch01/0';
//
//       _videoPlayerController?.dispose();
//
//       _videoPlayerController = VlcPlayerController.network(
//         rtspUrl,
//         hwAcc: HwAcc.auto,
//         autoPlay: true,
//         options: VlcPlayerOptions(),
//       );
//
//       // Error handling for the controller
//       _videoPlayerController!.addListener(() {
//         if (!_videoPlayerController!.value.isInitialized) {
//           setState(() {
//             _errorMessage = 'Stream not initialized';
//           });
//         }
//
//         if (_videoPlayerController!.value.hasError) {
//           setState(() {
//             _errorMessage =
//             'Error: ${_videoPlayerController!.value.errorDescription}';
//             print('Error ${_videoPlayerController!.value.errorDescription}');
//           });
//         }
//       });
//
//       setState(() {
//         _isPlaying = true;
//         _errorMessage = null; // Reset error message
//       });
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Error starting stream: $e';
//       });
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // backgroundColor: Color(0xFFd4f1f4),
//       backgroundColor: Color(0xFFd4f1f4),
//       appBar: AppBar(
//         title: Center(child: const Text('Live Stream')),
//         actions: [
//           IconButton(onPressed:(){
//             _discoverCameraManually();
//           },
//               icon: Icon(Icons.wifi))
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(13.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if(_cameraList.isNotEmpty)...[
//               const Text('Select a Camera:'),
//               DropdownButton<String>(
//                 value: _selectedCamera,
//                 hint: const Text('Select Camera'),
//                 items: _cameraList.map((camera)
//                 {
//                   return DropdownMenuItem(
//                     value: camera,
//                     child: Text(camera),
//                   );
//                 }).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedCamera = value;
//                     _ipController.text = _selectedCamera ?? '';
//                   });
//                 },
//               ),
//               const SizedBox(height: 20),
//             ]else
//               const Text("No cameras discovered yet"),
//
//            SizedBox(height: 10),
//             Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Color(0xFFb1d4e0), Colors.white],
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black54.withOpacity(0.8),
//                     offset: Offset(8, 8),
//                     blurRadius: 16.0,
//                   ),
//                   BoxShadow(
//                     color: Colors.white.withOpacity(0.8),
//                     offset: Offset(-8, -8),
//                     blurRadius: 16.0,
//                   ),
//                 ],
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(
//                   color: Colors.white,
//                   width: 2,
//                 ),
//               ),
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   _buildTextField(
//                     controller: _ipController,
//                     label: 'IP Address',
//                     icon: Icons.wifi,
//                   ),
//                   const SizedBox(height: 10),
//                   _buildTextField(
//                     controller: _portController,
//                     label: 'Port',
//                     icon: Icons.stream,
//                   ),
//                   const SizedBox(height: 10),
//                   _buildTextField(
//                     controller: _usernameController,
//                     label: 'Username',
//                     icon: Icons.person,
//                   ),
//                   const SizedBox(height: 10),
//                   _buildTextField(
//                     controller: _passwordController,
//                     label: 'Password',
//                     icon: Icons.password,
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             Center(
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child:Container(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [Color(0xFFb1d4e0), Colors.white],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black54.withOpacity(0.8),
//                         offset: Offset(8, 8),
//                         blurRadius: 16.0,
//                       ),
//                       BoxShadow(
//                         color: Colors.white.withOpacity(0.8),
//                         offset: Offset(-8, -8),
//                         blurRadius: 16.0,
//                       ),
//                     ],
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(
//                       color: Colors.white,
//                       width: 2,
//                     ),
//                     //borderRadius: BorderRadius.circular(15),
//                   ),
//                   child: ElevatedButton(
//                     onPressed: _startStream,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.transparent,
//                       shadowColor: Colors.transparent,
//                       padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                     child: const Text(
//                       'Start Stream',
//                       style: TextStyle(color: Colors.black),
//                     ),
//                   ),
//                 ),
//
//               ),
//             ),
//             if (_errorMessage != null)
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(
//                   _errorMessage!,
//                   style: const TextStyle(color: Colors.red),
//                 ),
//               ),
//
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child:Container(
//                     decoration: BoxDecoration(
//                       color: Colors.grey[900],
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child:
//                    _isPlaying && _videoPlayerController != null
//                         ? VlcPlayer(
//                       controller: _videoPlayerController!,
//                       aspectRatio: 16 / 9,
//                       placeholder: const Center(
//                         child: CircularProgressIndicator(),
//                       ),
//                     )
//                         : const Center(
//                       child: Text(
//                         'No stream available',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//
//                 ),
//                    ),
//                 ),
//           ],
//         ),
//       ),
//     );
//   }
//   void _discoverCameraManually(){
//     setState(() {
//       _cameraList =['172.16.0.123','172.16.0.140'];
//     });
//   }
//
//
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     String? Function(String?)? validator,
//
//   }) {
//     return TextFormField(
//       controller: controller,
//       cursorColor: Colors.grey[500],
//       decoration: InputDecoration(
//         labelText: label,
//         labelStyle: TextStyle(color: Colors.blueGrey),
//         prefixIcon: Icon(icon, color: Colors.blueGrey),
//         focusedBorder: OutlineInputBorder(
//           borderSide: BorderSide(
//             color: Colors.blueGrey,
//             width: 2.0,
//           ),
//           borderRadius: BorderRadius.circular(10.0),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderSide: BorderSide(
//             color: Colors.blueGrey,
//             width: 2.0,
//           ),
//           borderRadius: BorderRadius.circular(10.0),
//         ),
//       ),
//       validator: validator,
//     );
//   }
// }
//
//
import 'package:flutter/material.dart';
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
  List<String> _cameraList = ['172.16.0.123', '172.16.0.140']; // Camera list directly here
  String? _selectedCamera;

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

  void _startStream() {
    try {
      final ipAddress = _ipController.text;
      final port = _portController.text;
      final username = _usernameController.text;
      final password = _passwordController.text;

      if (ipAddress.isEmpty ||
          port.isEmpty ||
          username.isEmpty ||
          password.isEmpty) {
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
          });
        }
      });

      setState(() {
        _isPlaying = true;
        _errorMessage = null;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error starting stream: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFd4f1f4),
      appBar: AppBar(
        title: const Center(child: Text('Live Stream')),
        actions: [
          if (_cameraList.isNotEmpty)
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                icon: const Icon(Icons.videocam, color: Colors.black),
                dropdownColor: Colors.white,
                value: _selectedCamera,
                hint: const Text('Select Camera', style: TextStyle(color: Colors.black)),
                items: _cameraList.map((camera) {
                  return DropdownMenuItem<String>(
                    value: camera,
                    child: Text(camera, style: const TextStyle(color: Colors.black)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCamera = value;
                    _ipController.text = _selectedCamera ?? '';
                  });
                },
              ),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(13.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_cameraList.isEmpty) const Text("No cameras discovered yet"),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFb1d4e0), Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54.withOpacity(0.8),
                    offset: const Offset(8, 8),
                    blurRadius: 16.0,
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.8),
                    offset: const Offset(-8, -8),
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
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFb1d4e0), Colors.white],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black54.withOpacity(0.8),
                        offset: const Offset(8, 8),
                        blurRadius: 16.0,
                      ),
                      BoxShadow(
                        color: Colors.white.withOpacity(0.8),
                        offset: const Offset(-8, -8),
                        blurRadius: 16.0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: _startStream,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 30),
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
            const SizedBox(height: 20,),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: _isPlaying && _videoPlayerController != null
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
        labelStyle: const TextStyle(color: Colors.blueGrey),
        prefixIcon: Icon(icon, color: Colors.blueGrey),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.blueGrey,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
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
