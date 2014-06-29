![](http://i.imgur.com/NhqFka5.png)

## Overview

This project is a port of the LZMA-JS project [https://github.com/nmrugg/LZMA-JS].  
Usage is pretty much the same, with the addition of some `Base64` and `Uint8Array` features.

## Install

* Run the command `haxelib install lzmahx`
* Copy the sources `lib/bin/lzma.js` `lib/bin/lzma_worker.js` to your root folder (nodejs) or where the `<script>` can find them.
* If your application is HTML:
  * For `Async` mode using `WebWorker` use this tag `<script src="lzma.js"></script>`
  * For `Sync` mode use this tag `<script src="lzma_worker.js"></script>`

## Usage

### Compression
````
var d : Uint8Array = new Uint8Array(1000);

//Put some data in it.

//Mode can be 1-9 (1 is fast but not as good; 9 will probably make your browser crash).
LZMA.Compress(d, mode, function(cr:Array<Int>):Void
{
  //cr is the RAW compressed data.
});

LZMA.Compress64(d, mode, function(cr:String):Void
{
  //cr is the RAW compressed data converted to Base64.
  //Usefull to send it using HTTP.
});

//Also accepts string.
var d_str : String = "somedata"; 
LZMA.Compress(d, mode, function(cr:Array<Int>):Void {});
````

### Decompression
````
var d : Array<Int>; //contains the compressed data.

LZMA.DecompressString(d,function(res:String):Void
{
  //res is the original data (if it was a String)
});

LZMA.Decompress(d,function(res:Uint8Array):Void
{
  //res is the original data in RAW format.
}


var d_str : String; //Compressed dat in Base64 format.
LZMA.Decompress64(d_str,function(cr:Uint8Array):Void {});
````

