using System;
using System.Interop;

namespace Paintbox;

[CRepr]
public struct MaterialMap
{
	/// Material map texture
	public Texture2D texture;
	
	/// Material map color
	public Color32 color;
	
	/// Material map value
	public float value;
	
	public this(Texture2D texture, Color32 color, float value)
	{
		this.texture = texture;
		this.color = color;
		this.value = value;
	}
}
