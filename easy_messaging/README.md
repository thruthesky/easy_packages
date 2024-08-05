# Easy messaging

- The `easy_messaging` provides an easy way of handling the Firebase Cloud Messaging service.

- This packages works 


## TODO

- subscribe topic of
  - all and each platform( android, ios, web, windows, macos)



- Send push notification Using Http Api v1
  - send bunch of message; make it optional; default is 128;
  - return success tokens and error tokens in an array.


- `fcm tokens` are saved under `fcm_tokens/{uid}` in realtime database.



## Logic

- Save the tokens in the realtime database only when the user signs in.
- Subscribe to `all` and platform even the user is not signed in.
- When the user signs out, and signs in another user, the same token will be saved into the another user.



