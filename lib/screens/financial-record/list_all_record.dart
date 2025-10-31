import 'package:finmene/models/entities/recommendation.dart';
import 'package:finmene/models/entities/report.dart';
import 'package:finmene/providers/bookkeeping/bookkeeping_provider.dart';
import 'package:finmene/providers/ml/monthly_budget_provider.dart';
import 'package:finmene/utils/enums/snackbar_enum.dart';
import 'package:finmene/utils/enums/status_state_enum.dart';
import 'package:finmene/utils/extensions/context_extensions.dart';
import 'package:finmene/utils/extensions/num_extensions.dart';
import 'package:finmene/utils/utilities.dart';
import 'package:finmene/utils/views/provider_listener.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class ListAllRecordScreen extends StatefulWidget {
  const ListAllRecordScreen({super.key});

  @override
  State<ListAllRecordScreen> createState() => _ListAllRecordScreenState();
}

class _ListAllRecordScreenState extends State<ListAllRecordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Semua Catatan Keuangan')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<MonthlyBudgetProvider>().getMonthlyBudgetPayload();
        },
        child: const Icon(Icons.start_rounded),
      ),
      body: ProviderListenerWidget<MonthlyBudgetProvider>(
        listener: (context, state) {
          var stateApp = state.state.state;
          if (stateApp.isLoading) {
            Utilities.showLoadingDialog(context);
          } else if (stateApp.isError) {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
            Utilities.showSnackbar(
              context,
              SnackbarEnum.error,
              state.state.message,
            );
          } else if (stateApp.isSuccess) {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
            showDialogSummary(state.state.data!);
          }
        },
        child: Consumer<BookkeepingProvider>(
          builder: (_, state, _) {
            var stateReport = state.reportsState.state;
            if (stateReport.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (stateReport.isLoaded || stateReport.isSuccess) {
              if (state.reports.isEmpty) {
                return const Center(child: Text('Belum ada catatan keuangan.'));
              } else {
                return ListView.builder(
                  itemCount: state.reports.length,
                  padding: EdgeInsets.only(top: 16),
                  itemBuilder: (_, index) {
                    Report val = state.reports[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(child: Icon(val.category.icon)),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(val.category.labelName),
                            Text(
                              '${val.trxDate.day}-${val.trxDate.month}-${val.trxDate.year}',
                              style: context.textTheme.bodySmall,
                            ),
                          ],
                        ),
                        subtitle: Text("Rp. ${val.ammount.rupiah}"),
                      ),
                    );
                  },
                );
              }
            }
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }

  void showDialogSummary(BudgetRecommendation recommendation) {
    showDialog(
      context: context,
      fullscreenDialog: false,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Rekomendasi Bulanan",
                    textAlign: TextAlign.center,
                    style: context.textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (recommendation.nextMonthBudgetMonthly > 1) ...[
                  Gap(20),
                  Text(
                    "Rekomendasi pengehematan bulan depan : ${recommendation.nextMonthBudgetMonthlyFormatted}",
                  ),
                ],
                Gap(20),
                ...recommendation.recommendations.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${index + 1}. $item',
                        style: context.textTheme.bodyMedium,
                      ),
                      Gap(8),
                    ],
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}
