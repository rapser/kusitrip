# Changelog

Cambios de la app KusiTrip por versión. El formato sigue [Keep a Changelog](https://keepachangelog.com/es-ES/1.1.0/) y las versiones siguen [Semantic Versioning](https://semver.org/lang/es/).

Cada versión indica su número de build entre paréntesis, que es el que aparece en TestFlight.

## [Sin publicar]

## [1.0.0] (build 2) - 2026-10-22

Primera versión de KusiTrip, conectada al API [kusitrip-api-rest](https://github.com/rapser/kusitrip-api-rest).

### Agregado

- **Pantallas:** login, registro, splash, Inicio, Destinos, detalle de destino, detalle de actividad, reserva y confirmación, Buscar, Favoritos, Perfil y Mis reservas. Todas consumen el API con Alamofire.
- **Sesión:** se guarda en el Keychain y el inicio es instantáneo. La app muestra el último perfil guardado mientras valida la sesión en segundo plano. El token se renueva solo cuando el API responde 401, y cerrar sesión es inmediato.
- **Favoritos:** se guardan con SwiftData, funcionan sin conexión y se sincronizan con el servidor.
- **Dos ambientes**, cada uno con su app, ícono y bundle ID:
  - **KusiTrip**: API en Render.
  - **KusiTrip-Dev**: API en la Mac.
- **Loader a pantalla completa** con el logo y un anillo que gira. Se usa al iniciar sesión, crear cuenta, reservar y cerrar sesión, y explica las esperas largas.
- **Skeletons de carga** con brillo en Inicio, Destinos, detalle de destino, detalle de actividad, Mis reservas y Buscar. El contenido aparece con un fundido.
- **Fotos con caché** en memoria y en disco:
  - Se reducen a 720 px por el lado corto.
  - Si la descarga falla, se reintenta dos veces.
  - Al volver a una pantalla, las fotos aparecen al instante.
- **Portada del Inicio:** la foto de Machu Picchu se convierte poco a poco en la barra de navegación al deslizar y vuelve a aparecer al subir. Si tiras hacia abajo estando arriba, la foto se estira.
- **Registro de llamadas al API** en la consola de Xcode (`NetworkLogger`).
- **Marca Kusi Trip:**
  - Paleta amarillo, azul noche y naranja.
  - Ícono con variantes oscura y tintada.
  - Pantalla de lanzamiento amarilla con el logo.
- **Declaración de exportación:** `ITSAppUsesNonExemptEncryption = false` en `Kusi-Info.plist`. App Store Connect ya no pregunta por la encriptación en cada build.

### Corregido

- Las fotos ya no se salen de sus contenedores, y las de cada actividad corresponden a su título.
- Las tarjetas de actividad ya no se superponen en los carruseles.
- El Inicio ya no abre desplazado hasta el carrusel de actividades destacadas.
- El anillo del loader ahora también gira en la pantalla de login.
