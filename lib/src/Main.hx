package;
import haxe.crypto.Base64;
import haxe.io.Bytes;
import haxe.io.BytesData;
import haxe.zip.Compress;
import js.html.Float32Array;
import js.html.Uint8Array;
import js.lzma.LZMA;

/**
 * ...
 * @author Eduardo Pons - eduardo@thelaborat.org
 */
class Main
{
	
	static function main():Void 
	{ 	
		var max_size : Int        = 5000;
		var data_str : String     = "";
		var data_buf : Uint8Array = new Uint8Array(max_size);// new Array<Int>(max_size);
		var data_f32 : Float32Array = new Float32Array(max_size);
		
		for (i in 0...max_size)
		{
			var v : Dynamic = Std.int(Math.random() * 10);
			data_str += v+"";
			data_buf[i] = v;
			data_f32[i] = Math.random();
		}
		
		var is_base64 : Bool = true;
		
		var d : Dynamic = 
		//data_str;
		//data_buf;
		new Uint8Array(data_f32.buffer);
		
		trace("Input> " + d.length + " bytes");
		//trace(d);
		
		if (!is_base64)
		{		
			LZMA.Compress(d, 2, function(cr:Array<Int>):Void
			{
				trace("Output> " + cr.length + " bytes");									
				LZMA.Decompress(cr, function(res:Uint8Array):Void
				{				
					var is_eq : Bool = true;				
					for (i in 0...d.length) if (res[i] != d[i]) is_eq = false;				
					trace(is_eq);
				});
				//*/
				
				/*
				LZMA.DecompressString(cr, function(res:String):Void
				{					
					trace(d == res);
				});
				//*/
				
			});
		}
		else
		{
			LZMA.Compress64(d, 2, function(cr:String):Void
			{
				trace("Output> " + cr.length + " bytes");
				trace(cr);
				LZMA.Decompress64(cr, function(res:Uint8Array):Void
				{				
					var is_eq : Bool = true;				
					for (i in 0...d.length) if (res[i] != d[i]) is_eq = false;				
					var f32 : Float32Array = new Float32Array(res.buffer);					
					trace(is_eq);
				});
			});
		}
		
	}	
	
	
}