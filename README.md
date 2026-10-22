# KusiTrip

App iOS (SwiftUI, Clean Architecture por feature) de visitas guiadas y excursiones en Perú y Sudamérica.

## API

Los datos vienen de [kusitrip-api-rest](https://github.com/rapser/kusitrip-api-rest) (NestJS + Supabase) y se consumen con **Alamofire**.

- La URL base se define por configuración en el build setting `API_BASE_URL` del target (llega a la app vía `Kusi-Info.plist`):
  - **Debug:** `http://localhost:3000` (corre el API en local con `npm run start:dev`)
  - **Release:** `https://kusitrip-api-rest.onrender.com` (Render, plan Free: la primera petición tras un rato sin uso puede tardar hasta ~2 min; el timeout es de 120 s)
- `Core/Network/` es la única capa que importa Alamofire:
  - `AlamofireAPIClient` (`APIClientProtocol`): envía `Endpoint`s, valida el status y traduce el envelope de error del API a `APIError`.
  - `KusiAuthenticator` + `AuthenticationInterceptor`: agrega el bearer token y, ante un 401, rota el token con `POST /auth/refresh` una sola vez y reintenta las requests en cola.
  - `KeychainTokenStore`: guarda la sesión en el Keychain; al abrir la app se restaura con `GET /auth/me`.
- Cada feature declara sus endpoints en `Data/Endpoint/Endpoint+<Feature>.swift` y sus repositorios reciben `APIClientProtocol` por inyección (`AppDependencies` es el composition root).
- Favoritos: SwiftData sigue siendo la fuente local (UI instantánea y offline); `FavoritesSyncService` los sincroniza con `/favorites` escuchando el `EventBus`.

Usuario demo: `usuario@kusitrip.com` / `kusitrip123`
