using System;
using System.Interop;

namespace Paintbox;

[CRepr]
public struct float16
{
	/// 
	public float[16] v;
	
	public this(float[16] v)
	{
		this.v = v;
	}
}
