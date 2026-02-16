using System;

namespace Paintbox;

/// A 2D Triangle
struct Triangle : IEquatable<Triangle>
{
	public Vector2 A;
	public Vector2 B;
	public Vector2 C;

	public this(Vector2 a, Vector2 b, Vector2 c)
	{
		this.A = a;
		this.B = b;
		this.C = c;
	}

	public this(float x1, float y1, float x2, float y2, float x3, float y3)
		: this(.(x1, y1), .(x2, y2), .(x3, y3))
	{
	}

	public Vector2 this[int index]
	{
		get
		{
			switch (index)
			{
			case 0: return A;
			case 1: return B;
			case 2: return C;
			}

			Runtime.FatalError("Index out of bounds");
		}

		set mut
		{
			switch (index)
			{
			case 0: A = value; break;
			case 1: B = value; break;
			case 2: C = value; break;
			}

			Runtime.FatalError("Index out of bounds");
		}
	}
	
	public readonly float Area
		=> Math.Abs(A.x * (B.y - C.y) + B.x * (C.y - A.y) + C.x * (A.y - B.y)) / 2;

	public readonly Rectangle Bounds
		=> Rectangle.Between(Math.Min(A, B, C), Math.Max(A, B, C));

	public readonly Line AB => .(A, B);
	public readonly Line BC => .(B, C);
	public readonly Line CA => .(C, A);
	public readonly Vector2 Center => Bounds.Center;
	public readonly Vector2 Average => (A + B + C) / 3;

	// ==============================================================
	// Collision
	// ==============================================================

	public bool Contains(Vector2 pt)
		=> Math.Cross(B - A, pt - A) > 0 &&  Math.Cross(C - B, pt - B) > 0 && Math.Cross(A - C, pt - C) > 0;

	// ==============================================================
	// Operator overloads
	// ==============================================================

	public static Triangle operator +(Triangle a, Vector2 b) => .(a.A + b, a.B + b, a.C + b);
	public static Triangle operator -(Triangle a, Vector2 b) => .(a.A - b, a.B - b, a.C - b);
	public static Triangle operator *(Triangle a, float scalar) => .(a.A * scalar, a.B * scalar, a.C * scalar);
	public static Triangle operator /(Triangle a, float scalar) => .(a.A / scalar, a.B / scalar, a.C / scalar);
	public static bool operator ==(Triangle a, Triangle b) => a.A == b.A && a.B == b.B && a.C == b.C;
	public static bool operator !=(Triangle a, Triangle b) => a.A != b.A || a.B != b.B || a.C != b.C;

	public bool Equals(Triangle val2)
	{
		return default;
	}
}