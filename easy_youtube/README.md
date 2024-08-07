# Easy Youtube

This package provide an easy way to handle youtube video.



## TODOs


- Get youtube id from any kinds of youtube url like
  - `https://www.youtube.com/watch?v=smdmEhkIRVc`
  - `https://youtu.be/smdmEhkIRVc?si=PDDwV_Giuu0pZb_0`


- Get youtube snippet data using Youtube Data API v3.



## Installation


## How to get the API Key

- Enable `YouTube Data API v3` into your project from GCP.
- Create an API Key from GCP.

## How to use


Get Youtube Video ID from any kinds of string or URL. A string may contains a youtube url. So, it can be a string of any content.

```dart
Youtube.extractVideoId('https://youtu.be/smdmEhkIRVc?si=PDDwV_Giuu0pZb_0'); // returns 'smdmEhkIRVc'
```


To get information of the youtube
```dart
Youtube.extractSnippet(id: 'yotube_id', key: '___api_key____');
```

- `https://www.googleapis.com/youtube/v3/videos?part=id%2C+snippet&id=ZZKZBC_Fv0k&key=____xxxx____`



