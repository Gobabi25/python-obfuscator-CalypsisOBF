import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import 'package:go_babi_drive/map_google/GoogleMapVehiclePage.dart';

import 'package:go_babi_drive/no_connexion/no_connexion_widget.dart';
import 'package:go_babi_drive/pages_drawer/reservations/infos_reservation/infos_reservation_widget.dart';
import 'package:go_babi_drive/pages_drawer/reservations/liste_reservations/liste_reservations_widget.dart';
import 'package:go_babi_drive/pages_drawer/reservations/map_reserv/map_reserv_widget.dart';
import 'package:go_babi_drive/pages_drawer/reservations/research_reserv/research_reserv_widget.dart';
import 'package:go_babi_drive/trajet/infos_course/infos_course_widget.dart';
import 'package:go_babi_drive/trajet/navigation/navigation_widget.dart';
import 'package:go_babi_drive/trajet/navigation_google/navigationg_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '/backend/backend.dart';

import '/index.dart';
import '/main.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/lat_lng.dart';
import '/flutter_flow/place.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'serialization_util.dart';

export 'package:go_router/go_router.dart';
export 'serialization_util.dart';

const kTransitionInfoKey = '__transition_info__';

class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();

  static AppStateNotifier? _instance;
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  bool showSplashImage = true;

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }
}

