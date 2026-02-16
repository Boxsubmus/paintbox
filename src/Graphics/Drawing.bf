namespace Paintbox;

extension Raylib
{
	public static void DrawRectangle(Vector2 pos, Vector2 size, Color color = .White)
	{
		DrawRectanglePro(.(pos, size), .Zero, 0.0f, (Color32)color);
	}

	public static void DrawRectangle(Rectangle rect, Color color = .White)
	{
		DrawRectanglePro(rect, .Zero, 0.0f, color);
	}

	public static void DrawRectanglePro(Rectangle rec, Vector2 origin, float angle = 0.0f, Color color = .White)
	{
		Raylib.DrawRectanglePro(rec, origin, angle, (Color32)color);
	}
}