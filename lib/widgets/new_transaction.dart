
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_app/blocs/settings_syncer/settings_syncer_bloc.dart';
import 'package:savings_app/blocs/settings_syncer/settings_syncer_events.dart';
import 'package:savings_app/blocs/settings_syncer/settings_syncer_states.dart';
import 'package:savings_app/models/account.dart';
import 'package:savings_app/models/category.dart';
import 'package:savings_app/models/fund.dart';
import 'package:savings_app/repositories/transactions_repository.dart';
import 'package:savings_app/widgets/account_transfer_form.dart';
import 'package:savings_app/widgets/in_out_form.dart';
import 'package:savings_app/widgets/nested_tabs/nested_tab_bar.dart';
import 'package:savings_app/widgets/nested_tabs/tab.dart';
import 'package:savings_app/widgets/section_title.dart';

import 'content_surface.dart';

class NewTransactionScreen extends StatefulWidget {

  static const routeName = '/new-transaction';

  const NewTransactionScreen();

  @override
  _NewTransactionScreenState createState() => _NewTransactionScreenState();
}

class _NewTransactionScreenState extends State<NewTransactionScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) {
          return SettingsSyncerBloc();
        },
        child: BlocBuilder<SettingsSyncerBloc, SettingsSyncState>(
          builder: (context, state) {
            if (state is InitialSync){
              BlocProvider.of<SettingsSyncerBloc>(context).add(ReloadLocalData(
                accounts: true,
                funds: true,
                categories: true
              ));
              return Center(child: CircularProgressIndicator(),);
            }
            return SafeArea(
              child: Container(
                height: double.infinity,
                child: ContentSurface(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SectionTitle(title: "New Transaction",),
                          Card(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                NestedTabBar(
                                  onTap: (position) {
                                    setState(() {
                                      _selectedTab = position;
                                    });
                                  },
                                  tabs: [
                                    NestedTab(
                                      text: "Expense",
                                    ),
                                    NestedTab(
                                      text: "Income",
                                    ),
                                    NestedTab(text: "Transfer"),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: IndexedStack(
                                    index: _selectedTab,
                                    children: [
                                      const InOutForm(expenseMode: true,),
                                      const InOutForm(),
                                      const AccountTransferForm(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}