GoRouter createRouter(AppStateNotifier appStateNotifier) => GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: appStateNotifier,
      // observers: [routeObserver],
      errorBuilder: (context, state) => appStateNotifier.showSplashImage
          ? Builder(
              builder: (context) => Container(
                color: Colors.transparent,
                child: Image.asset(
                  'assets/images/ic_driver_white.png',
                  fit: BoxFit.cover,
                ),
              ),
            )
          : FFAppState().userInfo == null
              ? FFAppState().playerId == ""
                  ? const HeroPageWidget()
                  : const LoginWidget()
              : const HomePageWidget(),
      routes: [
        FFRoute(
          name: '_initialize',
          path: '/',
          builder: (context, _) => appStateNotifier.showSplashImage
              ? Builder(
                  builder: (context) => Container(
                    color: Colors.transparent,
                    child: Image.asset(
                      'assets/images/ic_driver_white.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : FFAppState().userInfo == null
                  ? FFAppState().playerId == ""
                      ? const HeroPageWidget()
                      : const LoginWidget()
                  : const HomePageWidget(),
        ),
        FFRoute(
          name: 'noConnexion',
          path: '/noConnexion',
          builder: (context, params) => const NoConnexionWidget(),
        ),
        FFRoute(
          name: 'HomePage',
          path: '/homePage',
          builder: (context, params) => const HomePageWidget(),
        ),
        FFRoute(
          name: 'stats',
          path: '/stats',
          builder: (context, params) => const StatsWidget(),
        ),
        FFRoute(
          name: 'infosTrajet',
          path: '/infosTrajet',
          builder: (context, params) => InfosTrajetWidget(
            idCourse: params.getParam(
              'idCourse',
              ParamType.int,
            ),
            depart: params.getParam(
              'depart',
              ParamType.JSON,
            ),
            arrivee: params.getParam(
              'arrivee',
              ParamType.JSON,
            ),
            arret: params.getParam<dynamic>(
              'arret',
              ParamType.JSON,
              isList: true,
            ),
            change: params.getParam(
              'change',
              ParamType.bool,
            ),
            serviceId: params.getParam(
              'serviceId',
              ParamType.int,
            ),
            distanceClientChauffeurDepart: params.getParam(
              'distanceClientChauffeurDepart',
              ParamType.double,
            ),
          ),
        ),
        FFRoute(
          name: 'listeReservations',
          path: '/listeReservations',
          builder: (context, params) => ListeReservationsWidget(
            ind: params.getParam(
              'ind',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: 'infosReservation',
          path: '/infosReservation',
          builder: (context, params) => InfosReservationWidget(
            reservation: params.getParam(
              'reservation',
              ParamType.JSON,
            ),
            dejaEnCourse: params.getParam(
              'dejaEnCourse',
              ParamType.bool,
            ),
          ),
        ),
        FFRoute(
          name: 'mapReserv',
          path: '/mapReserv',
          builder: (context, params) => MapReservWidget(
            depart: params.getParam(
              'depart',
              ParamType.JSON,
            ),
            arrivee: params.getParam(
              'arrivee',
              ParamType.JSON,
            ),
          ),
        ),
        FFRoute(
          name: 'login',
          path: '/login',
          builder: (context, params) => LoginWidget(
            deco: params.getParam(
              'deco',
              ParamType.bool,
            ),
          ),
        ),
        FFRoute(
          name: 'infosCourse',
          path: '/infosCourse',
          builder: (context, params) => InfosCourseWidget(
            idCourse: params.getParam(
              'idCourse',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: 'navigation',
          path: '/navigation',
          builder: (context, params) => NavigationWidget(
            // routeObserver: routeObserver,
            depart: params.getParam(
              'depart',
              ParamType.JSON,
            ),
            arrivee: params.getParam(
              'arrivee',
              ParamType.JSON,
            ),
            arrets: params.getParam<dynamic>(
              'arrets',
              ParamType.JSON,
              isList: true,
            ),
            idCourse: params.getParam(
              'idCourse',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: 'signup',
          path: '/signup',
          builder: (context, params) => const SignupWidget(),
        ),
        FFRoute(
          name: 'choixCouleur',
          path: '/choixCouleur',
          builder: (context, params) => const ChoixCouleurWidget(),
        ),
        FFRoute(
          name: 'changerMdp',
          path: '/changerMdp',
          builder: (context, params) => const ChangerMdpWidget(),
        ),
        FFRoute(
          name: 'historique',
          path: '/historique',
          builder: (context, params) => const HistoriqueWidget(),
        ),
        FFRoute(
          name: 'profil',
          path: '/profil',
          builder: (context, params) => const ProfilWidget(),
        ),
        FFRoute(
          name: 'infosVehicule',
          path: '/infosVehicule',
          builder: (context, params) => const InfosVehiculeWidget(),
        ),
        FFRoute(
          name: 'portefeuille',
          path: '/portefeuille',
          builder: (context, params) => PortefeuilleWidget(
            statut: params.getParam(
              'statut',
              ParamType.String,
            ),
            playerid: params.getParam(
              'playerid',
              ParamType.String,
            ),
            idLastTrans: params.getParam(
              'idLastTrans',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: 'researchReserv',
          path: '/researchReserv',
          builder: (context, params) => const ResearchReservWidget(),
        ),
        FFRoute(
          name: 'dashboard',
          path: '/dashboard',
          builder: (context, params) => const DashboardWidget(),
        ),
        FFRoute(
          name: 'contactUrgence',
          path: '/contactUrgence',
          builder: (context, params) => const ContactUrgenceWidget(),
        ),
        FFRoute(
          name: 'Gains',
          path: '/gains',
          builder: (context, params) => const GainsWidget(),
        ),
        FFRoute(
          name: 'document',
          path: '/document',
          builder: (context, params) => const DocumentWidget(),
        ),
        FFRoute(
          name: 'confirmTrajet',
          path: '/confirmTrajet',
          builder: (context, params) => ConfirmTrajetWidget(
            depart: params.getParam(
              'depart',
              ParamType.JSON,
            ),
            arrivee: params.getParam(
              'arrivee',
              ParamType.JSON,
            ),
            arrets: params.getParam<dynamic>(
              'arrets',
              ParamType.JSON,
              isList: true,
            ),
            trajetInfo: params.getParam(
              'trajetInfo',
              ParamType.JSON,
            ),
          ),
        ),
        FFRoute(
          name: 'creationArretTrajet',
          path: '/creationArretTrajet',
          builder: (context, params) => CreationArretTrajetWidget(
            depart: params.getParam(
              'depart',
              ParamType.JSON,
            ),
            arrivee: params.getParam(
              'arrivee',
              ParamType.JSON,
            ),
            arrets: params.getParam<dynamic>(
              'arrets',
              ParamType.JSON,
              isList: true,
            ),
            change: params.getParam(
              'change',
              ParamType.bool,
            ),
            prevInterface: params.getParam(
              'prevInterface',
              ParamType.String,
            ),
            index: params.getParam(
              'index',
              ParamType.int,
            ),
            idCourse: params.getParam(
              'idCourse',
              ParamType.int,
            ),
            serviceId: params.getParam(
              'serviceId',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: 'creationTrajet',
          path: '/creationTrajet',
          builder: (context, params) => CreationTrajetWidget(
            depart: params.getParam(
              'depart',
              ParamType.JSON,
            ),
            arrivee: params.getParam(
              'arrivee',
              ParamType.JSON,
            ),
            arrets: params.getParam<dynamic>(
              'arrets',
              ParamType.JSON,
              isList: true,
            ),
            change: params.getParam(
              'change',
              ParamType.bool,
            ),
            prevInterface: params.getParam(
              'prevInterface',
              ParamType.String,
            ),
            focus: params.getParam(
              'focus',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: 'placementCarte',
          path: '/placementCarte',
          builder: (context, params) => PlacementCarteWidget(
            index: params.getParam(
              'index',
              ParamType.int,
            ),
            depart: params.getParam(
              'depart',
              ParamType.JSON,
            ),
            arrets: params.getParam<dynamic>(
              'arrets',
              ParamType.JSON,
              isList: true,
            ),
            arrivee: params.getParam(
              'arrivee',
              ParamType.JSON,
            ),
          ),
        ),
        FFRoute(
          name: 'confirmTrajetCopy',
          path: '/confirmTrajetCopy',
          builder: (context, params) => ConfirmTrajetCopyWidget(
            depart: params.getParam(
              'depart',
              ParamType.JSON,
            ),
            arrivee: params.getParam(
              'arrivee',
              ParamType.JSON,
            ),
            arrets: params.getParam<dynamic>(
              'arrets',
              ParamType.JSON,
              isList: true,
            ),
            trajetInfo: params.getParam(
              'trajetInfo',
              ParamType.JSON,
            ),
          ),
        ),
        FFRoute(
          name: 'rechargementPage',
          path: '/rechargementPage',
          builder: (context, params) => const RechargementPageWidget(),
        ),
        FFRoute(
          name: 'heroPage',
          path: '/heroPage',
          builder: (context, params) => const HeroPageWidget(),
        ),
        FFRoute(
          name: 'navigationG',
          path: '/navigationG',
          builder: (context, params) => NavigationG(),
        ),
        FFRoute(
          name: 'mapGoogle',
          path: '/mapGoogle',
          builder: (context, params) => GoogleMapVehiclePage(),
        )
      ].map((r) => r.toRoute(appStateNotifier)).toList(),
    );

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
}

extension NavigationExtensions on BuildContext {
  void safePop() {
    // If there is only one route on the stack, navigate to the initial
    // page instead of popping.
    if (canPop()) {
      pop();
    } else {
      go('/');
    }
  }
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap =>
      extra != null ? extra as Map<String, dynamic> : {};
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(pathParameters)
    ..addAll(uri.queryParameters)
    ..addAll(extraMap);
  TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
      ? extraMap[kTransitionInfoKey] as TransitionInfo
      : TransitionInfo.appDefault();
}

class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  // Parameters are empty if the params map is empty or if the only parameter
  // present is the special extra parameter reserved for the transition info.
  bool get isEmpty =>
      state.allParams.isEmpty ||
      (state.allParams.length == 1 &&
          state.extraMap.containsKey(kTransitionInfoKey));
  bool isAsyncParam(MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);
  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (param) async {
            final doc = await asyncParams[param.key]!(param.value)
                .onError((_, __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  dynamic getParam<T>(
    String paramName,
    ParamType type, {
    bool isList = false,
    List<String>? collectionNamePath,
  }) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    // Got parameter from `extras`, so just directly return it.
    if (param is! String) {
      return param;
    }
    // Return serialized value.
    return deserializeParam<T>(
      param,
      type,
      isList,
      collectionNamePath: collectionNamePath,
    );
  }
}

class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
        name: name,
        path: path,
        pageBuilder: (context, state) {
          fixStatusBarOniOS16AndBelow(context);
          final ffParams = FFParameters(state, asyncParams);
          final page = ffParams.hasFutures
              ? FutureBuilder(
                  future: ffParams.completeFutures(),
                  builder: (context, _) => builder(context, ffParams),
                )
              : builder(context, ffParams);
          final child = page;

          final transitionInfo = state.transitionInfo;
          return transitionInfo.hasTransition
              ? CustomTransitionPage(
                  key: state.pageKey,
                  child: child,
                  transitionDuration: transitionInfo.duration,
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          PageTransition(
                    type: transitionInfo.transitionType,
                    duration: transitionInfo.duration,
                    reverseDuration: transitionInfo.duration,
                    alignment: transitionInfo.alignment,
                    child: child,
                  ).buildTransitions(
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ),
                )
              : MaterialPage(key: state.pageKey, child: child);
        },
        routes: routes,
      );
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  static TransitionInfo appDefault() =>
      const TransitionInfo(hasTransition: false);
}

class RootPageContext {
  const RootPageContext(this.isRootPage, [this.errorRoute]);
  final bool isRootPage;
  final String? errorRoute;

  static bool isInactiveRootPage(BuildContext context) {
    final rootPageContext = context.read<RootPageContext?>();
    final isRootPage = rootPageContext?.isRootPage ?? false;
    final location = GoRouterState.of(context).uri.toString();
    return isRootPage &&
        location != '/' &&
        location != rootPageContext?.errorRoute;
  }

  static Widget wrap(Widget child, {String? errorRoute}) => Provider.value(
        value: RootPageContext(true, errorRoute),
        child: child,
      );
}

extension GoRouterLocationExtension on GoRouter {
  String getCurrentLocation() {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }
}
