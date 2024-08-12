import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zeusfile/constants.dart';
import 'package:zeusfile/utils/represent_utils.dart';
import 'package:zeusfile/presentation/authorization/bloc/auth_bloc.dart';
import 'package:zeusfile/presentation/main/cubit/main_screen_page_index_cubit.dart';
import 'package:zeusfile/presentation/widgets/button_app.dart';
import 'package:zeusfile/purchase/cubit/purchase_cubit.dart';

class PremiumBlock extends StatelessWidget {
  final ServiceType serviceType;
  const PremiumBlock({Key? key, required this.serviceType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authBlocState) {
        final premiumExpiresDateTime = authBlocState
            .getServiceAuth(serviceType: serviceType)
            .account
            ?.premiumExpiresDateTime;

        return BlocBuilder<PurchaseCubit, PurchaseCubitState>(
          builder: (context, purchaseCubitState) {
            final hasAnySubscription =
                (purchaseCubitState.hasSubscription[serviceType] ?? false) ||
                    premiumExpiresDateTime != null;

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: const BoxDecoration(
                  color: extractorColor,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Column(children: [
                Text(
                  'Premium expires: ${premiumExpiresDateTime?.dateOnlyLocalRepresent}',
                  style: h2RWhiteStyle,
                  overflow: TextOverflow.visible,
                ),
                Visibility(
                  visible: !hasAnySubscription,
                  child: Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: ButtonApp(
                      text: 'Buy premium',
                      color: mainBackColor,
                      borderColor: accentColor,
                      textStyle: h2SbWhiteStyle,
                      onTap: () {
                        context
                            .read<MainScreenPageIndexCubit>()
                            .setPageIndex(pageIndex: 4);
                      },
                    ),
                  ),
                ),
              ]),
            );
          },
        );
      },
    );
  }
}
