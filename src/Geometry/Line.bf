using System;

namespace Paintbox;

/// A 2D Floating-Point Line
struct Line : IEquatable<Line>
{
	public Vector2 From;
	public Vector2 To;

	public this(Vector2 from, Vector2 to)
	{
		From = from;
		To = to;
	}

	public this(float x1, float y1, float x2, float y2)
		: this(.(x1, y1), .(x2, y2))
	{
	}

	public Vector2 GetAxis(int index)
	{
		var axis = (To - From).Normalized();
		return .(axis.y, -axis.x);
	}

	public Vector2 GetPoint(int index)
	{
		switch (index)
		{
		case 0: return From;
		case 1: return To;
		}

		Runtime.FatalError("Out of bounds!");
	}

	public Vector2 On(float percent)
		=> Vector2.Lerp(From, To, percent);

	public Vector2 OnClamped(float percent)
		=> Vector2.Lerp(From, To, Math.Clamp01(percent));

	public void Project(Vector2 axis, out float min, out float max)
	{
		min = float.MaxValue;
		max = float.MinValue;

		var dot = From.x * axis.x + From.y * axis.y;
		min = Math.Min(dot, min);
		max = Math.Max(dot, max);
		dot = To.x * axis.x + To.y * axis.y;
		min = Math.Min(dot, min);
		max = Math.Max(dot, max);
	}

	public float ClosestTUnclamped(Vector2 to)
		=> Vector2.Dot(to - From, To - From) / (To - From).LengthSquared();

	public float ClosestT(Vector2 to)
		=> Math.Clamp01(ClosestTUnclamped(to));

	public Vector2 ClosestPoint(Vector2 to)
		=> On(ClosestT(to));

	/// <summary>
	/// Get the closest points on each line
	/// </summary>
	public (Vector2 A, Vector2 B) ClosestPoints(Line other)
	{
		let v1 = To - From;
		let v2 = other.To - other.From;
		let w = From - other.From;

		float a = Vector2.Dot(v1, v1); // = to v1.LengthSquared()
		float b = Vector2.Dot(v1, v2);
		float c = Vector2.Dot(v2, v2); // = to v2.LengthSquared()
		float d = Vector2.Dot(v1, w);
		float e = Vector2.Dot(v2, w);

		float denominator = a * c - b * b;
		float s, t;

		if (denominator < 1e-8f)
		{
			// lines are parallel (within error), so default to endpoint
			s = 0;
			t = Math.Clamp(e / c, 0, 1); // Project an endpoint onto the other segment
		}
		else
		{
			s = (b * e - c * d) / denominator;
			t = (a * e - b * d) / denominator;

			// Clamp 's' and 't' to the range [0, 1] to ensure points stay on the segments
			s = Math.Clamp(s, 0, 1);
			t = Math.Clamp(t, 0, 1);
		}

		let closest1 = From + s * v1;
		let closest2 = other.From + t * v2;
		return (closest1, closest2);
	}

	/// <summary>
	/// Get the shortest distance between the two lines
	/// </summary>
	public float ClosestDistance(Line other)
	{
		var (a, b) = ClosestPoints(other);
		return Vector2.Distance(a, b);
	}

	/// <summary>
	/// Get the shortest distance squared between the two lines
	/// </summary>
	public float ClosestDistanceSquared(Line other)
	{
		var (a, b) = ClosestPoints(other);
		return Vector2.DistanceSquared(a, b);
	}

	// ==============================================================
	// Collision
	// ==============================================================

	public float DistanceSquared(Vector2 to)
		=> Vector2.DistanceSquared(ClosestPoint(to), to);

	public float Distance(Vector2 to)
		=> Vector2.Distance(ClosestPoint(to), to);

	public bool Intersects(Rectangle rect)
		=> rect.Overlaps(this);

	public bool Intersects(Circle circle)
		=> circle.Overlaps(this);

	public bool Intersects(Line other)
		=> Intersects(other, ?);

	public bool Intersects(Rectangle other, out Vector2 point)
	{
		for (let line in other.Edges)
			if (Intersects(line, out point))
				return true;

		if (other.Contains(From))
		{
			point = From;
			return true;
		}
		else if (other.Contains(To))
		{
			point = To;
			return true;
		}

		point = default;
		return false;
	}

	public bool Intersects(Line other, out Vector2 point)
	{
		point = default;

		let b = To - From;
		let d = other.To - other.From;
		let bDotDPerp = b.x * d.y - b.y * d.x;

		// if b dot d == 0, it means the lines are parallel so have infinite intersection points
		if (bDotDPerp == 0)
			return false;

		let c = other.From - From;
		let t = (c.x * d.y - c.y * d.x) / bDotDPerp;
		if (t < 0 || t > 1)
			return false;

		let u = (c.x * b.y - c.y * b.x) / bDotDPerp;
		if (u < 0 || t > 1)
			return false;

		point = From + b * t;
		return true;
	}

	// ==============================================================
	// Operator overloads
	// ==============================================================

	public static Line operator +(Line a, Vector2 b) => .(a.From + b, a.To + b);
	public static Line operator -(Line a, Vector2 b) => .(a.From - b, a.To - b);
	public static bool operator ==(Line left, Line right) => left.Equals(right);
	public static bool operator !=(Line left, Line right) => !(left == right);

	public bool Equals(Line other) => this == other;
}