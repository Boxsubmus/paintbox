using Paintbox;

namespace System;

extension Math
{
	public const float TAU_f = Math.PI_f * 2.0f; // 2π

	/// Epsilon
	public const float EPS_f = 1e-6f;

	public static float Squared(float v)
		=> v * v;

	/// Get the area of a triangle.
	public static float TriangleArea(Vector2 triA, Vector2 triB, Vector2 triC)
		=> Math.Abs((triA.x * (triB.y - triC.y)
					+ triB.x * (triC.y - triA.y)
					+ triC.x * (triA.y - triB.y)) * 0.5f);

	public static int Repeat(int t, int length)
	{
		return Math.Clamp(t - (int)Math.Floor(t / length) * length, 0, length);
	}

	public static float Repeat(float t, float length)
	{
		return Math.Clamp(t - Math.Floor(t / length) * length, 0, length);
	}

	public static double Repeat(double t, double length)
	{
		return Math.Clamp(t - Math.Floor(t / length) * length, 0, length);
	}

	public static bool IsWithin<T>(T val, T min, T max)
		where bool : operator T >= T
		where bool : operator T <= T
		where T : IIsNaN
	{
		return val >= min && val <= max;
	}

	public static float Normalize(float val, float min, float max, bool clamp = true)
	{
	    // if (max - min == 0) return 1.0f;

		// @HACK
		// I don't know why, but the screen gets fucked up if the value of this is ever set to 0.
		// So we need to EPSILON, you can't really tell the difference, but jeez.
		var val;
		if (val == 0)
			val = Math.EPS_f;

	    var ret = (val - min) / (max - min);
	    return clamp ? Math.Clamp(ret, 0, 1) : ret;
	}

	public static double Normalize(double val, double min, double max, bool clamp = true)
	{
		// if (max - min == 0) return 1.0;
		var ret = (val - min) / (max - min);
		return clamp ? Math.Clamp(ret, 0, 1) : ret;
	}

	public static float Clamp01(float val)
	{
		return Math.Clamp(val, 0f, 1f);
	}

	public static double Clamp01(double val)
	{
		return Math.Clamp(val, 0d, 1d);
	}

	public static int Clamp01(int val)
	{
		return Math.Clamp(val, 0, 1);
	}

	public static Matrix CreateRotationMatrix2D(float radians)
	{
		let cosTheta = Math.Cos(radians);
		let sinTheta = Math.Sin(radians);

		return .(
		    cosTheta,  sinTheta, 0.0f, 0.0f,
		   -sinTheta,  cosTheta, 0.0f, 0.0f,
		    0.0f,      0.0f,    1.0f, 0.0f,
		    0.0f,      0.0f,    0.0f, 1.0f
		);
	}

	public static bool PointInCircle(Vector2 point, Vector2 center, float radius)
	{
		let dsp = (point - center).SqrMagnitude();
		return dsp < (radius * radius);
	}

	public static float Round2Nearest(float a, float interval)
	{
		if (a <= 0)
			return (a - (a % interval)) - interval;
	    return a - (a % interval);
	}

	public static Rectangle GetBoundingBox(Vector2 a, Vector2 b)
	{
		let minX = Math.Min(a.x, b.x);
		let minY = Math.Min(a.y, b.y);
		let maxX = Math.Max(a.x, b.x);
		let maxY = Math.Max(a.y, b.y);

		return .(minX, minY, maxX - minX, maxY - minY);
	}

	[Inline]
	public static T Mod<T>(T x, T y) where T : operator T % T where T : IIsNaN
	{
	    return x % y;
	}

	/// Compares two floating point values if they are similar.
	public static bool Approximately(float a, float b)
	{
		// If a or b is zero, compare that the other is less or equal to epsilon.
		// If neither a or b are 0, then find an epsilon that is good for
		// comparing numbers at the maximum magnitude of a and b.
		// Floating points have about 7 significant digits, so
		// 1.000001f can be represented while 1.0000001f is rounded to zero,
		// thus we could use an epsilon of 0.000001f for comparing values close to 1.
		// We multiply this epsilon by the biggest magnitude of a and b.
		return Abs(b - a) < Max(0.000001f * Max(Abs(a), Abs(b)), E_f * 8);
	}

	public static float Epsilon => sMachineEpsilonFloat;

