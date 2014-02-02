<p align="right"><a href="https://travis-ci.org/agersant/itsumono"><img src="https://travis-ci.org/agersant/itsumono.png?branch=master"/><a/></p>
<p align="center"><img src="logo.png"/></p>

This library is a collection of utilities for Haxe game development built with three principles in mind:

* Elegant API, itsumono utilities only do what their names say and are very simple to use.
* Highly-flexible, itsumono is designed to work with *your* data formats and *your* classes.
* Loose coupling, itsumono does not have a main loop and the utilities are vastly independant from one another.

#Features

* Animated sprites rendering
* Pathfinding
* Game flow manager
* Object pooling
* …more to come

#Setup instructions
Assuming you have installed Haxe and Haxelib is in your system's path, run

    haxelib git itsumono https://github.com/agersant/itsumono master src/
    
If your project uses [OpenFL](https://github.com/openfl/openfl), add ```<haxelib name="itsumono" />``` to your application.xml file. Otherwise, add "-lib itsumono" to your project's compilation flags. In [FlashDevelop](http://flashdevelop.org/), this can be done by clicking *Project* > *Properties…* > *Compiler Options* > *Libraries* and adding "itsumono" on a blank line. That's it, you can now use as many (or as few) itsumono utilities as you want in your project.

#API Reference

##Assertions
Assertions are a tool that helps you make sure your code behave the way you want and enforce that your invariants are respected.
```haxe
Assertive.assert(1 + 1 == 2, "Unexpected addition result");
```
* In release builds, this function will have no effect (it will not even generate any code).
* In debug builds, it will have no effect unless the first argument evaluates to false. When that happens, an error message will be displayed (including the optional String passed as second argument) and an AssertionError object will be thrown.

##Animated Sprites
###Code Sample
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
###Spritesheet class breakdown
####Constructor
####registerFrame()
####registerAnimation()
###AnimateSprite class breakdown
####Constructor
####setAnimation()
####animateSequence()
####animateLoop()

##Flow Manager

##Object Pooling
This class can be used to manage a pool of reusable objects. This is especially useful when you need a large number of objects that have a short lifetime (such as when making a particle system).
```haxe
var pool = new Pool (   function() : MyClass { return new MyClass(); }
                    ,   function(o : MyClass) : Void { o.reset(); }
                    );
var object = pool.get();    // Get a clean object from the pool
pool.free(object);          // Return an object that is no longer needed to the pool
```
The Pool constructor takes two arguments:
* The first argument is a factory that your pool can use to build objects when you need them
* The second argument is an optional cleanup function that will be called on pool objects before they are re-used

##Pathfinding
