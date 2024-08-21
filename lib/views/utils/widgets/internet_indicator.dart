import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';

import '../constant/colors.dart';

class InternetIndicator extends StatelessWidget {
  InternetIndicator({super.key});
  final Connectivity _connectivity = Connectivity();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 28.0),
      child: StreamBuilder<ConnectivityResult>(
        stream: _connectivity.onConnectivityChanged,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CupertinoActivityIndicator();
          }

          if (snapshot.hasData) {
            final ConnectivityResult result = snapshot.data!;
            if (result == ConnectivityResult.none) {
              return const Padding(
                padding: EdgeInsets.only(right: 5),
                child: Column(
                  children: [
                    Icon(
                      CupertinoIcons.wifi_slash,
                      color: tdRed,
                    ),
                    Text(
                      "Disconnected",
                      style: TextStyle(color: tdRed, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              );
            } else {
              return const Padding(
                padding: EdgeInsets.only(right: 5),
                child: Column(
                  children: [
                    Icon(CupertinoIcons.wifi, color: tdGreen,),
                    Text("Connected", style: TextStyle(color: tdGreen, fontWeight: FontWeight.bold),)
                  ],
                ),
              );
            }
          } else {
            return const Center(
              child: Text('Error: No data'),
            );
          }
        },
      ),
    );
  }
}
