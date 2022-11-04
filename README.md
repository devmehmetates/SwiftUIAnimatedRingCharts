# SwiftUIAnimatedRingCharts

## How to use
Follow all the steps for 3rd party Swift packages and add the package to your project. If you have no idea, have a look here 👉🏻 <a href="https://github.com/devmehmetates/SwiftUIDragMenu#how-to-install-this-package"> Click here.</a>


Then add it to your project as follows.
```swift
// MARK: STEP 1
import SwiftUIAnimatedRingCharts 

// MARK: STEP 2
RingChartsView(values: [100,900,300], colors: [[.red, .orange], [.purple, .pink],[.teal, .green]], ringsMaxValue: 1000)
```

## Variables and Customization

| Variables     | Type                  | Required | Description                                           |
|---------------|-----------------------|----------|-------------------------------------------------------|
| Values        | Array\<CGFloat>       | yes      | The required array for the values in the chart.       |
| Colors        | Array\<Array\<Color>> | no       | The array of colors specified for the entered arrays. |
| ringsMaxValue | CGFloat               | yes      | The value against which the values are compared.      |
| lineWidth     | CGFloat               | no       | This value sets the width of the charts.              |

## Tips 
+ Shape the class with the frame. Since it is flexible, it will use all the space it can cover.
+ Use the frame's height and width property. Alignment issues may arise in determining the height size.

## Preview
https://user-images.githubusercontent.com/74152011/165101749-746dff52-40f8-428d-bd27-119c3d3363c9.mov

