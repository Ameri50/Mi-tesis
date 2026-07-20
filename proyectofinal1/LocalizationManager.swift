import SwiftUI

@MainActor
class LocalizationManager: ObservableObject {
    // MARK: - Propiedad reactiva (forzada a español)
    @Published var currentLanguage: String = "es" {
        didSet {
            UserDefaults.standard.set(currentLanguage, forKey: "selectedLanguage")
        }
    }

    // MARK: - Cambiar idioma manualmente
    func setLanguage(_ language: String) {
        currentLanguage = language
    }

    // MARK: - Traductor principal
    func translate(_ key: String) -> String {
        let translations: [String: [String: String]] = [
            // MARK: - Settings
            "settings.title": ["es": "Ajustes"],
            "settings.profile": ["es": "Perfil"],
            "settings.appearance": ["es": "Apariencia"],
            "settings.fontSize": ["es": "Tamaño de Fuente"],
            "settings.notifications": ["es": "Notificaciones"],
            "settings.language": ["es": "Idioma"],
            "settings.privacy": ["es": "Privacidad y Seguridad"],
            "settings.info": ["es": "Información"],
            "settings.textSize": ["es": "Tamaño de Texto"],
            "settings.currentSize": ["es": "Tamaño Actual"],
            "settings.enableNotifications": ["es": "Notificaciones Habilitadas"],
            "settings.theme": ["es": "Tema"],
            "settings.light": ["es": "Modo Claro"],
            "settings.dark": ["es": "Modo Oscuro"],
            "settings.privacyPolicy": ["es": "Política de Privacidad"],
            "settings.termsOfService": ["es": "Términos de Servicio"],
            "settings.information": ["es": "Información"],
            "settings.about": ["es": "Acerca de"],
            "settings.support": ["es": "Soporte"],
            "settings.firebaseTools": ["es": "🔧 Herramientas Firebase"],
            "settings.uploadImages": ["es": "Subir Imágenes a Firebase"],
            "settings.syncProducts": ["es": "Sincronizar Productos"],
            "settings.uploadSuccess": ["es": "✅ Imágenes subidas y URLs actualizadas en Firestore"],
            "settings.uploadError": ["es": "❌ Error al subir imágenes"],
            "settings.syncSuccess": ["es": "✅ Productos sincronizados"],
            "settings.syncError": ["es": "❌ Error al sincronizar productos"],
            "settings.firebaseAlert": ["es": "Firebase Imágenes"],
            "settings.logout": ["es": "Cerrar Sesión"],
            "settings.logoutConfirmation": ["es": "¿Estás seguro de que deseas cerrar sesión?"],

            // MARK: - Theme
            "theme.light": ["es": "Modo Claro"],
            "theme.dark": ["es": "Modo Oscuro"],
            "theme.auto": ["es": "Automático"],
            "theme.light.desc": ["es": "Siempre claro"],
            "theme.dark.desc": ["es": "Siempre oscuro"],
            "theme.auto.desc": ["es": "Según la hora del día"],

            // MARK: - Font Size
            "fontSize.adjust": ["es": "Ajusta el tamaño del texto"],
            "fontSize.apply": ["es": "Se aplica en toda la aplicación"],
            "fontSize.reset": ["es": "Restablecer"],

            // MARK: - Notifications
            "notif.enabled": ["es": "Notificaciones Habilitadas"],
            "notif.advanced": ["es": "Configuración Avanzada"],
            "notif.push": ["es": "Notificaciones Push"],
            "notif.email": ["es": "Correo Electrónico"],
            "notif.sms": ["es": "SMS"],

            // MARK: - Language
            "lang.spanish": ["es": "Español"],
            "lang.english": ["es": "Inglés"],
            "lang.es": ["es": "Español - ES"],
            "lang.en": ["es": "Inglés - EN"],

            // MARK: - Privacy
            "privacy.policy": ["es": "Política de Privacidad"],
            "privacy.terms": ["es": "Términos de Servicio"],
            "privacy.title": ["es": "Política de Privacidad"],
            "privacy.text": ["es": "Tus datos están protegidos con las más altas medidas de seguridad. No compartimos información personal con terceros sin tu consentimiento."],
            "privacy.terms.title": ["es": "Términos de Servicio"],
            "privacy.terms.text": ["es": "Al usar nuestra aplicación, aceptas estos términos. Nos reservamos el derecho de actualizar estos términos en cualquier momento."],

            // MARK: - Info
            "info.version": ["es": "Versión de la App"],
            "info.build": ["es": "Número de Build"],
            "info.time": ["es": "Hora Actual"],
            "info.period": ["es": "Período del Día"],

            // MARK: - Home
            "home.store": ["es": "Tienda"],
            "home.searchPlaceholder": ["es": "Buscar productos"],
            "home.categories": ["es": "Categorías"],
            "home.repairTitle": ["es": "Servicio Técnico Apple"],
            "home.repairSubtitle": ["es": "Repuestos y reparaciones originales"],
            "home.featured": ["es": "Destacados"],
            "home.newArrivals": ["es": "Nuevas Llegadas"],
            "home.welcome": ["es": "Bienvenido a nuestra tienda"],
            "home.noProducts": ["es": "No hay productos disponibles"],
            "home.noResults": ["es": "No se encontraron resultados"],
            "home.noCategoryProducts": ["es": "No hay productos en esta categoría"],

            // MARK: - Categories
            "category.all": ["es": "Todos"],
            "category.ipad": ["es": "iPad"],
            "category.iphone": ["es": "iPhone"],
            "category.mac": ["es": "Mac"],
            "category.applewatch": ["es": "Apple Watch"],
            "category.accessories": ["es": "Accesorios"],
            "category.products": ["es": "productos"],
            "category.product": ["es": "producto"],
            "category.noProducts": ["es": "No hay productos en esta categoría"],

            // MARK: - Cart
            "cart.title": ["es": "Carrito"],
            "cart.empty": ["es": "Tu carrito está vacío"],
            "cart.checkout": ["es": "Ir al Pago"],
            "cart.total": ["es": "Total"],
            "cart.subtotal": ["es": "Subtotal"],
            "cart.shipping": ["es": "Envío"],

            // MARK: - Product
            "product.price": ["es": "Precio"],
            "product.stock": ["es": "En Stock"],
            "product.outOfStock": ["es": "Agotado"],
            "product.addToCart": ["es": "Agregar al Carrito"],
            "product.description": ["es": "Descripción"],
            "product.details": ["es": "Detalles"],
            "product.quantity": ["es": "Cantidad"],

            // MARK: - Support
            "support.title": ["es": "Soporte"],
            "support.chat": ["es": "Chat"],
            "support.hello": ["es": "¡Hola de nuevo!"],
            "support.howCanHelp": ["es": "¿Qué cosas puedes hacer?"],
            "support.typeSomething": ["es": "Escribe algo..."],
            "support.send": ["es": "Enviar"],
            "support.heading": ["es": "¿Cómo podemos ayudarte?"],
            "support.subheading": ["es": "Elige una categoría o describe tu problema"],
            "support.placeholder": ["es": "Escribe tu pregunta..."],
            "support.typing": ["es": "Escribiendo..."],
            "support.available": ["es": "Disponible"],
            "support.hideKeyboard": ["es": "Ocultar teclado"],
            "support.clearChat": ["es": "Limpiar chat"],
            "support.clearMessage": ["es": "¿Estás seguro de que deseas eliminar todo el historial?"],
            "support.cancel": ["es": "Cancelar"],
            "support.clear": ["es": "Limpiar"],
            "support.issuePrefix": ["es": "Tengo un problema con:"],
            "support.category1.title": ["es": "Pantallas y reparaciones"],
            "support.category1.subtitle": ["es": "Roturas, fallas táctiles, cambio de pantalla"],
            "support.category2.title": ["es": "Conectividad"],
            "support.category2.subtitle": ["es": "WiFi, Bluetooth, señal y redes"],
            "support.category3.title": ["es": "Batería y carga"],
            "support.category3.subtitle": ["es": "Duración, carga lenta, puerto dañado"],
            "support.category4.title": ["es": "Almacenamiento y software"],
            "support.category4.subtitle": ["es": "Espacio, actualizaciones, rendimiento"],

            // MARK: - Orders
            "orders.title": ["es": "Mis Órdenes"],
            "orders.empty.title": ["es": "Aún no tienes compras"],
            "orders.empty.subtitle": ["es": "Cuando realices una compra, aparecerá aquí"],
            "orders.delivered": ["es": "Entregada"],
            "orders.shipped": ["es": "En camino"],
            "orders.processing": ["es": "Procesando"],
            "orders.cancelled": ["es": "Cancelada"],
            "orders.total": ["es": "Total"],
            "orders.date": ["es": "Fecha"],
            "orders.status": ["es": "Estado"],
            "orders.items": ["es": "Artículos"],

            // MARK: - Common
            "common.home": ["es": "Inicio"],
            
            "common.assistant": ["es": "Asistente"],
            "common.about": ["es": "Sobre Nosotros"],
            "common.profile": ["es": "Perfil"],
            "orders": ["es": "Mis Compras"],
            "cancel": ["es": "Cancelar"],
            "Pre save": ["es": "Guardar"],
            "delete": ["es": "Eliminar"],
            "edit": ["es": "Editar"],
            "loading": ["es": "Cargando..."],
            "error": ["es": "Error"],
            "success": ["es": "Éxito"],
            "home": ["es": "Inicio"],
            "ishop": ["es": "Tienda"],
            "assistant": ["es": "Asistente"],
            "About us": ["es": "Sobre Nosotros"],
            "profile": ["es": "Perfil"],
            "retry": ["es": "Reintentar"],
            
            // MARK: - Profile
            
            "profile.selectPhoto": ["es": "Seleccionar Foto"],
            "profile.name": ["es": "Nombre"],
            "profile.lastName": ["es": "Apellido"],
            "profile.email": ["es": "Correo Electrónico"],
            "profile.address": ["es": "Dirección"],
            "profile.age": ["es": "Edad"],
            "profile.birthDate": ["es": "Fecha de Nacimiento"],
            "profile.phone": ["es": "Teléfono"],
            "profile.save": ["es": "Guardar Cambios"],
            "profile.edit": ["es": "Editar Perfil"],
            
            // MARK: - Shop
            "common.shop": ["es": "Tienda"],
            
            // MARK: - Login
            "login.termsAndConditions": ["es": "Aceptar términos y condiciones"],
            "login.signIn": ["es": "Iniciar Sesión"],
            "login.continueAsGuest": ["es": "Continuar como Invitado"],
            "login.termsPlaceholder": ["es": "Lorem ipsum dolor sit amet..."],
            "login.close": ["es": "Cerrar"],
            "login.guest": ["es": "Invitado"]
        ]

        // ✅ Fallback seguro (solo español)
        if let localized = translations[key]?["es"] {
            return localized
        } else {
            return key
        }
    }
}
