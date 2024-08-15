# SwiftUI video player iOS 14+, macOS 11+, tvOS 14+
### I am currently developing three open-source packages. Please star the repository if you believe continuing the development of this package is worthwhile. This will help me understand which package deserves more effort.

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FThe-Igor%2Fswiftui-loop-videoplayer%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/The-Igor/swiftui-loop-videoplayer)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FThe-Igor%2Fswiftui-loop-videoplayer%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/The-Igor/swiftui-loop-videoplayer)
## Why if we have Apple’s VideoPlayer ?!
Apple’s VideoPlayer offers a quick setup for video playback in SwiftUI but for example it doesn’t allow you to hide or customize the default video controls UI, limiting its use for custom scenarios. In contrast, this solution provides full control over playback, including the ability to disable or hide UI elements, making it suitable for background videos, tooltips, and video hints. Additionally, it supports advanced features like seamless looping and real-time filter application, adding vector graphics upon the video stream etc. This package uses a declarative approach to declare parameters for the video component based on building blocks. This implementation might give you some insights into how SwiftUI works under the hood. You can also pass parameters in the common way.

## Disclaimer on Video Sources like YouTube
Please note that using videos from URLs requires ensuring that you have the right to use and stream these videos. Videos hosted on platforms like YouTube cannot be used directly due to restrictions in their terms of service. Always ensure the video URL is compliant with copyright laws and platform policies.


## [SwiftUI video player example](https://github.com/The-Igor/swiftui-loop-videoplayer-example)

