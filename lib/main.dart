import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/screens/home/Login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: Theme.of(context).textTheme.apply(bodyColor: kTextColor),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyApp1(),
    );
  }
}

import 'package:carinfo_cms/base/base_page.dart';
import 'package:carinfo_cms/common/app_svg.dart';
import 'package:carinfo_cms/global/app_router.dart';
import 'package:carinfo_cms/page/manager/spending_manager/cons_spending.dart';
import 'package:carinfo_cms/utils/utils.dart';
import 'package:carinfo_cms/widgets/widget_button.dart';
import 'package:carinfo_cms/widgets/widget_input_text_form_field.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'spending_controller.dart';
import 'item_spending.dart';

class SpendingPage extends BaseScreen<SpendingController> {
  SpendingPage({super.key});

  @override
  Widget builder() {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Phiếu chi',
        style: textStyle.bold(size: 20, color: Colors.black),
      )),
      body: RefreshIndicator(
        onRefresh: () async {
          controller.getListSpending(page: 1);
        },
        child: Column(children: [
          const SizedBox(width: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Tìm kiếm phiếu chi',
                prefixIcon: Icon(
                  Icons.search,
                  size: 20,
                ),
              ),
              onChanged: (value) {
                print('ok$value');
                controller.debounce(() {
                  controller.keySearch = value;
                  controller.getListSpending(page: 1);
                });
              },
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
              child: Obx(() => (controller.listOrder.toList().isNotEmpty)
                  ? NotificationListener(
                      onNotification: (ScrollNotification notification) {
                        return false;
                      },
                      child: ListView.builder(
                        controller: controller.scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: controller.listOrder.toList().length + 1,
                        itemBuilder: (context, index) {
                          if (index == controller.listOrder.toList().length) {
                            return const SizedBox(height: 60);
                          } else {
                            return ItemCollect(
                              item: controller.listOrder[index],
                              openDetail: (itemValue) async {
                                controller.getDetailSpending(
                                    id: itemValue.sId,
                                    onSuccess: (value) async {
                                      Utils.showBottomSheet(
                                          context,
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                    Text(value.code ?? ''),
                                                const SizedBox(height: 8),
                                                WidgetButton(
                                                    radius: 5,
                                                    backgroundColor:
                                                        _getColorStatus(
                                                            value.status),
                                                    title: getTextStatus(
                                                        value.status),
                                                    onTab: () {}),
                                                const SizedBox(height: 20),
                                                Row(children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text('Người tạo'),
                                                      Text(value.createdBy
                                                              ?.username ??
                                                          ''),
                                                    ],
                                                  ),
                                                  const SizedBox(width: 100),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text('Loại phiếu'),
                                                      Text(loaiphieu.getStyle(
                                                          value.type)),
                                                    ],
                                                  ),
                                                ]),
                                                const SizedBox(height: 16),
                                                Text('Số tiền'),
                                                Text((Utils.formatNumber(
                                                        value.total ?? 0) +
                                                    'đ')),
                                                const SizedBox(height: 16),
                                                Text('Ghi chú'),
                                                Text(value.note ?? ''),
                                                const SizedBox(height: 36),
                                              ],
                                            ),
                                          ));
                                    });
                              },
                              updateItem: (itemValue) async {
                                Utils.showBottomSheet(
                                    context,
                                    Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            children: [
                                              const Spacer(),
                                              IconButton(
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                  icon:
                                                      const Icon(Icons.close)),
                                            ],
                                          ),
                                          const SizedBox(height: 9),
                                          InkWell(
                                            onTap: () {
                                              controller.getDetailSpending(
                                                  id: itemValue.sId,
                                                  onSuccess: (value) async {
                                                    Get.back();
                                                    var data = await Get.toNamed(
                                                        AppRouter
                                                            .routerAddSpendingPage,
                                                        arguments: value);
                                                    if (data == true) {
                                                      controller
                                                          .getListSpending(
                                                              page: 1);
                                                    }
                                                  });
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 16),
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset(
                                                      AppSvgs.icEdit2),
                                                  const SizedBox(width: 16),
                                                  Text('Chỉnh sửa phiếu'),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const Divider(height: 1),
                                          GestureDetector(
                                            onTap: () {
                                              controller.cancelSpending(
                                                  id: itemValue.sId);
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 16),
                                              child: Row(
                                                children: const [
                                                  Icon(
                                                    Icons.close,
                                                    color: Colors.red,
                                                  ),
                                                  SizedBox(width: 16),
                                                  Text('Hủy phiếu',style: TextStyle(
                                                      color: Colors.red)),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ));
                              },
                            );
                          }
                        },
                      ),
                    )
                  : (controller.page.value == 0)
                      ? const SizedBox()
                      : SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Center(
                                child: Text(
                              (controller.keySearch?.isEmpty == true)
                                  ? 'Bạn chưa có phiếu chi '
                                  : 'Không tìm thấy thông tin',
                              style: textStyle.semiBold(size: 30),
                              textAlign: TextAlign.center,
                            )),
                          ))))
        ]),
      ),
      floatingActionButton: FloatingActionButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          onPressed: () async {
            var data = await Get.toNamed(AppRouter.routerAddSpendingPage);
            if (data == true) {
              controller.getListSpending(page: 1);
            }
          },
          child: const Icon(Icons.add)),
    );
  }

  @override
  SpendingController? putController() => SpendingController();

  Color _getColorStatus(num? status) {
    var textStatus = Utils.getColor('0065FF');
    if (status == 1) {
      textStatus = Utils.getColor('FB8C00');
    } else if (status == 0) {
      textStatus = Utils.getColor('FF5252');
    } else if (status == 2) {
      textStatus = Utils.getColor('36B37E');
    }
    return textStatus;
  }

  String getTextStatus(num? status) {
    var textStatus = '';
    if (status == 1) {
      textStatus = 'Nháp';
    } else if (status == 0) {
      textStatus = 'Hủy';
    } else if (status == 2) {
      textStatus = 'Đã hoàn thành';
    }
    return textStatus;
  }
}
