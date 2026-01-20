# 🔔 Notifications & Firebase Setup (AGRIVET – Mobile)

This document describes the **complete, production-grade setup** for **Expo Push Notifications (Android)** using **Firebase Cloud Messaging (FCM)** in an **Expo Managed workflow with EAS Build (SDK 53+)**.

---

## 🧠 Architecture Overview

```
Mobile App (Expo)
   ↓ getExpoPushTokenAsync()
Expo Push Service
   ↓
Firebase Cloud Messaging (FCM)
   ↓
Android Device
```

### Key Principles

-   Mobile app never talks directly to Firebase
-   Expo servers handle push delivery
-   Firebase is configured at build time via EAS
-   Deprecated Expo CLI push commands are not used

---

## ✅ Requirements

-   Expo SDK ≥ 53
-   EAS Build configured
-   expo-notifications installed
-   Android package name finalized

```
com.agrivet.app
```

---

## 🔹 Step 1: Create Firebase Project

1. Open https://console.firebase.google.com
2. Create a new project (AGRIVET)
3. Add an Android app
4. Use package name exactly:

```
com.agrivet.app
```

---

## 🔹 Step 2: Download google-services.json

1. From Firebase Project Settings → General
2. Download `google-services.json`
3. Do NOT modify this file

---

## 🔹 Step 3: Add google-services.json to Expo Project

Place file at:

```
mobile/google-services.json
```

Update `app.json`:

```json
{
    "expo": {
        "android": {
            "package": "com.agrivet.app",
            "googleServicesFile": "./google-services.json"
        }
    }
}
```

Do NOT place file inside src/, assets/, or multiple locations.

---

## 🔹 Step 4: Enable Firebase Cloud Messaging

1. Firebase Console → Project Settings
2. Open Cloud Messaging
3. Ensure HTTP v1 API is enabled

No keys are required from this screen.

---

## 🔹 Step 5: Create Firebase Service Account

> This service account JSON will be used in **Step 6** to link Firebase with Expo, and also by your backend server.

1. Firebase Console → Project Settings → Service Accounts
2. Click **Generate new private key**
3. Download the JSON file (e.g., `firebase-adminsdk-xxxx.json`)

### Important Notes

-   This same file is used by **both Expo EAS and your backend**
-   Keep it secure - it contains private keys
-   Store it securely, do NOT commit to Git
-   You'll need this file for the next step

---

## 🔹 Step 6: Link Firebase Service Account with Expo (FCM V1)

> ⚠️ **MANDATORY** for Android push notifications in **Expo SDK 53+**.
> Without this, Expo can generate push tokens but **cannot send notifications**.

### ❗ Why this step is required

-   `google-services.json` configures **Firebase inside the app**
-   Expo Push Service runs **outside your app**
-   Expo must authenticate with Firebase using a **Service Account**
-   This authentication is managed **only via EAS Credentials**

If this step is skipped, you will see errors like:

-   `InvalidCredentials: Unable to retrieve the FCM server key`
-   Push tokens work, but notifications never arrive

---

### 📌 Prerequisites

-   ✅ Firebase project created (Step 1)
-   ✅ Android app added in Firebase (Step 1)
-   ✅ `google-services.json` configured (Step 3)
-   ✅ Firebase Service Account JSON downloaded (Step 5)
-   ✅ EAS CLI installed: `npm install -g eas-cli`
-   ✅ Logged into EAS: `eas login`

---

### 🔧 Instructions

1. **Run EAS credentials command:**

    ```bash
    npx eas credentials
    ```

2. **Select your project** (if prompted)

3. **Choose platform:** `android`

4. **Select:** `Push Notifications Setup`

5. **When prompted for FCM Server Key:**

    - Choose option to upload Service Account JSON
    - Provide the path to your `firebase-adminsdk-xxxx.json` file downloaded in Step 5
    - EAS will extract the necessary credentials automatically

6. **Verify setup:**
    ```bash
    eas credentials
    # Navigate to android → Push Notifications
    # Should show "FCM credentials configured"
    ```

### ✅ Success Indicators

-   EAS credentials shows FCM configured
-   No errors during EAS build
-   Push tokens can be generated
-   Backend can send notifications successfully

---

## 🔹 Step 7: Firebase Service Account for Backend

> The same service account JSON from Step 5 is also used by your backend server.

1. Place the `firebase-adminsdk-xxxx.json` in your backend project
2. Store it securely (use environment variables or secure vault)
3. Use it to initialize Firebase Admin SDK in your backend

### Backend Usage Example:

```typescript
import admin from "firebase-admin";
import serviceAccount from "./firebase-adminsdk-xxxx.json";

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount as admin.ServiceAccount),
});
```

### Important Notes

-   Same JSON file used for both Expo EAS (Step 6) and Backend (this step)
-   Used ONLY by backend servers
-   NEVER used inside mobile app
-   NEVER uploaded using Expo CLI (already done in Step 6)
-   Must remain secret and outside Git

---

## 🔹 Step 8: Expo Notifications Plugin

Ensure this exists in app.json:

```json
{
    "plugins": [
        [
            "expo-notifications",
            {
                "icon": "./assets/images/icon.png",
                "color": "#16a34a",
                "sounds": []
            }
        ]
    ]
}
```

---

## ❌ What NOT To Do

-   Do NOT install Firebase JS SDK
-   Do NOT initialize Firebase manually
-   Do NOT edit Gradle files
-   Do NOT use expo push:android:upload
-   Do NOT store Firebase secrets in env files

---

## 🔹 Step 9: Build With EAS (Required Once)

```bash
npx eas build --profile development --platform android
```

Required whenever Firebase config or package name changes.

---

## 🔹 Step 10: Get Expo Push Token (Code)

```ts
import * as Notifications from "expo-notifications";

const token = await Notifications.getExpoPushTokenAsync();
```

Expected:

-   No Firebase initialization errors
-   Valid Expo push token returned

---

## 🔹 Common Errors

### FirebaseApp is not initialized

Cause: google-services.json not compiled  
Fix: rebuild with EAS

### expo push:android:upload not supported

Cause: command deprecated  
Fix: ignore and use EAS

---

## ✅ Final Checklist

-   ✅ Firebase Android app exists
-   ✅ Package name matches everywhere (`com.agrivet.app`)
-   ✅ `google-services.json` placed correctly
-   ✅ Firebase Service Account JSON downloaded
-   ✅ FCM credentials linked with Expo via EAS
-   ✅ Service Account configured in backend
-   ✅ EAS build completed successfully

---

## 🏁 Summary

-   Firebase setup is one-time
-   Service account is backend-only
-   EAS handles all native configuration
-   Production ready
