# SwiftUI loop video player Video from URL or Local file

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FThe-Igor%2Fswiftui-loop-videoplayer%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/The-Igor/swiftui-loop-videoplayer)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FThe-Igor%2Fswiftui-loop-videoplayer%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/The-Igor/swiftui-loop-videoplayer)

This package uses a declarative approach to declare parameters for the video component based on building blocks. This implementation might give you some insights into how SwiftUI works under the hood. You can also pass parameters in the common way.

## [SwiftUI loop video player example](https://github.com/The-Igor/swiftui-loop-videoplayer-example)

  ![The concept](https://github.com/The-Igor/swiftui-loop-videoplayer-example/blob/main/swiftui-loop-videoplayer-example/img/swiftui.gif)

## How to use the package
### 1. Create LoopPlayerView

```swift
LoopPlayerView(fileName: 'swipe')    
```

or in a declarative way

 ```swift
    LoopPlayerView{
            Settings{
                SourceName("swipe")
                Ext("mp11") // Set default extension here If not provided then mp4 is default
                Gravity(.resizeAspectFill)
                ErrorGroup{
                    EColor(.accentColor)
                    EFontSize(27)
                }
            }
        }   
``` 
          
 ```swift            
       LoopPlayerView{
            Settings{
                SourceName("swipe")
                Gravity(.resizeAspectFill)
                EFontSize(27)                  
            }
        } 
```  

```swift
LoopPlayerView{
    Settings{
        SourceName('https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_ts/master.m3u8')
        ErrorGroup{
            EFontSize(27)
        }
    }
}
```

You can group error settings in group **ErrorGroup** or just pass all settings as a linear list of settings. You don't need to follow some specific order for settings, just pass in an arbitrary order you are interested in. The only required setting is now **SourceName**.

### Settings

| Name | Description | Default |
| --- | --- |  --- |
| **SourceName** | The URL or local filename of the video. If a valid URL (http or https) is provided, the video will be streamed from the URL. If not a URL, the system will check if a video with the given name exists in the local bundle. The local name provided can either include an extension or be without one. The system first checks if the local name contains an extension. If the local name includes an extension, it extracts this extension and uses it as the default. If the local name does not contain an extension, the system assigns a default extension of .mp4 The default file extension can be set up via Ext param. | - |
| **Ext** | File extension for the video, used when loading from local resources. This is optional when a URL is provided and the URL ends with the video file extension. | "mp4" |
| **Gravity** | How the video content should be resized to fit the player's bounds. | .resizeAspect |
| **EColor** | Error message text color. | .red |
| **EFontSize** | Size of the error text. | 17.0 |


## New Functionality: Remote Video URLs
The package now supports using remote video URLs, allowing you to stream videos directly from web resources. This is an extension to the existing functionality that primarily focused on local video files. Here's how to specify a remote URL within the settings:

```swift
LoopPlayerView{
    Settings{
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

## Disclaimer on Video Sources
Please note that using videos from URLs requires ensuring that you have the right to use and stream these videos. Videos hosted on platforms like YouTube cannot be used directly due to restrictions in their terms of service. Always ensure the video URL is compliant with copyright laws and platform policies.

  ![The concept](https://github.com/The-Igor/swiftui-loop-videoplayer-example/blob/main/swiftui-loop-videoplayer-example/img/remote_video_player_swiftui.gif)

## Practical idea for the package
You can introduce video hints about some functionality into the app, for example how to add positions to favorites. Put loop video hint into background or open as popup.

![The concept](https://github.com/The-Igor/swiftui-loop-videoplayer-example/blob/main/swiftui-loop-videoplayer-example/img/swiftui_video_hint.gif)

![The concept](https://github.com/The-Igor/swiftui-loop-videoplayer-example/blob/main/swiftui-loop-videoplayer-example/img/tip_video_swiftui.gif)

## Change video file dynamically 
  ![The concept](https://github.com/The-Igor/swiftui-loop-videoplayer-example/blob/main/swiftui-loop-videoplayer-example/img/change_video_file.gif)
  
## Documentation(API)
- You need to have Xcode 13 installed in order to have access to Documentation Compiler (DocC)

- Go to Product > Build Documentation or **⌃⇧⌘ D**

### XCode 15 beta note (iOS 17)

- At the current time XCode 15 is in beta and in the console you might see message "A structure that defines how a layer displays a player’s visual content within the layer’s bounds" I found on Stack-overflow that many came across this message and at the time it is treated like XCode 15 beta bug
