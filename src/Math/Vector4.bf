using System;

namespace Paintbox;

[CRepr]
extension Vector4
{
	public this(float xyzw)
	{
		this.x = xyzw;
		this.y = xyzw;
		this.z = xyzw;
		this.w = xyzw;
	}

	public static Self operator +(Self a, Self b) => .(a.x + b.x, a.y + b.y, a.z + b.z, a.w + b.w);
	public static Self operator -(Self a, Self b) => .(a.x - b.x, a.y - b.y, a.z - b.z, a.w - b.w);
	public static Self operator *(Self a, Self b) => .(a.x * b.x, a.y * b.y, a.z * b.z, a.w * b.w);
	public static Self operator /(Self a, Self b) => .(a.x / b.x, a.y / b.y, a.z / b.z, a.w / b.w);
	public static Self operator -(Self a) => .(-a.x, -a.y, -a.z, -a.w);
	public static Self operator +(Self a, float d) => .(a.x + d, a.y + d, a.z + d, a.w + d);
	public static Self operator +(float a, Self d) => .(a + d.x, a + d.y, a + d.z, a + d.w);
	public static Self operator -(Self a, float d) => .(a.x - d, a.y - d, a.z - d, a.w - d);
	public static Self operator -(float a, Self d) => .(a - d.x, a - d.y, a - d.z, a - d.w);
	public static Self operator *(Self a, float d) => .(a.x * d, a.y * d, a.z * d, a.w * d);
	public static Self operator *(float a, Self d) => .(a * d.x, a * d.y, a * d.z, a * d.w);
	public static Self operator /(Self a, float d) => .(a.x / d, a.y / d, a.z / d, a.w / d);
	public static Self operator /(float a, Self d) => .(a / d.x, a / d.y, a / d.z, a / d.w);

	public override void ToString(String strBuffer)
	{
		strBuffer.Append(scope $"({x}, {y}, {z}, {w})");
	}

	public static implicit operator Self(Vector3 vec3)
	{
		return .(vec3.x, vec3.y, vec3.z, 0.0f);
	}

	public static implicit operator Vector3(Self vec4)
	{
		return .(vec4.x, vec4.y, vec4.z);
	}
}