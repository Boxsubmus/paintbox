using System;

namespace Paintbox;

// A 2D integer point.
public struct Point2
{
	public int x = 0;
	public int y = 0;

	public this() : this(0, 0)
	{
	}

	public this(int x, int y)
	{
		this.x = x;
		this.y = y;
	}

	public this(int xy) : this(xy, xy)
	{
	}

	public static readonly Self Zero  = .(0, 0);
	public static readonly Self UnitX = .(1, 0);
	public static readonly Self UnitY = .(0, 1);
	public static readonly Self One   = .(1, 1);
	public static readonly Self Right = .(1, 0);
	public static readonly Self Left  = .(-1, 0);
	public static readonly Self Up    = .(0, -1);
	public static readonly Self Down  = .(0, 1);

	public static implicit operator Vector2(Self point)
	{
		return .(point.x, point.y);
	}

	// Explicit only, because of loss of precision
	public static explicit operator Point2(Vector2 vec2)
	{
		return .((int)vec2.x, (int)vec2.y);
	}
}

typealias Vector2I = Point2;