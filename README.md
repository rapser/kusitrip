# KusiTrip

App iOS (SwiftUI, Clean Architecture por feature) de visitas guiadas y excursiones en Perú y Sudamérica.

## Cómo correr la app

En Xcode, elige el scheme en el selector de arriba (junto al simulador) y pulsa Run (`Cmd + R`):

| Scheme | Se conecta a | Base de datos | ¿Hay que correr algo en la Terminal? |
|---|---|---|---|
| **KusiTrip** (prod) | API en Render | Supabase | No |
| **KusiTrip-Dev** (dev) | API en tu Mac (`http://localhost:3000`) | PostgreSQL local | **Sí**, ver abajo |

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

## API

Los datos vienen de [kusitrip-api-rest](https://github.com/rapser/kusitrip-api-rest) (NestJS + Supabase) y se consumen con **Alamofire**.

- Hay un scheme por ambiente. Elige uno en el selector de Xcode (junto al simulador) y pulsa Run:

  | Scheme | API | Bundle ID | Nombre e ícono | Configuraciones |
  |---|---|---|---|---|
  | **KusiTrip-Dev** | `http://localhost:3000` (API en tu Mac, ver [Ambiente dev](#ambiente-dev-antes-de-pulsar-run)) | `com.rapser.kusitrip.dev` | "KusiTrip Dev", ícono con franja DEV | `Debug-Dev` / `Release-Dev` |
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
