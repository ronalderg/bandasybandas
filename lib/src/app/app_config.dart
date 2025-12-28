// lib/src/app/app_config.dart

// ignore_for_file: no_default_cases

/// Define los posibles entornos (flavors) para la aplicación.
enum AppFlavor {
  development, // Entorno de desarrollo (para desarrolladores)
  staging, // Entorno de pruebas (para QA, pre-producción)
  production, // Entorno de producción (para usuarios finales)
}

/// [AppConfig] gestiona las configuraciones de la aplicación específicas del entorno.
/// Debe ser inicializada una sola vez al inicio de la aplicación (generalmente en main.dart).
class AppConfig {
  // Constructor privado para evitar que se creen instancias de esta clase de utilidades estáticas.
  AppConfig._();

  /// La variable estática que contendrá el entorno (flavor) actual de la aplicación.
  static AppFlavor? appFlavor;

  // --- Propiedades de Configuración ---

  /// Retorna la URL base de la API según el entorno actual.
  static String get baseUrl {
    switch (appFlavor) {
      case AppFlavor.development:
        return 'https://bandasybandassg.web.app'; // Cambia esta URL por la de tu API de desarrollo
      case AppFlavor.staging:
        return 'https://bandasybandassg.web.app'; // Cambia esta URL por la de tu API de staging
      case AppFlavor.production:
        return 'https://bandasybandassg.web.app'; // Cambia esta URL por la de tu API de producción
      default:
        // Fallback robusto si appFlavor no ha sido inicializado o es un valor inesperado.
        throw Exception(
          'AppConfig.appFlavor no ha sido inicializado. Por favor, asegúrate de llamarlo en main.dart',
        );
    }
  }

  /// Retorna el nombre de la aplicación para mostrar en la interfaz de usuario.
  static String get appName {
    switch (appFlavor) {
      case AppFlavor.development:
        return '[DEV] Sistema POS';
      case AppFlavor.staging:
        return '[STAGING] Sistema POS';
      case AppFlavor.production:
        return 'Sistema POS';
      default:
        return 'Sistema POS (Desconocido)';
    }
  }

  /// Indica si las funciones de análisis de uso (analytics) deben estar habilitadas.
  static bool get enableAnalytics {
    switch (appFlavor) {
      case AppFlavor.development:
        return false; // Desactivado en desarrollo para no enviar datos de prueba
      case AppFlavor.staging:
        return true; // Activado en staging para pruebas de QA
      case AppFlavor.production:
        return true; // Activado en producción para recopilar datos reales
      default:
        return false;
    }
  }

  /// Retorna el tiempo máximo de espera para las peticiones HTTP.
  static Duration get httpTimeout {
    switch (appFlavor) {
      case AppFlavor.development:
        return const Duration(seconds: 30); // Más indulgente para depuración
      case AppFlavor.production:
        return const Duration(seconds: 15); // Más estricto para mejor UX
      default:
        return const Duration(seconds: 20);
    }
  }

  /// Retorna la URL base del sitio web público según el entorno.
  static String get webBaseUrl {
    switch (appFlavor) {
      case AppFlavor.development:
        return 'https://bandasybandassg.web.app/#'; // URL web para desarrollo
      case AppFlavor.staging:
        return 'https://stg.bandasybandas.com'; // URL web para staging/pruebas
      case AppFlavor.production:
        return 'https://bandasybandas.com'; // URL web para producción
      default:
        // Fallback robusto si appFlavor no ha sido inicializado.
        throw Exception(
          'AppConfig.appFlavor no ha sido inicializado. Por favor, asegúrate de llamarlo en main.dart',
        );
    }
  }

  // Puedes añadir más propiedades de configuración aquí según las necesidades de tu aplicación.
  // Por ejemplo, claves de APIs de terceros, configuración de base de datos local, etc.
}
