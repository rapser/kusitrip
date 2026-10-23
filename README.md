# KusiTrip

App iOS de visitas guiadas y excursiones en español por Perú y Sudamérica: Cusco, Lima, Arequipa, Puno, Buenos Aires, Río de Janeiro, Cartagena de Indias y Santiago de Chile.

- **SwiftUI** + **Observation** (`@Observable`) + **Swift Concurrency** (async/await, actors, `AsyncStream`)
- **Clean Architecture por feature** (Presentation → Domain ← Data) y principios **SOLID**
- **Alamofire** para la red, con renovación automática del token
- **SwiftData** para favoritos offline y **Keychain** para la sesión
- Backend: [kusitrip-api-rest](https://github.com/rapser/kusitrip-api-rest) (NestJS + Prisma + PostgreSQL en Supabase, desplegado en Render)

## Contenido

1. [Requisitos](#requisitos)
2. [Cómo correr la app](#cómo-correr-la-app)
3. [Qué se puede hacer en la app](#qué-se-puede-hacer-en-la-app)
4. [Arquitectura](#arquitectura)
5. [Módulos](#módulos)
6. [Navegación](#navegación)
7. [Reactividad y concurrencia](#reactividad-y-concurrencia)
8. [Capa de red](#capa-de-red)
9. [Persistencia local](#persistencia-local)
10. [Principios SOLID](#principios-solid)
11. [Design System](#design-system)
12. [Ambientes](#ambientes)
13. [Pendientes conocidos](#pendientes-conocidos)

---

## Requisitos

| | Versión |
|---|---|
| Xcode | 26.3 |
| iOS mínimo | 26.2 |
| Swift | 5 (modo de lenguaje), con `SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor` y *Approachable Concurrency* |
| Dependencias | [Alamofire](https://github.com/Alamofire/Alamofire) 5.12 vía Swift Package Manager (Xcode la descarga sola al abrir el proyecto) |

Usuario demo: `usuario@kusitrip.com` / `kusitrip123`. También puedes crear una cuenta desde la app.

---

## Cómo correr la app

En Xcode, elige el scheme en el selector de arriba (junto al simulador) y pulsa Run (`Cmd + R`):

| Scheme | Se conecta a | Base de datos | ¿Hay que correr algo en la Terminal? |
|---|---|---|---|
| **KusiTrip** (prod) | API en Render | Supabase | No |
| **KusiTrip-Dev** (dev) | API en tu Mac (`http://localhost:3000`) | PostgreSQL local | **Sí**, ver abajo |

> Si un scheme no aparece en el selector, cierra el proyecto (**File → Close Project**) y vuelve a abrirlo.

### Ambiente dev: antes de pulsar Run

El scheme **KusiTrip-Dev** necesita el API corriendo en tu Mac. Abre dos Terminales y déjalas abiertas mientras usas la app:

```bash
# Terminal 1: base de datos local
cd ~/Downloads/Codigo/kusitrip-api-rest
npm run db:local
```

Espera a ver `PGLiteSocketServer listening on {"port":55432,...}`.

```bash
# Terminal 2: API
cd ~/Downloads/Codigo/kusitrip-api-rest
npm run start:dev
```

Espera a ver `Nest application successfully started`. Luego, en Xcode, elige **KusiTrip-Dev** y pulsa Run.

**Para apagar:** `Ctrl + C` en la Terminal 2 (API) y luego en la Terminal 1 (base). Los datos se conservan para la próxima vez.

**Si la app Dev muestra un error de conexión,** revisa que las dos Terminales sigan abiertas y sin errores. Puedes comprobarlo abriendo http://localhost:3000/health en el navegador.

#### Si es la primera vez en esta Mac

Solo si acabas de clonar [kusitrip-api-rest](https://github.com/rapser/kusitrip-api-rest) y todavía no existe `.env.development`. Si ya lo tienes configurado, sáltate esto.

```bash
cd ~/Downloads/Codigo/kusitrip-api-rest
npm install
cp .env.development.example .env.development   # pon dos valores de `openssl rand -hex 32` en JWT_SECRET y JWT_REFRESH_SECRET
```

Después enciende la base (Terminal 1, como arriba) y, antes de `npm run start:dev`, crea las tablas y carga los datos una sola vez:

```bash
npm run db:migrate && npm run db:seed
```

Guía detallada y errores comunes: [`docs/LEVANTAR-EN-LOCAL.md`](https://github.com/rapser/kusitrip-api-rest/blob/develop/docs/LEVANTAR-EN-LOCAL.md) del API.

### Ver las llamadas al API

Mientras la app corre desde Xcode, la consola muestra cada request y response:

```
────────────────────────────────────────────────────────────
⬆️ REQUEST  POST https://kusitrip-api-rest.onrender.com/auth/login
Headers:
  Accept: application/json
  Content-Type: application/json
Body:
{
  "email" : "usuario@kusitrip.com",
  "password" : "•••"
}
────────────────────────────────────────────────────────────
✅ RESPONSE 200 · GET https://kusitrip-api-rest.onrender.com/auth/me · 569 ms
Content-Type: application/json; charset=utf-8
Body:
{ ... }
────────────────────────────────────────────────────────────
```

Detalles en [Capa de red → NetworkLogger](#networklogger).

---

## Qué se puede hacer en la app

| Pantalla | Operaciones | Endpoints |
|---|---|---|
| **Login** | Iniciar sesión con email y contraseña. Ir a registro | `POST /auth/login` |
| **Registro** | Crear cuenta (nombre, apellido, email, contraseña ≥ 8 caracteres y su confirmación). Entra directo a la app | `POST /auth/register` |
| **Splash** | Si hay sesión guardada, entra directo a las pestañas (~1 s) y valida la sesión en segundo plano | `GET /auth/me` |
| **Inicio** | Ver categorías, principales destinos y carrusel de actividades destacadas. Marcar favoritos. Deslizar hacia abajo para recargar | `GET /home` |
| **Destinos** | Listar destinos, filtrar por país con chips y buscar por nombre o país | `GET /destinations` |
| **Detalle de destino** | Ver las actividades del destino y filtrarlas por categoría. Marcar favoritos | `GET /destinations/:id`, `GET /destinations/:id/activities` |
| **Detalle de actividad** | Galería de fotos, valoración, duración, idioma, punto de encuentro, qué incluye, cancelación gratuita, opiniones y actividades relacionadas. Marcar favorito. Botón **Reservar** | `GET /activities/:id`, `/related`, `/reviews` |
| **Reservar** | Elegir fecha (desde hoy hasta un año), hora y número de personas. El total se calcula al instante. Confirmar | `POST /bookings` |
| **Confirmación** | Código de reserva (`KUSI-######`), resumen y total pagado | — |
| **Buscar** | Búsqueda en vivo de actividades y destinos mientras escribes (con *debounce* de 400 ms). Búsquedas populares y destinos destacados como sugerencias | `GET /search?q=` |
| **Favoritos** | Ver las actividades guardadas, ordenadas por fecha de guardado. Abrir su detalle. Funciona sin conexión | `GET/POST/DELETE /favorites` |
| **Perfil** | Ver nombre, email y "miembro desde". Ir a **Mis reservas**. Cerrar sesión (con confirmación) | `POST /auth/logout` |
| **Mis reservas** | Ver todas las reservas con su estado. Cancelar una deslizando la fila (con confirmación). Deslizar hacia abajo para recargar | `GET /bookings`, `PATCH /bookings/:id/cancel` |

Comportamientos transversales:

- **Sesión persistente e inicio instantáneo:** al abrir la app no hay que volver a iniciar sesión, y no se espera al servidor: se muestra el último perfil guardado mientras `/auth/me` valida la sesión. Si la sesión ya no es válida, vuelve al login.
- **Loader a pantalla completa** al iniciar sesión, crear cuenta, confirmar una reserva y cerrar sesión.
- **Cerrar sesión es inmediato:** la sesión termina en el teléfono al instante y el token se revoca en el API en segundo plano.
- **Renovación de token transparente:** el access token dura 15 minutos. Cuando el API responde 401, la app lo renueva con el refresh token y repite la petición sin que el usuario lo note. Si el refresh también falla, vuelve al login.
- **Favoritos sincronizados:** se guardan al instante en el teléfono y luego se envían al servidor. Al iniciar sesión en otro dispositivo aparecen los mismos.
- **Errores legibles:** sin conexión, timeout o errores del API (por ejemplo "La fecha de la actividad debe ser posterior a hoy") se muestran en español con un botón **Reintentar**.

---

## Arquitectura

**Clean Architecture por feature.** Cada módulo tiene tres capas, y las dependencias apuntan siempre hacia el dominio:

```mermaid
flowchart LR
    subgraph Presentation
        V[View<br/>SwiftUI] --> VM[ViewModel<br/>@Observable]
    end
    subgraph Domain
        UC[UseCase] --> RP[[RepositoryProtocol]]
        M[Modelos de dominio]
    end
    subgraph Data
        RI[RepositoryImpl] --> E[Endpoint + DTO]
        RI --> MAP[Mapper DTO → Dominio]
    end
    VM --> UC
    RI -. implementa .-> RP
    E --> API[(APIClientProtocol<br/>Alamofire)]
```

| Capa | Contiene | Conoce a |
|---|---|---|
| **Presentation** | `View` (SwiftUI), `ViewModel` (`@Observable`, `@MainActor`), modelos `*UI` ya formateados para mostrar (precios, fechas, textos) y mappers Dominio → UI | Domain |
| **Domain** | Modelos de negocio (`Activity`, `Destination`, `User`, `BookingConfirmation`…), casos de uso y **protocolos** de repositorio. Swift puro: no importa SwiftUI, Alamofire ni SwiftData | Nadie |
| **Data** | Implementación de los repositorios, `Endpoint`s del API, DTOs `Decodable` y mappers DTO → Dominio | Domain y `Core/Network` |

**Tres modelos por entidad**, cada uno con su responsabilidad:

```
ActivityDTO  ──ActivityMapper.toDomain──▶  Activity  ──ActivityMapper.toUI──▶  ActivityUI
(JSON del API)                             (negocio)                           (lista para la vista: "US$ 45.00", "3 h", "4,8")
```

Si el API cambia un campo, solo cambian el DTO y su mapper. Si cambia cómo se muestra un precio, solo cambia el modelo UI.

### Estructura de carpetas

```
KusiTrip/
├── KusiTripApp.swift          # @main: contenedor SwiftData, splash, restaurar sesión, escucha del EventBus
├── App/
│   ├── AppDependencies.swift  # Composition root: APIClient, AuthSession, configuración
│   ├── AppCoordinator.swift   # Estado global de autenticación (login ↔ tabs)
│   ├── AppRoute.swift         # Rutas de navegación tipadas
│   ├── MainTabView.swift      # 5 tabs, cada uno con su NavigationStack
│   └── SplashView.swift
├── Core/
│   ├── EventBus/              # Bus de eventos (actor + AsyncStream)
│   ├── Network/               # Única capa que importa Alamofire
│   │   └── Auth/              # Token en Keychain, authenticator, sesión
│   ├── SharedModels/          # Activity, Destination, Category, Review (DTO / Domain / UI / Mapper)
│   ├── Storage/               # KeychainStore genérico (token y perfil)
│   └── Extensions/            # Colores, precios, fechas ISO 8601, modificadores de vista
├── DesignSystem/Components/   # ActivityCard, DestinationCard, RemoteImage, ErrorStateView…
└── Features/
    ├── Auth/                  # Login, registro, restaurar sesión
    ├── Home/
    ├── Destinations/
    ├── ActivityDetail/
    ├── Booking/               # Reservar, confirmación, mis reservas
    ├── Search/
    ├── Wishlist/              # Favoritos (SwiftData + sincronización)
    └── Profile/
```

Cada feature repite la misma forma:

```
Features/Home/
├── Data/
│   ├── DTO/HomeDTO.swift
│   ├── Endpoint/Endpoint+Home.swift
│   └── Repository/HomeRepositoryImpl.swift
├── Domain/
│   ├── Model/HomeData.swift
│   ├── Repository/HomeRepositoryProtocol.swift
│   └── UseCase/GetHomeDataUseCase.swift
└── Presentation/
    ├── View/HomeView.swift
    └── ViewModel/HomeViewModel.swift
```

### Ejemplo de flujo completo: abrir el Inicio

1. `HomeView` ejecuta `.task { await viewModel.load() }` al aparecer.
2. `HomeViewModel.load()` marca `isLoading = true` y llama a `GetHomeDataUseCase.execute()`.
3. El caso de uso pide los datos a `HomeRepositoryProtocol` y agrega la categoría "Todos" al inicio (regla de negocio).
4. `HomeRepositoryImpl` envía `Endpoint.home` por `APIClientProtocol` y decodifica `HomeDTO`.
5. Los mappers convierten DTO → Dominio y el ViewModel convierte Dominio → UI.
6. Al asignar `destinations`, `featuredActivities` y `categories`, `@Observable` redibuja solo las vistas que leen esas propiedades.

---

## Módulos

| Módulo | Casos de uso | Repositorio (protocolo → implementación) | Notas |
|---|---|---|---|
| **Auth** | `LoginUseCase`, `RegisterUseCase`, `RestoreSessionUseCase` | `AuthRepositoryProtocol` → `AuthRepositoryImpl` | Validaciones en el dominio: campos vacíos, email, contraseña ≥ 8, confirmación. Normaliza el email (trim + minúsculas). Al autenticarse guarda el token en `AuthSession` |
| **Home** | `GetHomeDataUseCase` | `HomeRepositoryProtocol` → `HomeRepositoryImpl` | Una sola llamada (`/home`) trae categorías, destinos y destacadas |
| **Destinations** | `GetDestinationsUseCase` | `DestinationsRepositoryProtocol` → `DestinationsRepositoryImpl` | Lista y detalle. El detalle carga destino y actividades **en paralelo** (`async let`). Los filtros por país, texto y categoría se aplican en el ViewModel, sin volver a llamar al API |
| **ActivityDetail** | `GetActivityDetailUseCase` | `ActivityRepositoryProtocol` → `ActivityRepositoryImpl` | Actividad, relacionadas y opiniones en paralelo. Si fallan relacionadas u opiniones, el detalle se muestra igual |
| **Booking** | `CreateBookingUseCase`, `GetBookingsUseCase` | `BookingRepositoryProtocol` → `BookingRepositoryImpl` | El precio lo calcula el servidor con el catálogo (la app no envía precios). Publica `.bookingConfirmed` en el EventBus |
| **Search** | `SearchUseCase` | `SearchRepositoryProtocol` → `SearchRepositoryImpl` | Búsqueda con debounce y cancelación de la búsqueda anterior |
| **Wishlist** | — | `FavoritesRepositoryProtocol` → `FavoritesRepositoryImpl` | La vista lee SwiftData con `@Query`. `FavoritesSyncService` sincroniza con el API |
| **Profile** | `LogoutUseCase` | Usa `AuthRepositoryProtocol` | Revoca el refresh token en el API, borra el Keychain y publica `.logoutRequested` |

---

## Navegación

- **`AppCoordinator`** (`@Observable`) guarda `isAuthenticated` y `currentUser`. `KusiTripApp` muestra `LoginView` o `MainTabView` según ese estado. No hay navegación imperativa: cambiar el estado cambia la pantalla.
- **`MainTabView`** tiene 5 tabs: Inicio, Destinos, Buscar, Favoritos y Perfil. Cada tab tiene su propio `NavigationStack` con su `NavigationPath`, así que cada pestaña recuerda dónde estabas.
- **`AppRoute`** es un `enum Hashable` con todas las rutas (`activityDetail(id:)`, `destinationDetail(id:)`, `booking(activityId:)`, `bookingConfirmation(...)`, `myBookings`). Las vistas navegan con `NavigationLink(value: AppRoute...)` y un único `routeDestination(_:)` decide qué vista construir. Agregar una pantalla es agregar un `case`.
- **El coordinador reacciona a eventos** (`.loginSuccess`, `.logoutRequested`, `.sessionExpired`): ninguna vista le pide directamente que cambie de pantalla.

---

## Reactividad y concurrencia

### Observation (`@Observable`)

Todos los ViewModels y el `AppCoordinator` usan la macro `@Observable` (iOS 17+), no `ObservableObject`/`@Published`:

- SwiftUI rastrea **qué propiedades lee cada vista** y solo la redibuja cuando cambian esas. Por ejemplo, cambiar `isLoading` no redibuja la lista de destinos.
- Las vistas los guardan con `@State private var viewModel = HomeViewModel()`, y el coordinador se comparte con `.environment(coordinator)`.
- Hay propiedades derivadas sin estado duplicado: `BookingViewModel.totalPrice` (precio × personas), `DestinationsViewModel.countries` y `DestinationDetailViewModel.availableCategories` se calculan a partir de los datos.
- Los filtros reaccionan con `didSet`: escribir en el buscador de Destinos o elegir un país vuelve a filtrar al instante.

### Swift Concurrency

- **`@MainActor` por defecto** (`SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor`): la UI y los ViewModels corren en el hilo principal sin anotaciones. Lo que debe correr fuera (red, DTOs, Keychain, logger) se marca `nonisolated` y `Sendable`, y el compilador verifica que no haya *data races*.
- **async/await de punta a punta:** `View.task` → ViewModel → UseCase → Repository → `APIClient.send` (que usa `serializingData` de Alamofire). No hay callbacks ni Combine.
- **Cargas en paralelo con `async let`:** el detalle de actividad pide actividad, relacionadas y opiniones a la vez.
- **Cancelación estructurada:** las tareas de `.task` se cancelan solas al salir de la pantalla. La búsqueda cancela la anterior en cada tecla y espera 400 ms antes de llamar al API (*debounce*).
- **Restaurar sesión sin esperar a la red:** con el perfil guardado en el Keychain, las pestañas aparecen en cuanto termina el splash (500 ms mínimo, para empalmar con la pantalla de lanzamiento del sistema) y `/auth/me` corre en una `Task` aparte. Si no hay perfil guardado (sesiones de versiones anteriores), el splash espera como máximo 4 s con un `TaskGroup`.
- **`.refreshable`:** en Inicio y Mis reservas se recarga deslizando hacia abajo.

### EventBus

Comunicación entre módulos sin que se conozcan entre sí ([`Core/EventBus`](KusiTrip/Core/EventBus)):

```swift
actor EventBus {                          // actor: thread-safe sin locks
    func subscribe() -> AsyncStream<AppEvent>
    func send(_ event: AppEvent)
}
```

| Evento | Lo publica | Lo escuchan |
|---|---|---|
| `.loginSuccess(userUI:)` | Login, Registro, restaurar sesión | `AppCoordinator` (muestra los tabs) y `FavoritesSyncService` (descarga favoritos) |
| `.logoutStarted` | `LogoutUseCase` | `AppCoordinator` (muestra el loader "Cerrando sesión…") |
| `.logoutRequested` | `LogoutUseCase` | `AppCoordinator` (vuelve al login) y `FavoritesSyncService` (borra favoritos locales) |
| `.sessionExpired` | `KusiAuthenticator` (refresh token rechazado) o `AuthRepositoryImpl` (`/auth/me` con sesión revocada) | `AppCoordinator` (borra la sesión y vuelve al login) |
| `.favoriteToggled(activityId:isFavorite:)` | Tarjetas y detalle al tocar el corazón | `FavoritesSyncService` (lo envía al API) |
| `.bookingConfirmed(...)` | `BookingViewModel` | — (punto de extensión, por ejemplo para analítica) |

Las vistas se suscriben con el modificador `.onEventBus { event in ... }`, que consume el `AsyncStream` dentro de un `.task`. Al desaparecer la vista, el stream termina y el actor elimina la suscripción.

La raíz de la app tiene dos suscripciones separadas: una para el coordinador y otra para `FavoritesSyncService`. Así, una sincronización de favoritos lenta (llama al API) nunca retrasa la navegación de login o logout.

### Favoritos: UI optimista + sincronización

```
Tocar ♥ → SwiftData (al instante, @Query redibuja todas las vistas) → .favoriteToggled → FavoritesSyncService → POST/DELETE /favorites
                                                                                                    └─ si falla: descarga del servidor y revierte
```

- La UI nunca espera a la red: `@Query` en Inicio, detalle y Favoritos se actualiza solo en todas las pantallas a la vez.
- Al iniciar sesión, el servidor es la fuente de verdad: se reemplazan los favoritos locales por los del usuario.
- Al cerrar sesión se borran, para que el siguiente usuario no vea los del anterior.

---

## Capa de red

`Core/Network/` es la **única** carpeta que importa Alamofire. Los features solo conocen `APIClientProtocol` y `Endpoint`.

| Pieza | Responsabilidad |
|---|---|
| `Endpoint` | Describe una llamada: path, método (enum propio, para que los features no importen Alamofire), query, body `Encodable` y si requiere autenticación. Cada feature declara los suyos en `Data/Endpoint/Endpoint+<Feature>.swift`, por ejemplo `Endpoint.home` o `.search(query:)` |
| `APIClientProtocol` / `AlamofireAPIClient` | `send(_:as:)` envía, valida status 2xx y decodifica. Las rutas con `requiresAuth` pasan por el interceptor de autenticación |
| `APIConfiguration` | URL base (leída de `API_BASE_URL` en el `Info.plist`) y timeout de 120 s (Render Free puede tardar ~100 s en despertar) |
| `APIError` | Traduce los fallos a mensajes en español. Si el API responde su envelope `{ error: { code, message } }`, usa ese mensaje. Distingue sin conexión, timeout, 401 y errores de decodificación |
| `AuthSession` | Dueña de la credencial: mantiene sincronizados el Keychain y el interceptor al iniciar o cerrar sesión |
| `KusiAuthenticator` | `Authenticator` de Alamofire: agrega `Authorization: Bearer`, y ante un 401 llama a `POST /auth/refresh`. `AuthenticationInterceptor` garantiza **un solo refresh a la vez** y reintenta las peticiones que esperaban. Si el refresh devuelve 401, borra la sesión y publica `.sessionExpired` |
| `KeychainTokenStore` | Guarda access y refresh token en el Keychain (`AfterFirstUnlockThisDeviceOnly`), sobre el genérico `KeychainStore<Value: Codable>` de `Core/Storage` |
| `NetworkLogger` | Ver abajo |

### NetworkLogger

`EventMonitor` de Alamofire que imprime en la consola de Xcode cada request (método, URL, headers, body) y su response (status, duración en ms, body en JSON formateado), con `✅` o `❌` según el status:

- Registra cada intento: un 401, el `POST /auth/refresh` y el reintento aparecen como entradas separadas.
- Oculta el header `Authorization`, las contraseñas y los tokens (`•••`).
- Recorta los bodies de más de 10.000 caracteres.
- Usa `print` y no `os.Logger`, porque este último corta los mensajes en ~1 KB. La salida estándar solo se ve con la app corriendo desde Xcode; en el iPhone de un usuario se descarta.

---

## Persistencia local

| Qué | Dónde | Por qué |
|---|---|---|
| Access y refresh token | **Keychain** | Datos sensibles: cifrados por el sistema y sin copia en backups a otros dispositivos |
| Último perfil del usuario (`UserDTO`) | **Keychain** (`KeychainUserCache`) | Permite abrir la app sin esperar a `/auth/me`. Se borra al cerrar sesión |
| Favoritos | **SwiftData** (`FavoriteModel`, `@Attribute(.unique) activityId`) | Lectura instantánea y offline. `@Query` hace reactiva la UI |
| Fotos del catálogo | **Memoria** (`NSCache`, 100 MB) y **disco** (`URLCache`, 200 MB) en `RemoteImageLoader` | Una foto ya vista aparece al instante, también tras reabrir la app. Varias vistas que piden la misma foto comparten una sola descarga, y esa descarga sigue aunque la vista se redibuje |
| Todo lo demás (catálogo, reservas, perfil) | API | Siempre fresco; no se cachea |

Dev y Prod tienen bundle IDs distintos, así que cada app tiene su propio Keychain y su propia base SwiftData.

---

## Principios SOLID

| Principio | Cómo se aplica | Ejemplo |
|---|---|---|
| **S** — Responsabilidad única | Cada tipo hace una sola cosa: la vista dibuja, el ViewModel maneja el estado de la pantalla, el caso de uso aplica la regla de negocio, el repositorio obtiene datos y el mapper transforma | `RegisterUseCase` solo valida y registra. `APIError` solo traduce errores. `NetworkLogger` solo registra |
| **O** — Abierto/cerrado | Se extiende agregando, sin modificar lo existente | Un endpoint nuevo es una `extension Endpoint` en su feature, sin tocar `APIClient`. Una pantalla nueva es un `case` en `AppRoute`. Un listener nuevo se suscribe al `EventBus` sin tocar a quien publica |
| **L** — Sustitución de Liskov | Cualquier implementación de un protocolo sirve donde se espera el protocolo | `HomeRepositoryImpl` (API) puede reemplazarse por un repositorio en memoria en tests o previews sin cambiar el caso de uso. `KeychainTokenStore` por cualquier `TokenStore` |
| **I** — Segregación de interfaces | Protocolos pequeños y por feature, no un "repositorio gigante" | `SearchRepositoryProtocol` solo tiene `search(query:)`. `TokenStore` solo `load`, `save` y `clear`. `APIClientProtocol` solo dos `send` |
| **D** — Inversión de dependencias | Las capas altas dependen de abstracciones; las concretas se inyectan | Los casos de uso reciben `any XRepositoryProtocol` por `init`. Los repositorios reciben `any APIClientProtocol`, que por defecto viene de `AppDependencies` (el *composition root*). Ningún feature conoce Alamofire |

Cada ViewModel y caso de uso tiene dos `init`: uno sin parámetros, que usa las implementaciones reales, y otro que recibe las dependencias, para tests y previews.

---

## Design System

Componentes reutilizables en [`DesignSystem/Components`](KusiTrip/DesignSystem/Components):

| Componente | Uso |
|---|---|
| `ActivityCard` | Tarjeta de actividad para carruseles: foto, categoría, título, valoración, precio y favorito. Tamaño fijo (248 × 348) para que las tarjetas no se superpongan |
| `DestinationCard` | Tarjeta de destino con foto y número de actividades |
| `RemoteImage` | Foto remota con recorte correcto. Mientras descarga muestra un bloque con brillo, la foto aparece con un fundido y, si falla, reintenta dos veces (a 1 s y 3 s) antes de mostrar el ícono de "sin foto". Descarga con `RemoteImageLoader` |
| `CategoryChipView`, `SearchFieldView`, `StarRatingView`, `PriceTagView`, `PrimaryButton`, `KusiScreenHeader` | Piezas de UI comunes |
| `ErrorStateView` | Mensaje de error con botón **Reintentar** (async) |
| `KusiLoadingOverlay` | Loader a pantalla completa: fondo difuminado, logo con anillo animado en los colores de la marca y mensaje. Se usa con `.kusiLoadingOverlay(isPresented:message:)`, bloquea los toques y queda visible al menos 700 ms para no parpadear. Respeta *Reducir movimiento* |
| `SkeletonBlock` + `.kusiShimmer()` | Skeleton de carga: bloques grises con la forma del contenido y un brillo que los recorre. `.kusiShimmer()` se aplica una vez al contenedor para que el brillo vaya sincronizado. Lo usan todas las pantallas que cargan contenido del API: Inicio, Destinos, Detalle de destino, Detalle de actividad, Mis reservas y Buscar. Login, Registro y Reserva son acciones y usan `KusiLoadingOverlay`. Respeta *Reducir movimiento* |

Paleta en `Color+KusiTrip.swift`: `kusiPrimary` (amarillo `#FFC53D`), `kusiAccent` (naranja `#FF6B3D`), `kusiTextPrimary` (azul noche `#1B2A49`), además de fondo, superficie, bordes y rojo de descuento. Modificador `.kusiCard()` para tarjetas con fondo, esquinas y sombra.

---

## Ambientes

| Scheme | API | Bundle ID | Nombre e ícono | Configuraciones |
|---|---|---|---|---|
| **KusiTrip-Dev** | `http://localhost:3000` (API en tu Mac, ver [Ambiente dev](#ambiente-dev-antes-de-pulsar-run)) | `com.rapser.kusitrip.dev` | "KusiTrip Dev", ícono con franja DEV | `Debug-Dev` / `Release-Dev` |
| **KusiTrip** | `https://kusitrip-api-rest.onrender.com` (Render + Supabase) | `com.rapser.kusitrip` | "KusiTrip" | `Debug` / `Release` |

- Cada ambiente es una app distinta: se pueden tener las dos instaladas a la vez, cada una con su sesión y sus favoritos.
- Los valores de cada ambiente están en [`Configuration/Dev.xcconfig`](Configuration/Dev.xcconfig) y [`Configuration/Prod.xcconfig`](Configuration/Prod.xcconfig): URL del API, bundle ID, nombre visible e ícono. `API_BASE_URL` llega al código vía `Kusi-Info.plist`. Para agregar un ambiente (por ejemplo QA), se crea otro `.xcconfig` con su configuración y su scheme.
- Render (plan Free) se duerme sin uso: la primera petición puede tardar hasta ~2 min.
- En un iPhone físico, `localhost` es el propio teléfono: para Dev cambia `API_BASE_URL` en `Dev.xcconfig` por la IP de tu Mac (por ejemplo `http:/$()/192.168.1.20:3000`; el `$()` evita que `//` se lea como comentario).

---

## Pendientes conocidos

> 🚀 Antes de publicar en la App Store, sigue el checklist [**Salida a producción**](https://github.com/rapser/kusitrip-api-rest/blob/develop/docs/SALIDA-A-PRODUCCION.md) del API: limpiar los datos de prueba de Supabase, cambiar credenciales, permitir eliminar la cuenta desde la app (lo exige Apple) y archivar con el scheme **KusiTrip**.

Elementos de la UI que todavía no están conectados al API o no tienen acción:

- **¿Olvidaste tu contraseña?** (Login): el botón no hace nada; el API aún no tiene ese flujo.
- **Chips de categoría en Inicio:** se muestran, pero no filtran.
- **"Cómo nos valoran 9,1/10 · +5.000.000 opiniones"** (Inicio y Perfil) y las **búsquedas populares** (Buscar) son textos fijos.
- **"Agregar a Favoritos"** en la confirmación de reserva solo cierra la pantalla.
- **Credenciales de demo** visibles en el Login: útiles para pruebas, hay que quitarlas antes de publicar en la App Store.
- No hay target de tests en la app todavía. La arquitectura ya lo permite: cada caso de uso y ViewModel recibe sus dependencias por `init`.
