# Easy messaging

- The `easy_messaging` provides an easy way of handling the Firebase Cloud Messaging service.
- Supports topic subscriptions.

## TODO

- subscribe topic of

  - all and each platform( android, ios, web, windows, macos)

- Send push notification Using Http Api v1

  - send bunch of message; make it optional; default is 128;
  - return success tokens and error tokens in an array.

- `fcm tokens` are saved under `fcm-tokens/{uid}` in realtime database.

## Overview

- To send push notification to a device token from Flutter, the `access token` for HTTP API v1 is required. There is no way to get one securely.

  - It is state in the official document - [Update authorization of send requests](https://firebase.google.com/docs/cloud-messaging/migrate-v1#update-authorization-of-send-requests): `HTTP v1 messages must be sent through a trusted environment such as your app server or Cloud Functions for Firebase using the HTTP protocol or the Admin SDK to build message requests. Sending directly from client app logic carries extreme security risk and is not supported.`
  - Using the service account to get the access token for HTTP API v1 is very insecure and not recommended.
  - For this reason, to send push notifications, we use `easy_engine` and cloud functions. See the installation.

- It is stated in the official document - [Topic messaging on Flutter](https://firebase.google.com/docs/cloud-messaging/flutter/topic-messaging): `One app instance can be subscribed to no more than 2000 topic`.
  - So, this package supports topic subscription.

## Install

### Security rules

```json
    "fcm-tokens": {
      ".read": true,
      "$token": {
        ".write": "newData.val() === auth.uid",
      },
      ".indexOn": [".value"],
    },
    "fcm-subscriptions": {
      ".read": true,
      "$subscriptionId": {
        "$uid": {
          ".write": "$uid === auth.uid"
        }
      }
    },
```

## Logic

- Save the tokens in the realtime database only when the user signs in.
- Subscribe to `all` and platform even the user is not signed in.
- When the user signs out, and signs in another user, the same token will be saved into the another user.

## How to get the tokens of multiple users

- You can get the tokens of the users by passing the uid of them.

```dart
MessagingService.instance.getTokens([
  'vysiFTQS1ZXSnvS3UnxfeJEpCWN2',
  'Jkihj9GMRoNeZ1WXQ5FHMOr3E4c2',
]);
```
