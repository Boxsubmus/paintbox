using System;
using System.Collections;

namespace Paintbox;

[CRepr]
extension Rectangle
{
	public this()
	{
		this.x = 0;
		this.y = 0;
		this.width = 0;
		this.height = 0;
	}

	public this(Vector2 pos, Vector2 size)
	{
		this.x = pos.x;
		this.y = pos.y;
		this.width = size.x;
		this.height = size.y;
	}

	[Inline]
	public Vector2 AA => .(x, y);
	[Inline]
	public Vector2 BB => .(x + width, y + height);

	[Inline]
	public Vector2 AB => .(x, y + height);
	[Inline]
	public Vector2 BA => .(x + width, y);

	[Inline]
	public Vector2 Pos => .(x, y);
	[Inline]
	public Vector2 Size => .(width, height);

	// ==============================================================
	// Edges
	// ==============================================================

	public float Left
	{
		get => x;
		set mut
		{
			let oldRight = Right;
			x = value;
			width = oldRight - value;
		}
	}

	public float Right
	{
		get => x + width;
		set mut => x = value - width;
	}

	public float Top
	{
		get => y;
		set mut => y = value;
	}

	public float Bottom
	{
		get => y + height;
		set mut => y = value - height;
	}

	public float CenterX
	{
		get => x + width / 2;
		set mut => x = value - width / 2;
	}

	public float CenterY
	{
		get => y + height / 2;
		set mut => y = value - height / 2;
	}

	public readonly Line LeftLine => .(BottomLeft, TopLeft);
	public readonly Line RightLine => .(TopRight, BottomRight);
	public readonly Line TopLine => .(TopLeft, TopRight);
	public readonly Line BottomLine => .(BottomRight, BottomLeft);

	public EdgeEnumerable Edges => .(this);

	public struct EdgeEnumerable : IEnumerable<Line>
	{
		private readonly Rectangle m_rect;

		public this(Rectangle rect)
		{
			m_rect = rect;
		}

		public EdgeEnumerator GetEnumerator()
		{
			return .(m_rect);
		}
	}

	public struct EdgeEnumerator : IEnumerator<Line>
	{
		private readonly Rectangle m_rect;

		private int m_index = -1;
		private Line m_current;

		public this(Rectangle rect)
		{
			m_rect = rect;
			m_current = rect.RightLine;
		}

		public int Index
		{
			get => m_index;
		}

		public Line Current
		{
			get
			{
				return m_current;
			}
		}

		public bool MoveNext() mut
		{
			m_index++;

			if (m_index < 4)
			{
				switch (m_index)
				{
				case 0: m_current = m_rect.RightLine; break;
				case 1: m_current = m_rect.BottomLine; break;
				case 2: m_current = m_rect.LeftLine; break;
				case 3: m_current = m_rect.TopLine; break;
				}
				return true;
			}
			else
				return false;
		}

		public void Reset() mut
		{
			m_index = -1;
		}

		public Result<Line> GetNext() mut
		{
			if (!MoveNext())
				return .Err;
			return Current;
		}
	}

	public Vector2 TopLeft
	{
		get => .(Left, Top);
		set mut
		{
			Left = value.x;
			Top = value.y;
		}
	}

	public Vector2 TopCenter
	{
		get => .(CenterX, Top);
		set mut
		{
			CenterX = value.x;
			Top = value.y;
		}
	}

	public Vector2 TopRight
	{
		get => .(Right, Top);
		set mut
		{
			Right = value.x;
			Top = value.y;
		}
	}

	public Vector2 CenterLeft
	{
		get => .(Left, CenterY);
		set mut
		{
			Left = value.x;
			CenterY = value.y;
		}
	}

	public Vector2 Center
	{
		get => .(CenterX, CenterY);
		set mut
		{
			CenterX = value.x;
			CenterY = value.y;
		}
	}

	public Vector2 CenterRight
	{
		get => .(Right, CenterY);
		set mut
		{
			Right = value.x;
			CenterY = value.y;
		}
	}

	public Vector2 BottomLeft
	{
		get => .(Left, Bottom);
		set mut
		{
			Left = value.x;
			Bottom = value.y;
		}
	}

	public Vector2 BottomCenter
	{
		get => .(CenterX, Bottom);
		set mut
		{
			CenterX = value.x;
			Bottom = value.y;
		}
	}

	public Vector2 BottomRight
	{
		get => .(Right, Bottom);
		set mut
		{
			Right = value.x;
			Bottom = value.y;
		}
	}

	// ==============================================================
	// Collision
	// ==============================================================

