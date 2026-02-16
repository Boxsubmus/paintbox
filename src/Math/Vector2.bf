using System;

namespace Paintbox;

[CRepr]
extension Vector2 : IEquatable<Vector2>
{
	public this(float xy)
	{
		this.x = xy;
		this.y = xy;
	}

	// ----------
	// Properties
	// ----------

	public float Length()
		=> Math.Sqrt(x * x + y * y);

	public float LengthSquared()
		=> x * x + y * y;

	public float Magnitude()
		=> Length();

	public float SqrMagnitude()
		=> LengthSquared();

	public float Angle()
		=> Math.Atan2(y, x);

	public Self Normalized()
		=> Normalize(this);

	// ==============================================================
	// Constants
	// ==============================================================

	public static Self Zero  => .(0, 0);
	public static Self One 	 => .(1, 1);
	public static Self Up 	 => .(0f, 1f);
	public static Self Down  => .(0f, -1f);
	public static Self Left  => .(-1f, 0f);
	public static Self Right => .(1f, 0f);

	/// <summary>
	/// Returns the vector (1, 0)
	/// </summary>
	public static Self UnitX => .(1.0f, 0.0f);

	/// <summary>
	/// Returns the vector (1, 0)
	/// </summary>
	public static Self UnitY => .(0.0f, 1.0f);

	public static Self PositiveInfinity => .(float.PositiveInfinity, float.PositiveInfinity);
	public static Self NegativeInfinity => .(float.NegativeInfinity, float.NegativeInfinity);

	// ==============================================================
	// Methods
	// ==============================================================

	/// <summary>
	/// Restricts a vector between a min and max value.
	/// </summary>
	public static Vector2 Clamp(Vector2 value1, Vector2 min, Vector2 max)
	{
	    // This compare order is very important!!!
	    // We must follow HLSL behavior in the case user specified min value is bigger than max value.
		// In this case I just stole it from System.Numerics, no point in changing it...
	    float x = value1.x;
	    x = (x > max.x) ? max.x : x;
	    x = (x < min.x) ? min.x : x;

	    float y = value1.y;
	    y = (y > max.y) ? max.y : y;
	    y = (y < min.y) ? min.y : y;

	    return .(x, y);
	}

	/// Lineraly interpolates between two vectors.
	public static Self Lerp(Self a, Self b, float t)
	{
		return .(
			a.x + (b.x - a.x) * t,
			a.y + (b.y - a.y) * t
		);
	}

	/// Lineraly interpolates between two vectors.
	/// Also clamps t between 0-1
	public static Self LerpClamp01(Self a, Self b, float t)
	{
		var t;
		t = Math.Clamp01(t);
		return .(
			a.x + (b.x - a.x) * t,
			a.y + (b.y - a.y) * t
		);
	}

	/// <summary>
	/// Returns a vector with the same direction as the given vector, but with a length of 1.
	/// </summary>
	[Inline]
	public static Self Normalize(Self vec)
	{
		let len = vec.Length();
		if (len == 0)
			return .Zero;
		return vec / len;
	}

	/// <summary>
	/// Returns the dot product of two vectors.
	/// </summary>
	[Inline]
	public static float Dot(Self lhs, Self rhs)
	{
		return lhs.x * rhs.x + lhs.y * rhs.y;
	}

	/// <summary>
	/// Returns a vector whose elements are the maximum of each of the pairs of elements in the two source vectors
	/// </summary>
	public static Vector2 Min(Vector2 value1, Vector2 value2)
	{
	    return .(
	        Math.Min(value1.x, value2.x),
	        Math.Min(value1.y, value2.y)
	    );
	}

	/// <summary>
	/// Returns a vector whose elements are the absolute values of each of the source vector's elements.
	/// </summary>
	public static Vector2 Max(Vector2 value1, Vector2 value2)
	{
	    return .(
	        Math.Max(value1.x, value2.x),
	        Math.Max(value1.y, value2.y)
	    );
	}

