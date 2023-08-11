import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:gajgaji/_manager/bindings.dart';
import 'package:gajgaji/_manager/myVoids.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../_manager/firebaseVoids.dart';
import '../_manager/myLocale/myLocaleCtr.dart';
import '../_manager/myUi.dart';
import '../_manager/styles.dart';
import '../_models/worker.dart';
import 'workersCtr.dart';

class AddEditWorker extends StatefulWidget {
  const AddEditWorker({super.key});

  @override
  State<AddEditWorker> createState() => _AddEditWorkerState();
}

class _AddEditWorkerState extends State<AddEditWorker> {
  bool isAdd = Get.arguments['isAdd'];

  double spaceFields = 25;



  @override
  void initState() {
    super.initState();
  }

  //###############################################################"
  //###############################################################"

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: backGroundTemplate(
      child: GetBuilder<WorkersCtr>(
          initState: (_) {
            if(!isAdd){

              wrkCtr.nameTec.text = wrkCtr.selectedWorker.name!;
              wrkCtr.ageTec.text = wrkCtr.selectedWorker.age!;
              wrkCtr.phoneTec.text = wrkCtr.selectedWorker.phone!;
              wrkCtr.addressTec.text = wrkCtr.selectedWorker.address!;
              wrkCtr.salaryTec.text = wrkCtr.selectedWorker.salary!.toString();
              wrkCtr.emailTec.text = wrkCtr.selectedWorker.email!;
              wrkCtr.roleTec.text = wrkCtr.selectedWorker.role!;
              wrkCtr.specialityTec.text = wrkCtr.selectedWorker.speciality!;
              wrkCtr.sex = wrkCtr.selectedWorker.sex!;

            }else{
              wrkCtr.nameTec.text ='';
              wrkCtr.ageTec.text = '';
              wrkCtr.phoneTec.text ='';
              wrkCtr.addressTec.text = '';
              wrkCtr.salaryTec.text ='';
              wrkCtr.emailTec.text = '';
              wrkCtr.roleTec.text ='';
              wrkCtr.specialityTec.text = '';
              wrkCtr.sex = wrkCtr.selectedGender[0];
            }

          },
          dispose: (_) {},
        builder: (_) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: Form(
              key:  wrkCtr.registerWorkerKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      child: Text(
                        isAdd? "New Worker".tr:wrkCtr.selectedWorker.name!,
                        style: TextStyle(
                            fontFamily: 'Segoe UI',
                            fontSize: 35,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),

                    SizedBox(
                      height: 30,
                    ),

                    /// /////////////////////////////////

                    //name
                    customTextField(
                      controller: wrkCtr.nameTec,
                      labelText: 'Name'.tr,
                      hintText: 'Enter name'.tr,
                      icon: Icons.person,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "name can't be empty".tr;
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: spaceFields),
                    customTextField(
                      textInputType: TextInputType.number,
                      controller: wrkCtr.ageTec,
                      labelText: 'Age'.tr,
                      hintText: 'Enter age'.tr,
                      icon: Icons.perm_contact_calendar,
                      // validator: (value) {
                      //   if (value!.isEmpty) {
                      //     return "age can't be empty".tr;
                      //   } else {
                      //     return null;
                      //   }
                      // },
                    ),

                    SizedBox(height: spaceFields),
                    customTextField(
                      textInputType: TextInputType.number,
                      controller: wrkCtr.phoneTec,
                      labelText: 'Phone'.tr,
                      hintText: 'Enter number'.tr,
                      icon: Icons.phone,
                      isPwd: false,
                      obscure: false,
                      onSuffClick: () {},
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "number can't be empty".tr;
                        } else {
                          return null;
                        }
                      },
                    ),

                    SizedBox(height: spaceFields),
                    customTextField(
                      controller: wrkCtr.addressTec,
                      labelText: 'Address'.tr,
                      hintText: 'Enter address'.tr,
                      icon: Icons.home,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "address can't be empty".tr;
                        } else {
                          return null;
                        }
                      },
                    ),

                    SizedBox(height: spaceFields),
                    customTextField(
                      controller: wrkCtr.emailTec,
                      labelText: 'Email'.tr,
                      hintText: 'Enter email'.tr,
                      icon: Icons.email,
                    ),
                    SizedBox(height: spaceFields),
                    customTextField(
                      textInputType: TextInputType.text,
                      controller: wrkCtr.roleTec,
                      labelText: 'Role'.tr,
                      hintText: 'Enter role'.tr,
                      icon: Icons.perm_identity_rounded,
                      isPwd: false,
                      obscure: false,
                      onSuffClick: () {},
                    ),
                    SizedBox(height: spaceFields),

                    customTextField(
                      controller: wrkCtr.specialityTec,
                      labelText: 'Speciality'.tr,
                      hintText: 'Enter speciality'.tr,
                      icon: Icons.task,
                    ),
                    SizedBox(height: spaceFields),
                    customTextField(
                      textInputType: TextInputType.number,
                      controller: wrkCtr.salaryTec,
                      labelText: 'Salary'.tr,
                      hintText: 'Enter salary'.tr,
                      icon: Icons.attach_money,
                      validator: (value) {
                        final numberRegExp = RegExp(r'^\d*\.?\d+$');
                        if (value!.isEmpty) {
                          return "salary can't be empty".tr;
                        }
                        if (!numberRegExp.hasMatch(value)) {
                          return 'Please enter a valid salary'.tr;
                        }

                          return null;

                      },
                    ),

                    SizedBox(height: spaceFields),

                    ///sex
                    Container(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(color: Colors.white38, width: 1),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                            child: DropdownButtonFormField<String>(
                              //borderRadius: BorderRadius.circular(40),
                              decoration: InputDecoration(
                                labelStyle: TextStyle(
                                    color: Colors.white38, fontSize: 14.5),
                                prefixIconConstraints: BoxConstraints(minWidth: 45),
                                prefixIcon: Icon(
                                  Icons.male,
                                  color: Colors.white70,
                                  size: 22,
                                ),
                              ),
                              //dropdownColor: customColor,
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white,
                              ),

                              style: TextStyle(color: Colors.white70),
                              value: wrkCtr.sex,
                              items: wrkCtr.selectedGender.map((gender) {
                                return DropdownMenuItem(
                                  value: gender,
                                  child: Text('$gender'),
                                );
                              }).toList(),
                              onChanged: (val) => setState(() => wrkCtr.sex = val!),
                            ),
                          ),
                        ),
                      ),
                    ),

                    ///Button add update
                    Container(
                      //color: Colors.red,
                      width: 90.w,
                      padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),

                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0.1,
                          side: const BorderSide(width: 1.5, color: Colors.white),
                          padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(50.0),
                            ),
                          ),
                        ),
                        onPressed: () {
                        if(isAdd)  wrkCtr.addWorker();
                        else wrkCtr.updateWorker();
                        },
                        child: Text(
                         isAdd? "Add Worker".tr:"Update Worker".tr,
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      ),
    ));
  }
}