![The concept](https://github.com/The-Igor/swiftui-loop-videoplayer-example/blob/main/swiftui-loop-videoplayer-example/img/swiftui_video_player.gif) 

## API Specifications

| Property/Method                       | Type                          | Description                                                            |
|---------------------------------------|-------------------------------|------------------------------------------------------------------------|
| `settings`                            | `VideoSettings`                    | A struct containing configuration settings for the video player.       |
| `command`                             | `Binding<PlaybackCommand>`    | A binding to control playback actions (play, pause, or seek).          |
| `init(fileName:ext:gravity:timePublishing: ` <br> ` eColor:eFontSize:command:)` | Constructor       | Initializes the player with specific video parameters and playback command binding. |
| `init(settings: () -> VideoSettings, command:)` | Constructor | Initializes the player with a declarative settings block and playback command binding. |

## Commands

### Playback Commands

| Command                     | Description                                                                                                                                          |
|-----------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------|
| `play`                      | Command to play the video.                                                                                                                            |
| `pause`                     | Command to pause the video.                                                                                                                           |
| `seek(to: Double)`          | Command to seek to a specific time in the video. The parameter is the target position in seconds. If the time is negative, the playback will move to the start of the video. If the time exceeds the video's duration, the playback will move to the end of the video. If the time is within the video’s duration, the playback will move to the specified time. |
| `begin`                     | Command to position the video at the beginning.                                                                                                       |
| `end`                       | Command to position the video at the end.                                                                                                             |
| `mute`                      | Command to mute the video. By default, the player is muted.                                                                                           |
| `unmute`                    | Command to unmute the video.                                                                                                                          |
| `volume(Float)`             | Command to adjust the volume of the video playback. The `volume` parameter is a `Float` value between 0.0 (mute) and 1.0 (full volume). If a value outside this range is passed, it will be clamped to the nearest valid value (0.0 or 1.0). |
| `playbackSpeed(Float)`      | Command to adjust the playback speed of the video. The `speed` parameter is a `Float` value representing the playback speed (e.g., 1.0 for normal speed, 0.5 for half speed, 2.0 for double speed). If a negative value is passed, it will be clamped to 0.0. |
| `loop`                      | Command to enable looping of the video playback. By default, looping is enabled, so this command will have no effect if looping is already active.     |
| `unloop`                    | Command to disable looping of the video playback. This command will only take effect if the video is currently being looped.                                                                |

### Visual Adjustment Commands

| Command                     | Description                                                                                                                                          |
|-----------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------|
| `brightness(Float)`         | Command to adjust the brightness of the video playback. The `brightness` parameter is a `Float` value typically ranging from -1.0 (darkest) to 1.0 (brightest). Values outside this range will be clamped to the nearest valid value. |
| `contrast(Float)`           | Command to adjust the contrast of the video playback. The `contrast` parameter is a `Float` value typically ranging from 0.0 (no contrast) to 4.0 (high contrast). Values outside this range will be clamped to the nearest valid value. |
| `filter(CIFilter, clear: Bool)` | Applies a specific Core Image filter to the video. If `clear` is true, any existing filters on the stack are removed before applying the new filter; otherwise, the new filter is added to the existing stack. |
| `removeAllFilters`          | Command to remove all applied filters from the video playback.                                                                                        |

### Vector Graphics Commands

| Command                                      | Description                                                                                                                                          |
|----------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------|
| `addVector(ShapeLayerBuilderProtocol, clear: Bool)` | Command to add a vector graphic layer over the video stream. The `builder` parameter is an instance conforming to `ShapeLayerBuilderProtocol`. The `clear` parameter specifies whether to clear existing vector layers before adding the new one.                                                                                                           |
| `removeAllVectors`                           | Command to remove all vector graphic layers from the video stream.                                                                                    |

### Audio & Language Commands

| Command                     | Description                                                                                                                                          |
|-----------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------|
| `audioTrack(String)`        | Command to select a specific audio track based on language code. The `languageCode` parameter specifies the desired audio track's language (e.g., "en" for English). |
| `subtitles(String?)`        | Command to set subtitles to a specified language or turn them off. Pass a language code (e.g., "en" for English) to set subtitles, or `nil` to turn them off. |

## Player Events
| Event                              | Description                                                                                                                                       |
|------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------|
| `idle`                             | Represents a state where the player is idle, meaning it is not currently performing any action.                                                    |
| `seek(Bool, currentTime: Double)`  | Represents an end seek action within the player. The first parameter (`Bool`) indicates whether the seek was successful, and the second parameter (`currentTime`) provides the time (in seconds) to which the player is seeking. |


### Additional Notes on Adding and Removing Vector Graphics

When you use the `addVector` command, you can dynamically add a new vector graphic layer (such as a logo or animated vector) over the video stream. This is particularly useful for enhancing the user experience with overlays, such as branding elements, animated graphics.

**Adding a Vector Layer**:
   - The `addVector` command takes a `ShapeLayerBuilderProtocol` instance. This protocol defines the necessary method to build a `CAShapeLayer` based on the given geometry (frame, bounds).
   - The `clear` parameter determines whether existing vector layers should be removed before adding the new one. If set to `true`, all existing vector layers are cleared, and only the new layer will be displayed.
   - The vector layer will be laid out directly over the video stream, allowing it to appear as part of the video playback experience.

**Important Lifecycle Consideration**:
Integrating vector graphics into SwiftUI views, particularly during lifecycle events such as onAppear, requires careful consideration of underlying system behaviors. When vectors are added as the view appears, developers might encounter issues where the builder receives frame and bounds values of zero. This discrepancy stems from the inherent mismatch between the lifecycle of SwiftUI views and the lifecycle of UIView or NSView, depending on the platform. SwiftUI defers much of its view layout and rendering to a later stage in the view lifecycle. To mitigate these issues, a small delay can be introduced during onAppear. I'll try to add this command in the initial config later to cover the case when you need a vector layer at the very early stage of the video streaming.

### Additional Notes on Brightness and Contrast

- **Brightness and Contrast**: These settings function also filters but are managed separately from the filter stack. Adjustments to brightness and contrast are applied additionally and independently of the image filters.
- **Persistent Settings**: Changes to brightness and contrast do not reset when the filter stack is cleared. They remain at their last set values and must be adjusted or reset separately by the developer as needed.
- **Independent Management**: Developers should manage brightness and contrast adjustments through their dedicated methods or properties to ensure these settings are accurately reflected in the video output.

### Initializer Parameters Settings

| Name | Description | Default |
| --- | --- |  --- |
| **SourceName** | The URL or local filename of the video. If a valid URL (http or https) is provided, the video will be streamed from the URL. If not a URL, the system will check if a video with the given name exists in the local bundle. The local name provided can either include an extension or be without one. The system first checks if the local name contains an extension. If the local name includes an extension, it extracts this extension and uses it as the default. If the local name does not contain an extension, the system assigns a default extension of .mp4 The default file extension can be set up via Ext param. | - |
| **Ext** | File extension for the video, used when loading from local resources. This is optional when a URL is provided and the URL ends with the video file extension. | "mp4" |
| **Gravity** | How the video content should be resized to fit the player's bounds. | .resizeAspect |
| **TimePublishing** | Specifies the interval at which the player publishes the current playback time. If the parameter is passed during initialization, the player will publish the time according to the input settings. You can pass just `TimePublishing` without any value to use the default interval of 1 second, or you can pass a specific `CMTime` value to set a custom interval. | 1 second (CMTime with 1 second and preferred timescale of 600) |
| **EColor** | Error message text color. | .red |
| **EFontSize** | Size of the error text. | 17.0 |



In the core of this package, I use `AVQueuePlayer`. Here are the supported features that are automatically enabled by `AVQueuePlayer` without passing any extra parameters:

| Feature                                                                                                    | Description                                                                                                   |
|------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------|
| Hardware accelerator                                                                                       | `AVQueuePlayer` uses hardware acceleration by default where available.                                        |
| 4k/HDR/HDR10/HDR10+/Dolby Vision                                                                           | These high-definition and high-dynamic-range formats are natively supported by `AVQueuePlayer`.               |
| Multichannel Audio/Dolby Atmos/Spatial Audio                                                               | `AVQueuePlayer` supports advanced audio formats natively.                                                     |
| Text subtitle/Image subtitle/Closed Captions                                                               | Subtitle and caption tracks included in the video file are automatically detected and rendered.               |
| Automatically switch to multi-bitrate streams based on network                                             | Adaptive bitrate streaming is handled automatically by `AVQueuePlayer` when streaming from a source that supports it. |

## How to use the package
### 1. Create LoopPlayerView

```swift
LoopPlayerView(fileName: 'swipe')    
```

or in a declarative way

 ```swift
    LoopPlayerView{
            VideoSettings{
                SourceName("swipe")
                Ext("mp8") // Set default extension here If not provided then mp4 is default
                Gravity(.resizeAspectFill)
                TimePublishing()
                ErrorGroup{
                    EColor(.accentColor)
                    EFontSize(27)
                }
            }
        } 
        .onPlayerTimeChange { newTime in
            // Current video playback time
        }  
        .onPlayerEventChange { event in
            // Player event
        }
``` 
          
 ```swift            
       LoopPlayerView{
            VideoSettings{
                SourceName("swipe")
                Gravity(.resizeAspectFill)
                EFontSize(27)                  
            }
        } 
```  

```swift
LoopPlayerView{
    VideoSettings{
        SourceName('https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_ts/master.m3u8')
        ErrorGroup{
            EFontSize(27)
        }
    }
}
```

You can group error settings in group **ErrorGroup** or just pass all settings as a linear list of settings. You don't need to follow some specific order for settings, just pass in an arbitrary order you are interested in. The only required setting is now **SourceName**.


### Supported Video Types and Formats
The AVFoundation framework used in the package supports a wide range of video formats and codecs, including both file-based media and streaming protocols. Below is a list of supported video types, codecs, and streaming protocols organized into a grid according to Apple’s documentation. Sorry, didn’t check all codecs and files. Hope they are all work well.

| Supported File Types     | Supported Codecs | Supported Streaming Protocols      |
|--------------------------|------------------|-------------------------------------|
| **3GP**                  | **H.264**        | **HTTP Live Streaming (HLS)**       |
| `.3gp`, `.3g2`           | **H.265 (HEVC)** | `.m3u8`                             |
| **MKV** (Limited support)| **MPEG-4 Part 2**|                                     |
| `.mkv`                   | **AAC** (audio)  |                                     |
| **MP4**                  | **MP3** (audio)  |                                     |
| `.mp4`                   |                  |                                     |
| **MOV**                  |                  |                                     |
| `.mov`                   |                  |                                     |
| **M4V**                  |                  |                                     |
| `.m4v`                   |                  |                                     |

## Remote Video URLs
The package now supports using remote video URLs, allowing you to stream videos directly from web resources. This is an extension to the existing functionality that primarily focused on local video files. Here's how to specify a remote URL within the settings:

```swift
LoopPlayerView{
    VideoSettings{
        SourceName('https://example.com/video')
        Gravity(.resizeAspectFill)  // Video content fit
        ErrorGroup{
            EColor(.red)  // Error text color
            EFontSize(18)  // Error text font size
        }
    }
}
```

### Video Source Compatibility

| Video Source | Possible to Use | Comments |
| --- | --- | --- |
| YouTube | No | Violates YouTube's policy as it doesn't allow direct video streaming outside its platform. |
| Direct MP4 URLs | Yes | Directly accessible MP4 URLs can be used if they are hosted on servers that permit CORS. |
| HLS Streams | Yes | HLS streams are supported and can be used for live streaming purposes. |


## New Functionality: Playback Commands

The package now supports playback commands, allowing you to control video playback actions such as play, pause, and seek to specific times. 

```swift
struct VideoView: View {
    @State private var playbackCommand: PlaybackCommand = .play

    var body: some View {
        LoopPlayerView(
            {
                VideoSettings {
                    SourceName("swipe")
                }
            },
            command: $playbackCommand
        )
    }
}
```

## Practical idea for the package
You can introduce video hints about some functionality into the app, for example how to add positions to favorites. Put loop video hint into background or open as popup.

![The concept](https://github.com/The-Igor/swiftui-loop-videoplayer-example/blob/main/swiftui-loop-videoplayer-example/img/swiftui_video_hint.gif)

![The concept](https://github.com/The-Igor/swiftui-loop-videoplayer-example/blob/main/swiftui-loop-videoplayer-example/img/tip_video_swiftui.gif)
  
## Documentation(API)
- You need to have Xcode 13 installed in order to have access to Documentation Compiler (DocC)

- Go to Product > Build Documentation or **⌃⇧⌘ D**
