enum SourceType {
  /// Opens up the device camera, letting the user to take a new picture.
  photoCamera,

  /// Opens the user's gallery to select a photo(s) and photo only.
  photoGallery,

  /// Open up the user's gallery to select a video(s) and video and some audio files only.
  videoGallery,

  /// Open up the device camera, letting the user take video from camera
  videoCamera,

  /// Open up the gallery folder for picking up any type of media
  mediaGallery,

  /// Open up file
  file,
}
