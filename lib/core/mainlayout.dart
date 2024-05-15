import 'package:abiball_planer/core/managment/managerProvider.dart';
import 'package:abiball_planer/core/managment/stateManagment.dart';
import 'package:abiball_planer/core/route/cards/cards_overview.dart';
import 'package:abiball_planer/core/route/email/email_view.dart';
import 'package:abiball_planer/core/service/web_socket_service.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State createState() => MainLayoutState();
}

class MainLayoutState extends State<MainLayout> {
  PageController controller = PageController(initialPage: 2);
  int selectedPage = 2;
  bool isMaximized = false;
  StateManager stateManager = StateManager();
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      isMaximized = !await WindowManager.instance.isMaximized();
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    RealtimeDataService().close();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      surfaceTintColor: Colors.white,
      color: Colors.white,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.only(right: 5.0),
            constraints: const BoxConstraints(maxWidth: 275.0),
            child: Drawer(
              width: MediaQuery.sizeOf(context).width * 0.17,
              surfaceTintColor: Colors.white,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey.shade300),
                borderRadius:
                    const BorderRadius.horizontal(right: Radius.circular(36.0)),
              ),
              shadowColor: Colors.grey,
              elevation: 3,
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: MediaQuery.sizeOf(context).height * 0.15,
                    margin: EdgeInsets.zero,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(maxHeight: 125.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.01,
                        ),
                        Image.asset(
                          'assets/logo.jpeg',
                          width: 60,
                        ),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.03,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Abiball',
                              textScaler: TextScaler.linear(2.1),
                              style: TextStyle(
                                fontFamily: 'Fantastic Paris',
                                height: 0.8,
                              ),
                            ),
                            Text(
                              'Planer',
                              textScaler: const TextScaler.linear(0.9),
                              style: TextStyle(
                                //fontFamily: 'Fantastic Paris',
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.bold,
                                height: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.sizeOf(context).width * 0.01 + 4),
                    child: ListTile(
                      title: Text(
                        'Patient Tools',
                        textScaler: const TextScaler.linear(0.8),
                        style: TextStyle(
                          //fontFamily: 'Fantastic Paris',
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.bold,
                          height: 1.0,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.sizeOf(context).width * 0.01),
                      children: [
                        Card(
                          color: selectedPage == 0
                              ? const Color(0xFF237FEA)
                              : Colors.white,
                          shadowColor: Colors.blue,
                          elevation: selectedPage == 0 ? 4 : 0,
                          clipBehavior: Clip.antiAlias,
                          child: ListTile(
                            leading: Icon(
                              Icons.dashboard,
                              color: selectedPage == 0
                                  ? Colors.white
                                  : Colors.grey.shade600,
                            ),
                            textColor: Colors.grey.shade600,
                            titleTextStyle:
                                const TextStyle(fontWeight: FontWeight.bold),
                            title: const Text('Overview'),
                            selectedColor: Colors.white,
                            selected: selectedPage == 0,
                            onTap: () => controller.jumpToPage(0),
                          ),
                        ),
                        Card(
                          color: selectedPage == 1
                              ? const Color(0xFF237FEA)
                              : Colors.white,
                          shadowColor: Colors.blue,
                          elevation: selectedPage == 1 ? 4 : 0,
                          clipBehavior: Clip.antiAlias,
                          child: ListTile(
                            leading: Icon(
                              Icons.description,
                              color: selectedPage == 1
                                  ? Colors.white
                                  : Colors.grey.shade600,
                            ),
                            textColor: Colors.grey.shade600,
                            titleTextStyle:
                                const TextStyle(fontWeight: FontWeight.bold),
                            title: const Text('Organisation'),
                            selectedColor: Colors.white,
                            selected: selectedPage == 1,
                            onTap: () => controller.jumpToPage(1),
                          ),
                        ),
                        Card(
                          color: selectedPage == 2
                              ? const Color(0xFF237FEA)
                              : Colors.white,
                          shadowColor: Colors.blue,
                          elevation: selectedPage == 2 ? 4 : 0,
                          clipBehavior: Clip.antiAlias,
                          child: ListTile(
                            leading: Icon(
                              Icons.local_activity,
                              color: selectedPage == 2
                                  ? Colors.white
                                  : Colors.grey.shade600,
                            ),
                            textColor: Colors.grey.shade600,
                            titleTextStyle:
                                const TextStyle(fontWeight: FontWeight.bold),
                            title: const Text('Cards'),
                            selectedColor: Colors.white,
                            selected: selectedPage == 2,
                            onTap: () => controller.jumpToPage(2),
                          ),
                        ),
                        Card(
                          color: selectedPage == 3
                              ? const Color(0xFF237FEA)
                              : Colors.white,
                          shadowColor: Colors.blue,
                          elevation: selectedPage == 3 ? 4 : 0,
                          clipBehavior: Clip.antiAlias,
                          child: ListTile(
                            leading: Icon(
                              Icons.settings,
                              color: selectedPage == 3
                                  ? Colors.white
                                  : Colors.grey.shade600,
                            ),
                            textColor: Colors.grey.shade600,
                            titleTextStyle:
                                const TextStyle(fontWeight: FontWeight.bold),
                            title: const Text('Settings'),
                            selectedColor: Colors.white,
                            selected: selectedPage == 3,
                            onTap: () => controller.jumpToPage(3),
                          ),
                        ),
                        const Divider(
                          indent: 5,
                          endIndent: 5,
                        ),
                        Card(
                          color: selectedPage == 4
                              ? const Color(0xFF237FEA)
                              : Colors.white,
                          shadowColor: Colors.blue,
                          elevation: selectedPage == 4 ? 4 : 0,
                          clipBehavior: Clip.antiAlias,
                          child: ListTile(
                            leading: Icon(
                              Icons.email,
                              color: selectedPage == 4
                                  ? Colors.white
                                  : Colors.grey.shade600,
                            ),
                            textColor: Colors.grey.shade600,
                            titleTextStyle:
                                const TextStyle(fontWeight: FontWeight.bold),
                            title: const Text('Inbox'),
                            selectedColor: Colors.white,
                            selected: selectedPage == 4,
                            onTap: () => controller.jumpToPage(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0, right: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const CircleAvatar(
                          backgroundImage: AssetImage('assets/person.jpeg'),
                          radius: 22,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Pascal Reinmuth',
                              textScaler: TextScaler.linear(1.1),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, height: 0.99),
                            ),
                            Text(
                              'Free account',
                              textScaler: const TextScaler.linear(0.8),
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: DragToMoveArea(
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () => WindowManager.instance.minimize(),
                      icon: const Icon(Icons.minimize_rounded),
                      iconSize: 16,
                      hoverColor: Colors.grey.shade300,
                      constraints: const BoxConstraints(minWidth: 48),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8.0), // Round corners
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async => (isMaximized =
                              await WindowManager.instance.isMaximized())
                          ? WindowManager.instance.unmaximize()
                          : WindowManager.instance.maximize(),
                      icon: !isMaximized
                          ? const Icon(Icons.photo_size_select_small_rounded)
                          : const Icon(Icons.check_box_outline_blank_rounded),
                      iconSize: 16,
                      hoverColor: Colors.grey.shade300,
                      constraints: const BoxConstraints(minWidth: 48),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8.0), // Round corners
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => WindowManager.instance.close(),
                      icon: const Icon(Icons.close),
                      iconSize: 16,
                      hoverColor: Colors.red,
                      constraints: const BoxConstraints(minWidth: 48),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8.0), // Round corners
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: PageView(
                    controller: controller,
                    onPageChanged: (index) =>
                        setState(() => selectedPage = index),
                    children: [
                      Container(),
                      Container(),
                      ManagerProvider(
                        notifier: stateManager,
                        child: CardsOverview(focusNode),
                      ),
                      Container(),
                      const EmailView(),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
