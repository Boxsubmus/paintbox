using System;

namespace Paintbox;

[CRepr]
struct Color
{
	public float r;
	public float g;
	public float b;
	public float a;

	public this(float r, float g, float b, float a)
	{
		this.r = r;
		this.g = g;
		this.b = b;
		this.a = a;
	}

	public this(float r, float g, float b) : this(r, g, b, 1.0f)
	{
	}

	public this(StringView hex)
	{
		let col = Hex2RGB(hex);
		r = col.r;
		g = col.g;
		b = col.b;
		a = col.a;
	}

	/// Converts a Hexadecimal Color to a float-based RGBA Color (0.0–1.0).
	public static Color Hex2RGB(StringView hex)
	{
		var hex;
	    if (hex.Length > 0 && hex[0] == '#')
	        hex = hex.Substring(1);

	    if (uint.Parse(hex, .HexNumber) case .Ok(let value))
	    {
	        Color color = .(0f, 0f, 0f, 0f);

	        if (hex.Length == 6)
	        {
	            // Format: RRGGBB (alpha defaults to 1.0)
	            color.r = ((value >> 16) & 0xFF) / 255.0f;
	            color.g = ((value >> 8) & 0xFF) / 255.0f;
	            color.b = (value & 0xFF) / 255.0f;
	            color.a = 1.0f;
	        }
	        else if (hex.Length == 8)
	        {
	            // Format: RRGGBBAA
	            color.r = ((value >> 24) & 0xFF) / 255.0f;
	            color.g = ((value >> 16) & 0xFF) / 255.0f;
	            color.b = ((value >> 8) & 0xFF) / 255.0f;
	            color.a = (value & 0xFF) / 255.0f;
	        }

	        return color;
	    }

	    return .Black;
	}

	/// Returns a brighter or darker version of the color by modifying its RGB values.
	private static Self AdjustBrightness(Self color, float factor)
	{
	    let r = Math.Clamp01(color.r * factor);
	    let g = Math.Clamp01(color.g * factor);
	    let b = Math.Clamp01(color.b * factor);
	    return .(r, g, b, color.a);
	}

	/// <summary>
	/// Returns a lighter version of the color. Factor > 1.0 lightens the color.
	/// </summary>
	public Self Lighter(float factor = 1.2f)
	{
	    return AdjustBrightness(this, factor);
	}

	/// <summary>
	/// Returns a darker version of the color. Factor > 1.0 darkens the color.
	/// </summary>
	public Self Darker(float factor = 1.2f)
	{
	    return AdjustBrightness(this, 1f / factor);
	}

	public Self Darken(float amount)
	{
		let scalar = Math.Max(1.0f, 1.0f + amount);

		let r = Math.Clamp01(r / scalar);
		let g = Math.Clamp01(g / scalar);
		let b = Math.Clamp01(b / scalar);

		return .(r, g, b, a);
	}

	public Self ShiftHue(float deltaHueDegrees)
	{
		var hsv = HSV(this);
		hsv.h = Math.Mod(hsv.h + deltaHueDegrees, 360.0f);
		if (hsv.h < 0.0f)
			hsv.h += 360.0f;
		return (Color)hsv;
	}

	public bool IsAlmostWhite()
	{
		return IsAlmostWhite((Color32)this);
	}

	public static bool IsAlmostWhite(Color32 color)
	{
		double luminance = (0.2126 * color.r +
		                    0.7152 * color.g +
		                    0.0722 * color.b) / 255.0;

		return luminance > 0.5;
	}

	public static Color Lerp(Color a, Color b, float t)
	{
		var t;
	    t = Math.Clamp01(t);
	    return .(
	        a.r + (b.r - a.r) * t,
	        a.g + (b.g - a.g) * t,
	        a.b + (b.b - a.b) * t,
	        a.a + (b.a - a.a) * t
	    );
	}

	public Self WithAlpha(float a)
	{
		return .(this.r, this.g, this.b, a);
	}

	public Self ShiftAlpha(float a)
	{
		return .(this.r, this.g, this.b, this.a * a);
	}

	[Obsolete("Please replace me!")]
	public Self WithAlpha(uint8 a)
	{
		return .(this.r, this.g, this.b, a / 255.0f);
	}

	public Self Invert()
	{
		return .(1.0f - this.r, 1.0f - this.g, 1.0f - this.b, this.a);
	}

	// ========================================================
	// Operator overloads
	// ========================================================

	public static implicit operator Vector3(Self a)
	{
		return .(a.r, a.g, a.b);
	}

	public static implicit operator Vector4(Self a)
	{
		return .(a.r, a.g, a.b, a.a);
	}

#if IMGUI
	public static implicit operator ImGui.ImGui.Vec4(Self a)
	{
		return .(a.r, a.g, a.b, a.a);
	}
#endif

	/// Converts a Color to a Color32
	/// Right now this is explicit for data storing reasons.
	public static explicit operator Color32(Color c)
	{
		return .((uint8)(Math.Round((Math.Clamp01(c.r) * 255f))),
			(uint8)(Math.Round((Math.Clamp01(c.g) * 255f))),
			(uint8)(Math.Round((Math.Clamp01(c.b) * 255f))),
			(uint8)(Math.Round((Math.Clamp01(c.a) * 255f))));
	}

	// ========================================================
	// Built-in colors
	// ========================================================

	public static Color White => .(1, 1, 1, 1);
	public static Color Black => .(0, 0, 0, 1);
	public static Color Transparent => .(0, 0, 0, 0);

	public static Color Red => .(1, 0, 0, 1);
	public static Color Green => .(0, 1, 0, 1);
	public static Color Blue => .(0, 0, 1, 1);
	public static Color Orange => (Color32)Raylib.ORANGE;
	public static Color Yellow => (Color32)Raylib.YELLOW;

	public static Color Gray => (Color32)Raylib.GRAY;
	public static Color DarkGray => (Color32)Raylib.DARKGRAY;
}