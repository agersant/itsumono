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
    
If your project uses [OpenFL](https://github.com/openfl/openfl), add ```<haxelib name="itsumono" />``` to your application.xml file. Otherwise, add "-lib itsumono" to your project's compilation flags. In [FlashDevelop](http://flashdevelop.org/), this can be done by clicking *Project* > *Properties…* > *Compiler Options* > *Libraries* and adding "itsumono" on a blank line. That's it, you can now use as many (or as few) itsumono utilities in your project.

#API Reference

##Assertions

##Animated Sprites

##Flow Manager

##Object Pooling

##Pathfinding
