import 'package:flutter/material.dart';
import '../../core/utils/logger.dart';

/// Navigation service for managing app navigation
/// Provides a centralized way to handle navigation without BuildContext
class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Get current context
  BuildContext? get currentContext => navigatorKey.currentContext;

  /// Check if navigator is available
  bool get canNavigate => navigatorKey.currentState != null;

  /// Navigate to a named route
  Future<T?>? navigateTo<T>(String routeName, {Object? arguments}) {
    try {
      if (!canNavigate) {
        AppLogger.warning('Cannot navigate - navigator not available');
        return null;
      }

      AppLogger.info('Navigating to: $routeName');
      return navigatorKey.currentState?.pushNamed<T>(
        routeName,
        arguments: arguments,
      );
    } catch (e) {
      AppLogger.error('Navigation to $routeName failed', e);
      return null;
    }
  }

  /// Navigate to a route and replace current route
  Future<T?>? navigateToAndReplace<T>(String routeName, {Object? arguments}) {
    try {
      if (!canNavigate) {
        AppLogger.warning('Cannot navigate - navigator not available');
        return null;
      }

      AppLogger.info('Navigating to and replacing: $routeName');
      return navigatorKey.currentState?.pushReplacementNamed<T, T>(
        routeName,
        arguments: arguments,
      );
    } catch (e) {
      AppLogger.error('Navigation and replace to $routeName failed', e);
      return null;
    }
  }

  /// Navigate to a route and remove all previous routes
  Future<T?>? navigateToAndRemoveUntil<T>(
    String routeName, {
    Object? arguments,
  }) {
    try {
      if (!canNavigate) {
        AppLogger.warning('Cannot navigate - navigator not available');
        return null;
      }

      AppLogger.info('Navigating to and removing until: $routeName');
      return navigatorKey.currentState?.pushNamedAndRemoveUntil<T>(
        routeName,
        (route) => false,
        arguments: arguments,
      );
    } catch (e) {
      AppLogger.error('Navigation and remove until $routeName failed', e);
      return null;
    }
  }

  /// Navigate to a route and remove until condition is met
  Future<T?>? navigateToAndRemoveUntilCondition<T>(
    String routeName,
    bool Function(Route<dynamic>) predicate, {
    Object? arguments,
  }) {
    try {
      if (!canNavigate) {
        AppLogger.warning('Cannot navigate - navigator not available');
        return null;
      }

      AppLogger.info('Navigating to and removing until condition: $routeName');
      return navigatorKey.currentState?.pushNamedAndRemoveUntil<T>(
        routeName,
        predicate,
        arguments: arguments,
      );
    } catch (e) {
      AppLogger.error(
        'Navigation and remove until condition $routeName failed',
        e,
      );
      return null;
    }
  }

  /// Pop current route
  void goBack<T>([T? result]) {
    try {
      if (!canNavigate) {
        AppLogger.warning('Cannot go back - navigator not available');
        return;
      }

      if (navigatorKey.currentState!.canPop()) {
        AppLogger.info('Going back');
        navigatorKey.currentState!.pop<T>(result);
      } else {
        AppLogger.warning('Cannot go back - no route to pop');
      }
    } catch (e) {
      AppLogger.error('Go back failed', e);
    }
  }

  /// Pop to specific route
  Future<T?>? popToRoute<T>(String routeName) {
    try {
      if (!canNavigate) {
        AppLogger.warning('Cannot pop to route - navigator not available');
        return null;
      }

      AppLogger.info('Popping to route: $routeName');
      return navigatorKey.currentState?.popAndPushNamed<T, T>(routeName);
    } catch (e) {
      AppLogger.error('Pop to route $routeName failed', e);
      return null;
    }
  }

  /// Pop until specific route
  void popUntil(String routeName) {
    try {
      if (!canNavigate) {
        AppLogger.warning('Cannot pop until - navigator not available');
        return;
      }

      AppLogger.info('Popping until route: $routeName');
      navigatorKey.currentState?.popUntil(
        (route) => route.settings.name == routeName,
      );
    } catch (e) {
      AppLogger.error('Pop until $routeName failed', e);
    }
  }

  /// Pop until condition is met
  void popUntilCondition(bool Function(Route<dynamic>) predicate) {
    try {
      if (!canNavigate) {
        AppLogger.warning(
          'Cannot pop until condition - navigator not available',
        );
        return;
      }

      AppLogger.info('Popping until condition met');
      navigatorKey.currentState?.popUntil(predicate);
    } catch (e) {
      AppLogger.error('Pop until condition failed', e);
    }
  }

  /// Check if can pop
  bool get canPop {
    try {
      return canNavigate && navigatorKey.currentState!.canPop();
    } catch (e) {
      AppLogger.error('Can pop check failed', e);
      return false;
    }
  }

  /// Show dialog
  Future<T?>? showCustomDialog<T>({
    required WidgetBuilder builder,
    bool barrierDismissible = true,
    Color? barrierColor,
    String? barrierLabel,
    bool useSafeArea = true,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
  }) {
    try {
      if (!canNavigate) {
        AppLogger.warning('Cannot show dialog - navigator not available');
        return null;
      }

      AppLogger.info('Showing dialog');
      return showDialog<T>(
        context: currentContext!,
        builder: builder,
        barrierDismissible: barrierDismissible,
        barrierColor: barrierColor,
        barrierLabel: barrierLabel,
        useSafeArea: useSafeArea,
        useRootNavigator: useRootNavigator,
        routeSettings: routeSettings,
      );
    } catch (e) {
      AppLogger.error('Show dialog failed', e);
      return null;
    }
  }

  /// Show bottom sheet
  Future<T?>? showBottomSheet<T>({
    required WidgetBuilder builder,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehavior,
    BoxConstraints? constraints,
    Color? barrierColor,
    bool isScrollControlled = false,
    bool useRootNavigator = false,
    bool isDismissible = true,
    bool enableDrag = true,
    RouteSettings? routeSettings,
    AnimationController? transitionAnimationController,
  }) {
    try {
      if (!canNavigate) {
        AppLogger.warning('Cannot show bottom sheet - navigator not available');
        return null;
      }

      AppLogger.info('Showing bottom sheet');
      return showModalBottomSheet<T>(
        context: currentContext!,
        builder: builder,
        backgroundColor: backgroundColor,
        elevation: elevation,
        shape: shape,
        clipBehavior: clipBehavior,
        constraints: constraints,
        barrierColor: barrierColor,
        isScrollControlled: isScrollControlled,
        useRootNavigator: useRootNavigator,
        isDismissible: isDismissible,
        enableDrag: enableDrag,
        routeSettings: routeSettings,
        transitionAnimationController: transitionAnimationController,
      );
    } catch (e) {
      AppLogger.error('Show bottom sheet failed', e);
      return null;
    }
  }

  /// Show snackbar
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showSnackBar(
    SnackBar snackBar,
  ) {
    try {
      if (!canNavigate) {
        AppLogger.warning('Cannot show snackbar - navigator not available');
        return null;
      }

      AppLogger.info('Showing snackbar');
      return ScaffoldMessenger.of(currentContext!).showSnackBar(snackBar);
    } catch (e) {
      AppLogger.error('Show snackbar failed', e);
      return null;
    }
  }

  /// Hide current snackbar
  void hideCurrentSnackBar() {
    try {
      if (!canNavigate) {
        AppLogger.warning('Cannot hide snackbar - navigator not available');
        return;
      }

      AppLogger.info('Hiding current snackbar');
      ScaffoldMessenger.of(currentContext!).hideCurrentSnackBar();
    } catch (e) {
      AppLogger.error('Hide current snackbar failed', e);
    }
  }

  /// Clear all snackbars
  void clearSnackBars() {
    try {
      if (!canNavigate) {
        AppLogger.warning('Cannot clear snackbars - navigator not available');
        return;
      }

      AppLogger.info('Clearing all snackbars');
      ScaffoldMessenger.of(currentContext!).clearSnackBars();
    } catch (e) {
      AppLogger.error('Clear snackbars failed', e);
    }
  }

  /// Get current route name
  String? get currentRouteName {
    try {
      if (!canNavigate) return null;

      final route = ModalRoute.of(currentContext!);
      return route?.settings.name;
    } catch (e) {
      AppLogger.error('Get current route name failed', e);
      return null;
    }
  }

  /// Check if on specific route
  bool isOnRoute(String routeName) {
    try {
      return currentRouteName == routeName;
    } catch (e) {
      AppLogger.error('Check if on route failed', e);
      return false;
    }
  }

  /// Get route arguments
  T? getRouteArguments<T>() {
    try {
      if (!canNavigate) return null;

      final route = ModalRoute.of(currentContext!);
      return route?.settings.arguments as T?;
    } catch (e) {
      AppLogger.error('Get route arguments failed', e);
      return null;
    }
  }
}
