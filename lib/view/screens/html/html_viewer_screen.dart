// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:efood_multivendor_restaurant/controller/splash_controller.dart';
import 'package:efood_multivendor_restaurant/util/dimensions.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_app_bar.dart';

class HtmlViewerScreen extends StatelessWidget {
  final bool isPrivacyPolicy;
  final bool isFaq;
  const HtmlViewerScreen({
    Key? key,
    required this.isPrivacyPolicy,
    this.isFaq = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? data = isPrivacyPolicy
        ? Get.find<SplashController>().configModel!.privacyPolicy
        : isFaq
            ? faq
            : Get.find<SplashController>().configModel!.termsAndConditions;
    return Scaffold(
      appBar: CustomAppBar(
          isCenterTitle: true,
          title: isPrivacyPolicy
              ? 'privacy_policy'.tr
              : isFaq
                  ? 'FAQ'
                  : 'terms_condition'.tr),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).cardColor,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          physics: const BouncingScrollPhysics(),
          child: HtmlWidget(
            data ?? '',
            key: Key(isPrivacyPolicy ? 'privacy_policy' : 'terms_condition'),
            onTapUrl: (String url) {
              return launchUrlString(url, mode: LaunchMode.externalApplication);
            },
          ),
        ),
      ),
    );
  }
}

String faq = '''<p><strong>For OMG Customers:</strong></p>
      
      <p><strong>How is OMG Different from Swiggy or Zomato?</strong></p>
      
      <ul>
      	<li>We are an aggregator platform mainly focusing on small businesses and the issues they face in marketing and delivering their products. We offer a platform for small businesses to promote their brand, offering customers direct access to all their products in one place.</li>
      </ul>
      
      <p><strong>Should I provide my number?</strong></p>
      
      <ul>
      	<li>Yes, you can provide/a business number for the delivery driver to contact you for your order.</li>
      </ul>
      
      <p><strong>How much time does it typically take for the order to be delivered?</strong></p>
      
      <ul>
      	<li>It usually depends upon the order and the vendor. The vendor dispatch information is written on their respective store page.&nbsp;</li>
      </ul>
      
      <p><strong>I want to partner with OMG</strong></p>
      
      <ul>
      	<li>You can directly go to the Hamburger Menu on the bottom right and click on Become a Vendor under the Earnings tab</li>
      </ul>
      
      <p><strong>What are the documents needed to list my brand on the platform?</strong></p>
      
      <ul>
      	<li>For onboarding, you need:</li>
      </ul>
      
      <ol>
      	<li>Pan Card</li>
      	<li>Aadhar Card</li>
      	<li>Cancelled Cheque</li>
      	<li>FSSAI document</li>
      	<li>The agreement is sent to the vendor - Make sure you read it sign the agreement.</li>
      </ol>
      
      <p><strong>After I submit my documents, how long does it take to go live on the platform?</strong></p>
      
      <ul>
      	<li>It typically takes 24-48 hours to make your store live once the onboarding fees have been done. We encourage you to send your documents and pay as soon as possible to make the onboarding process seamless</li>
      </ul>
      
      <p><strong>What are the commission charges that I&rsquo;ll be charged by OMG?&nbsp;</strong></p>
      
      <ul>
      	<li>Commission charges vary from city to city. For more information, please email <a href="mailto:support@ordermygift.in">support@ordermygift.in</a>.&nbsp;</li>
      </ul>
      
      <p><strong>Who should I contact if I need help and support with onboarding?</strong></p>
      
      <ul>
      	<li>You can email us at: <a href="mailto:support@ordermygift.in">support@ordermygift.in</a> and one of our team members would gladly help you out.</li>
      </ul>
      
      <p><strong>How can I review/rate the order?</strong></p>
      
      <p><strong>Can I pay for orders after Delivery?&nbsp;</strong></p>
      
      <ul>
      	<li>For now, we only offer pre-paid orders as everything is customized according to the customers. We will be adding a cash-on-delivery option in the future.</li>
      </ul>
      
      <p><strong>Is customization allowed for items?&nbsp;</strong></p>
      
      <ul>
      	<li>Yes, you can add customizations according to you. We have different types of customizations offered by different vendors.</li>
      </ul>
      
      <p>&nbsp;</p>
      
      <p>For OMG Vendors:</p>
      
      <p><strong>Should I Upload my personal number?</strong></p>
      
      <ul>
      	<li>Yes, Please upload your business number so that the riders and our team can be in touch with you.</li>
      </ul>
      
      <p><strong>Can I select more than 1 category?&nbsp;</strong></p>
      
      <ul>
      	<li>You can select more than 1 category if you sell more than one.</li>
      </ul>
      
      <p><strong>Should I provide a Location address or a Business Registered Address?</strong></p>
      
      <ul>
      	<li>You should provide an address from where the orders could be picked up by the delivery partner</li>
      </ul>
      
      <p><strong>What is the registration process to be on the platform?</strong></p>
      
      <ul>
      	<li>To become a vendor on a gifting aggregator application, you will need to create a profile and submit your products for review. Once your products have been approved, you will be able to start selling your gifts through the platform.</li>
      </ul>
      
      <p><strong>How do I manage my orders on the platform?</strong></p>
      
      <ul>
      	<li>To manage your orders, you will need to log into your account and view your order history. You can track the status of your orders and contact the customer if there are any problems.</li>
      </ul>
      
      <p><strong>How do I get paid for my sales?</strong></p>
      
      <ul>
      	<li>You will be paid for your sales through the platform&rsquo;s withdrawal payment system. You can choose to be paid through a variety of payment options including UPI.</li>
      </ul>
      
      <p><strong>What are the benefits of being a vendor on a gifting aggregator platform?</strong></p>
      
      <p>There are many benefits to being a vendor on the platform mainly,</p>
      
      <ol>
      	<li>Increased Exposure: Your products will be seen by a wider audience of potential customers.</li>
      	<li>Increased Sales: Gifting applications can help you increase your sales by providing a convenient way for businesses to purchase gifts</li>
      	<li>Increased Brand Awareness: Your brand will be seen by businesses/customers who are looking to send gifts</li>
      	<li>Deliveries: You do not have to worry about the deliveries as our verified delivery partners will take care of picking up the product from you and getting it delivered directly</li>
      	<li>Be an Entrepreneur: Showcase your products in the way you want and sell from the platform itself.</li>
      </ol> ''';
