import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todos_app/blocs/auth/auth_bloc.dart';
import 'package:todos_app/components/profile/Info_card.c.dart';
import 'popups/profile/changepass.p.dart';
import '../models/auth.m.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final Auth auth = (state as AuthLoggedIn).auth;
        return SafeArea(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomRight,
                colors: [
                  Colors.red[200]!,
                  Colors.red[400]!,
                  Colors.grey[500]!,
                  Colors.red[800]!,
                ],
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: CircleAvatar(
                        radius: 100,
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(
                            auth.user!.images!.avatar ?? "",
                            scale: 1),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '${auth.user!.name ?? ''} ${auth.user!.lastName ?? ''}',
                      style: GoogleFonts.rubik(
                        textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    InfoCard(
                        text: 'Username:  ${auth.user!.login!.username}',
                        icon: Icons.vpn_key_outlined),
                    InfoCard(
                        text: auth.user!.login!.email ?? '', icon: Icons.email),
                    InfoCard(icon: Icons.phone, text: auth.user!.phone ?? ''),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          onPressed: () {
                            context
                                .read<AuthBloc>()
                                .add(AuthEventLogOut(auth: auth));
                          },
                          child: Text(
                            'Log Out',
                            style: GoogleFonts.rubik(
                              textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: Text(
                            'Change Password',
                            style: GoogleFonts.rubik(
                              textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ChangePassPopup(
                                  auth.token!,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
