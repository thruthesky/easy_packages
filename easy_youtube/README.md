# Easy Youtube

This package provide an easy way to handle youtube video.



## How to get the API Key

- Enable `YouTube Data API v3` into your project from GCP.
- Create an API Key from GCP.

## How to use


How to get youtube video id

```dart
final youtube =
    Youtube(url: 'https://www.youtube.com/watch?v=YBmFxBb9U6g');

print('id: ${youtube.getVideoId()}');
```

How to get youtube video information

```dart
final youtube =
    Youtube(url: 'https://www.youtube.com/watch?v=YBmFxBb9U6g');

final snippet = await youtube.getSnippet(apiKey: '___xxx___');

print('snippet: $snippet');
```