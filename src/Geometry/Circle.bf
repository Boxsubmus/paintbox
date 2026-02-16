using System;

namespace Paintbox;

struct Circle : IEquatable<Circle>, IHashable
{
	/// The center position of the circle in 2D space.
	public Vector2 Center;

	/// The radius of the circle.
	public float Radius;

	public this(Vector2 pos, float rad)
	{
		Center = pos;
		Radius = rad;
	}

	public this(float x, float y, float rad)
	{
		Center = .(x, y);
		Radius = rad;
	}

	public this(float radius)
	{
		Center = .Zero;
		Radius = radius;
	}

	public this(Rectangle r)
	{
		Center = r.Center;
		Radius = Math.Max(r.width, r.height);
	}

	/// <summary>
	/// Gets the diameter of the circle.
	/// </summary>
	public readonly float Diameter => Radius * 2.0f;

	/// <summary>
	/// Calculate the area of this <see cref="Circle"/>
	/// </summary>
	public readonly float Area => Math.PI_f * Radius * Radius;

	/// <summary>
	/// Calculate the circumference of this <see cref="Circle"/>
	/// </summary>
	public readonly float Circumference => Radius * 2 * Math.PI_f;

	/// Gets the top point of the circle.
	/// The top point is located directly above the center at a distance equal to the radius.
	public Vector2 Top => Center + Vector2(0, -Radius);

	/// Gets the right point of the circle.
	/// The right point is located directly to the right of the center at a distance equal to the radius.
	public Vector2 Right => Center + Vector2(Radius, 0);

	/// Gets the bottom point of the circle.
	/// The bottom point is located directly below the center at a distance equal to the radius.
	public Vector2 Bottom => Center + Vector2(0, Radius);

	/// Gets the left point of the circle.
	/// The left point is located directly to the left of the center at a distance equal to the radius.
	public Vector2 Left => Center + Vector2(-Radius, 0);

	/// Gets the top-left corner of the bounding box of the circle.
	/// The top-left corner is located diagonally above and to the left of the center at a distance equal to the radius.
	public Vector2 TopLeft => Center + Vector2(-Radius, -Radius);

	/// Gets the bottom-left corner of the bounding box of the circle.
	/// The bottom-left corner is located diagonally below and to the left of the center at a distance equal to the radius.
	public Vector2 BottomLeft => Center + Vector2(-Radius, Radius);

	/// Gets the bottom-right corner of the bounding box of the circle.
	/// The bottom-right corner is located diagonally below and to the right of the center at a distance equal to the radius.
	public Vector2 BottomRight => Center + Vector2(Radius, Radius);

	/// Gets the top-right corner of the bounding box of the circle.
	/// The top-right corner is located diagonally above and to the right of the center at a distance equal to the radius.
	public Vector2 TopRight => Center + Vector2(Radius, -Radius);

	// ==============================================================
	// Collision
	// ==============================================================

	/// <summary>
	/// Checks if the <see cref="Vector2"/> is inside this <see cref="Circle"/>
	/// </summary>
	public bool Contains(Vector2 point)
		=> (Center - point).LengthSquared() < (Radius * Radius);

	/// <summary>
	/// Checks if the <see cref="Point2"/> is inside this <see cref="Circle"/>
	/// </summary>
	public bool Contains(Point2 point)
		=> (Center - point).LengthSquared() < (Radius * Radius);

	/// <summary>
	/// Checks if the Circle overlaps with another <see cref="Circle"/>, and returns their pushout vector
	/// </summary>
	public bool Overlaps(Circle other, out Vector2 pushout)
	{
		pushout = Vector2.Zero;

		var combinedRadius = (Radius + other.Radius);
		var lengthSqrd = (other.Center - Center).LengthSquared();

		if (lengthSqrd < combinedRadius * combinedRadius)
		{
			var length = Math.Sqrt(lengthSqrd);

			// they overlap exactly, so there is no "direction" to push out of.
			// instead just push out along the unit-x vector
			if (length <= 0)
				pushout = Vector2.UnitX * combinedRadius;
			else
				pushout = ((Center - other.Center) / length) * (combinedRadius - length);

			return true;
		}

		return false;
	}

	/// <summary>
	/// Checks whether we overlap a <see cref="Circle"/> (as defined by its center and radius)
	/// </summary>
	public bool Overlaps(Vector2 center, float radius)
		=> Vector2.DistanceSquared(Center, center) < Math.Squared(radius + Radius);

	/// <summary>
	/// Checks whether we overlap a <see cref="Line"/>
	/// </summary>
	public bool Overlaps(Line line)
		=> Vector2.DistanceSquared(Center, line.ClosestPoint(Center)) < Radius * Radius;

	/// <summary>
	/// Checkers whether we overlap a <see cref="Triangle"/>
	/// </summary>
	public bool Overlaps(Triangle tri)
		=> tri.Contains(Center) || Overlaps(tri.AB) || Overlaps(tri.BC) || Overlaps(tri.CA);

	// ==============================================================
	// Operator overloads
	// ==============================================================

	public static bool operator ==(Circle a, Circle b) => a.Center == b.Center && a.Radius == b.Radius;
	public static bool operator !=(Circle a, Circle b) => !(a == b);

	public static Circle operator +(Circle a, Vector2 b) => .(a.Center + b, a.Radius);
	public static Circle operator -(Circle a, Vector2 b) => .(a.Center - b, a.Radius);

	public bool Equals(Circle other)
	{
		return this == other;
	}

	public int GetHashCode()
	{
		return HashCode.Mix(HashCode.Generate(Center), HashCode.Generate(Radius));
	}
}