	/// <summary>
	/// Returns a vector whose elements are the absolute values of each of the source vector's elements.
	/// </summary>
	public static Vector2 Abs(Vector2 value)
	{
	    return .(Math.Abs(value.x), Math.Abs(value.y));
	}

	/// <summary>
	/// Returns a vector whose elements are the square root of each of the source vector's elements.
	/// </summary>
	public static Vector2 SquareRoot(Vector2 value)
	{
	    return .(Math.Sqrt(value.x), Math.Sqrt(value.y));
	}

	/// <summary>
	/// Returns the Euclidean distance between the two given points.
	/// </summary>
	public static float Distance(Vector2 value1, Vector2 value2)
	{
		let difference = value1 - value2;
		let ls = Vector2.Dot(difference, difference);
		return (float)System.Math.Sqrt(ls);
	}
	
	/// <summary>
	/// Returns the Euclidean distance squared between the two given points.
	/// </summary>
	public static float DistanceSquared(Vector2 value1, Vector2 value2)
	{
		let difference = value1 - value2;
		return Vector2.Dot(difference, difference);
	}

	/// <summary>
	/// Returns the reflection of a vector off a surface that has the specified normal.
	/// </summary>
	public static Vector2 Reflect(Vector2 vector, Vector2 normal)
	{
		let dot = Vector2.Dot(vector, normal);
		return vector - (2 * dot * normal);
	}

	public static Self Transform(Self v, Matrix mat)
	{
		let transform = Raymath.Vector2Transform(v, mat);
		return .(transform.x, transform.y);
	}

	// ==============================================================
	// Collision
	// ==============================================================

	public static bool Overlaps(Self v, Rectangle rect)
	{
		return (v.x >= rect.Left && v.x <= rect.Right) && (v.y >= rect.Top && v.y <= rect.Bottom);
	}

	public static bool OverlapsCircle(Self point, Circle circle)
	{
		let delta = point - circle.Center;
		return delta.SqrMagnitude() <= circle.Radius * circle.Radius;
	}

	public bool Overlaps(Rectangle rect)
	{
		return Overlaps(this, rect);
	}

	public bool OverlapsCircle(Circle circle)
	{
		return OverlapsCircle(this, circle);
	}

	// ==============================================================
	// Operator Overloads
	// ==============================================================

	public static Self operator +(Self a, Self b) => .(a.x + b.x, a.y + b.y);
	public static Self operator -(Self a, Self b) => .(a.x - b.x, a.y - b.y);
	public static Self operator *(Self a, Self b) => .(a.x * b.x, a.y * b.y);
	public static Self operator /(Self a, Self b) => .(a.x / b.x, a.y / b.y);
	public static Self operator -(Self a) => .(-a.x, -a.y);
	public static Self operator +(Self a, float d) => .(a.x + d, a.y + d);
	public static Self operator +(float a, Self d) => .(a + d.x, a + d.y);
	public static Self operator -(Self a, float d) => .(a.x - d, a.y - d);
	public static Self operator -(float a, Self d) => .(a - d.x, a - d.y);
	public static Self operator *(Self a, float d) => .(a.x * d, a.y * d);
	public static Self operator *(float a, Self d) => .(a * d.x, a * d.y);
	public static Self operator /(Self a, float d) => .(a.x / d, a.y / d);
	public static Self operator /(float a, Self d) => .(a / d.x, a / d.y);

	public override void ToString(String strBuffer)
	{
		strBuffer.Append(scope $"({x}, {y})");
	}

	private const float kEpsilon = 0.00001F;

#if IMGUI
	public static implicit operator Self(ImGui.ImGui.Vec2 vec2)
	{
		return .(vec2.x, vec2.y);
	}

	public static implicit operator ImGui.ImGui.Vec2(Self vec2)
	{
		return .(vec2.x, vec2.y);
	}
#endif

	public bool Equals(Vector2 val2)
	{
		return this == val2;
	}
}