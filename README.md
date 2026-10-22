# KusiTrip

App iOS (SwiftUI, Clean Architecture por feature) de visitas guiadas y excursiones en Perú y Sudamérica.

## API

Los datos vienen de [kusitrip-api-rest](https://github.com/rapser/kusitrip-api-rest) (NestJS + Supabase) y se consumen con **Alamofire**.

- Hay un scheme por ambiente. Elige uno en el selector de Xcode (junto al simulador) y pulsa Run:

  | Scheme | API | Bundle ID | Nombre e ícono | Configuraciones |
  |---|---|---|---|---|
  | **KusiTrip-Dev** | `http://localhost:3000` (API en tu Mac: `npm run start:dev`) | `com.rapser.kusitrip.dev` | "KusiTrip Dev", ícono con franja DEV | `Debug-Dev` / `Release-Dev` |
  | **KusiTrip** | `https://kusitrip-api-rest.onrender.com` (Render + Supabase) | `com.rapser.kusitrip` | "KusiTrip" | `Debug` / `Release` |

  - Cada ambiente es una app distinta: se pueden tener las dos instaladas a la vez, cada una con su sesión (Keychain) y sus favoritos (SwiftData).
  - Los valores de cada ambiente están en [`Configuration/Dev.xcconfig`](Configuration/Dev.xcconfig) y [`Configuration/Prod.xcconfig`](Configuration/Prod.xcconfig). `API_BASE_URL` llega a la app vía `Kusi-Info.plist`.
  - Render (plan Free) se duerme sin uso: la primera petición puede tardar hasta ~2 min. El timeout es de 120 s.
  - En un iPhone físico, `localhost` es el propio teléfono: para Dev cambia `API_BASE_URL` en `Dev.xcconfig` por la IP de tu Mac (por ejemplo `http:/$()/192.168.1.20:3000`).
- `Core/Network/` es la única capa que importa Alamofire:
  - `AlamofireAPIClient` (`APIClientProtocol`): envía `Endpoint`s, valida el status y traduce el envelope de error del API a `APIError`.
  - `KusiAuthenticator` + `AuthenticationInterceptor`: agrega el bearer token y, ante un 401, rota el token con `POST /auth/refresh` una sola vez y reintenta las requests en cola.
  - `KeychainTokenStore`: guarda la sesión en el Keychain; al abrir la app se restaura con `GET /auth/me`.
  - `NetworkLogger` (`EventMonitor` de Alamofire): imprime en la consola de Xcode cada request (método, URL, headers, body) y su response (status, duración, body en JSON formateado). Oculta el `Authorization`, las contraseñas y los tokens, y recorta los bodies de más de 10.000 caracteres. Usa `print` porque `os.Logger` corta los mensajes en ~1 KB; fuera de Xcode esa salida se descarta.
- Cada feature declara sus endpoints en `Data/Endpoint/Endpoint+<Feature>.swift` y sus repositorios reciben `APIClientProtocol` por inyección (`AppDependencies` es el composition root).
- Favoritos: SwiftData sigue siendo la fuente local (UI instantánea y offline); `FavoritesSyncService` los sincroniza con `/favorites` escuchando el `EventBus`.

Usuario demo: `usuario@kusitrip.com` / `kusitrip123`
