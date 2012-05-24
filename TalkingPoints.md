

Talking Points and Some Notes
=============================

* Core Animation common gotchas. Fillmode. Stickiness. Must use KVO -- [setValue:forKeyPath:]
* QuartzCore. Linking binaries.
* UIView animation blocks vs. CAAnimations. Async nature of blocks, they run in separate threads.
* UIView transitions.
* Threading.
* Wrapper classes around numbers. Conventions. 
* Key-Value coding/observing.
* Timing Functions. Graph it -- Time(x), Speed(Y)
* Basics regarding CALayer and what inherits from it. Device independent.
* Spinning activity indicators. How this is done, and how I had originally thought it was done. The differences.
* Trigonometry/Geometry recap. Distance/Midpoint/Slope.
* Links to good Apple documentation. Animatable Properties, Class Hierarchy, Class list, etc.
* Animatable properties, what is, what isn't.
* Class hierarchy. Abstract vs. concretely instantitated classes.
* Animations in a 3D space and the implications.
* Gaming is possible using core animation. There isn't always a need for OpenGL when the game is simple. Hit testing.
* UIResponder, UITouch. How UIView inherits from this.
* Double tap to do things using UITouch tapCount.
* cumulative rotation around a circle, CA will find the optimal distance from one angle to another, can set cumulative property of an
  animation to YES, so it won't find the shortest angle from value to the next.



Slides
======

1. Core Animation
 * talk about my app, my experience developing for iOS
 * Coffee Timer, Pearson
 * people can get in touch w/ me when they want 
 * ask if people have questions

2. Get The Code
 * github is awesome

3. What is Core Animation?
 * Link binary with Quartz 
 * First developed on iOS and brought to OS X
 * CoreAnimation is all over the place on iOS in subtle/not so subtle ways

4. Why Bother?
 * Better UX by far
 * Delight
 * As developers, our job isn't to only be concerned with code, we must be concerned with how people are delighted by our app
   and how they respond to the UI
 * that being said, excessive animation can ruin a UX just as easily as it can make it better.
 * Times when CA is overkill -- i.e [UIView] animaiton blocks

5. CALayer
 * MVC? 
 * May think it is 'V', but...
 * M -- because it holds data about the view to be rendered
 * UIView/NSView inherit from CALayer, and it is at the core of the iOS GUI 
 * CALayer is cross platform

6. Working with CALayer
 * delegation => `drawLayer:inContext:` and `displayLayer:`
 * subclassing => `display` and `drawInContext:`
 * I advise using delegation before attempting to subclass CALayer

7. Rendering Architecture
 * Tree like structure

8. Three Parts
 * Layer Tree => immidiate values, holds properties of layers
 * Presentation Tree => What is rendered on screen, values you want to query when performing an animation
 * Render Tree => private, but we can guess at what it does. It inerpolates values into pixels
 * Important, Pres-Tree !== Layer-Tree

9. Threading
 * Core animation will handle animations on a seperate thread for you. 
 * It automatically handles balancing the CPU to create smooth animations
 * Query Presentation Layer for currently animated against values

10. Layer Hierarchy
 * Like UIViews, each layer has a `superlayer` and `sublayers`
 * This is recursively defined, principle applies to all layers
 * Imagine how a layout routine could work, it could recursively travel this hierarchy

11. Geometry
 * anchorPoint default => (0.5, 0.5)
 * Talk about some values being normalized between 0 and 1, and other values directly taking place on the coordinate system
 * i.e anchorPoint (0-1), keyFrameAnimations timing (0-1)
 * position, correlates to anchorpoint
 * transform in 3D space, translation happens relative to anchorpoint
 * bounds
 * frame is a fucntions of anchorpoint/bounds/position

12. Animation Classes
 * `CABasicAnimation` => from/to value, presentation layer
 * `CAKeyFrameAnimation` => specify values and timing for those values inside arrays, CoreAnimation handles the interpolation
 * `CATransition` => switching between layers, using pushing/sliding and fade in/out
 * `CAAnimationGroup` => an array of animations that will run in tandem

13. Picture of CA classes
 * talk about abstract vs. concrete
 * emphasize the need to read through the Apple Docs to understand all these classes.


14. What we are going to build
 * Pass out iPad with app
 * talk about the animation involved, but also address the fact that we are focusing on iOS' UITouch API
 * explain idea, and ask class if they have any ideas on how to implement this

15. Geometry and Trigonometry
 * I know we want to build apps, but when dealing with Drawing/animation, a good foundational understanding of Geometry/Trig 
   will save many headaches and bugs
 * Pythagorean theorem
 * triangles baby, they solve a lot of problems
 * Use whiteboard to demonstrate two touches, slope/distance/midpoint
 * Inverse tangent/ relates to slope formula

16. CAAnimation
 * abstract superclass of many of the animation classes
 * CAMediaTiming protocol defines a lot of important behavior that CAAnimation classes follow
 * `CAMediaTiming` protocol methods =>
   {
     repeatCount
     , duration
     , speed
     , autoreverses
     , fillMode (important)
   }

17. CABasicAnimation
 * The simplest of Core Animation's animation classes.
 * Animations must start from a value and end on a value
 * If you ping the model-layer, not the presentation-layer from the `fromValue`, we will get jumpy animations.
 * `presentationLayer` changes as the animation takes place

18. Wrapping Conventions
 * can't just set properties on an animation using primitives, you must wrap different primitives/structs inside an object
 
19. NSKeyValueCoding
 * values are set indirectly through a key, and are accessed through a key
 * instead of setting/getting values through getters/setter, you get/set values indirectly by their key
 * wrapper classes are accessed this way
 * `key` VS. `keyPath`  => property name VS. nested property ... i.e `bounds` vs. `bounds.origin.x`


