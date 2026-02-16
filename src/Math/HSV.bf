using System;

namespace Paintbox;

[CRepr]
public struct HSV
{
	public float h;
	public float s;
	public float v;

	public this(float hsv)
	{
		this.h = hsv;
		this.s = hsv;
		this.v = hsv;
	}

	public this(float h, float s, float v)
	{
		this.h = h;
		this.s = s;
		this.v = v;
	}

	public this(Color color)
	{
		this = rgb_2_hsv(color);
	}

	public static operator Color(HSV hsv)
	{
		return hsv_2_rgb(hsv.h, hsv.s, hsv.v, 1.0f);
	}

	public static operator HSV(Color color)
	{
		return rgb_2_hsv(color);
	}

	private static HSV rgb_2_hsv(Color c)
	{
	    float r = c.r;
	    float g = c.g;
	    float b = c.b;

	    float max = Math.Max(r, Math.Max(g, b));
	    float min = Math.Min(r, Math.Min(g, b));
	    float delta = max - min;

		float h, s, v;

	    // Hue
	    if (delta == 0.0f)
	        h = 0.0f;
	    else if (max == r)
	        h = Math.Mod(((g - b) / delta), 6.0f);
	    else if (max == g)
	        h = ((b - r) / delta) + 2.0f;
	    else
	        h = ((r - g) / delta) + 4.0f;

	    h *= 60.0f;
	    if (h < 0.0f)
			h += 360.0f;

	    // Saturation
	    s = (max == 0.0f) ? 0.0f : (delta / max);

	    // Value
	    v = max;

		return .(h, s, v);
	}

	private static Color hsv_2_rgb(float h, float s, float v, float a)
	{
		let c = v * s;
		let x = c * (1.0f - Math.Abs(Math.Mod(h / 60.0f, 2.0f) - 1.0f));
		let m = v - c;
		float r, g, b;

		if (h < 60.0f)       { r = c; g = x; b = 0; }
		else if (h < 120.0f) { r = x; g = c; b = 0; }
		else if (h < 180.0f) { r = 0; g = c; b = x; }
		else if (h < 240.0f) { r = 0; g = x; b = c; }
		else if (h < 300.0f) { r = x; g = 0; b = c; }
		else                 { r = c; g = 0; b = x; }

		let result = Color(
			(r + m),
			(g + m),
			(b + m),
			a);

		return result;
	}
}