namespace Paintbox;

/// An interface for an easing function that is applied to <see cref="Transform{TValue}"/>s.
public interface IEasingFunction
{
	/// Applies the easing function to a time value.
	double ApplyEasing(double time);
}