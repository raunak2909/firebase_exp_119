import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_exp_119/main.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController mobNoController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            controller: nameController,
          ),
          TextField(
            keyboardType: TextInputType.emailAddress,
            controller: emailController,
          ),
          TextField(
            keyboardType: TextInputType.phone,
            controller: mobNoController,
          ),
          TextField(
            keyboardType: TextInputType.number,
            controller: ageController,
          ),
          TextField(
            controller: passController,
          ),
          TextField(
            controller: confirmPassController,
          ),
          ElevatedButton(
              onPressed: () async{
                var name = nameController.text;
                var email = emailController.text;
                var mobNo = mobNoController.text;
                var age = ageController.text;
                var pass = passController.text;
                var confirmPass = confirmPassController.text;

                if (name.isNotEmpty &&
                    email.isNotEmpty &&
                    mobNo.isNotEmpty &&
                    age.isNotEmpty &&
                    pass.isNotEmpty &&
                    confirmPass.isNotEmpty) {
                  if (pass == confirmPass) {
                    ///now you can register

                    try {
                      UserCredential userCred = await auth.createUserWithEmailAndPassword(
                          email: email, password: pass);

                      FirebaseFirestore.instance.collection("users").doc(userCred.user!.uid).set({
                        "name" : name,
                        "email" : email,
                        "age" : age,
                        "mobNo" : mobNo,
                      });


                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Success: User with ${userCred.user!.uid} registered successfully!!')));

                      Navigator.pop(context);
                      /*Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(uid: userCred.user!.uid),));
*/

                    } on FirebaseAuthException catch(e){
                      if (e.code == 'weak-password') {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: The password provided is too weak.')));
                      } else if (e.code == 'email-already-in-use') {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: The account already exists for that email.')));
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $e')));
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Password does not match!!')));
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Please fill all the required blanks!!')));
                }
              },
              child: Text('Register')),
          InkWell(
            onTap: (){
              Navigator.pop(context);
            },
              child: Text('Already have an Account, Login now..'))
        ],
      ),
    );
  }
}
