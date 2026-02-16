using System;

namespace Paintbox;

[AttributeUsage(.StaticField)]
public struct DescriptionAttribute : Attribute
{

}

[AttributeUsage(.StaticField, .ReflectAttribute, ReflectUser=.All)]
public struct NameAttribute : Attribute
{
	public String Text;

	public this(String text)
	{
		this.Text = text;
	}
}

/// <summary>
/// See http://easings.net/ for more samples.
/// </summary>
[Reflect(.StaticFields)]
public enum Easing
{
    case None;
    case Out;
    case In;
    case InQuad;
    case OutQuad;
    case InOutQuad;
    case InCubic;
    case OutCubic;
    case InOutCubic;
    case InQuart;
    case OutQuart;
    case InOutQuart;
    case InQuint;
    case OutQuint;
    case InOutQuint;
    case InSine;
    case OutSine;
    case InOutSine;
    case InExpo;
    case OutExpo;
    case InOutExpo;
    case InCirc;
    case OutCirc;
    case InOutCirc;
    case InElastic;
    case OutElastic;
    case OutElasticHalf;
    case OutElasticQuarter;
    case InOutElastic;
    case InBack;
    case OutBack;
    case InOutBack;
    case InBounce;
    case OutBounce;
    case InOutBounce;
    case OutPow10;
}

[Reflect(.StaticFields)]
public enum EasingKind
{
	[Name("No Ease")]
	case None;
	[Name("Ease In")]
	case In;
	[Name("Ease Out")]
	case Out;
	[Name("Ease In Out")]
	case InOut;

	public String Name
	{
		get
		{
			let field = typeof(Self).GetField((int)this).Value;
			return field.GetCustomAttribute<NameAttribute>().Value.Text;
		}
	}

	public Type GetEasingPresetEnum()
	{
		switch (this)
		{
		case .None:
			return typeof(NoEasingPreset);
		case .In:
			return typeof(InEasingPreset);
		case .Out:
			return typeof(OutEasingPreset);
		case .InOut:
			return typeof(InOutEasingPreset);
		}
	}
}

[Reflect(.StaticFields)]
public enum NoEasingPreset
{
}

[Reflect(.StaticFields)]
public enum InEasingPreset
{
	case Quad = Easing.InQuad;
	case Cubic = Easing.InCubic;
	case Quart = Easing.InQuart;
	case Quint = Easing.InQuint;
	case Sine = Easing.InSine;
	case Expo = Easing.InExpo;
	case Circ = Easing.InCirc;
	case Elastic = Easing.InElastic;
	case Back = Easing.InBack;
	case Bounce = Easing.InBounce;
}

[Reflect(.StaticFields)]
public enum OutEasingPreset
{
	case Quad = Easing.OutQuad;
	case Cubic = Easing.OutCubic;
	case Quart = Easing.OutQuart;
	case Quint = Easing.OutQuint;
	case Sine = Easing.OutSine;
	case Expo = Easing.OutExpo;
	case Circ = Easing.OutCirc;
	case Elastic = Easing.OutElastic;
	case Back = Easing.OutBack;
	case Bounce = Easing.OutBounce;
	case Pow10 = Easing.OutPow10;
}

[Reflect(.StaticFields)]
public enum InOutEasingPreset
{
	case Quad = Easing.InOutQuad;
	case Cubic = Easing.InOutCubic;
	case Quart = Easing.InOutQuart;
	case Quint = Easing.InOutQuint;
	case Sine = Easing.InOutSine;
	case Expo = Easing.InOutExpo;
	case Circ = Easing.InOutCirc;
	case Elastic = Easing.InOutElastic;
	case Back = Easing.InOutBack;
	case Bounce = Easing.InOutBounce;
}