# SwiftUI loop video player

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FThe-Igor%2Fswiftui-loop-videoplayer%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/The-Igor/swiftui-loop-videoplayer)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FThe-Igor%2Fswiftui-loop-videoplayer%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/The-Igor/swiftui-loop-videoplayer)

## How to use the package
### 1. Create LoopPlayerView

```swift
    LoopPlayerView(fileName: "swipe")    
```

   or in declarative way
   
 ```swift
    LoopPlayerView{
            Settings{
                FileName("swipe")
                Ext("mp4")
                Gravity(.resizeAspectFill)
                ErrorGroup{
                    EText("Not found")
                    EFontSize(27)
                }
            }
        }   
``` 
          
 ```swift            
       LoopPlayerView{
            Settings{
                FileName("swipe")
                Ext("mp4")
                Gravity(.resizeAspectFill)
                EFontSize(27)                  
            }
        } 
```  
If you add any setting twice or more the first one only will be applied
You can group error settings in group **ErrorGroup** or just pass all settings as a linear list of settings. You don't need to follow some specific order for settings, just pass in arbitrary oder settings you are interested in. The only required setting is **FileName**.

### Settings

| Name | Description | Default |
| --- | --- |  --- | 
|**FileName("swipe")**| Name of the video to play| - |
|**Ext("mp4")**| Video extension | "mp4" |
|**Gravity(.resizeAspectFill)**| A structure that defines how a layer displays a player’s visual content within the layer’s bounds | .resizeAspect |
|**EText("Not found")**| Error message text| "Resource is not found" |
|**EFontSize(27)**| Size of the error text | 17.0 |
## SwiftUI example for the package
[ SwiftUI loop video player example](https://github.com/The-Igor/swiftui-loop-videoplayer-example)

  ![The concept](https://github.com/The-Igor/swiftui-loop-videoplayer-example/blob/main/swiftui-loop-videoplayer-example/img/img_02.gif)

## Documentation(API)
- You need to have Xcode 13 installed in order to have access to Documentation Compiler (DocC)

- Go to Product > Build Documentation or **⌃⇧⌘ D**

### XCode 15 beta note (iOS 17)

- At the current time XCode 15 is in beta and in the console you might see message "A structure that defines how a layer displays a player’s visual content within the layer’s bounds" I found on Stack-overflow that many came across this message and at the time it is treated like XCode 15 beta bug
