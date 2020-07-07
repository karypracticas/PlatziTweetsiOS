# PlatziTweetsiOS

iOS Apps:

Generar un .ipa :
* Xcode -> Signing & Capabilities -> Team: Asignar cuenta de developer de paga -> Generic iOS Device -> Product -> Archive (En caso de que no se abra, ir a Window -> Organizer) -> Distribute App ->  Development -> Quitar los checklist dejarlos limpios -> Automatically -> Export 

Formas de distribuir la App:
* Es necesario una cuenta developer iOS pagada
* Registrar los dispositivos que van a probar, en: developer.apple.com -> Certificates,Identifiers & Profiles -> Devices

* TestFlight
    * appstoreconnect.apple.com -> Mis apps -> + -> Nueva app
        * ID de pack -> wildcard *  
        * Sufijo ID de Pack (Es el Bundle Identifier que está en Xcode)
        * SKU (Bundle Identifier)
    * Pestaña de TestFlight
    * Generar un nuevo .ipa con la opción -> App Store Connect en lugar de Development -> Upload -Descheck opciones -> Automatically -> Upload -> Done

* Firebase Distribution
    * console.firebase.google.com -> App Distribution -> Verificadores y grupos -> Distribuciones: Drag and drop el .ipa generado previamente en Xcode

Distribución de tu app con TestFlight:

Completa los permisos necesarios
Al inicio del curso, en la lectura de introducción, te mencioné que Apple puede rechazar tu app en el App Store por múltiples razones. Aquí tienes un pantallazo de un correo donde Apple rechaza PlatziTweets de TestFlight porque aparentemente le falta especificar un par de permisos.
￼
Si te fijas en la imagen, el correo dice que falta el permiso “NSPhotoLibraryUsageDescription”, lo cual traduce a pedir un permiso para acceder a la librería de imágenes del usuario, lo cual nunca hicimos, ¿verdad?. Bien, este es un ejemplo de por qué con Apple debes ser tan paciente con sus procesos en la tienda en la App Store.
El mismo escenario ocurre con el permiso “NSLocationAlwaysUsageDescription”. Realmente, no estamos utilizando “todo el tiempo” la ubicación del usuario, solo la pedimos una vez para agregarlo al Tweet, pero para Apple va a ser necesario que lo especifiquemos.
En tu archivo Info.plist (clic derecho y abrir como código) agrega estas líneas:
￼
Aumenta tu build number
Tendrás que archivar nuevamente tu aplicación aumentando el build number:
￼
(Puedes usar cualquier número, mi recomendación es que siempre lo aumentes).
Archiva tu aplicación y subela a TestFlight como hicimos en la clase anterior a este video.
￼
Tendrás que esperar un rato a que Apple (su bot de revisión de apps) revise la tuya y la deje disponible para pruebas. Algo así deberías ver cuando la app se procese en TestFlight.
Completa información sobre leyes de exportación
￼
Hay un detalle importante que siempre tendrás que completar cuando subas una nueva versión. La parte que dice “Falta documentación sobre el……”. Para continuar, haz clic en el build number, es decir, en el caso de la imagen anterior, el número 3.
￼
La página cambiará al detalle de la versión de tu app, busca un botón en la parte superior derecha que diga algo así como “Proporcionar información sobre el cumplimiento de las leyes de exportación”.
￼
Vas a ver un cuadro de diálogo que te pregunta si tu app tiene encriptación, para el caso de PlatziTweets no es necesario, haz click en “No” y luego en el botón “Empezar pruebas internas”.
￼
Envía tu app a tus conocidos para que la prueben
Hay dos tipos de usuarios que pueden probar tu app, los externos y los internos.
Externos: idealmente, todos los “probadores” de tu aplicación.
Internos: otros desarrolladores, el manager o gente que esté muy de cerca al desarrollo de tu app.
La gran diferencia entre estos dos grupos, a parte de la teoría, es que los externos tendrán que esperar a que Apple revise tu app para poder probarla, los internos no. Tienes un número máximo de probadores internos: 25, así que piénsalo dos veces antes de agregar personas a ese grupo.
Para continuar, busca en la sección de TestFlight “testers y grupos”.
￼
La primera opción, la que dice “Usuarios de App Store Connect”, son los internos, puedes probar agregando tu propio correo y el de alguien más, después podrás eliminarlos.
￼
Una vez hayas agregado tu usuario de prueba, podrás ver el estado del usuario como “invitado”
￼
La invitación es algo parecido a esto:
￼
￼
Cuando tu usuario haga clic en “View in TestFlight”, lo que tendrá que hacer es descargar la app de TestFlight en su iPhone y poner un código, algo así:
￼
Una vez en la app de TestFlight, agrega el código y podrás descargar la versión de prueba de tu app.

Dark Mode:

if #available(iOS 13.0, *) {

}



SwiftUI (Solo compatible con iOS 13)
