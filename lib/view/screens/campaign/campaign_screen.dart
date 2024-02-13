import 'package:efood_multivendor_restaurant/controller/campaign_controller.dart';
import 'package:efood_multivendor_restaurant/util/dimensions.dart';
import 'package:efood_multivendor_restaurant/util/styles.dart';
import 'package:efood_multivendor_restaurant/view/screens/campaign/widget/campaign_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CampaignScreen extends StatelessWidget {
  const CampaignScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.find<CampaignController>().getCampaignList();

    return Scaffold(
      appBar: AppBar(
        title: Text('campaign'.tr),
      ),
      body: GetBuilder<CampaignController>(builder: (campaignController) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: ChoiceChip(
                    showCheckmark: false,
                    label: Text(
                      'all'.tr,
                      style: senRegular.copyWith(
                        color: campaignController.selectedFilter == 'all'
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    selected: campaignController.selectedFilter == 'all',
                    onSelected: (bool selected) {
                      if (selected) {
                        Get.find<CampaignController>().filterCampaign('all');
                      }
                    },
                    shape: const StadiumBorder(side: BorderSide(color: Colors.transparent)),
                    backgroundColor:
                        campaignController.selectedFilter == 'all' ? Colors.green : null,
                  ),
                ),
                // const SizedBox(width: 10),
                ChoiceChip(
                  showCheckmark: false,
                  label: Text(
                    'joined'.tr,
                    style: senRegular.copyWith(
                      color: campaignController.selectedFilter == 'joined'
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  selected: campaignController.selectedFilter == 'joined',
                  onSelected: (bool selected) {
                    if (selected) {
                      Get.find<CampaignController>().filterCampaign('joined');
                    }
                  },
                  shape: const StadiumBorder(side: BorderSide(color: Colors.transparent)),
                  backgroundColor:
                      campaignController.selectedFilter == 'joined' ? Colors.green : null,
                ),
              ],
            ),
            Expanded(
              child: campaignController.campaignList != null
                  ? campaignController.campaignList!.isNotEmpty
                      ? RefreshIndicator(
                          onRefresh: () async {
                            await Get.find<CampaignController>().getCampaignList();
                          },
                          child: ListView.builder(
                            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                            itemCount: campaignController.campaignList!.length,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return CampaignWidget(
                                campaignModel: campaignController.campaignList![index],
                              );
                            },
                          ),
                        )
                      : Center(child: Text('no_campaign_available'.tr))
                  : const Center(child: CircularProgressIndicator()),
            ),
          ],
        );
      }),
    );
  }
}
