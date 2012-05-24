
Core Animation Programming Guide Notes
======================================

Overview
--------

* Core Animation abstracts the multithreading for you. Once you tell it to animate, it does the animation on a separate thread. It will make sure
  animations happen at an acceptable frame-rate.
* Layer classes are the foundation of Core Animation. CALayer is the superclass of NSView and UIView alike.
  It is also the parent class of all Core Animation Layer classes.
* Not necessary to subclass CALayer to do custom drawing the way it is with UIView. Its drawing methods can be accessed through delegation.
* CALayer uses conforms to NSKeyValueObserving and extends it to provide wrapper classes around => (CGPoint, CGSize, CGRect, CGAffineTransform and CATransform3D).
* Some CALayer properties are implicitly animatable. Simply setting a property to a certain value will trigger an animation. Other properties
  are explicitly animatable, and can be animated using an animation class.
* Difference between CALayer and UIView/NSView is that CALayer is a model object. It stores layer geometry/other properties, and isn't
  explicitly responsible for rendering these properties onto the screen. While, a UIView IS responsible for rendering it's contents.
* CA rendering architecture has 3 parts => the Layer-Tree, Presentation-Tree, Rendering-Tree(private)
* Layer-Tree contains the CALayer's model property values. Presentation-Tree contains the values that the current presented layer has,
  you could imagine these values change during the course of an animation. I.E, when someone animates a CALayer's alpha property from 
  0.0f to 1.0f, the Presentation Layers alpha property will change throughout the duration of the animation.
* The Rendering-Tree is responsible compositing the Layer's properties onto the screen, it handles this in a separate thread.


Layer Geometry
--------------

* Coordinate system on iOS has point (0, 0) of the coordinate system in the upper left corner. Values extend to the right and down, becoming bigger. All
  coordinate values are floating point values.
* Each layer contains its own coordinate system. There are method provided to convert points from one layer to another.
* Some coordinates measure coordinates in normalized values from (0.0-1.0) making 0.5 the middle values. Say you width is 100 => 0.5 will give you 50
* The Anchor Point of a Layer defines how the bounds is calculated relative to the position of a layer. 
  [Documentation Link](https://developer.apple.com/library/ios/#documentation/Cocoa/Conceptual/CoreAnimation_guide/Articles/Layers.html)
* CATransform3D matrix structure is used to define a layer's => scale, offset, rotation, skew, and perspective
* CA extends KVO by adding access to CATransform3D properties. [Documentation Link](https://developer.apple.com/library/ios/#documentation/Cocoa/Conceptual/CoreAnimation_guide/Articles/Layers.html)


Layer-Tree Hierarchy
--------------------

* Layers can be inserted, removed, replaced, etc, like UIViews. Layers also have superlayers and sublayers, like UIViews.
* Sublayers are automatically clipped to the bounds of their superlayers, to allow them to expand past the bounds of the superlayer,
  set the superlayer's `masksToBounds` poperty to `NO`.


Providing Layer Content
-----------------------

* Set the `contents` property to an instance of `CGImageRef`.
* override `displayLayer:`(loading in content from an image) or `drawLayer:inContext`(drawing layer's content) and becoming the delegate of the CALayer.
* It is possible to subclas CALayer and override `display`(correlate to `displayLayer` delegate method) or `drawInContext:`(correlates to `drawLayer:inContext:` delegate method).
  This is often unnecessary, but can be useful when implementing significant custom behavior. 
* Overriding drawing methods by subclassing or delegation doesn't automatically call those methods, the layer must be queued up to be redrawn by calling 
  `setNeedsDisplay` or `setNeedsDisplayInRect:` or setting `needsDisplayOnBoundsChange` to `YES`.
* When providing a layer an image for its `content` property, you may need to change the Layer's  `contentsGravity` property to affect the aspect ratio that
  the image is displayed at.


Animation
---------

* Core animation classes => `CABasicAnimation`, `CAKeyFrameAnimation`, `CATransition`, `CAAnimationGroup`
* Animations don't take effect until explicitly added to the layer using `addAnimation:forKey:` and are removed using `removeAnimationForKey:` or `removeAllAnimations`


Layer Actions
-------------

* `CAAction` protocol allows classes to respond to certain events on a layer. 
* All `CAAnimation` classes adopt the `CAAction` protocol.
* from the docs => "When an action trigger occurs, the layer’s actionForKey: method is invoked. 
  This method returns an action object that corresponds to the action identifier passed as the parameter, or nil if no action object exists."
* Classes that implement `CAAction` respond to `runActionForKey:object:arguments:` by repsonding to a given action (often performing an animation).
* Can override default implicit animations.



Transactions
------------

* Both explicit and implicit transactions.
* Implicit transactions work by setting a few animatble properties on a layer and having them take effect on the next iteration of the run loop.
* Explicit animations happen by setting animatable properties inbetween the => `[CATransaction begin]` and `[CATransaction commit]` blocks.
* Transactions can be nested and only begin animations when the outermost transactions is `commit`ed. (this can be useful for changing the timing on different animations)


Laying Out Core Animation Layers
--------------------------------

* Can adopt the `CALayoutManager` protocol to provide advanced layouts for a given layer.
* This protocol is not available on iOS.


Core Animation Extensions to Key-Value Coding
---------------------------------------------

* Extended support to KVO for => `CGPoint CGRect CGSize CATransform3D`
* There are particular wrapping conventions around non-objects

    `Conventions = {
       CGPoint => NSValue
       CGSize => NSValue
       CGRect => NSValue
       CGAffineTransform => NSAffineTransform (OS X only)
       CATransform3D => NSValue
       (numbered primitives) => NSNumber
    }`

* [Extended keypath support, reference this link](https://developer.apple.com/library/ios/#documentation/Cocoa/Conceptual/CoreAnimation_guide/Articles/KVCAdditions.html)


Layer Style Properties
----------------------

* (covering stuff already discussed)
* Layer's can have borders, rounded corners using `cornerRadius` property, shadows, masks ...  (no surprise that these properties exist)





