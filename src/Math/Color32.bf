using System;

namespace Paintbox;

/// 8-bit RGBA color struct.
[CRepr]
extension Color32
{
	public this(uint8 r, uint8 g, uint8 b) : this(r, g, b, 255)
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

	public static Color32 White => .(255, 255, 255, 255);
	public static Color32 Black => .(0, 0, 0, 255);
	public static Color32 Transparent => .(0, 0, 0, 0);
	public static Color32 Raywhite => Raylib.RAYWHITE;

	public static Color32 Red => .(255, 0, 0, 255);
	public static Color32 Green => .(0, 255, 0, 255);
	public static Color32 Blue => .(0, 0, 255, 255);
	public static Color32 Orange => Raylib.ORANGE;
	public static Color32 Yellow => Raylib.YELLOW;

	public static Color32 Shadow => .(0, 0, 0, 100);
	public static Color32 Gray => Raylib.GRAY;
	public static Color32 DarkGray => Raylib.DARKGRAY;

	public static Color32 ScreenFade => .(25, 25, 25, 255);

	public static Color32 DarkOutline => .Black;

	[Obsolete("Use ColorF.Lerp instead, which is more accurate and doesn't bug out randomly? I still need to fix that.")]
	public static Color32 Lerp(Color32 a, Color32 b, float t)
	{
		return .((uint8)Math.Ceiling(Math.Lerp(a.r, b.r, t)), (uint8)Math.Ceiling(Math.Lerp(a.g, b.g, t)), (uint8)Math.Ceiling(Math.Lerp(a.b, b.b, t)), (uint8)Math.Ceiling(Math.Lerp(a.a, b.a, t)));
	}

	public Self WithAlpha(uint8 a)
	{
		return .(this.r, this.g, this.b, a);
	}

	/// Converts a Hexadecimal Color to an RGB Color.
	public static Color32 Hex2RGB(StringView hex)
	{
		var hex;
		if (hex.Length > 0 && hex[0] == '#')
		    hex = hex.Substring(1);

		if (uint.Parse(hex, .HexNumber) case .Ok(let value))
		{
			Color32 color = .(0, 0, 0, 0);

			if (hex.Length == 6)
			{
			    // Format: RRGGBB (alpha defaults to 255)
			    color.r = (uint8)((value >> 16) & 0xFF);
			    color.g = (uint8)((value >> 8) & 0xFF);
			    color.b = (uint8)(value & 0xFF);
			    color.a = 255;
			}
			else if (hex.Length == 8)
			{
			    // Format: RRGGBBAA
			    color.r = (uint8)((value >> 24) & 0xFF);
			    color.g = (uint8)((value >> 16) & 0xFF);
			    color.b = (uint8)((value >> 8) & 0xFF);
			    color.a = (uint8)(value & 0xFF);
			}

			return color;
		}

		return .Black;
	}

	/// <summary>
	/// Parses two hex characters into a byte without allocation.
	/// </summary>
	private static Result<uint8> TryParseHexByte(StringView str, int index)
	{
	    uint8 result = 0;
	    if (index + 1 >= str.Length) return .Err;

	    int high = HexDigit(str[index]);
	    int low = HexDigit(str[index + 1]);

	    if (high < 0 || low < 0) return .Err;

	    result = (uint8)((high << 4) | low);
	    return .Ok(result);
	}

	public void ToHex(String outStr, bool includeAlpha = true)
	{
		if (includeAlpha)
			outStr.Append(scope $"#{this.r:X2}{this.g:X2}{this.b:X2}{this.a:X2}");
		else
			outStr.Append(scope $"#{this.r:X2}{this.g:X2}{this.b:X2}");
	}

	[Inline]
	private static int HexDigit(char8 c)
	{
	    if (c >= '0' && c <= '9') return c - '0';
	    if (c >= 'A' && c <= 'F') return c - 'A' + 10;
	    if (c >= 'a' && c <= 'f') return c - 'a' + 10;
	    return -1;
	}

#if IMGUI
	public static implicit operator Color32(ImGui.Vec4 a)
	{
		return .((uint8)(a.x * 255), (uint8)(a.y * 255), (uint8)(a.z * 255), (uint8)(a.w * 255));
	}

	public static implicit operator ImGui.Vec4(Self a)
	{
		return .(a.r / 255.0f, a.g / 255.0f, a.b / 255.0f, a.a / 255.0f);
	}
#endif

	public static implicit operator Vector3(Self a)
	{
		return .(a.r / 255.0f, a.g / 255.0f, a.b / 255.0f);
	}

	public static implicit operator Vector4(Self a)
	{
		return .(a.r / 255.0f, a.g / 255.0f, a.b / 255.0f, a.a / 255.0f);
	}

	public static implicit operator Color(Color32 c)
	{
	    return .(c.r / 255f, c.g / 255f, c.b / 255f, c.a / 255f);
	}

	public static implicit operator uint32(Self c)
	{
		return (c.r | ((uint32)c.g << 8) | ((uint32)c.b << 16) | ((uint32)c.a << 24));
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

		let r = Clamp(r / scalar);
		let g = Clamp(g / scalar);
		let b = Clamp(b / scalar);

		return .(r, g, b, a);
	}

	/// Checks if the color is valid (e.g., not transparent black).
	public bool IsValid()
	{
	    return this.a != 0 || (this.r != 0 || this.g != 0 || this.b != 0);
	}

	/// Returns a brighter or darker version of the color by modifying its RGB values.
	private static Self AdjustBrightness(Self color, float factor)
	{
	    let r = Clamp(color.r * factor);
	    let g = Clamp(color.g * factor);
	    let b = Clamp(color.b * factor);
	    return .(r, g, b, color.a);
	}

	private static uint8 Clamp(float value)
	{
	    return (uint8)Math.Clamp(value, 0, 255);
	}

	public bool IsAlmostWhite()
	{
		return IsAlmostWhite(this);
	}

	public static bool IsAlmostWhite(Color32 color)
	{
		double luminance = (0.2126 * color.r +
		                    0.7152 * color.g +
		                    0.0722 * color.b) / 255.0;

		return luminance > 0.5;
	}

	public override void ToString(String strBuffer)
	{
		strBuffer.Append(scope $"({r}, {g}, {b}, {a})");
	}
}