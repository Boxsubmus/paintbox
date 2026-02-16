namespace Paintbox;

/// A 2D ray.
struct Ray2D
{
	/// Origin of the ray.
	public Vector2 Position;

	/// Direction of the ray.
	public Vector2 Direction;

	public this(Vector2 pos, Vector2 dir)
	{
		this.Position = pos;
		this.Direction = dir;
	}
}