import 'package:flutter/material.dart';
import 'package:referaly/widgets/salesforce_partnership_card.dart';

class ExampleUsageSalesforceCard extends StatelessWidget {
  const ExampleUsageSalesforceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Partnership Deals'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SalesforcePartnershipCard(
            contractName: 'CRM Partnership Deal',
            referrersCount: '12',
            leadsCount: '23',
            commissionRate: '15',
            commissionType: 'percentage_commission',
            isRecurring: true,
            companyLogoUrl: null,
            onViewContract: () {},
            onEdit: () {},
            onAttachFiles: () {},
            onInvitePartner: () {},
            onShareForm: () {},
            onInviteManually: () {},
            onHowItWorks: () {},
          ),
          SalesforcePartnershipCard(
            contractName: 'Marketing Platform Deal',
            referrersCount: '8',
            leadsCount: '12',
            commissionRate: '500',
            commissionType: 'fix_commission',
            isRecurring: false,
            companyLogoUrl: null,
            onViewContract: () {},
            onEdit: () {},
            onAttachFiles: () {},
            onInvitePartner: () {},
            onShareForm: () {},
            onInviteManually: () {},
            onHowItWorks: () {},
          ),
          SalesforcePartnershipCard(
            contractName: 'Business Suite Partnership',
            referrersCount: '3',
            leadsCount: '8',
            commissionRate: '0',
            commissionType: 'no_commission',
            isRecurring: false,
            companyLogoUrl: null,
            onViewContract: () {},
            onEdit: () {},
            onAttachFiles: () {},
            onInvitePartner: () {},
            onShareForm: () {},
            onInviteManually: () {},
            onHowItWorks: () {},
          ),
        ],
      ),
    );
  }
}

/// Example of how to integrate into MyActivityScreen.
class IntegrationExample {
  Widget buildDealsListViewWithNewCard() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 3,
      itemBuilder: (context, index) {
        final commissionTypes = [
          'percentage_commission',
          'fix_commission',
          'no_commission',
        ];
        final currentCommissionType = commissionTypes[index % 3];

        return SalesforcePartnershipCard(
          layout: SalesforcePartnershipLayout.listCollapsed,
          contractName: 'Partnership Deal ${index + 1}',
          referrersCount: '${index + 2}',
          leadsCount: '${(index + 1) * 5}',
          commissionRate: currentCommissionType == 'fix_commission'
              ? '${(15 + index * 2) * 100}'
              : '${15 + index * 2}',
          commissionType: currentCommissionType,
          isRecurring: index % 2 == 0,
          companyLogoUrl: null,
          onToggleExpand: () {},
          onViewContract: () {},
          onEdit: () {},
          onAttachFiles: () {},
          onInvitePartner: () {},
          onShareForm: () {},
          onInviteManually: () {},
          onHowItWorks: () {},
        );
      },
    );
  }
}

// -----------------------------------------------------------------------------
// Reference-only: previous `example_usage_salesforce_card.dart` (Git HEAD).
// -----------------------------------------------------------------------------
/*
import 'package:flutter/material.dart';
import 'package:referaly/widgets/salesforce_partnership_card.dart';

class ExampleUsageSalesforceCard extends StatelessWidget {
  const ExampleUsageSalesforceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Partnership Deals'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Example 1 - Salesforce Partnership (Percentage Commission)
          SalesforcePartnershipCard(
            companyName: 'Salesforce',
            dealType: 'CRM Partnership Deal',
            leadsReceived: '23 leads received',
            commissionRate: '15',
            commissionType: 'percentage_commission',
            isRecurring: true,
            companyLogoUrl: null, // Will show default logo
            onViewContract: () {
              // Handle view contract action
              print('View Contract tapped');
            },
            onEdit: () {
              // Handle edit action
              print('Edit tapped');
            },
            onAttachFiles: () {
              // Handle attach files action
              print('Attach Files tapped');
            },
            onInvitePartner: () {
              // Handle invite partner action
              print('Invite Partner tapped');
            },
            onShareForm: () {
              // Handle share form action
              print('Share Form tapped');
            },
            onHowItWorks: () {
              // Handle how it works action
              print('How it works tapped');
            },
            onMoreOptions: () {
              // Handle more options action
              print('More options tapped');
            },
          ),

          // Example 2 - HubSpot Partnership (Fixed Commission)
          SalesforcePartnershipCard(
            companyName: 'HubSpot',
            dealType: 'Marketing Platform Deal',
            leadsReceived: '12 leads received',
            commissionRate: '500',
            commissionType: 'fix_commission',
            isRecurring: false,
            companyLogoUrl: null,
            onViewContract: () {
              print('View HubSpot Contract tapped');
            },
            onEdit: () {
              print('Edit HubSpot tapped');
            },
            onAttachFiles: () {
              print('Attach HubSpot Files tapped');
            },
            onInvitePartner: () {
              print('Invite HubSpot Partner tapped');
            },
            onShareForm: () {
              print('Share HubSpot Form tapped');
            },
            onHowItWorks: () {
              print('HubSpot How it works tapped');
            },
            onMoreOptions: () {
              print('HubSpot More options tapped');
            },
          ),

          // Example 3 - Zoho Partnership (No Commission)
          SalesforcePartnershipCard(
            companyName: 'Zoho',
            dealType: 'Business Suite Partnership',
            leadsReceived: '8 leads received',
            commissionRate: '0',
            commissionType: 'no_commission',
            isRecurring: false,
            companyLogoUrl: null,
            onViewContract: () {
              print('View Zoho Contract tapped');
            },
            onEdit: () {
              print('Edit Zoho tapped');
            },
            onAttachFiles: () {
              print('Attach Zoho Files tapped');
            },
            onInvitePartner: () {
              print('Invite Zoho Partner tapped');
            },
            onShareForm: () {
              print('Share Zoho Form tapped');
            },
            onHowItWorks: () {
              print('Zoho How it works tapped');
            },
            onMoreOptions: () {
              print('Zoho More options tapped');
            },
          ),
        ],
      ),
    );
  }
}

// Example of how to integrate into your existing MyActivityScreen
class IntegrationExample {
  // Replace your existing buildDealsListView method with this approach
  Widget buildDealsListViewWithNewCard() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 3, // Replace with your actual data length
      itemBuilder: (context, index) {
        // Replace with your actual data mapping
        final commissionTypes = [
          'percentage_commission',
          'fix_commission',
          'no_commission'
        ];
        final currentCommissionType = commissionTypes[index % 3];

        return SalesforcePartnershipCard(
          companyName: 'Company ${index + 1}',
          dealType: 'Partnership Deal ${index + 1}',
          leadsReceived: '${(index + 1) * 5} leads received',
          commissionRate: currentCommissionType == 'fix_commission'
              ? '${(15 + index * 2) * 100}'
              : '${15 + index * 2}',
          commissionType: currentCommissionType,
          isRecurring: index % 2 == 0,
          companyLogoUrl: null,
          onViewContract: () {
            // Add your existing contract viewing logic here
          },
          onEdit: () {
            // Add your existing edit logic here
          },
          onAttachFiles: () {
            // Add your file attachment logic here
          },
          onInvitePartner: () {
            // Add your partner invitation logic here
          },
          onShareForm: () {
            // Add your form sharing logic here
          },
          onHowItWorks: () {
            // Add help/info dialog
          },
          onMoreOptions: () {
            // Add more options menu
          },
        );
      },
    );
  }
}
*/
