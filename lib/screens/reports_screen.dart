import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_app/blocs/reports/reports_bloc.dart';
import 'package:savings_app/blocs/reports/reports_events.dart';
import 'package:savings_app/blocs/reports/reports_states.dart';

class ReportsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ReportsBloc(),
      child: BlocConsumer<ReportsBloc, ReportsState>(
        listener: (context, state) {
        },
        builder: (context, state){

          if (state is InitialState){
            BlocProvider.of<ReportsBloc>(context).add(LoadNextPage());
            return Center(
              child: Text("starting"),
            );
          }

          if (state is PageLoaded){
            return Container(
              child: Center(
                child: Text("load"),
              ),
            );
          }

        },
      ),
    );
  }
}