	public bool Contains(Vector2 point)
		=> point.x >= x && point.y >= y && point.x < x + width && point.y < y + height;

	public bool Contains(Rectangle rect)
		=> Left <= rect.Left && Top <= rect.Top && Bottom >= rect.Bottom && Right >= rect.Right;

	public bool Overlaps(Rectangle against)
		=> x + width > against.x && y + height > against.y && x < against.x + against.width && y < against.y + against.height;

	public bool Overlaps(Triangle tri)
		=> tri.Contains(TopLeft) || Overlaps(tri.AB) || Overlaps(tri.BC) || Overlaps(tri.CA);

	public bool Overlaps(Line line)
		=> this.Overlaps(line);

	/// <summary>
	/// Get the largest rectangle full contained by both rectangles
	/// </summary>
	public Self GetIntersection(Rectangle against)
	{
		var overlapX = x + width > against.x && x < against.x + against.width;
		var overlapY = y + height > against.y && y < against.y + against.height;

		Rectangle r = .();

		if (overlapX)
		{
			r.Left = Math.Max(Left, against.Left);
			r.width = Math.Min(Right, against.Right) - r.Left;
		}

		if (overlapY)
		{
			r.Top = Math.Max(Top, against.Top);
			r.height = Math.Min(Bottom, against.Bottom) - r.Top;
		}

		return r;
	}

	// ==============================================================
	// Static Constructors
	// ==============================================================

	/// <summary>
	/// Get a rect centered around a position
	/// </summary>
	public static Self Centered(float centerX, float centerY, float width, float height)
		=> .(centerX - width / 2, centerY - height / 2, width, height);

	/// <summary>
	/// Get a rect centered around a position
	/// </summary>
	public static Self Centered(Vector2 center, float width, float height)
		=> .(center.x - width / 2, center.y - height / 2, width, height);

	/// <summary>
	/// Get a rect centered around a position
	/// </summary>
	public static Self Centered(Vector2 center, Vector2 size)
		=> .(center.x - size.x / 2, center.y - size.y / 2, size.x, size.y);

	/// <summary>
	/// Get a rect centered around (0, 0)
	/// </summary>
	public static Self Centered(Vector2 size)
		=> .(-size.x/2, -size.y/2, size.x, size.y);

	/// <summary>
	/// Get a rect centered around (0, 0)
	/// </summary>
	public static Self Centered(float width, float height)
		=> .(-width/2, -height/2, width, height);

	/// <summary>
	/// Get a rect justified around the origin point
	/// </summary>
	public static Self Justified(Vector2 origin, float width, float height, float justifyX, float justifyY)
		=> .(origin.x - (justifyX * width), origin.y - (justifyY * height), width, height);

	/// <summary>
	/// Get a rect justified around the origin point
	/// </summary>
	public static Self Justified(Vector2 origin, Vector2 size, Vector2 justify)
		=> .(origin.x - (justify.x * size.x), origin.y - (justify.y * size.y), size.x, size.y);

	/// <summary>
	/// Get a rect justified around the origin point
	/// </summary>
	public static Self Justified(float width, float height, float justifyX, float justifyY)
		=> .(justifyX * -width, justifyY * -height, width, height);

	/// <summary>
	/// Get a rect justified around the origin point
	/// </summary>
	public static Self Justified(Vector2 size, Vector2 justify)
		=> .(justify.x * -size.x, justify.y * -size.y, size.x, size.y);

	/// <summary>
	/// Get the rect with positive width and height that stretches from point a to point b
	/// </summary>
	public static Self Between(Vector2 a, Vector2 b)
	{
		Self rect;

		rect.x = a.x < b.x ? a.x : b.x;
		rect.y = a.y < b.y ? a.y : b.y;
		rect.width = (a.x > b.x ? a.x : b.x) - rect.x;
		rect.height = (a.y > b.y ? a.y : b.y) - rect.y;

		return rect;
	}

	// ==============================================================
	// Operator Overloads
	// ==============================================================

	public static Self operator +(Self a, Self b) => 	.(a.x + b.x, a.y + b.y, a.width + b.width, a.height + b.height);
	public static Self operator -(Self a, Self b) =>  	.(a.x - b.x, a.y - b.y, a.width - b.width, a.height - b.height);
	public static Self operator *(Self a, Self b) =>  	.(a.x * b.x, a.y * b.y, a.width * b.width, a.height * b.height);

	public static implicit operator Bounds(Self rect)
	{
		return .(rect.AA, rect.BB);
	}
} 