# Notification screen contract (NAVIGATE action)

When `data.action === 'NAVIGATE'`, `data.screen` must be one of the **allowed** paths below. The app validates and resolves the screen in:

-   **In-app:** `notifications.tsx` → `handleNotificationPress`
-   **Push tap:** `usePushNotifications` (foreground, background, cold start)

If `data.screen` is missing or not allowed, the app opens **`/(stack)/notifications`** as a fallback.

---

## Supported `data.screen` values

Use these **exact** strings in `data.screen` when sending notifications (backend, admin, or triggers).

| `data.screen`                 | Description            | `data.params` (optional)                             |
| ----------------------------- | ---------------------- | ---------------------------------------------------- |
| `/(stack)/notifications`      | Notifications list     | `{}`                                                 |
| `/(stack)/help`               | Help & Support         | `{}`                                                 |
| `/(stack)/settings`           | Settings               | `{}`                                                 |
| `/(stack)/(tabs)`             | Home (tabs)            | `{}`                                                 |
| `/(stack)/(tabs)/post`        | Post tab               | `{}` or `{ id?: string }` when listing detail exists |
| `/(stack)/(tabs)/my-listings` | My listings            | `{}`                                                 |
| `/(stack)/(tabs)/profile`     | Profile                | `{}`                                                 |
| `/(protected)/edit-profile`   | Edit profile           | `{}`                                                 |
| `/(protected)/edit-address`   | Edit address           | `{}`                                                 |
| `/(public)/terms`             | Terms (public)         | `{}`                                                 |
| `/(protected)`                | Protected home (stack) | `{}`                                                 |

---

## Shortcuts (aliases)

These are accepted and mapped to the canonical screen:

| Sent as          | Resolved to              |
| ---------------- | ------------------------ |
| `/notifications` | `/(stack)/notifications` |
| `/help`          | `/(stack)/help`          |
| `/settings`      | `/(stack)/settings`      |

---

## Params shape

-   `data.params` must be a plain object or null/undefined (defaults to `{}`).
-   Params are passed to the screen via `router.push({ pathname, params })`. The screen reads them with `useLocalSearchParams()`.
-   For now, most screens use `{}`. When you add listing/product detail, use e.g. `params: { id: listingId }` and have that screen fetch by `id`.

---

## Adding a new screen

1. Add the **canonical** path to `ALLOWED_NOTIFICATION_SCREENS` in  
   `mobile/src/notifications/notification-routes.ts`.
2. Optionally add an alias in `SCREEN_ALIASES` (e.g. `/product` → `/(stack)/product/[id]` if you add that route).
3. Update this doc with the new row and any required `params`.

---

## Backend / admin usage

**`sendNotification` or admin broadcast/announcement:**

```ts
data: {
  action: 'NAVIGATE',
  screen: '/(stack)/help',
  params: {},
  url: null,
  meta: { source: 'broadcast' },
}
```

**Admin API (broadcast) body:**

```json
{
    "title": "New feature",
    "body": "Check the help section.",
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

## Validation module

-   **`isAllowedNotificationScreen(screen)`** – `true` if the screen is allowed.
-   **`resolveNotificationScreen(screen)`** – returns the screen if allowed, otherwise `/(stack)/notifications`.
-   **`ALLOWED_NOTIFICATION_SCREENS`** – readonly list of canonical paths.
-   **`NOTIFICATION_SCREEN_FALLBACK`** – `/(stack)/notifications`.

Defined in: `mobile/src/notifications/notification-routes.ts`.
