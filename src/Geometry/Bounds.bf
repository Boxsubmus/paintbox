using System;

namespace Paintbox;

public struct Bounds
{
	public float xMin;
	public float xMax;
	public float yMin;
	public float yMax;

	[Inline]
	public Vector2 AA => .(xMin, yMin);
	[Inline]
	public Vector2 BB => .(xMax, yMax);

	[Inline]
	public Vector2 Pos => .(xMin, yMin);
	[Inline]
	public Vector2 Size => .(xMax - xMin, yMax - yMin);

	[Inline]
	public float Left => xMin;
	[Inline]
	public float Right => xMax;
	[Inline]
	public float Top => yMin;
	[Inline]
	public float Bottom => yMax;

	public this()
	{
		xMin = 0;
		xMax = 0;
		yMin = 0;
		yMax = 0;
	}

	public this(Vector2 min, Vector2 max)
	{
		xMin = min.x;
		yMin = min.y;
		xMax = max.x;
		yMax = max.y;
	}

	public bool Overlaps(Bounds other)
	{
		return !((other.Right <= Left) ||
			(other.Bottom <= Top) ||
			(other.Left >= Right) ||
			(other.Top >= Bottom));
	}

	public static implicit operator Rectangle(Self bounds)
	{
		return .(bounds.Pos, bounds.Size);
	}
}