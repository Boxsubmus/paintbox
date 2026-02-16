using System;

namespace Paintbox;

public static class Ease
{
	[Inline]
	public static double Apply(Easing ease, double t)
	{
		return DefaultEasingFunction(ease).ApplyEasing(t);
	}
	public static float Apply(Easing ease, float t) => (float)Apply(ease, (double)t);
}