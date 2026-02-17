namespace System.Diagnostics
{
	extension Stopwatch
	{
		// Idk what this is
		[CLink]
		private static extern bool QueryPerformanceFrequency(out int64 freq);

		[Inline]
		private static int64 QueryPerformanceFrequency_VAL()
		{
			QueryPerformanceFrequency(var v);
			return v;
		}

		// "Frequency" stores the frequency of the high-resolution performance counter,
		// if one exists. Otherwise it will store TicksPerSecond.
		// The frequency cannot change while the system is running,
		// so we only need to initialize it once.
		public static readonly int64 Frequency = QueryPerformanceFrequency_VAL();

		public int64 ElapsedTicks
		{
			// @NOTE
			// Idk why, but we need to multiply this by 10 or else the result is wrong.
			// Don't ask me why, I don't know!
			get => GetRawElapsedTicks() * 10;
		}
	}
}