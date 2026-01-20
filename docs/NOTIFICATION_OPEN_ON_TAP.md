# Sending Notifications That Auto-Open on Tap

When users **tap a push notification**, the app can open a specific screen and mark it as read. Use the **`data`** payload with `action`, `screen`, and `params`.

**Allowed `screen` values and params:** see [NOTIFICATION_SCREENS.md](./NOTIFICATION_SCREENS.md). The app validates `data.screen` and falls back to `/(stack)/notifications` if it’s not allowed.

---

## 1. Data Payload (Backend)

The backend **always injects `notificationId`** into the push payload. You only set `action`, `screen`, `params`, `url`, and `meta`.

### For in-app navigation

```ts
data: {
  action: 'NAVIGATE',
  screen: '/(protected)/notifications',   // or /help, /(stack)/settings, etc.
  params: { id: 'abc', tab: 'profile' },  // optional, whatever the screen needs
  url: null,
  meta: { source: 'broadcast' },
}
```

### For external link

```ts
data: {
  action: 'OPEN_EXTERNAL',
  screen: null,
  params: null,
  url: 'https://example.com/page',
  meta: null,
}
```

### For in-app WebView

```ts
data: {
  action: 'OPEN_WEBVIEW',
  screen: null,
  params: null,
  url: 'https://yoursite.com/announcement/123',
  meta: null,
}
```

### No navigation (only mark as read)

```ts
data: {
  action: 'NONE',
  screen: null,
  params: null,
  url: null,
  meta: { event: 'REMINDER' },
}
```

---

## 2. Backend: Where to Put `data`

### `sendNotification()` (e.g. triggers, test, admin)

```ts
import { sendNotification } from "@/services/notification/notification.service.js";

await sendNotification(
    {
        title: "New message",
        body: "You have a new message. Tap to open.",
        type: "SYSTEM",
        targetType: "USER",
        targetUserId: userId,
        data: {
            action: "NAVIGATE",
            screen: "/(protected)/notifications",
            params: { highlightId: "msg-123" },
            url: null,
            meta: { type: "chat" },
        },
        createdByActorType: "SYSTEM",
    },
    { ipAddress, userAgent, actorId: userId }
);
```

### Admin broadcast / system announcement

`data` is optional in the request body. If you omit it, the service uses `action: 'NONE'`. To open a screen:

**POST /api/v1/admin/notifications/broadcast**

```json
{
    "title": "New feature",
    "body": "Check out the new help section.",
    "data": {
        "action": "NAVIGATE",
        "screen": "/(stack)/help",
        "params": {},
        "url": null,
        "meta": null
    }
}
```

---

## 3. `screen` Values (Expo Router)

Use your real file paths. Examples:

| Screen              | `screen` value (typical)     |
| ------------------- | ---------------------------- |
| Notifications       | `/(protected)/notifications` |
| Help                | `/(stack)/help`              |
| Settings            | `/(stack)/settings`          |
| Profile             | `/(stack)/(tabs)/profile`    |
| Home                | `/(stack)/(tabs)`            |
| Post/Listing detail | `/(stack)/(tabs)/post`       |

`screen` must start with `/` or `(` so the app accepts it. The app navigates with:

```ts
router.push({ pathname: data.screen, params: data.params || {} });
```

---

## 4. Long or Rich Data

Expo recommends **&lt; 4KB** for the whole push payload. For large or complex data:

1. **Store full content on your API** (e.g. notification or message by id).
2. **Put only IDs in `params`**:
    ```ts
    data: {
      action: 'NAVIGATE',
      screen: '/(stack)/(tabs)/post',
      params: { id: 'post-123' },
      url: null,
      meta: null,
    }
    ```
3. **On tap**, the app opens the screen with `params`. The screen uses `id` to fetch the full data from your API.

This keeps the push small and works for “long” or rich content.

---

## 5. What the App Does on Tap

1. **Mark as read**  
   Uses `data.notificationId` (injected by the backend) to call mark-as-read.

2. **Navigate**

    - `NAVIGATE`: `router.push({ pathname: data.screen, params: data.params })`
    - `OPEN_EXTERNAL`: `Linking.openURL(data.url)`
    - `OPEN_WEBVIEW`: `router.push({ pathname: '/webview', params: { url: data.url } })`
    - `DOWNLOAD`: placeholder.
    - `NONE`: no navigation.

3. **Refresh unread count**  
   Unread count is invalidated after handling the tap.

---

## 6. End-to-End Example

**Backend (e.g. “new listing” trigger):**

```ts
await sendNotification(
    {
        title: "New listing near you",
        body: "Cattle feed available. Tap to view.",
        type: "SYSTEM",
        targetType: "USER",
        targetUserId: userId,
        data: {
            action: "NAVIGATE",
            screen: "/(stack)/(tabs)/post",
            params: { id: listingId },
            url: null,
            meta: { type: "listing" },
        },
        createdByActorType: "SYSTEM",
    },
    { ipAddress, userAgent, actorId: userId }
);
```

**Expo push payload (after backend injects `notificationId`):**

```json
{
    "action": "NAVIGATE",
    "screen": "/(stack)/(tabs)/post",
    "params": { "id": "listing-xyz" },
    "url": null,
    "meta": { "type": "listing" },
    "notificationId": "uuid-from-db"
}
```

**On tap:**  
App marks the notification as read, then runs  
`router.push({ pathname: '/(stack)/(tabs)/post', params: { id: 'listing-xyz' } })`.  
The post screen reads `id` from `router.params` and fetches the full listing from your API.

---

## 7. Test API for open-on-tap

**POST /api/v1/user/notifications/test-open**  
Auth: Bearer &lt;user token&gt;

Sends a notification that opens the app on tap. All body fields are optional.

**No body (default: NAVIGATE to notifications):**

```bash
curl -X POST "https://your-api/api/v1/user/notifications/test-open" \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json"
```

**NAVIGATE to a specific screen:**

```json
{
    "action": "NAVIGATE",
    "screen": "/(stack)/help",
    "params": { "from": "test" }
}
```

**OPEN_EXTERNAL (browser):**

```json
{
    "action": "OPEN_EXTERNAL",
    "url": "https://example.com"
}
```

**OPEN_WEBVIEW (in-app browser):**

```json
{
    "action": "OPEN_WEBVIEW",
    "url": "https://yoursite.com/page"
}
```

Response: `{ "success": true, "action", "screen", "params", "url" }`

---

## 8. Summary

-   Put `action`, `screen`, `params`, `url`, `meta` in `data` when calling `sendNotification` or in the admin broadcast/announcement body.
-   Backend **adds `notificationId`** to the push payload; you do not set it.
-   Use `NAVIGATE` + `screen` + `params` for in-app screens.
-   For long/rich data: store it on the server, pass an `id` in `params`, and load details in the target screen.
