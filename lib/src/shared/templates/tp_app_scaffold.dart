import 'package:bandasybandas/src/shared/organisms/org_app_drawer.dart';
import 'package:departamento_tecnico/src/controllers/user_controller.dart';
import 'package:departamento_tecnico/src/widgets/navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

///
class AppScaffold extends StatelessWidget {
  AppScaffold({
    Key? key,
    required this.body,
    required this.pageTitle,
    this.botonAyuda,
    this.externalScaffoldKey,
  }) : super(key: key);

  final Widget body;
  final String pageTitle;
  final Widget? botonAyuda;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState>? externalScaffoldKey =
      new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();
    final bool displayMobileLayout =
        MediaQuery.of(context).size.width < MediaQuery.of(context).size.height;
    if (displayMobileLayout) {
      return Scaffold(
        //resizeToAvoidBottomInset: false,

        key: externalScaffoldKey == null ? _scaffoldKey : externalScaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: displayMobileLayout,
          leading: BackButton(
            color: Colors.white,
          ),
          title: Text(pageTitle),
          actions: <Widget>[
            botonAyuda ?? Text(''),
            if (displayMobileLayout)
              IconButton(
                  onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
                  icon: Icon(Icons.menu))
          ],
        ),
        endDrawer: displayMobileLayout ? OrgAppDrawer() : null,
        body: body,
      );
    } else {
      return Row(
        children: [
          if (!displayMobileLayout)
            Obx(() {
              if (userController.user.value != null) {
                return OrgAppDrawer();
              } else
                return Column();
            }),
          Expanded(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              key: externalScaffoldKey == null
                  ? _scaffoldKey
                  : externalScaffoldKey,
              appBar: AppBar(
                automaticallyImplyLeading: displayMobileLayout,
                leading: BackButton(
                  color: Colors.white,
                ),
                title: Text(pageTitle),
                actions: <Widget>[
                  botonAyuda ?? Text(''),
                  if (displayMobileLayout)
                    IconButton(
                        onPressed: () =>
                            _scaffoldKey.currentState?.openEndDrawer(),
                        icon: Icon(Icons.menu))
                ],
              ),
              endDrawer: displayMobileLayout ? OrgAppDrawer() : null,
              body: body,
            ),
          )
        ],
      );
    }
  }
}
