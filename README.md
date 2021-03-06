# What is this?

BoxyBoxxy is a sample project that demonstrates the usage of DHConstraintBuilder and compares it to NSLayoutConstraint.constraintsWithVisualFormat(_ :options:metrics:views)

To use this project, simply run all the unit tests in BoxyBoxxytests.swift

# Why does DHConstraintBuilder exist?

DHConstraintBuilder is meant to simplify the experience of adding auto-layout constraints programatically as well as offer a more "swifty" api.

# What does DHConstraintBuilder look like in action?

You can make constraints like this one:

![alt text](ViewExample.png)

Using code like this:
```swift
view_cb.addConstraints(.H, () |-^ greenView_cb ^-^ 15.5 ^-^ redView_cb ^-| ())
view_cb.addConstraints(.H, () |-^ blueView_cb ^-| ())

view_cb.addConstraints(.V, () |-^ greenView_cb ^-^ blueView_cb ^-| ())
view_cb.addConstraints(.V, () |-^ redView_cb ^-^ blueView_cb)

view_cb.addConstraints(.H, DHConstraintBuilder(greenView_cb, lengthRelativeToView: redView_cb))
view_cb.addConstraints(.V, DHConstraintBuilder(greenView_cb, lengthRelativeToView: blueView_cb))
```

The equivalent using NSLayoutConstraint.constraintsWithVisualFormat(_ :options:metrics:views) would look like this:

```
let viewArray = [
	greenView_vf,
	redView_vf,
	blueView_vf
]
viewArray.forEach({ $0.translatesAutoresizingMaskIntoConstraints = false })
viewArray.forEach(view_vf.addSubview)
let viewDict = [
	"greenView" : greenView_vf,
	"redView" : redView_vf,
	"blueView" : blueView_vf
]
view_vf.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[greenView]-15.5-[redView]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
view_vf.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[blueView]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))

view_vf.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[greenView]-[blueView]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))

view_vf.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[redView]-[blueView]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))

greenView_vf.widthAnchor.constraintEqualToAnchor(redView_vf.widthAnchor).active = true
greenView_vf.heightAnchor.constraintEqualToAnchor(blueView_vf.heightAnchor).active = true
```
# Need More Examples?

There are more Examples in [BoxyBoxxyTests.swift](BoxyBoxxyTests/BoxyBoxxyTests.swift) where there is a more comprehensive side by side comparison of `NSLayoutConstraint.constraintsWithVisualFormat` and `DHConstraintBuilder`

# Installation of DHConstraintBuilder
`carthage github "wh1pch81n/DHConstraintBuilder"`

