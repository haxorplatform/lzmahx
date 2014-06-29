package js.lzma;
import haxe.crypto.Base64;
import haxe.io.Bytes;
import js.html.Uint8Array;

/**
 * Class binding to use the LZMA-JS class.
 * For more information visit the project page [https://github.com/nmrugg/LZMA-JS]
 * @author Eduardo Pons - eduardo@thelaborat.org
 */
class LZMA
{	
	
	static var m_instance(get_m_instance, null) : Dynamic;
	static function get_m_instance():Dynamic
	{
		if (m_instance != null) return m_instance;
		try
		{
			m_instance = untyped __js__("require('./lzma.js').LZMA()");		
			if (m_instance != null) return m_instance;
		}
		catch (e:Error)
		{
			m_instance  = untyped __js__("LZMA");			
		}		
		return m_instance;
	}
	
	/**
	 * Compress the data.
	 * Mode can be 1-9 (1 is fast but not as good; 9 will probably make your browser crash).
	 * @param	p_data
	 * @param	p_mode
	 * @param	p_on_finish
	 * @param	p_on_progress
	 */	
	@:overload(function(p_data:Uint8Array,p_mode:Int,p_on_finish : Array<Int>->Void,?p_on_progress : Float -> Void):Void{})	
	static public function Compress(p_data:String,p_mode:Int,p_on_finish : Array<Int>->Void,?p_on_progress : Float -> Void):Void
	{
		var opc : Float->Void = p_on_progress;
		if (opc == null) opc = function(r:Float):Void { };		
		m_instance.compress(p_data, p_mode, p_on_finish, opc);
	}
	
	/**
	 * Compress and returns the result as Base64 String.
	 * @param	p_data
	 * @param	p_mode
	 * @param	p_on_finish
	 * @param	p_on_progress
	 */
	@:overload(function(p_data:Uint8Array, p_mode:Int, p_on_finish : String->Void, ?p_on_progress : Float -> Void):Void { } )		
	static public function Compress64(p_data:String, p_mode:Int, p_on_finish : String->Void, ?p_on_progress : Float -> Void):Void
	{
		Compress(p_data, p_mode, function(p_result:Array<Int>):Void
		{
			var buf : Bytes = Bytes.alloc(p_result.length);
			for (i in 0...buf.length) buf.set(i, p_result[i]);
			p_on_finish(Base64.encode(buf));
		},p_on_progress);
	}
		
	/**
	 * Decompress the data expecting to return its original String value.
	 * @param	p_data
	 * @param	p_on_finish
	 * @param	p_on_progress
	 */
	@:overload(function(p_data:Uint8Array, p_on_finish : String->Void, p_on_progress : Float -> Void = null):Void { } )	
	static public function DecompressString(p_data:Array<Int>,p_on_finish : String->Void,p_on_progress : Float -> Void=null):Void
	{
		var opc : Float->Void = p_on_progress;
		if (opc == null) opc = function(r:Float):Void { };
		m_instance.decompress(p_data, p_on_finish, opc);	
	}
	
	/**
	 * Decompress the data returning its original RAW binary value.
	 * @param	p_data
	 * @param	p_on_finish
	 * @param	p_on_progress
	 */
	@:overload(function(p_data:Uint8Array, p_on_finish : Uint8Array->Void, p_on_progress : Float -> Void = null):Void { } )	
	static public function Decompress(p_data:Array<Int>,p_on_finish : Uint8Array->Void,p_on_progress : Float -> Void=null):Void
	{
		DecompressString(p_data, function(p_string:String):Void
		{
			var buf : Uint8Array = new Uint8Array(p_string.length);
			for (i in 0...buf.length) buf[i] = p_string.charCodeAt(i);
			p_on_finish(buf);
		},p_on_progress);		
	}
	
	/**
	 * Decompress Base64 encoded data which was compressed with Compress64, returning its RAW binary value.
	 * @param	p_data
	 * @param	p_on_finish
	 * @param	p_on_progress
	 */
	static public function Decompress64(p_data:String,p_on_finish : Uint8Array->Void,p_on_progress : Float -> Void=null):Void
	{
		var buf : Bytes = Base64.decode(p_data);
		var buf8 : Uint8Array = new Uint8Array(buf.length);		
		for (i in 0...buf8.length) buf8[i] = buf.get(i);
		Decompress(buf8, p_on_finish, p_on_progress);
	}
	
}