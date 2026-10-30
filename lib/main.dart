import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fixmate/supabase/supabase.dart';
import 'package:fixmate/view/booknow%20view.dart';
import 'package:fixmate/viewmodel/AC%20viewmodel.dart';
import 'package:fixmate/viewmodel/add%20address%20viewmodel.dart';
import 'package:fixmate/viewmodel/address%20viewmodel.dart';
import 'package:fixmate/viewmodel/auth%20viewmodel.dart';
import 'package:fixmate/viewmodel/bookdetails%20viewmodel.dart';
import 'package:fixmate/viewmodel/booking%20confirmed%20viewmodel.dart';
import 'package:fixmate/viewmodel/cancelled%20viewmodel.dart';
import 'package:fixmate/viewmodel/categories%20viewmodel.dart';
import 'package:fixmate/viewmodel/completed%20viewmodel.dart';
import 'package:fixmate/viewmodel/editaddress%20viewmodel.dart';
import 'package:fixmate/viewmodel/home%20viewmodel.dart';
import 'package:fixmate/viewmodel/service%20booking%20viewmodel.dart';
import 'package:fixmate/viewmodel/upcoming%20viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'firebase_options.dart';



import 'view/Personal info.dart';
import 'view/bottom.dart';
import 'view/profile.dart';
import 'view/splah.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );  if (SupabaseConfig.url.isNotEmpty && SupabaseConfig.anonKey.isNotEmpty) {
    try {
      await Supabase.initialize(
        url: 'https://xtfrnvrjyhsdhjjdfakb.supabase.co',
        anonKey: 'sb_publishable_Jk7FVbxh9Lo81pZXJfOT6w_x_owhVqO',
      );
    } catch (_) {}
    runApp(Proclass());
  }}

class Proclass extends StatelessWidget {
  const Proclass({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => EditAddressViewModel()),
        ChangeNotifierProvider(create: (context) => AcViewModel()),
        ChangeNotifierProvider(create: (context) => AddAddressViewmodel()),
        ChangeNotifierProvider(create: (context) => AddressListViewmodel()),
        ChangeNotifierProvider(create: (context) => BookingDetailsViewModel()),
        ChangeNotifierProvider(create: (context) => ConfirmViewModel()),
        ChangeNotifierProvider(create: (context) => CancelledViewModel()),
        ChangeNotifierProvider(create: (context) => CategoriesViewModel()),
        ChangeNotifierProvider(create: (context) => CompletedViewModel()),
        ChangeNotifierProvider(create: (context) => HomeViewModel()),
        ChangeNotifierProvider(create: (context) => ProfessionalViewModel()),
        // ChangeNotifierProvider(create: (context) => UpcomingViewModel()),
        ChangeNotifierProvider(create: (context) => AuthViewModel()),

      ],
      child:  MaterialApp(
        home: Splash(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}