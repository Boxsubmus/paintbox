using System;

namespace Paintbox;

[CRepr]
extension Vector3
{
	public this(float xyz)
	{
		this.x = xyz;
		this.y = xyz;
		this.z = xyz;
	}

	// ---------
	// Constants
	// ---------

	public static Self Zero  	=> .(0, 0, 0);
	public static Self One 	 	=> .(1, 1, 1);
	public static Self Up 	 	=> .(0f, 1f, 0f);
	public static Self Down  	=> .(0f, -1f, 0f);
	public static Self Left  	=> .(-1f, 0f, 0f);
	public static Self Right 	=> .(1f, 0f, 0f);
	public static Self Forward 	=> .(0f, 0f, 1f);
	public static Self Back 	=> .(0f, 0f, -1f);

	public static Self PositiveInfinity => .(float.PositiveInfinity, float.PositiveInfinity, float.PositiveInfinity);
	public static Self NegativeInfinity => .(float.NegativeInfinity, float.NegativeInfinity, float.NegativeInfinity);

	// ------------------
	// Operator Overloads
	// ------------------

	public static Self operator +(Self a, Self b) => .(a.x + b.x, a.y + b.y, a.z + b.z);
	public static Self operator -(Self a, Self b) => .(a.x - b.x, a.y - b.y, a.z - b.z);
	public static Self operator *(Self a, Self b) => .(a.x * b.x, a.y * b.y, a.z * b.z);
	public static Self operator /(Self a, Self b) => .(a.x / b.x, a.y / b.y, a.z / b.z);
	public static Self operator -(Self a) => .(-a.x, -a.y, -a.z);
	public static Self operator +(Self a, float d) => .(a.x + d, a.y + d, a.z + d);
	public static Self operator +(float a, Self d) => .(a + d.x, a + d.y, a + d.z);
	public static Self operator -(Self a, float d) => .(a.x - d, a.y - d, a.z - d);
	public static Self operator -(float a, Self d) => .(a - d.x, a - d.y, a - d.z);
	public static Self operator *(Self a, float d) => .(a.x * d, a.y * d, a.z * d);
	public static Self operator *(float a, Self d) => .(a * d.x, a * d.y, a * d.z);
	public static Self operator /(Self a, float d) => .(a.x / d, a.y / d, a.z / d);
	public static Self operator /(float a, Self d) => .(a / d.x, a / d.y, a / d.z);

	public override void ToString(String strBuffer)
	{
		strBuffer.Append(scope $"({x}, {y}, {z})");
	}

	public const float kEpsilon = 0.00001F;

	public static implicit operator Self(Vector2 vec2)
	{
		return .(vec2.x, vec2.y, 0.0f);
	}

	public static implicit operator Vector2(Self vec3)
	{
		return .(vec3.x, vec3.y);
	}
}