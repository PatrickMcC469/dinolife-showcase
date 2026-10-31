extends RefCounted

const SHEET = preload("res://assets/ui/adventure/information_icons_v1.png")
const ACTIONS = preload("res://assets/ui/adventure/action_symbols_v1.png")
# Bounds are reviewed against the generated artwork, not an assumed grid.
const REGIONS = {
	"territory": Rect2i(48, 90, 312, 268), "training": Rect2i(407, 100, 290, 250),
	"journal": Rect2i(776, 74, 269, 330), "group": Rect2i(46, 408, 329, 326),
	"nest": Rect2i(390, 441, 334, 284), "settings": Rect2i(754, 429, 299, 302),
	"weather_sun": Rect2i(54, 750, 302, 302), "weather_rain": Rect2i(411, 760, 300, 284),
	"weather_bloom": Rect2i(758, 766, 291, 286), "weather_snow": Rect2i(49, 1081, 318, 303),
	"weather_flood": Rect2i(387, 1097, 338, 274), "alpha": Rect2i(759, 1096, 281, 267),
}
static var cache: Dictionary = {}


static func texture(key: String) -> Texture2D:
	if cache.has(key): return cache[key]
	var pixels: Image
	if key in ["hunt", "rest", "water"]:
		var index := ["hunt", "rest", "water"].find(key)
		var size := ACTIONS.get_size()
		pixels = ACTIONS.get_image().get_region(Rect2i(int(index * size.x / 3), 0, int(size.x / 3), int(size.y)))
		pixels = pixels.get_region(pixels.get_used_rect())
	elif key in REGIONS:
		pixels = SHEET.get_image().get_region(REGIONS[key])
	else:
		return load("res://assets/ui/action_icons/%s.svg" % key)
	var scale := 128.0 / maxf(pixels.get_width(), pixels.get_height())
	pixels.resize(maxi(1, roundi(pixels.get_width() * scale)), maxi(1, roundi(pixels.get_height() * scale)), Image.INTERPOLATE_LANCZOS)
	pixels.generate_mipmaps()
	cache[key] = ImageTexture.create_from_image(pixels)
	return cache[key]
