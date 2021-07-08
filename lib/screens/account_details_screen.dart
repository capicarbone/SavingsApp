import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:savings_app/blocs/account_summary/account_summary_bloc.dart';
import 'package:savings_app/blocs/account_summary/account_summary_event.dart';
import 'package:savings_app/blocs/account_summary/account_summary_state.dart';
import 'package:savings_app/blocs/account_transactions/account_transactions_bloc.dart';
import 'package:savings_app/blocs/account_transactions/account_transactions_events.dart';
import 'package:savings_app/blocs/account_transactions/account_transactions_state.dart';
import 'package:savings_app/models/account.dart';
import 'package:savings_app/models/category.dart';
import 'package:savings_app/models/transaction.dart';
import 'package:savings_app/widgets/transaction_tile.dart';

class AccountDetailsScreen extends StatefulWidget {
  static const routeName = '/account-details';

  @override
  _AccountDetailsScreenState createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  AccountTransactionsBloc _bloc;

  Account account;
  bool _loading = false;
  bool _hasNextPage = false;

  ScrollController _scrollController = ScrollController();

  String _getShortDescription(Transaction transaction, String accountId,
      Map<String, Account> accounts, Map<String, Category> categories) {
    if (transaction.dateAccomplished == null) return "Initial balance";

    if (transaction.isAccountTransfer) {
      var receiver = transaction.getReceiverAccount();
      var source = transaction.getAccountSource();

      if (receiver.accountId == accountId) {
        return "Transfer from " + accounts[source.accountId].name;
      } else {
        return "Transfer to " + accounts[receiver.accountId].name;
      }
    }

    if (transaction.categoryId != null) {
      return categories[transaction.categoryId].name;
    } else {
      if (transaction.isIncome) {
        return "Income";
      } else {
        return "Expense";
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onTransactionTap(BuildContext ctx, Transaction transaction) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  onTap: () {
                    var event =
                        DeleteTransactionEvent(account.id, transaction.id);
                    _bloc.add(event);

                    var accountTransaction =
                        transaction.transactionForAccount(account.id);

                    BlocProvider.of<AccountSummaryBloc>(ctx).add(
                        AccountSummaryBalanceUpdateEvent(
                            accountTransaction.change));

                    Navigator.pop(ctx);
                  },
                  leading: Icon(Icons.delete),
                  title: Text(
                    "Delete",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _buildTransactionsList(
      BuildContext ctx, Account account, AccountTransactionsUpdated state) {
    var transactions = state.transactions;

    _loading = false;
    _hasNextPage = state.hasNextPage;

    if (!_scrollController.hasListeners) {
      _scrollController.addListener(() {
        if (_scrollController.position.maxScrollExtent ==
                _scrollController.position.pixels &&
            _hasNextPage && _loading == false) {
          _loading = true;
          _bloc.add(LoadNextPageEvent());
        }
      });
    }

    return ListView.builder(
        controller: _scrollController,
        itemCount: transactions.length + ((_hasNextPage)? 1 : 0),
        itemBuilder: (_, index) {
          if (index < transactions.length) {
            var transaction = transactions[index];
            var accountTransaction =
                transaction.transactionForAccount(account.id);

            return TransactionTile(
              transaction: transaction,
              title: _getShortDescription(transaction, account.id,
                  state.accountsMap, state.categoriesMap),
              description: transaction.description,
              date: transaction.dateAccomplished,
              change: accountTransaction.change,
              onTap: (transaction) {
                _onTransactionTap(ctx, transaction);
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _buildLoadingView() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildAccountSummary(Account account) {
    return Container(
      width: double.infinity,
      color: Colors.blueGrey,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              "Balance",
              style: TextStyle(color: Colors.white),
            ),
            BlocBuilder<AccountSummaryBloc, AccountSummaryState>(
              builder: (_, state) {
                return Text(
                  "\$${state.balance}",
                  style: TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAccountTransactionsList(Account account) {
    return Container(
      child: BlocBuilder<AccountTransactionsBloc, AccountTransactionsState>(
        builder: (ctx, state) {
          if (state is AccountTransactionsUpdated) {
            if (state.transactions.length > 0) {
              return _buildTransactionsList(ctx, account, state);
            } else {
              return Center(
                child: Text("No transactions"),
              );
            }
          }
          return _buildLoadingView();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var args =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    account = args['account'];

    assert(account != null);

    if (_bloc == null) {
      _bloc = AccountTransactionsBloc(accountId: account.id);
    }

    _bloc.add(LoadNextPageEvent());

    return Scaffold(
      appBar: AppBar(
        title: Text(account.name),
      ),
      body: BlocProvider(
        create: (_) {
          return AccountSummaryBloc(account.balance);
        },
        child: BlocProvider(
          create: (_) {
            return _bloc;
          },
          child: Column(
            children: <Widget>[
              _buildAccountSummary(account),
              Flexible(child: _buildAccountTransactionsList(account))
            ],
          ),
        ),
      ),
    );
  }
}
