using System;
using System.Interop;

namespace Paintbox;

[CRepr]
public struct GlyphInfo
{
	/// Character value (Unicode)
	public int32 value;
	
	/// Character offset X when drawing
	public int32 offsetX;
	
	/// Character offset Y when drawing
	public int32 offsetY;
	
	/// Character advance position X
	public int32 advanceX;
	
	/// Character image data
	public Image image;
	
	public this(int32 value, int32 offsetX, int32 offsetY, int32 advanceX, Image image)
	{
		this.value = value;
		this.offsetX = offsetX;
		this.offsetY = offsetY;
		this.advanceX = advanceX;
		this.image = image;
	}
}
