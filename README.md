# SwiftUI loop video player

## How to use the package
### 1. Create LoopPlayerView

```swift
   LoopPlayerView(resourceName: "swipe")
```

### Params

| Strategy | Description | Default |
| --- | --- |  --- | 
|**resourceName**| Name of the video to play| - |
|**extention**| Video extension | "mp4" |
|**errorText**| Error message text| "Resource is not found" |
|**videoGravity**| A structure that defines how a layer displays a player’s visual content within the layer’s bounds | .resizeAspect |
|**errorTextSize**| Size of the error text | 17.0 |

## SwiftUI example for the package
[ SwiftUI loop video player example](https://github.com/The-Igor/swiftui-loop-videoplayer-example)

  ![The concept](https://github.com/The-Igor/swiftui-loop-videoplayer-example/blob/main/swiftui-loop-videoplayer-example/img/img_02.gif)

## Documentation(API)
- You need to have Xcode 13 installed in order to have access to Documentation Compiler (DocC)

- Go to Product > Build Documentation or **⌃⇧⌘ D**

### XCode 15 beta note (iOS 17)

- At the current time XCode 15 is in beta and in the console you might see message "A structure that defines how a layer displays a player’s visual content within the layer’s bounds" I found on Stack-overflow that many came across this message and at the time it is treated like XCode 15 beta bug