	public static Vector2 ClampPointToCircle(float x, float y, float radius)
	{
		var x, y;

	    let yAbs = Math.Abs(y);
	    if (yAbs > radius)
	    {
	        // y is already outside the circle; clamp it to the edge vertically
	        y = Math.Sign(y) * radius;
	        x = 0f; // no x possible at the poles
	    }
	    else
	    {
	        let maxX = Math.Sqrt(radius * radius - y * y);
	        x = Math.Clamp(x, -maxX, maxX);
	    }

	    return .(x, y);
	}

	public static double Log2(double x)
	{
	    if (x.IsNaN)
	        return double.NaN;

	    if (x < 0.0)
	        return double.NaN;

	    if (x == 0.0)
	        return double.NegativeInfinity;

	    if (x.IsPositiveInfinity)
	        return double.PositiveInfinity;

	    // ln(x) / ln(2)
	    return Math.Log(x) * 1.4426950408889634073599246810019;
	    // 1 / ln(2)
	}

	[Inline]
	public static double SecondsToMilliseconds(double seconds)
	{
		return seconds * 1000.0;
	}

	[Inline]
	public static double MillisecondsToSeconds(double seconds)
	{
		return seconds / 1000.0;
	}

	public static T Min<T>(T a, T b, T c) where bool : operator T < T where T : IIsNaN
		=> Min(Min(a, b), c);

	public static T Min<T>(T a, T b, T c, T d) where bool : operator T < T where T : IIsNaN
		=> Min(Min(Min(a, b), c), d);

	public static T Max<T>(T a, T b, T c) where bool : operator T < T where T : IIsNaN
		=> Max(Max(a, b), c);

	public static T Max<T>(T a, T b, T c, T d) where bool : operator T < T where T : IIsNaN
		=> Max(Max(Max(a, b), c), d);

	/// <summary>
	/// Returns a vector whose X and Y are the minimums of the three Xs and Ys of the given vectors
	/// </summary>
	public static Vector2 Min(Vector2 a, Vector2 b, Vector2 c)
		=> Vector2.Min(Vector2.Min(a, b), c);

	/// <summary>
	/// Returns a vector whose X and Y are the maximums of the three Xs and Ys of the given vectors
	/// </summary>
	public static Vector2 Max(Vector2 a, Vector2 b, Vector2 c)
		=> Vector2.Max(Vector2.Max(a, b), c);

	/// <summary>
	/// Get the cross product of two Vector2s, ie. (a.X * b.Y) - (a.Y * b.X)
	/// </summary>
	public static float Cross(Vector2 a, Vector2 b)
		=> (a.x * b.y) - (a.y * b.x);

	#region Interpolation

	[Inline]
	public static float Lerp01(float t)
	{
		return Math.Lerp(0, 1, t);
	}

	[Inline]
	public static float Lerp10(float t)
	{
		return Math.Lerp(1, 0, t);
	}

	[Inline]
	public static float LerpEase(float val1, float val2, float t, Easing ease = .None)
	{
		return Math.Lerp(val1, val2, DefaultEasingFunction(ease).ApplyEasing(t));
	}

	public static float Bezier(float a, float b, float c, float t)
		=> Lerp(Lerp(a, b, t), Lerp(b, c, t), t);

	public static float Bezier(float a, float b, float c, float d, float t)
		=> Bezier(Lerp(a, b, t), Lerp(b, c, t), Lerp(c, d, t), t);

	public static Vector2 Bezier(Vector2 a, Vector2 b, Vector2 c, float t)
		=> Vector2.Lerp(Vector2.Lerp(a, b, t), Vector2.Lerp(b, c, t), t);

	public static Vector2 Bezier(Vector2 a, Vector2 b, Vector2 c, Vector2 d, float t)
		=> Bezier(Vector2.Lerp(a, b, t), Vector2.Lerp(b, c, t), Vector2.Lerp(c, d, t), t);

	public static float SmoothDamp(float current, float target, ref float velocity, float smoothTime, float maxSpeed, float deltaTime)
	{
		var smoothTime;
		var target;

		smoothTime = Math.Max(0.0001f, smoothTime);
		float omega = 2f / smoothTime;
		float x = omega * deltaTime;
		float exp = 1f / (1f + x + 0.48f * x * x + 0.235f * x * x * x);
		float change = current - target;
		float origTo = target;
		float maxChange = maxSpeed * smoothTime;
		change = Math.Clamp(change, -maxChange, maxChange);
		target = current - change;
		float temp = (velocity + omega * change) * deltaTime;
		velocity = (velocity - omega * temp) * exp;
		float output = target + (change + temp) * exp;
		if (origTo - current > 0f == output > origTo)
		{
			output = origTo;
			velocity = (output - origTo) / deltaTime;
		}
		return output;
	}

	#endregion
}