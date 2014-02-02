<p align="right"><a href="https://travis-ci.org/agersant/itsumono"><img src="https://travis-ci.org/agersant/itsumono.png?branch=master"/><a/></p>
<p align="center"><img src="logo.png"/></p>

This library is a collection of utilities for Haxe game development built with three principles in mind:

* Elegant API, itsumono utilities only do what their names say and are very simple to use.
* Highly-flexible, itsumono is designed to work with *your* data formats and *your* classes.
* Loose coupling, itsumono does not have a main loop and the utilities are vastly independant from one another.

#Setup instructions
Assuming you have installed Haxe and Haxelib is in your system's path, run

    haxelib git itsumono https://github.com/agersant/itsumono master src/
    
If your project uses [OpenFL](https://github.com/openfl/openfl), add ```<haxelib name="itsumono" />``` to your application.xml file. Otherwise, add "-lib itsumono" to your project's compilation flags. In [FlashDevelop](http://flashdevelop.org/), this can be done by clicking *Project* > *Properties…* > *Compiler Options* > *Libraries* and adding "itsumono" on a blank line. That's it, you can now use as many (or as few) itsumono utilities as you want in your project.

#API Reference

* [Animated Sprites](#animated-sprites)
* [Assertions](#assertions)
* [Flow Manager](#flow-manager)
* [Object Pooling](#object-pooling)
* [Pathfinding](#pathfinding)

##Animated Sprites
####Code Sample
The itsumono sprites utility lets you load and animate virtually any spritesheet format into your game so it requires a few lines of setup:
```haxe
var myBitmapData : BitmapData = /*This is your job*/;
var sheet = new SpriteeSheet(myBitmapData);

// Register a 32x32 frame called "stand" in the top left corner of the sheet
sheet.registerFrame("stand_0", 0, 0, 32, 32);
// Register a 32x32 frame called "walk_0" below the "stand" frame
sheet.registerFrame("walk_0", 0, 32, 32, 32);
// Register a 32x32 frame called "walk_1" next to the "walk_0" frame
sheet.registerFrame("walk_1", 32, 32, 32, 32);

// Register an animation displaying the "stand" frame
sheet.registerAnimation("stand", ["stand_0"], [200], false);
// Register an animation that loops between the "walk_0" and "walk_1" frame
sheet.registerAnimation("walk", ["walk_0", "walk_1"], [200, 200], true);

// Create an animated sprite using our sheet:
var sprite = new AnimatedSprite(sheet, "stand");
sprite.setAnimation("walk");
addChild(sprite);
```
####Spritesheet class
#####new Spritesheet (bitmapData: BitmapData)
The only argument of the Spritesheet constructor is a *bitmapData* from which frames will be copied.

#####spritesheet.registerFrame(key: String, x: Int, y: Int, w: Int, h: Int, ?fx: Int = 0, ?fy: Int = 0, ?fw:  Int, ?fh: Int)
* *key* is a unique identifier for the frame.
* *x* and *y* are the position of the frame in the sheet bitmap.
* *w* and *h* are the width and height of the frame in the sheet bitmap.
* *fx* and *fy* are the number pixels that were taken off the top left corner of the frame on the x/y axis when it was packed into the sheet bitmap. These numbers default to 0 and are useful only if your spritesheet packing tool crops bitmaps to save space.
* *fw* and *fh* are the width/height of the frame before it was packed into the sheet bitmap. These numbers default to the values of *w*/*h* and are useful only if your spritesheet packing tool crops bitmaps to save space.

#####spritesheet.registerAnimation(key: String, frameKeys: Array\<String\>, frameDurations: Array\<String\>, loop: Bool)
* *key* is a unique identifier for the animation.
* *frameKeys* is an array of frame keys (as used in calls to *registerFrame*) that compose the animation.
* *frameDuration* is an array listing how long each frame of *frameKeys* should be displayed. This array must have the same number of elements as *frameKeys*.
* *loop* is a boolean that determines whether the animation should repeat itself after playing.

####AnimatedSprite class
#####new AnimatedSprite()
#####animatedSprite.setAnimation()
#####animatedSprite.animateSequence()
#####animatedSprite.animateLoop()

##Assertions
####Code Sample
Assertions are a tool that helps you make sure your code behave the way you want and enforce that your invariants are respected.
```haxe
Assertive.assert(1 + 1 == 2, "Unexpected addition result");
```
####Assertive class
#####Assertive.assert (condition: Bool, ?message: String)
* In release builds, this function will have no effect (it will not even generate any code).
* In debug builds, it will have no effect unless *condition* evaluates to false. When that happens, an error message will be displayed (including the optional String passed as *message*) and an AssertionError object will be thrown.

##Flow Manager

##Object Pooling
####Code Sample
This class can be used to manage a pool of reusable objects. This is especially useful when you need a large number of objects that have a short lifetime (such as when making a particle system).
```haxe
var pool = new Pool (   function() : MyClass { return new MyClass(); }
                    ,   function(o : MyClass) : Void { o.reset(); }
                    );
var object = pool.get();    // Get a clean object from the pool
pool.free(object);          // Return an object that is no longer needed to the pool
```
####Pool class
#####new Pool (factory: Void->T, ?resetFunction: T->Void)
The Pool constructor takes two arguments:
* A *factory* function that the pool can use to build objects when you need them
* An optional *resetFunction* that will be called on pool objects before they are re-used

#####pool.get() : T
Returns a new or cleaned up object from the pool.

#####pool.free (object: T)
Marks an object as available for reuse by the pool. You should not attempt to use *object* after calling this function.

##Pathfinding
