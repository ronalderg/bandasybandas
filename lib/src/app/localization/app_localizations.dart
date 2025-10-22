import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localization/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es')
  ];

  /// No description provided for @helloWorld.
  ///
  /// In es, this message translates to:
  /// **'Hola Mundo!'**
  String get helloWorld;

  /// No description provided for @ok.
  ///
  /// In es, this message translates to:
  /// **'Aceptar'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get save;

  /// No description provided for @done.
  ///
  /// In es, this message translates to:
  /// **'Hecho'**
  String get done;

  /// No description provided for @next.
  ///
  /// In es, this message translates to:
  /// **'Siguiente'**
  String get next;

  /// No description provided for @back.
  ///
  /// In es, this message translates to:
  /// **'Atrás'**
  String get back;

  /// No description provided for @close.
  ///
  /// In es, this message translates to:
  /// **'Cerrar'**
  String get close;

  /// No description provided for @yes.
  ///
  /// In es, this message translates to:
  /// **'Sí'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In es, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @continue_button.
  ///
  /// In es, this message translates to:
  /// **'Continuar'**
  String get continue_button;

  /// No description provided for @skip.
  ///
  /// In es, this message translates to:
  /// **'Omitir'**
  String get skip;

  /// No description provided for @retry.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get retry;

  /// No description provided for @submit.
  ///
  /// In es, this message translates to:
  /// **'Enviar'**
  String get submit;

  /// No description provided for @search.
  ///
  /// In es, this message translates to:
  /// **'Buscar'**
  String get search;

  /// No description provided for @email.
  ///
  /// In es, this message translates to:
  /// **'Correo electrónico'**
  String get email;

  /// No description provided for @password.
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get password;

  /// No description provided for @error_unexpected.
  ///
  /// In es, this message translates to:
  /// **'Ocurrió un error inesperado. Por favor, inténtalo de nuevo más tarde.'**
  String get error_unexpected;

  /// No description provided for @error_no_internet.
  ///
  /// In es, this message translates to:
  /// **'Sin conexión a internet. Por favor, revisa tu conexión e inténtalo de nuevo.'**
  String get error_no_internet;

  /// No description provided for @error_server.
  ///
  /// In es, this message translates to:
  /// **'No se pudo conectar con el servidor. Por favor, inténtalo de nuevo más tarde.'**
  String get error_server;

  /// No description provided for @error_required_field.
  ///
  /// In es, this message translates to:
  /// **'Este campo es obligatorio'**
  String get error_required_field;

  /// No description provided for @error_invalid_email.
  ///
  /// In es, this message translates to:
  /// **'Por favor, introduce una dirección de correo válida'**
  String get error_invalid_email;

  /// No description provided for @error_password_too_short.
  ///
  /// In es, this message translates to:
  /// **'La contraseña debe tener al menos 6 caracteres'**
  String get error_password_too_short;

  /// No description provided for @loading.
  ///
  /// In es, this message translates to:
  /// **'Cargando...'**
  String get loading;

  /// No description provided for @please_wait.
  ///
  /// In es, this message translates to:
  /// **'Por favor, espera...'**
  String get please_wait;

  /// No description provided for @success.
  ///
  /// In es, this message translates to:
  /// **'Éxito'**
  String get success;

  /// No description provided for @error.
  ///
  /// In es, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @settings.
  ///
  /// In es, this message translates to:
  /// **'Configuración'**
  String get settings;

  /// No description provided for @profile.
  ///
  /// In es, this message translates to:
  /// **'Perfil'**
  String get profile;

  /// No description provided for @logout.
  ///
  /// In es, this message translates to:
  /// **'Cerrar sesión'**
  String get logout;

  /// No description provided for @language.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In es, this message translates to:
  /// **'Tema'**
  String get theme;

  /// No description provided for @dark_mode.
  ///
  /// In es, this message translates to:
  /// **'Modo Oscuro'**
  String get dark_mode;

  /// No description provided for @light_mode.
  ///
  /// In es, this message translates to:
  /// **'Modo Claro'**
  String get light_mode;

  /// No description provided for @welcome.
  ///
  /// In es, this message translates to:
  /// **'Bienvenido'**
  String get welcome;

  /// No description provided for @get_started.
  ///
  /// In es, this message translates to:
  /// **'Comenzar'**
  String get get_started;

  /// No description provided for @confirm_logout_title.
  ///
  /// In es, this message translates to:
  /// **'Confirmar Cierre de Sesión'**
  String get confirm_logout_title;

  /// No description provided for @confirm_logout_message.
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro de que quieres cerrar sesión?'**
  String get confirm_logout_message;

  /// No description provided for @home.
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get home;

  /// No description provided for @dashboard.
  ///
  /// In es, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @inventory.
  ///
  /// In es, this message translates to:
  /// **'Inventario'**
  String get inventory;

  /// No description provided for @sales.
  ///
  /// In es, this message translates to:
  /// **'Ventas'**
  String get sales;

  /// No description provided for @product.
  ///
  /// In es, this message translates to:
  /// **'Producto'**
  String get product;

  /// No description provided for @products.
  ///
  /// In es, this message translates to:
  /// **'Productos'**
  String get products;

  /// No description provided for @create_product.
  ///
  /// In es, this message translates to:
  /// **'Crear Producto'**
  String get create_product;

  /// No description provided for @create_new_product.
  ///
  /// In es, this message translates to:
  /// **'Crear nuevo producto'**
  String get create_new_product;

  /// No description provided for @edit_product.
  ///
  /// In es, this message translates to:
  /// **'Editar Producto'**
  String get edit_product;

  /// No description provided for @delete_product.
  ///
  /// In es, this message translates to:
  /// **'Eliminar Producto'**
  String get delete_product;

  /// No description provided for @are_you_sure_delete_product.
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro de que quieres eliminar este producto?'**
  String get are_you_sure_delete_product;

  /// No description provided for @category.
  ///
  /// In es, this message translates to:
  /// **'Categoría'**
  String get category;

  /// No description provided for @supplier.
  ///
  /// In es, this message translates to:
  /// **'Proveedor'**
  String get supplier;

  /// No description provided for @customer.
  ///
  /// In es, this message translates to:
  /// **'Cliente'**
  String get customer;

  /// No description provided for @customers.
  ///
  /// In es, this message translates to:
  /// **'Clientes'**
  String get customers;

  /// No description provided for @create_customer.
  ///
  /// In es, this message translates to:
  /// **'Crear Cliente'**
  String get create_customer;

  /// No description provided for @create_new_customer.
  ///
  /// In es, this message translates to:
  /// **'Crear nuevo cliente'**
  String get create_new_customer;

  /// No description provided for @edit_customer.
  ///
  /// In es, this message translates to:
  /// **'Editar Cliente'**
  String get edit_customer;

  /// No description provided for @delete_customer.
  ///
  /// In es, this message translates to:
  /// **'Eliminar Cliente'**
  String get delete_customer;

  /// No description provided for @are_you_sure_delete_customer.
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro de que quieres eliminar este cliente?'**
  String get are_you_sure_delete_customer;

  /// No description provided for @no_customers_found.
  ///
  /// In es, this message translates to:
  /// **'No se encontraron clientes.'**
  String get no_customers_found;

  /// No description provided for @loading_customers.
  ///
  /// In es, this message translates to:
  /// **'Cargando clientes...'**
  String get loading_customers;

  /// No description provided for @order.
  ///
  /// In es, this message translates to:
  /// **'Orden'**
  String get order;

  /// No description provided for @orders.
  ///
  /// In es, this message translates to:
  /// **'Ordenes'**
  String get orders;

  /// No description provided for @create_order.
  ///
  /// In es, this message translates to:
  /// **'Crear Orden'**
  String get create_order;

  /// No description provided for @invoice.
  ///
  /// In es, this message translates to:
  /// **'Factura'**
  String get invoice;

  /// No description provided for @invoices.
  ///
  /// In es, this message translates to:
  /// **'Facturas'**
  String get invoices;

  /// No description provided for @payment.
  ///
  /// In es, this message translates to:
  /// **'Pago'**
  String get payment;

  /// No description provided for @payments.
  ///
  /// In es, this message translates to:
  /// **'Pagos'**
  String get payments;

  /// No description provided for @shipment.
  ///
  /// In es, this message translates to:
  /// **'Envío'**
  String get shipment;

  /// No description provided for @shipments.
  ///
  /// In es, this message translates to:
  /// **'Envío'**
  String get shipments;

  /// No description provided for @purchase.
  ///
  /// In es, this message translates to:
  /// **'Compra'**
  String get purchase;

  /// No description provided for @purchases.
  ///
  /// In es, this message translates to:
  /// **'Compras'**
  String get purchases;

  /// No description provided for @purchase_order.
  ///
  /// In es, this message translates to:
  /// **'Orden de Compra'**
  String get purchase_order;

  /// No description provided for @purchase_orders.
  ///
  /// In es, this message translates to:
  /// **'Ordenes de Compra'**
  String get purchase_orders;

  /// No description provided for @purchase_invoice.
  ///
  /// In es, this message translates to:
  /// **'Factura de Compra'**
  String get purchase_invoice;

  /// No description provided for @purchase_invoices.
  ///
  /// In es, this message translates to:
  /// **'Facturas de Compra'**
  String get purchase_invoices;

  /// No description provided for @location.
  ///
  /// In es, this message translates to:
  /// **'Ubicación'**
  String get location;

  /// No description provided for @locations.
  ///
  /// In es, this message translates to:
  /// **'Ubicaciones'**
  String get locations;

  /// No description provided for @warehouse.
  ///
  /// In es, this message translates to:
  /// **'Almacen'**
  String get warehouse;

  /// No description provided for @warehouses.
  ///
  /// In es, this message translates to:
  /// **'Almacenes'**
  String get warehouses;

  /// No description provided for @employee.
  ///
  /// In es, this message translates to:
  /// **'Empleado'**
  String get employee;

  /// No description provided for @employees.
  ///
  /// In es, this message translates to:
  /// **'Empleados'**
  String get employees;

  /// No description provided for @user.
  ///
  /// In es, this message translates to:
  /// **'Usuario'**
  String get user;

  /// No description provided for @users.
  ///
  /// In es, this message translates to:
  /// **'Usuarios'**
  String get users;

  /// No description provided for @create_user.
  ///
  /// In es, this message translates to:
  /// **'Crear Usuario'**
  String get create_user;

  /// No description provided for @role.
  ///
  /// In es, this message translates to:
  /// **'Rol'**
  String get role;

  /// No description provided for @roles.
  ///
  /// In es, this message translates to:
  /// **'Roles'**
  String get roles;

  /// No description provided for @permission.
  ///
  /// In es, this message translates to:
  /// **'Permiso'**
  String get permission;

  /// No description provided for @permissions.
  ///
  /// In es, this message translates to:
  /// **'Permisos'**
  String get permissions;

  /// No description provided for @menu.
  ///
  /// In es, this message translates to:
  /// **'Menú'**
  String get menu;

  /// No description provided for @menus.
  ///
  /// In es, this message translates to:
  /// **'Menús'**
  String get menus;

  /// No description provided for @sub_menu.
  ///
  /// In es, this message translates to:
  /// **'Submenú'**
  String get sub_menu;

  /// No description provided for @sub_menus.
  ///
  /// In es, this message translates to:
  /// **'Submenús'**
  String get sub_menus;

  /// No description provided for @action.
  ///
  /// In es, this message translates to:
  /// **'Acción'**
  String get action;

  /// No description provided for @actions.
  ///
  /// In es, this message translates to:
  /// **'Acciones'**
  String get actions;

  /// No description provided for @report.
  ///
  /// In es, this message translates to:
  /// **'Reporte'**
  String get report;

  /// No description provided for @reports.
  ///
  /// In es, this message translates to:
  /// **'Reportes'**
  String get reports;

  /// No description provided for @items.
  ///
  /// In es, this message translates to:
  /// **'Items'**
  String get items;

  /// No description provided for @item.
  ///
  /// In es, this message translates to:
  /// **'Item'**
  String get item;

  /// No description provided for @desing.
  ///
  /// In es, this message translates to:
  /// **'Diseño'**
  String get desing;

  /// No description provided for @desings.
  ///
  /// In es, this message translates to:
  /// **'Diseños'**
  String get desings;

  /// No description provided for @search_desing.
  ///
  /// In es, this message translates to:
  /// **'Buscar diseño'**
  String get search_desing;

  /// No description provided for @recipe.
  ///
  /// In es, this message translates to:
  /// **'Receta'**
  String get recipe;

  /// No description provided for @recipes.
  ///
  /// In es, this message translates to:
  /// **'Recetas'**
  String get recipes;

  /// No description provided for @brand.
  ///
  /// In es, this message translates to:
  /// **'Marca'**
  String get brand;

  /// No description provided for @brands.
  ///
  /// In es, this message translates to:
  /// **'Marcas'**
  String get brands;

  /// No description provided for @model.
  ///
  /// In es, this message translates to:
  /// **'Modelo'**
  String get model;

  /// No description provided for @models.
  ///
  /// In es, this message translates to:
  /// **'Modelos'**
  String get models;

  /// No description provided for @color.
  ///
  /// In es, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @colors.
  ///
  /// In es, this message translates to:
  /// **'Colores'**
  String get colors;

  /// No description provided for @size.
  ///
  /// In es, this message translates to:
  /// **'Tamaño'**
  String get size;

  /// No description provided for @sizes.
  ///
  /// In es, this message translates to:
  /// **'Tamaños'**
  String get sizes;

  /// No description provided for @material.
  ///
  /// In es, this message translates to:
  /// **'Material'**
  String get material;

  /// No description provided for @materials.
  ///
  /// In es, this message translates to:
  /// **'Materiales'**
  String get materials;

  /// No description provided for @status.
  ///
  /// In es, this message translates to:
  /// **'Estado'**
  String get status;

  /// No description provided for @statuses.
  ///
  /// In es, this message translates to:
  /// **'Estados'**
  String get statuses;

  /// No description provided for @quantity.
  ///
  /// In es, this message translates to:
  /// **'Cantidad'**
  String get quantity;

  /// No description provided for @price.
  ///
  /// In es, this message translates to:
  /// **'Precio'**
  String get price;

  /// No description provided for @discount.
  ///
  /// In es, this message translates to:
  /// **'Descuento'**
  String get discount;

  /// No description provided for @total.
  ///
  /// In es, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @subtotal.
  ///
  /// In es, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @unit.
  ///
  /// In es, this message translates to:
  /// **'Unidad'**
  String get unit;

  /// No description provided for @units.
  ///
  /// In es, this message translates to:
  /// **'Unidades'**
  String get units;

  /// No description provided for @date.
  ///
  /// In es, this message translates to:
  /// **'Fecha'**
  String get date;

  /// No description provided for @time.
  ///
  /// In es, this message translates to:
  /// **'Hora'**
  String get time;

  /// No description provided for @unit_of_measure.
  ///
  /// In es, this message translates to:
  /// **'Unidad de Medida'**
  String get unit_of_measure;

  /// No description provided for @unit_of_measures.
  ///
  /// In es, this message translates to:
  /// **'Unidades de Medidas'**
  String get unit_of_measures;

  /// No description provided for @unit_price.
  ///
  /// In es, this message translates to:
  /// **'Precio Unitario'**
  String get unit_price;

  /// No description provided for @unit_prices.
  ///
  /// In es, this message translates to:
  /// **'Precios Unitarios'**
  String get unit_prices;

  /// No description provided for @discount_percentage.
  ///
  /// In es, this message translates to:
  /// **'Porcentaje de Descuento'**
  String get discount_percentage;

  /// No description provided for @discount_percentages.
  ///
  /// In es, this message translates to:
  /// **'Porcentajes de Descuento'**
  String get discount_percentages;

  /// No description provided for @discount_amount.
  ///
  /// In es, this message translates to:
  /// **'Monto de Descuento'**
  String get discount_amount;

  /// No description provided for @discount_amounts.
  ///
  /// In es, this message translates to:
  /// **'Montos de Descuento'**
  String get discount_amounts;

  /// No description provided for @total_amount.
  ///
  /// In es, this message translates to:
  /// **'Monto Total'**
  String get total_amount;

  /// No description provided for @total_amounts.
  ///
  /// In es, this message translates to:
  /// **'Montos Totales'**
  String get total_amounts;

  /// No description provided for @subtotal_amount.
  ///
  /// In es, this message translates to:
  /// **'Monto Subtotal'**
  String get subtotal_amount;

  /// No description provided for @subtotal_amounts.
  ///
  /// In es, this message translates to:
  /// **'Montos Subtotales'**
  String get subtotal_amounts;

  /// No description provided for @zone.
  ///
  /// In es, this message translates to:
  /// **'Zona'**
  String get zone;

  /// No description provided for @zones.
  ///
  /// In es, this message translates to:
  /// **'Zonas'**
  String get zones;

  /// No description provided for @country.
  ///
  /// In es, this message translates to:
  /// **'País'**
  String get country;

  /// No description provided for @countries.
  ///
  /// In es, this message translates to:
  /// **'Países'**
  String get countries;

  /// No description provided for @machine.
  ///
  /// In es, this message translates to:
  /// **'Máquina'**
  String get machine;

  /// No description provided for @machines.
  ///
  /// In es, this message translates to:
  /// **'Máquinas'**
  String get machines;

  /// No description provided for @indicators.
  ///
  /// In es, this message translates to:
  /// **'Indicadores'**
  String get indicators;

  /// Etiqueta para el elemento del menú que lleva a la lista de solicitudes de compra.
  ///
  /// In es, this message translates to:
  /// **'Solicitudes de pedidos'**
  String get purchase_requests;

  /// No description provided for @name.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get name;

  /// Descripción del campo de entrada de texto para la descripción.
  ///
  /// In es, this message translates to:
  /// **'Descripción'**
  String get description;

  /// No description provided for @error_field_required.
  ///
  /// In es, this message translates to:
  /// **'Este campo es obligatorio'**
  String get error_field_required;

  /// No description provided for @error_invalid_value.
  ///
  /// In es, this message translates to:
  /// **'Valor inválido'**
  String get error_invalid_value;

  /// No description provided for @error_too_short.
  ///
  /// In es, this message translates to:
  /// **'Demasiado corto'**
  String get error_too_short;

  /// No description provided for @error_too_long.
  ///
  /// In es, this message translates to:
  /// **'Demasiado largo'**
  String get error_too_long;

  /// No description provided for @error_invalid_format.
  ///
  /// In es, this message translates to:
  /// **'Formato inválido'**
  String get error_invalid_format;

  /// No description provided for @loading_data.
  ///
  /// In es, this message translates to:
  /// **'Cargando datos...'**
  String get loading_data;

  /// No description provided for @no_data_available.
  ///
  /// In es, this message translates to:
  /// **'No hay datos disponibles'**
  String get no_data_available;

  /// No description provided for @pull_to_refresh.
  ///
  /// In es, this message translates to:
  /// **'Desliza para refrescar'**
  String get pull_to_refresh;

  /// No description provided for @refreshing.
  ///
  /// In es, this message translates to:
  /// **'Refrescando...'**
  String get refreshing;

  /// No description provided for @last_updated.
  ///
  /// In es, this message translates to:
  /// **'Última actualización'**
  String get last_updated;

  /// No description provided for @welcome_back.
  ///
  /// In es, this message translates to:
  /// **'¡Bienvenido de nuevo!'**
  String get welcome_back;

  /// No description provided for @sign_in_to_continue.
  ///
  /// In es, this message translates to:
  /// **'Inicia sesión para continuar'**
  String get sign_in_to_continue;

  /// No description provided for @forgot_password.
  ///
  /// In es, this message translates to:
  /// **'¿Olvidaste tu contraseña?'**
  String get forgot_password;

  /// No description provided for @reset_password.
  ///
  /// In es, this message translates to:
  /// **'Restablecer contraseña'**
  String get reset_password;

  /// No description provided for @send_reset_link.
  ///
  /// In es, this message translates to:
  /// **'Enviar enlace de restablecimiento'**
  String get send_reset_link;

  /// No description provided for @create_account.
  ///
  /// In es, this message translates to:
  /// **'Crear una cuenta'**
  String get create_account;

  /// No description provided for @create_new.
  ///
  /// In es, this message translates to:
  /// **'Crear Nuevo'**
  String get create_new;

  /// No description provided for @ref.
  ///
  /// In es, this message translates to:
  /// **'Referencia'**
  String get ref;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
