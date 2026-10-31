class_name StoryData

const IMG := "res://assets/story_deno/"

static func get_scene(id: String) -> Dictionary:
	var scenes := _build()
	return scenes.get(id, {"id": id, "title": "Missing Scene", "text": "Scene not found: " + id, "choices": []})


static func _build() -> Dictionary:
	return {

# ══════════════════════════════════════════════════════════════════════════════
# PROLOGUE — Name Entry
# ══════════════════════════════════════════════════════════════════════════════

"s_start": {
	"id":    "s_start",
	"act":   "",
	"title": "",
	"image": IMG + "act01_img01_morning_beneath_roots.jpg",
	"text":
"The forest remembers those who learn to read it.

Before the highland. Before the ravine and the storm and the cliff above the valley where everything ended and then began again. There was a hollow beneath a tangle of roots, and inside it, three hatchlings who did not yet know what any of those words meant.

You were the middle one. Old enough to notice things, young enough to believe the world would hold still long enough to be understood.

You had a name.",
	"type": "name_entry",
	"next": "s1_morning",
},

# ══════════════════════════════════════════════════════════════════════════════
# ACT ONE — Before the Waters
# ══════════════════════════════════════════════════════════════════════════════

"s1_morning": {
	"id":    "s1_morning",
	"act":   "Act One  —  Before the Waters",
	"title": "Morning Beneath the Roots",
	"image": IMG + "act01_img01_morning_beneath_roots.jpg",
	"text":
"The morning light came through the root tangle in pale gold lines, cutting the hollow floor into thin bright strips. The earth smelled of rain from two nights ago, and somewhere above you, a bird was repeating the same call over and over, neither alarmed nor cheerful, simply present.

You had been awake for a while, listening.

Flint was already up. He was the boldest of the three of you: rust-and-brown, with a notched left ear and a way of holding his tail that made him look permanently ready for something. Right now he stood at the mouth of the hollow with his back to you, watching the forest with the restless energy of something that needed to be moving.

Moss was still curled near the far root, breathing slowly. Quiet Moss, the smallest of you, whose feathers caught the light in two or three colors the others did not have. Moss did not rush. Moss watched and waited, and was often right about things because of it.

Mother had left before dawn. Her scent still lay warm across the threshold, the smell of home before home has been tested.

Flint turned and looked at you. His whole body was a question.",
	"choices": [
		{
			"label": "Race Flint to the tree line",
			"effects": {"flint_trust": 1},
			"result_image": IMG + "act01_img02_three_hatchlings_running.jpg",
			"result":
"You pushed past Flint before he had finished turning.

He caught up before the first fern bank, because he always did. But you had moved first, and that was the thing. You had looked at his restlessness and matched it, which was what Flint understood.

The two of you ran the length of the tree line and back, crashing through curtains of hanging moss, scattering a pair of small lizards that vanished into cracks in the bark. By the time you circled back, your legs ached and your lungs were burning pleasantly.

Flint knocked his head against your shoulder, quick and satisfied, in the way that meant: good. You kept up.

Behind you, Moss watched from the shade of the roots, somewhere between left-out and relieved.",
			"next": "s2_mother",
		},
		{
			"label": "Settle beside Moss",
			"effects": {"moss_trust": 1},
			"result":
"You stayed.

Moss looked up when you settled beside them, and for a moment the two of you sat together in the quiet, listening to the bird in the canopy, to Flint's footsteps at the hollow mouth, to the particular silence that settles when nothing is wrong.

Moss made a small sound and leaned their weight against your side.

Flint glanced back once from the threshold, reading the two of you together in the hollow, and turned away without comment. He understood things like this, even if he did not share them.",
			"next": "s2_mother",
		},
		{
			"label": "Pull Moss into the game",
			"effects": {"moss_trust": 1, "family_unity": 1},
			"result_image": IMG + "act01_img02_three_hatchlings_running.jpg",
			"result":
"You nudged Moss with your snout, gently, and waited.

Moss looked at you, then at Flint at the hollow mouth, then back at you. Something settled in them, some small decision.

The three of you ran together, Flint ahead as always, you in the middle, Moss keeping close at your side. In the dappled light at the tree line, Flint wheeled and turned to find you both there, and something shifted in him: pleased and surprised at once, which was not a combination Flint wore often.

Moss was breathing harder than either of you by the end. Moss did not fall behind once.",
			"next": "s2_mother",
		},
	],
},

"s2_mother": {
	"id":    "s2_mother",
	"act":   "Act One  —  Before the Waters",
	"title": "Mother's Return",
	"image": IMG + "act01_img04_mother_returns_fern_fix.jpg",
	"text":
"She came back before midday, moving low through the fern cover the way she did when she wanted to arrive without announcing herself.

{name} had learned to read her footsteps: the long deliberate stride that meant everything was fine, the shorter clipped steps that meant she was tired or being careful. These were the shorter ones.

She stopped at the threshold and examined each of you in the order she always did, a ritual so practiced it felt older than the hollow itself: Flint's notched ear, Moss's right-eye patch, and then you, the crescent marking across your chest that she had checked with her snout on the first morning of your life.

Then she set down what she had brought.",
	"next": "s2_meal",
},

"s2_meal": {
	"id":    "s2_meal",
	"act":   "Act One  —  Before the Waters",
	"title": "The Divided Meal",
	"image": IMG + "act01_img06_scarce_meal_v2.jpg",
	"text":
"It was not much. A young animal, already prepared, smaller than usual. The three of you looked at it without speaking. Nobody moved.

Flint's gaze went to the food and stayed there. Moss took a small step back, the way Moss did when something needed to be resolved and they did not want to be the one to resolve it.

Mother sat back. She had not eaten yet.

The meal could not feed all of you the same way. The choice of how to divide it was yours.",
	"choices": [
		{
			"label": "Give Flint the larger share",
			"effects": {"flint_trust": 1},
			"result":
"You pushed the better portion toward Flint without making it into anything.

He held eye contact with you for a moment, reading you, checking if it was real, and then ate, quickly, the way Flint did everything. When he finished he did not look away from you for a while.

Moss ate their share methodically, which was the usual way. But tonight it felt like something else, like someone eating what they had been given rather than what they needed.

Mother watched you and then looked away.",
			"next": "s3_boundary",
		},
		{
			"label": "Give Moss the larger share",
			"effects": {"moss_trust": 1},
			"result":
"Moss needed it more than Flint did. That was simply true.

You pushed the better portion across without comment. Moss stared at it for a moment before eating, quietly and with a care that felt like gratitude without being performed.

Flint accepted his share without saying anything. He did not look at you while he ate, which was its own kind of answer. He had noticed. He understood. He did not have to like it.",
			"next": "s3_boundary",
		},
		{
			"label": "Give Mother the larger share",
			"effects": {"mother_trust": 1},
			"result":
"She had run all morning to bring back what little she had. Whatever the hunt had cost her was visible in the way she carried herself.

You pushed the larger portion toward her. She paused, holding still in that particular way of hers that meant she was reading intent rather than action, and then she ate, efficiently, without excess, as she did everything.

When she finished, she pressed her snout briefly to the top of your head. One touch. Then she stepped back.

You went to sleep that night a little hungrier than you needed to be, and did not mind.",
			"next": "s3_boundary",
		},
		{
			"label": "Divide it as evenly as you can",
			"effects": {"family_unity": 1},
			"result":
"There was no clean way to make it exactly even, but you tried.

Three shares, roughly the same. Flint accepted his without reaction. Moss took a moment, then ate. You ate yours and were aware the whole time that none of it was quite enough.

The family finished the meal without friction. It was the quietest outcome, and perhaps the fairest, and everyone remained a little hungry in the same way.

Mother watched the process. She did not interfere.",
			"next": "s3_boundary",
		},
		{
			"label": "Take the better share for yourself",
			"effects": {},
			"result":
"You were faster than either of your siblings and you were hungry, and you let both of those things be reasons.

By the time anyone else had moved, the better part of the meal was already yours. Flint met your eyes and turned away without a sound. That was worse than if he had made one.

Moss did not look at you for the rest of the evening.

Mother observed it all without expression. That, somehow, was the hardest part to sit with.",
			"next": "s3_boundary",
		},
	],
},

"s3_boundary": {
	"id":    "s3_boundary",
	"act":   "Act One  —  Before the Waters",
	"title": "Beyond the Ferns",
	"image": IMG + "act01_img08_mothers_boundary.jpg",
	"text":
"The next morning, Mother led the three of you to the edge of familiar ground.

She marked the boundary the same way every time: a slow circuit, scent pressed into the bark of three particular trees, a low sound in her chest that was not quite a call. The message was clear enough. This is where safe ends. This is where you stay.

Then she left again.

Flint had already noticed the stream.",
	"next": "s3_stream",
},

"s3_stream": {
	"id":    "s3_stream",
	"act":   "",
	"title": "",
	"image": IMG + "act01_img09_changed_stream.jpg",
	"text":
"It was not where it had been yesterday. Not by much, but enough. The sound of it was different, the smell slightly changed, the way it moved through the fern gaps heavier than it should have been for the weather you had seen. Flint stood at the boundary with his head tilted, trying to decide whether it mattered.

The smell of rain was in the air again. Not falling. Building.",
	"choices": [
		{
			"label": "Obey the boundary and wait",
			"effects": {"mother_trust": 1},
			"result":
"You stayed on the safe side of the marked trees.

Flint watched you not following him, made a small dismissive sound, and crossed the boundary anyway. You watched him through the ferns, picking along the edge of the changed stream, investigating things you were not investigating.

By the time Mother returned, Flint was back in the hollow with mud on his forelegs. He said nothing about where he had been. You said nothing about what you had not done.

It is possible you were both right.",
			"next": "s_text_morning_of_hunt",
		},
		{
			"label": "Cross with Flint to investigate",
			"effects": {"flint_trust": 1, "flood_warning": true},
			"result_image": IMG + "act01_img09_changed_stream.jpg",
			"result":
"The stream had risen. More than the weather explained.

You and Flint crouched at the edge of it, watching the water move. It was quick and slightly clouded, and the ground on the near bank was soft in a way that made you want to step back. Flint read it as interesting. You read it as something else.

The soil at the root line was wet above where the water was now. The stream had been here and retreated and come back. That pattern meant something.

Flint said nothing. He rarely named things he did not understand. But he looked at you when you looked at the water, which meant he had noticed that you noticed.",
			"next": "s_text_morning_of_hunt",
		},
		{
			"label": "Bring Moss across carefully",
			"effects": {"moss_trust": 1, "family_unity": 1, "flood_warning": true},
			"result":
"Moss moved carefully, staying close. You matched their pace, which turned out to be useful.

It was Moss who noticed the marks on the tree bark first: water stains, higher than made sense, pressed into the grain like a record. You would not have looked at that height. Someone smaller and lower to the ground had a different view.

Between the two of you, the picture assembled itself: the stream had been here. Then it had not been here. The ground still remembered.

Moss looked at the marks for a long time before looking at you.",
			"next": "s_text_morning_of_hunt",
		},
		{
			"label": "Bring the changed stream to Mother",
			"effects": {"mother_trust": 1, "flood_warning": true},
			"result":
"Mother listened without interrupting. She was good at that: absorbing information, holding it behind eyes that gave nothing away while they worked.

When you finished, she went to look herself. She stood at the stream for longer than you expected. When she turned back, her expression was one you had not seen on her before: focused in a different way than hunting. Focused the way something focuses when it is revising what it knows about where it stands.",
			"next": "s_text_morning_of_hunt",
		},
		{
			"label": "Investigate on your own",
			"effects": {"flood_warning": true, "alternate_route": true},
			"result":
"Alone, you moved faster and lower.

You worked the bank methodically, checking things the others would have walked past. The soil told one story. The water line on the rocks told another. Put together, they said: this ground floods. Regularly. Recently.

Further along, where the bank bent and the trees grew close, you found a rise: a spine of older rock climbing from the streambed toward higher ground. Dry. Solid. The kind of thing that would still be there if the water came back with more intention.

You filed it somewhere useful.",
			"next": "s_text_morning_of_hunt",
		},
	],
},

"s_text_morning_of_hunt": {
	"id":    "s_text_morning_of_hunt",
	"act":   "Act One  —  Before the Waters",
	"title": "Before the Lesson",
	"image": IMG + "act01_img10_brambles_hunting_lesson (1).jpg",
	"text":
"The morning was the kind that made it easy to believe nothing had changed.

Sunlight through the root tangle. Flint already restless at the hollow mouth, tail in motion. Moss somewhere between awake and not, making the small sounds they made when they were choosing to stay down one moment longer. The birds in the canopy doing what birds did in the canopy.

{name} lay still in the warmth and let the morning be ordinary for as long as it was willing to stay that way.

Then Mother moved, and the three of you read the movement the way you read everything she did: not as instruction, not yet, but as a direction. She was going to the low ferns. She was going to show you something.

You got up.",
	"choices": [
		{"label": "Follow her", "effects": {}, "next": "s4_hunt"},
	],
},

"s4_hunt": {
	"id":    "s4_hunt",
	"act":   "Act One  —  Before the Waters",
	"title": "The First Hunt",
	"image": IMG + "act01_img10_brambles_hunting_lesson (1).jpg",
	"text":
"Mother brought the three of you to the low ferns at the far side of the hollow and showed you the shape of the thing without using words.

She moved through it first: the crouch, the drift forward, the long patience before the moment. She showed you that waiting was not the same as wasting time. That the ground between hunter and hunted was a problem to be solved, not a distance to be closed as fast as possible. That speed was the last tool you reached for, not the first.

Then she stepped back.

Flint went first, because he always did. He held the crouch for about six seconds before his tail gave him away, the involuntary lash, and he broke early, chasing something small that disappeared into the brush before he had taken three steps. He came back without anything. Mother watched without expression.

Moss went slower. More deliberate. Moss got within striking range and then froze entirely, overwhelmed by the gap between close enough and actually committing. Also nothing.

Your turn.",
	"next": "s4_hunt_danger",
},

"s4_hunt_danger": {
	"id":    "s4_hunt_danger",
	"act":   "",
	"title": "",
	"image": IMG + "act01_img11_talon_breaks_formation.jpg",
	"text":
"You were three steps into your approach when Flint moved again.

He had spotted something through the undergrowth, larger than what Mother had shown you, larger than anything the three of you should have been considering, and he had simply gone for it, without a signal, without a check, without any thought given to what a creature that size might have nearby.

The answer came back from the forest before you could call his name.",
	"next": "s4_hunt_choice",
},

"s4_hunt_choice": {
	"id":    "s4_hunt_choice",
	"act":   "",
	"title": "",
	"image": IMG + "act01_img12_forest_answers.jpg",
	"text":
"Something large crashed through the brush to the right: an adult carnivore, not the largest kind, but large enough, and moving fast and irritated. It had not been hunting you before Flint made noise. It was now.

Mother called once from across the hollow. Sharp. Final.

You had a second. Maybe two.",
	"choices": [
		{
			"label": "Grab what food you can and run",
			"effects": {},
			"result":
"There was prey on the ground from Flint's first attempt, small and unattended. You snatched it and ran, keeping low, breaking for the hollow before the larger animal could reorient.

You made it. Flint made it on his own, breathing hard. Moss had never left the ferns.

The meal was small. The family was intact. Mother looked at what you had brought back and did not comment on how you had gotten it.",
			"next": "s5_thunder",
		},
		{
			"label": "Call a warning to give everyone time",
			"effects": {"mother_trust": 1, "family_unity": 1},
			"result":
"You called out, the short sharp sound Mother had drilled into you, the one that meant move not look, and then you moved yourself.

Flint heard it and broke left. Moss broke right on instinct. The larger animal reached the clearing and found nobody there to catch.

Everyone made it back to the hollow. It had cost you the hunt, but not the family, and when Mother counted you over she made the small sound she made when the answer was the right one.",
			"next": "s5_thunder",
		},
		{
			"label": "Draw the danger toward yourself",
			"effects": {},
			"result":
"You broke from the fern cover and ran across the animal's sightline, making yourself loud and visible.

It worked. The larger predator swung toward you and away from the others, which gave Flint time to disappear into the brush and Moss time to do what Moss did well: vanish entirely.

You ran a winding path back to the hollow, the animal behind you for longer than you would have chosen. You arrived breathing hard and limping slightly from where you had caught your foot on a root.

Everyone was there when you reached them. That was what mattered.",
			"next": "s5_thunder",
		},
		{
			"label": "Go after Flint before it reaches him",
			"effects": {"flint_trust": 1},
			"result":
"Flint was still moving toward the larger animal when you cut him off, driving him sideways with your shoulder, forcing a direction change whether he wanted one or not.

He resisted for a stride, then understood what the sound behind you both meant, and ran.

The two of you made it back together. When the adrenaline wore off and the hollow was quiet again, Flint sat beside you without saying anything, which was Flint's version of acknowledgment.",
			"next": "s5_thunder",
		},
		{
			"label": "Keep yourself between the danger and Moss",
			"effects": {"moss_trust": 1},
			"result":
"Moss had gone still in the way they did under pressure: not hiding, not running, simply frozen between one decision and the next.

You placed yourself between Moss and the sound and held there until something shifted in Moss and they started moving. Then you moved with them, keeping yourself to the exposed side until you were both back inside the boundary.

Flint had found his own way back. He was already in the hollow when you arrived.

Moss pressed close to your side for a while after, and did not try to explain why.",
			"next": "s5_thunder",
		},
	],
},

"s5_thunder": {
	"id":    "s5_thunder",
	"music": "low_tension_140bpm",
	"act":   "Act One  —  Before the Waters",
	"title": "Thunder in the Distance",
	"image": IMG + "act01_img13_thunder_in_the_distance_family_only.jpg",
	"text":
"The rain came back that evening with more weight behind it.

It had been raining on and off for days. Long enough to feel ordinary, short enough that none of you had stopped to add it up. Now the adding-up felt urgent. The ground around the hollow had gone soft in a way that took longer than one night to happen. The stream, if you had been to see it, would have been louder.

Mother stood at the hollow entrance for a long time, watching the forest receive the rain. Her attention had a quality you recognized from the hunt: not general alertness, but something directed. Something she was trying to solve.

She had not told you to prepare. She had not told you anything. But the way she stood said the same thing the water-marked trees said, and the softened ground, and the stream that had moved without reason.

Something was coming, and there was still a little time.",
	"choices": [
		{
			"label": "Warn Mother what you found at the stream",
			"effects": {"mother_trust": 1},
			"requires": {"flood_warning": true},
			"result":
"You told her what you had seen: the changed bank, the water marks above the current level, the way the soil had been wet where it should not have been.

She listened differently this time. Not processing it from the outside in. Processing it as if it confirmed something she had already begun to believe.

She spent the next hour reinforcing the hollow entrance with packed earth and root fiber, moving with efficiency and no wasted motion. When she was done, she pulled the three of you further back from the entrance than the usual sleeping arrangement.

In the night, rain hammered the roof of roots overhead.",
			"next": "s6_night",
		},
		{
			"label": "Reinforce the walls of the hollow",
			"effects": {"reinforced_nest": true},
			"result":
"You worked through the afternoon at the hollow walls, packing soil into the gaps where the roots grew wide apart, pressing bark into the places where water had begun to seep.

Flint watched you for a while and then, without comment, started on the other side of the entrance. Moss wove smaller materials into the lower gaps, the kind of fine work that Moss was better at than either of you.

By the time the rain intensified, the hollow was tighter than it had been that morning. Not a different place. A more defended one.",
			"next": "s6_night",
		},
		{
			"label": "Search for higher ground nearby",
			"effects": {"alternate_route": true, "early_evacuation": true},
			"result":
"You slipped out of the hollow before the worst of the rain and worked your way uphill.

The rock spine you had noticed, or found this time for the first time, rose clean and dry above the forest floor, its surface too old and hard for the water to have softened. There was a shelf near the top wide enough for all of you, sheltered by an overhang.

You memorized the path in both directions. The route from the hollow. The way the light came through the trees that would let you find it in the dark.

You came back and told no one yet. But you knew where the high ground was.",
			"next": "s6_night",
		},
		{
			"label": "Stay close to Moss through the night",
			"effects": {"moss_trust": 1},
			"result":
"Moss had gone quiet in the particular way that meant not calm, just contained.

You settled beside them and stayed there. The rain built and receded and built again. Moss did not sleep easily, but they slept, eventually, with your weight alongside theirs.

In the morning, Moss looked at you before looking at anything else. There was something steady in it, like a decision they had made while you were both asleep.",
			"next": "s6_night",
		},
	],
},

"s6_night": {
	"id":    "s6_night",
	"act":   "Act One  —  Before the Waters",
	"title": "The Last Quiet Night",
	"image": IMG + "act01_img07_rain_over_nest_three_stripes.jpg",
	"text":
"The hollow was quiet.

Rain moved across the canopy above in slow waves, each one louder than the last, the forest adjusting its sounds around the water the way it always did. The air smelled of wet bark and turned earth and the particular cold that comes before something changes.

Mother had settled at the entrance, facing out. That was not her usual place. You noted it without speaking about it.

Flint was asleep or nearly so, his breathing even, his body finally at rest after a day of too much motion. Moss lay near the back root, awake and still.

The night felt like a room where someone had left something behind. Not wrong. Just heavier than it should have been.

You chose one of them to spend it beside. To hear something small and true before the world got louder.",
	"choices": [
		{
			"label": "Lie beside Mother at the entrance",
			"effects": {"mother_trust": 1, "knows_mother_call": true},
			"result":
"She did not say anything. Neither did you.

You lay beside her at the hollow mouth and watched the rain come down through the root gaps, and after a while she made the low sound she made sometimes when the family was accounted for: not language, not quite, but unmistakably a call, the one that meant I know where you are.

You would recognize that sound anywhere. Even in chaos. Even in dark water.

You stored it somewhere careful, the way you stored the things that mattered.",
			"next": "s7_flood",
		},
		{
			"label": "Settle beside Flint",
			"effects": {"flint_trust": 1, "knows_flint_signal": true},
			"result":
"Flint was almost asleep. He opened one eye when you settled beside him and closed it again, which was Flint's way of saying: fine.

After a while, in the near-dark, he made a low sound: not the one he used for the family, but a shorter one, a pattern you had heard him use once before when you were both very young. Once for attention. Twice for warning. The difference in the rhythm meant everything.

You lay there memorizing it without knowing why you were memorizing it.

By morning, you knew it without having to think.",
			"next": "s7_flood",
		},
		{
			"label": "Curl beside Moss at the back root",
			"effects": {"moss_trust": 1, "knows_moss_feather": true},
			"result":
"Moss was not asleep. You could tell by the small adjustments: the breathing that was slightly too careful, the occasional shift that gave nothing away to anyone who was not paying attention.

You settled beside them, and after a while Moss turned and pressed the side of their head against yours. Their feathers, the ones along the crest, the ones that caught every color differently, lay close against your face.

You would know that pattern anywhere. The particular arrangement, the way the light caught it.

In the dark, in noise, in water: you would know Moss by those feathers.",
			"next": "s7_flood",
		},
	],
},

"s7_flood": {
	"id":    "s7_flood",
	"act":   "Act One  —  Before the Waters",
	"title": "The Flood",
	"image": IMG + "act01_img14_flood_breaks_in.jpg",
	"text":
"The water did not warn you.

One moment the rain was heavy and the ground was soft and the stream was loud somewhere in the dark. The next moment the hollow filled with cold that moved.

{name} was awake before the water reached your legs. Something you had stored came through the dark and the noise: Mother's call, or Flint's rhythm, or the color of Moss's feathers. You moved toward it.

The world outside the hollow was unrecognizable. The forest floor had become a current. The root system that had been your home was collapsing under the weight of water from somewhere upstream, something larger than rain, a wall of it.

Everyone was in a different place. Everyone needed something different.

You had time for two choices before the water took the choice away.",
	"next": "s7_flood_first",
},

"s7_flood_first": {
	"id":    "s7_flood_first",
	"act":   "",
	"title": "First Action",
	"image": IMG + "act01_img16_run_for_higher_ground.jpg",
	"text":
"Through the noise and the dark and the moving water, you found them one at a time.

Mother was at the shelter entrance, pinned under a collapsed root section, working to free herself. Flint was stranded on a raised root to the left, the water between you moving too fast to wade without help. Moss was trapped in the far corner of the hollow where the water was shallowest but rising, too frightened to move without someone beside them.

You had to choose who to reach first.",
	"choices": [
		{
			"label": "Reach Mother at the entrance",
			"effects": {"mother_freed_in_flood": true, "flood_first_rescue": "mother"},
			"result_image": IMG + "act01_img17c_markings_more_prominent.jpg",
			"result":
"The root section was heavy. You dug your claws into the mud beside it and pushed from underneath while Mother worked from above, and after a long moment that felt like several, it shifted enough.

She came free. Checked herself. Checked you. Then she grabbed the back of your neck with her teeth, not hard, just holding, and moved you both toward the edge of the hollow before the next surge came through.

She was not injured. She was moving well. You would feel that later, the relief of it.",
			"next": "s7_flood_second_after_mother",
		},
		{
			"label": "Cross to Flint on the raised root",
			"effects": {"flint_trust": 1, "flood_first_rescue": "flint"},
			"result":
"The current between you and Flint was fast and cold. You drove into it low and kept your weight down, and the water tried to move you and did not entirely succeed.

Flint reached down with his forelimb and pulled when you were close enough. The two of you held the root together while the water peaked and then fell back a few inches, enough to move.

He looked at you the way Flint looked at things he did not have words for.",
			"next": "s7_flood_second_after_flint",
		},
		{
			"label": "Go to Moss in the far corner",
			"effects": {"moss_trust": 1, "flood_first_rescue": "moss"},
			"result_image": IMG + "act01_img17a_help_moss.jpg",
			"result":
"Moss was frozen. Not swept away, not hurt, just locked in place by something that had nothing to do with the water level.

You pressed against them until their breathing changed and their legs started working, and then you moved together, close, your body next to theirs, out of the corner and toward the hollow mouth.

Moss did not freeze again after that. Not that night.",
			"next": "s7_flood_second_after_moss",
		},
	],
},

"s7_flood_second_after_mother": {
	"id":    "s7_flood_second_after_mother",
	"act":   "",
	"title": "Second Action",
	"image": IMG + "act01_img16_run_for_higher_ground.jpg",
	"text":
"Mother was moving. She could find her own way now. You turned back into the chaos.

Flint was still on the raised root, which was still above water. Moss was still in the far corner. The hollow was continuing to fill. You had one more action before the water made all the decisions.",
	"choices": [
		{
			"label": "Get to Flint on the raised root",
			"effects": {"flint_trust": 1, "flood_companion": "flint"},
			"result_image": IMG + "act01_img20b_shelter_with_flint.jpg",
			"result":
"You drove through the current and reached Flint's root and pulled him down with you, and the two of you ran for the high ground together.

Moss was not where you had last seen them. The corner of the hollow was empty: of Moss and of everything else.

You woke the next morning on a shelf of dry rock above the flood line, cold and exhausted, Flint pressed against your side. You did not know yet where Moss was. Missing was not the same as gone.",
			"next": "s7_aftermath",
		},
		{
			"label": "Fight back to Moss in the far corner",
			"effects": {"moss_trust": 1, "flood_companion": "moss"},
			"result_image": IMG + "act01_img20a_shelter_with_moss.jpg",
			"result":
"You turned back into the hollow and found Moss still there, still frozen, the water now at their chest.

You drove against them until something gave and they moved, and this time you did not wait for them to decide; you moved them, shoulder to shoulder, all the way to the high ground.

Flint was not there when you arrived at the shelf. He was not there when the night ended either.

You woke the next morning with Moss curled against you, shivering, and the quiet that comes after water when the water is gone.",
			"next": "s7_aftermath",
		},
	],
},

"s7_flood_second_after_flint": {
	"id":    "s7_flood_second_after_flint",
	"act":   "",
	"title": "Second Action",
	"image": IMG + "act01_img16_run_for_higher_ground.jpg",
	"text":
"Flint was moving on his own now. You looked back into the hollow.

Mother was still at the entrance, working against the collapsed root. Moss was in the far corner, the water rising steadily around them. You had one more chance before the flood decided everything.",
	"choices": [
		{
			"label": "Go back for Mother at the entrance",
			"effects": {"mother_freed_in_flood": true, "flood_companion": "mother"},
			"result_image": IMG + "act01_img20b_shelter_with_flint.jpg",
			"result":
"You drove back through the current and pushed against the root from below while Mother worked from above, and it moved, and she came free.

She grabbed the back of your neck and moved you both toward open ground. Flint found you on the high shelf before dawn.

You woke with Mother to your left and Flint to your right, both of them damp and exhausted. Moss's place in the arrangement was empty. That absence had a shape to it.",
			"next": "s7_aftermath",
		},
		{
			"label": "Turn back for Moss in the corner",
			"effects": {"moss_trust": 1, "flood_companion": "flint"},
			"result_image": IMG + "act01_img20a_shelter_with_moss.jpg",
			"result":
"You broke from Flint's side and drove back into the hollow, following the sound of Moss through the water noise.

They were still there. You pressed against them until they moved, and then you kept moving them, and you found the high shelf together just ahead of the worst of the surge.

Flint came separately. You heard him arrive sometime in the night. Mother you did not hear.

You woke the next morning with both siblings beside you. The space where Mother should have been was cold.",
			"next": "s7_aftermath",
		},
	],
},

"s7_flood_second_after_moss": {
	"id":    "s7_flood_second_after_moss",
	"act":   "",
	"title": "Second Action",
	"image": IMG + "act01_img16_run_for_higher_ground.jpg",
	"text":
"Moss was moving. You looked back into the chaos of the hollow.

Mother was still at the entrance, the root across her, not yet free. Flint was on the raised root to the left, the current between you still running hard. Both of them needed something. You had one more choice.",
	"choices": [
		{
			"label": "Get back to Mother at the entrance",
			"effects": {"mother_freed_in_flood": true, "flood_companion": "moss"},
			"result_image": IMG + "act01_img20a_shelter_with_moss.jpg",
			"result":
"You pushed against the root from below and Mother worked from above and the thing moved, and she came out of it moving well, no injury, just the cost of effort, and the two of you went for higher ground with Moss already ahead of you.

Flint found the shelf on his own.

You woke the next morning with all of them around you, damp and close. It took a moment to count them. When you had, you pressed your nose to the cold ground and breathed.",
			"next": "s7_aftermath",
		},
		{
			"label": "Fight the current to reach Flint",
			"effects": {"flint_trust": 1, "flood_companion": "moss"},
			"result_image": IMG + "act01_img20c_shelter_together.jpg",
			"result":
"The water between you and Flint's root had dropped an inch or two, just enough. You drove through it and he pulled you up, and the two of you made it to the shelf together.

Mother was not on the high ground when you arrived. She came later, in the deep part of the night, moving stiffly. She had gotten herself free. But it had cost her something.

You woke the next morning with Flint and Moss on either side of you. Mother lay a little apart, her breathing heavier than usual.",
			"next": "s7_aftermath",
		},
	],
},

"s7_aftermath": {
	"id":    "s7_aftermath",
	"act":   "Act One  —  Before the Waters",
	"title": "After the Water",
	"image": IMG + "act01_img21_aftermath.jpg",
	"text":
"The flood left before dawn.

What it left behind was not the forest you had known. The hollow was collapsed, the root tangle broken open, the marked trees torn from the soft ground and carried somewhere downstream. The boundary that Mother had scented was gone. So was most of what the boundary had enclosed.

{name} lay on the shelf of dry rock and looked at what was left.

Some of the family was there. The rest was missing: not gone, not confirmed, just absent, the way things become absent when water takes what it takes and does not explain the accounting.

Missing was not the same as gone.

You held that like something you might need later.

The territory that had been your world since hatching did not exist anymore. Wherever you were going next, you were starting from here.",
	"next": "s8_wake",
},

# ══════════════════════════════════════════════════════════════════════════════
# ACT TWO — After the Flood
# ══════════════════════════════════════════════════════════════════════════════

"s8_wake": {
	"id":   "s8_wake",
	"type": "auto_redirect",
	"choices": [
		{"next": "s8_with_mother", "requires": {"flood_companion": "mother"}},
		{"next": "s8_with_flint",  "requires": {"flood_companion": "flint"}},
		{"next": "s8_with_moss",   "requires": {"flood_companion": "moss"}},
		{"next": "s8_alone"},
	],
},

"s8_with_mother": {
	"id":    "s8_with_mother",
	"act":   "Act Two  —  After the Flood",
	"title": "Waking",
	"image": IMG + "act02_img23_beyond_the_familiar_hollow_together.jpg",
	"text":
"The shelf was dry. That was the first thing.

The second thing was Mother.

She was there when you opened your eyes, close enough that you could feel the low tide of her breathing. She had not left in the night, had not slipped away to check some trail that could not wait. She was simply there, which was the thing you had not been sure of until you checked.

{name} held still and let that be enough for a moment.

Below, the forest had been remade by the water. The hollow was gone. You knew without looking, the way you know things whose absence you have not yet tested. The marked trees, the boundary, the route between sleeping and waking: all of it reorganized in a night by something that had not asked permission.

What you did not know yet: where Flint was. Where Moss was. You held missing like something fragile, trying not to apply pressure.",
	"next": "s8_leaving",
},

"s8_with_flint": {
	"id":    "s8_with_flint",
	"act":   "Act Two  —  After the Flood",
	"title": "Waking",
	"image": IMG + "act02_img23_beyond_the_familiar_hollow_flint.jpg",
	"text":
"The shelf was dry. That was the first thing.

The second thing was Flint: already awake, sitting at the shelf's edge with a stillness you had not seen on him before. Not the coiled kind. Not the waiting-to-move kind. Something that had run past motion entirely and arrived somewhere quieter.

He did not look at you when you stirred. His tail moved once, low and brief: the thing he did when he wanted to mark something without making it into a thing.

{name} lay still and added up what the night had been.

Mother was not on the shelf. Moss was not on the shelf. The forest below had been reorganized by the water: familiar shapes in unfamiliar arrangements, the territory broken open and rearranged. The hollow was gone. Two names that had always answered were not answering now.

Missing was not the same as gone. Flint had not said so. But he had not moved from the shelf's edge all morning.",
	"next": "s8_leaving",
},

"s8_with_moss": {
	"id":    "s8_with_moss",
	"act":   "Act Two  —  After the Flood",
	"title": "Waking",
	"image": IMG + "act02_img23_beyond_the_familiar_hollow_moss.jpg",
	"text":
"The shelf was dry. That was the first thing.

The second thing was Moss: pressed close enough to your side that the line between cold and warmth had become impossible to find. Awake, from the breathing, but not moving. Lying very still in the way Moss lay still when they were working through something difficult and did not want company inside the working.

{name} waited.

After a while Moss shifted, barely, just the weight of them settling more deliberately against your side, which was their version of: I know you are there.

Below the shelf, the forest had been rearranged. Paths that had been easy going now led to mud and new channels. The hollow was gone. The marked trees were gone.

Flint was not on the shelf. Mother was not on the shelf.

You did not say their names out loud. Moss did not say anything either, which was a kind of saying.",
	"next": "s8_leaving",
},

"s8_alone": {
	"id":    "s8_alone",
	"act":   "Act Two  —  After the Flood",
	"title": "Waking",
	"image": IMG + "act02_img23_beyond_the_familiar_hollow_alone.jpg",
	"text":
"The shelf was dry. That was the first thing.

The second thing was the silence.

{name} was alone on the rock. You had known it before you opened your eyes: the absence had a texture, something in the air that said: no one else. The shelf was cold and wide, the wind crossing it without obstruction, and all the small sounds that meant home were not there.

You lay still for a long time and listened to what was not there.

Below, the forest had been reorganized by the flood. Channels cut into the earth. The hollow gone or buried. The marked trees carried off. The territory that had been your world since hatching rebuilt in a night into something that did not remember what it had been.

You did not know where any of them were.

Missing was not the same as gone. You had decided that last night. You were still working on believing it.",
	"next": "s8_leaving",
},

"s8_leaving": {
	"id":    "s8_leaving",
	"act":   "Act Two  —  After the Flood",
	"title": "Beyond the Familiar Hollow",
	"image_by_state": {
		"flood_companion": {
			"mother":  IMG + "act02_img23_beyond_the_familiar_hollow_together.jpg",
			"flint":   IMG + "act02_img23_beyond_the_familiar_hollow_flint.jpg",
			"moss":    IMG + "act02_img23_beyond_the_familiar_hollow_moss.jpg",
			"default": IMG + "act02_img23_beyond_the_familiar_hollow_alone.jpg",
		},
	},
	"text":
"You moved when the sun was high enough to see by.

The shelf let down onto exposed rock, still damp, then into forest that was familiar in its parts and foreign in its arrangement. The great trees still stood: the old ones, rooted too deep to shift. But the spaces between them had changed. Undergrowth stripped clean in some places, heaped in others. Paths that had been easy going now led to mud and water-cut gaps that had not been there yesterday.

{name} moved slowly and read what was left.

The flood had come from the north. The land tilted away south and east, toward higher ground and open country that neither of you had entered before. Whoever was with you stayed close without being asked.

The hollow was gone. There was nothing to return to. The direction was the only question.",
	"choices": [
		{
			"label": "Search the flood plain for signs of the others",
			"effects": {"family_unity": 1},
			"result":
"You worked the flood plain first, moving low and methodical, reading the soft post-flood ground.

What you found were traces: a pressed place in the mud where something had rested, a scuff mark at the base of a standing tree. The particular smell of family at a set of exposed roots where the water had retreated.

Not them. Signs that they had been here, or were close, or that the flood had not taken everything.

You held the traces like something useful and moved on.",
			"next": "s9_herd",
		},
		{
			"label": "Follow the high ground south and east",
			"effects": {},
			"result":
"The slope rose clean and certain underfoot, the rock older and drier, the forest thinning as it climbed.

From the first ridge crest, the land opened up. More of it than you had known existed, stretching south in layered greens and shadow lines and the occasional flash of water. Unfamiliar. Large. Yours, now, to learn.

You picked a direction and descended into it.",
			"next": "s9_herd",
		},
		{
			"label": "Read the flood's path before moving",
			"effects": {"unstable_ridge_known": true},
			"result":
"You followed the flood line backward: not upstream, but reading what it had left. Bark stripped at water height. Debris piled in the direction the current had pushed. Soil compressed under something fast and heavy.

The flood had funneled through a gap in the ridge system to the south. That ridge still stood: dry, solid, too old and deep to have moved. The same ridge system ran higher further east, where the stone was older still.

High ground. Real high ground. You stored the bearing somewhere useful.",
			"next": "s9_herd",
		},
		{
			"label": "Wait another day in case they come back to the shelf",
			"effects": {"mother_trust": 1},
			"result":
"You stayed.

It cost a full day of light and most of a day's worth of food. You sat at the shelf's edge and watched the paths below for movement that was the right shape, the right way of moving.

Nothing came.

What settled in instead was a kind of certainty: that waiting had finished, and moving would find answers that sitting could not. You rose before dark and pointed yourself south.",
			"next": "s9_herd",
		},
	],
},

"s9_herd": {
	"id":    "s9_herd",
	"music": "hunt_music",
	"act":   "Act Two  —  After the Flood",
	"title": "The Great Herd",
	"image": IMG + "act02_img24_the_great_herd.jpg",
	"text":
"You heard them before you saw them.

A sound like the ground becoming conscious of itself: a low, sustained percussion of footsteps, thousands of them, rising from below the threshold of hearing into something you felt in the chest. The forest went quiet around it: birds dropped from sight, small animals vanished, and the air developed a particular tension of things that had calculated the herd's path and removed themselves from it.

Then the trees opened and {name} stopped entirely.

The herd was enormous. Sauropods, mostly: long-necked, wide-shouldered, the largest living things you had ever seen, moving in a formation that had its own internal logic. They were heading south, following a corridor of lower ground, and their passage was reshaping the land as they went: saplings pressed flat, stream banks widened, the air heavy with the smell of crushed vegetation on a scale you had no prior reference for.

At the edges, juveniles moved under the guard of the adults. Smaller. Faster. Watching the tree line.

Behind the herd, you knew, the things that followed it would be following it still.",
	"choices": [
		{
			"label": "Stay hidden and study them from cover",
			"effects": {"scarjaw_trust": 1},
			"result":
"You pulled whoever was with you into the fern line and crouched.

The herd passed for what might have been an hour. Long enough to read it: the spacing between family groups, the way adults shifted to close around the young when the tree line pressed close, the constant outward attention of the outer rank.

Near the last group, one adult turned its head and looked directly at the tree line where you were hidden. Held the look for a long moment. Then moved on.

You breathed again. The patience had cost nothing and given you everything about how the herd worked.",
			"next": "s10_hunt",
		},
		{
			"label": "Move at the herd's outer edge — borrow their presence as cover",
			"effects": {"alternate_route": true},
			"result":
"You matched the herd's pace at the outermost margin, far enough to stay unnoticed but close enough to borrow the safety that something that large provided.

The things that hunted sauropods did not hunt at the margins. The things that hunted you would not cross into that radius.

For a long stretch you moved in the shadow of something enormous and were not afraid.",
			"next": "s10_hunt",
		},
		{
			"label": "Watch the rear of the herd for opportunity",
			"effects": {"flint_trust": 1},
			"result":
"The stragglers at the tail were the slow, the young, the ones who had not found their position in the formation yet.

You watched them with the arithmetic Mother had taught: distances, angles, the weight of each obstacle. But the adults were watching the rear with identical attention, and when one turned toward you, not alarmed, simply large and aware, you let the window close without acting.

The lesson was in the measuring.",
			"next": "s10_hunt",
		},
		{
			"label": "Circle wide to track what follows behind the herd",
			"effects": {"unstable_ridge_known": true},
			"result":
"You circled wide of the herd's path and found the trail of what came after.

Most were small, opportunistic. But one set of tracks stopped you.

Large. Four-toed. The stride of something that covered ground efficiently rather than fast: patient movement, purposeful. Not chasing. Following. The kind that did not need to hurry because its prey could not change direction.

The prints were fresh. They were heading south. Same direction as the herd. Same direction as you.",
			"next": "s10_hunt",
		},
	],
},

"s10_hunt": {
	"id":    "s10_hunt",
	"music": "hunt_music",
	"act":   "Act Two  —  After the Flood",
	"title": "The First Sibling Hunt",
	"image_by_state": {
		"flood_companion": {
			"mother":  IMG + "act02_img25_coordinated_hunt_together_fern_cover.jpg",
			"flint":   IMG + "act02_img25_coordinated_hunt_flint.jpg",
			"moss":    IMG + "act02_img25_coordinated_hunt_moss.jpg",
			"default": IMG + "act02_img25_coordinated_hunt_alone.jpg",
		},
	},
	"text":
"The prey was a yearling, thin-limbed and uncertain, grazing alone in a fern clearing at the base of a long slope. You had been watching it for some time before you decided it was actually alone.

{name} had run hunts in the hollow: shorter ones, less certain, with Mother visible at the edge. This was different. Unfamiliar territory, no ground knowledge, no safety net. Whoever was beside you was watching your face the way you had sometimes watched Mother's: looking for the signal that would make this stop being waiting and start being something else.

The call was yours to make.",
	"choices": [
		{
			"label": "Set positions and coordinate before anyone moves",
			"effects": {"family_unity": 1},
			"result":
"You signaled the positions the way Mother had shown: the slow head tilt for left, tail drop for right, the particular stillness that meant hold.

The hunt ran clean. No crossed lines, no wasted movement, the prey caught in a triangle before it understood what was closing. It went fast at the end, the way Mother said it should: the violence compressed, the rest of it space and quiet.

You divided the catch without argument. The meal was the best thing that had happened since the flood, and you ate it in the shade of the fern cover with the particular satisfaction of a thing done correctly.",
			"next": "s_text_after_hunt",
		},
		{
			"label": "Wait for the perfect moment — however long it takes",
			"effects": {"moss_trust": 1},
			"result":
"You settled into position and held it.

Five minutes. Ten. The prey grazed. A breeze shifted the ferns and you recalculated. Rejected the window. Waited. Whoever was beside you had the quality of someone who could wait without fidgeting, which was the quality that mattered most.

The third window was right. The entry was clean, no warning, the prey taken before it had processed what was happening.

You ate unhurried in the slow warmth of the afternoon, and it felt like something to be grateful for.",
			"next": "s_text_after_hunt",
		},
		{
			"label": "Drive hard and push it into the slope",
			"effects": {"flint_trust": 1},
			"result":
"You broke cover and drove hard, the prey bolting the way terrain like this forced things to bolt: up the slope, sideways, into the corner the rock wall made where there was nowhere left to go.

There was a scramble at the end, less controlled than you would have chosen. But the conclusion was the same.

Whoever was with you emerged from the fern line with the look of someone who had been prepared for something worse and was revising their estimate.",
			"next": "s_text_after_hunt",
		},
		{
			"label": "Hunt alone — your own approach, no signals",
			"effects": {},
			"result":
"You moved without signaling, the way you sometimes had in the hollow when you wanted to know what you were capable of without the weight of an audience.

Every decision yours. Every adjustment yours. When it went right, you had no one else to credit, which was a different kind of thing than sharing it.

The catch was real. You brought back what you could carry.",
			"next": "s_text_after_hunt",
		},
	],
},

"s_text_after_hunt": {
	"id":    "s_text_after_hunt",
	"act":   "Act Two  —  After the Flood",
	"title": "The Catch",
	"image_by_state": {
		"flood_companion": {
			"mother": IMG + "act02_img25_coordinated_hunt_together_fern_cover.jpg",
			"flint": IMG + "act02_img25_coordinated_hunt_flint.jpg",
			"moss": IMG + "act02_img25_coordinated_hunt_moss.jpg",
			"default": IMG + "act02_img25_coordinated_hunt_alone.jpg",
		},
	},
	"text":
"You ate in the shade of the ferns with whoever had made it here.

The food was real. That was a fact with weight to it, after days of moving without certainty. The forest was different since the flood: wary, reorganized, the usual paths broken or moved. But prey still moved through it, still occupied the same niches in the same ways, and if you knew how to read those niches you could find what you needed.

You still knew how.

{name} sat in the dappled light of the afternoon and let that be a small thing to hold.

The highland was still ahead. The trail was still unfinished. But you had eaten, and the sun was warm, and for a moment the distance between where you were and where you needed to be felt like a thing that could be crossed.",
	"choices": [
		{"label": "Continue", "effects": {}, "next": "s11_target"},
	],
},

"s11_target": {
	"id":    "s11_target",
	"act":   "Act Two  —  After the Flood",
	"title": "The Tempting Target",
	"image": IMG + "act02_img26_the_tempting_target_no_left_parent.jpg",
	"text":
"The second clearing held prey that was wrong in its scale.

A juvenile: large enough that the arithmetic was plain before you had consciously run it. Beyond your range. Beyond the range of whoever was beside you. Possibly beyond both of you working together. The kind of size that still carried the proportions of youth but had already accumulated too much of everything else.

And it was alone.

Or appeared to be. The ferns at the clearing's far edge were too still in the particular way that things go still when something inside them is holding its breath rather than absent.

{name} felt the familiar pull of the target, and the familiar doubt that arrived half a step behind it.",
	"choices": [
		{
			"label": "Back away before it notices — this is not yours",
			"effects": {},
			"result":
"You retreated, slow and deliberate, until the clearing was gone from sight.

Nothing had happened except the decision not to let anything happen.

Forty seconds later you heard the crash from behind: the parent emerging, the juvenile bolting, the whole situation resolving the way it would have if you had still been inside it. You had been reading the ferns correctly.

The validation felt smaller than you expected. It always did.",
			"next": "s_text_ferns_watching",
		},
		{
			"label": "Circle the clearing to read those ferns before deciding",
			"effects": {"scarjaw_trust": 1},
			"result":
"You moved the long way around, low and patient, checking the far fern line from a different angle.

There: the parent. Broad-shouldered, twice the juvenile's mass, standing with the stillness of something that was not grazing, watching. It had not registered you yet. If you moved now, it would.

You withdrew without giving any signal. The opportunity was not an opportunity. It was a test you had identified before walking into it.

Behind you, whoever was with you exhaled a breath they had been holding without knowing it.",
			"next": "s_text_ferns_watching",
		},
		{
			"label": "Move in — take it before the parent can respond",
			"effects": {"player_condition": 1},
			"result_image": IMG + "act02_img27_the_angry_parent.jpg",
			"result":
"You broke cover.

The juvenile bolted. The ferns on the far side erupted.

The parent was not the kind of size that needed to be fast. It had force the way walls have force, and it covered the clearing before your instincts had finished processing the information. You ran. It pursued. You hit the tree line and the parent stopped at its territorial edge, and you kept running for another long minute anyway, because that is what the body decides after something like that.

You arrived at the brush above with your lungs empty and a revised understanding of why the arithmetic mattered.",
			"next": "s_text_ferns_watching",
		},
		{
			"label": "Signal everyone back — this is a warning, not a hunt",
			"effects": {"family_unity": 1},
			"result":
"You gave the retreat sign: the one Mother had drilled into you, the one that did not leave room for debate.

Whoever was with you moved.

You gave the clearing a wide margin on the way past, and heard behind you, at a distance, the parent returning to the juvenile with a low sustained sound that needed no translation.

You had read a situation and acted on the reading before it became a problem.",
			"next": "s_text_ferns_watching",
		},
	],
},

"s_text_ferns_watching": {
	"id":    "s_text_ferns_watching",
	"music": "low_tension_140bpm",
	"act":   "Act Two  —  After the Flood",
	"title": "Something in the Ferns",
	"image": IMG + "act02_img28_scarjaw_is_watching_marked.jpg",
	"text":
"The forest had quieted in a way that was not ordinary quiet.

{name} stopped moving and stood in it.

Small animals that had been busy in the undergrowth had gone elsewhere without apparent reason. The birds had shifted their patterns. The ferns to the east were still, which could have been coincidence. You did not have enough evidence to decide.

You kept moving. But something at the back of your awareness filed the east ferns and the shifted birds and the quality of the silence, and marked it: noted, unresolved.",
	"choices": [
		{"label": "Continue", "effects": {}, "next": "s12_scarjaw"},
	],
},

"s12_scarjaw": {
	"id":    "s12_scarjaw",
	"act":   "Act Two  —  After the Flood",
	"title": "Scarjaw",
	"image": IMG + "act02_img28_scarjaw_is_watching_marked.jpg",
	"text":
"You became aware of him the way you became aware of weather: gradually, and then all at once.

He had been in the ferns to the east for longer than you had been in this part of the forest. You understood that without knowing when you had started to understand it: the particular absence of small animals in his area, the quality of stillness that came from something choosing to be still rather than simply being it, one moment when the ferns did not move with the wind.

He was young, not much larger than you, built lean and long in the manner of something that moved through tight spaces frequently. His jaw had healed wrong from some old injury. A ridge of scar tissue ran along the right side, and the healed set of it gave his face a permanent focus.

He was watching you the way Mother had taught you to watch: with full attention, and none of it showing.

He was alone. Had been for a while. You could read that the same way you read a print in the mud: the depth of it, the edges.",
	"choices": [
		{
			"label": "Go still — visible, but not threatening",
			"effects": {"scarjaw_trust": 1},
			"result":
"You stopped moving entirely. Not prey-still: the deliberate kind, the kind that was a choice rather than a failure.

He watched. You watched. The space between you did the work of several conversations at once.

After a while he looked away, not alarmed, not retreating. Simply finished. He had read what he needed to read and found something in it that did not require a response.

You started moving again. The place where he had been did not feel empty in the way it would have if he had left.",
			"next": "s13_threat",
		},
		{
			"label": "Make a soft sound — the kind that means I see you too",
			"effects": {"scarjaw_trust": 1},
			"result":
"The sound you made was low and brief. Not a challenge. Not an invitation. The sound you made in the hollow on dark nights to tell the others you were there without waking them. Simply: I am here and I know you are here, and that is all this is.

Something shifted in the ferns.

He did not come out. But the quality of his stillness changed: less coiled, less calculated. Whatever he had been prepared to do was not what he did.

You moved on. The sense of being watched stayed with you for a while in the way things stay with you when they are not finished yet.",
			"next": "s13_threat",
		},
		{
			"label": "Step toward him slowly — close the distance on your own terms",
			"effects": {"scarjaw_trust": 1},
			"result":
"You moved toward him, one careful step at a time, keeping your head low and your pace slow enough that the approach read as intention rather than aggression.

The ferns held.

At five steps you stopped. Close enough to see the individual patterns of the scar tissue along his jaw, the way his eyes caught the light. He was watching you with an attention that was neither hostile nor welcoming: the attention of something deciding.

Then he turned, very deliberately, and disappeared into the brush.

Not flight. A choice. You read that much.",
			"next": "s13_threat",
		},
		{
			"label": "Hold your ground and display — show you are not prey",
			"effects": {},
			"result":
"You drew yourself up, not charging, not retreating. Making your actual size clear, your posture unambiguous: here, and not afraid, and not something that runs.

He read it. He did not move toward you.

After a moment he withdrew into the brush at his own pace, which was not the pace of something that had been driven off. More like the pace of something that had gathered the information it came for.

You had not made an enemy. You were not certain you had made anything else.",
			"next": "s13_threat",
		},
	],
},

"s13_threat": {
	"id":    "s13_threat",
	"music": "low_tension_140bpm",
	"act":   "Act Two  —  After the Flood",
	"title": "Hunted Through the Ferns",
	"image": IMG + "act02_img30_hunted_through_the_ferns_two_legs_concealed.jpg",
	"text":
"The forest changed its pitch around midday, and {name} felt it before understanding it.

The birds went silent in a particular direction: not the brief alarmed silence of a hawk's shadow but the extended quiet of something large enough that the birds had recalculated the entire area and excluded themselves from it. The undergrowth at the northern edge of the fern slope stayed motionless longer than wind patterns explained.

You were moving south when you realized you had been moving south for a while without consciously choosing to.

Something was in the ferns to the north, moving at the same pace you were moving, maintaining the same distance. Not hunting, not yet. Not closing. Simply following, the way a current follows the shape of a riverbank, reading the terrain without adjusting it.

The tracks you had seen behind the herd were fresh. You had not stopped thinking about them.",
	"next": "s13_signs",
},

"s13_signs": {
	"id":    "s13_signs",
	"act":   "",
	"title": "",
	"image": IMG + "act02_img31_what_the_hunter_leaves_behind_passage_trail.jpg",
	"text":
"You found its trail an hour later, crossing a stretch of soft ground where everything left a record.

The passage was not the herd's trail and not yours. The stride was long and measured. Four toes, the front two significantly wider-set, the impressions deep at the ball of the foot where weight rolled forward: the print of something that moved with a forward lean, something built for distance rather than speed.

The trail ran south. Had been running south for longer than you had been watching it. The prints it was tracking were narrower, lighter, a pattern that was not the herd and not any forest animal you knew.

Something specific was being followed.

{name} looked at the prints for a long moment before looking south.",
	"choices": [
		{
			"label": "Follow the trail — understand what is being hunted",
			"effects": {"mother_trust": 1},
			"result":
"The trail taught you things as you followed it.

The predator's pace was constant: no acceleration, no detours for terrain. It moved through obstacles rather than around them, which was what size like that allowed. The prey it tracked had adjusted its route twice, cutting east and then back, and both times the predator had read the adjustment and corrected without wasted movement.

Whatever was ahead of this trail was trying to lose it. Whatever was behind it was not interested in being lost.

You moved faster.",
			"next": "s14_refuge",
		},
		{
			"label": "Move parallel — track it without following directly",
			"effects": {},
			"result":
"You kept the trail in your peripheral reading, moving parallel, staying in heavier cover, close enough to cross-reference but not so close you were adding your prints to the record.

The predator's trail was old enough that following it posed no risk. What it was following was the more urgent question.

You gained ground from the side, reading the landscape ahead for where the trail was heading.",
			"next": "s14_refuge",
		},
		{
			"label": "Take the higher route and move fast",
			"effects": {"alternate_route": true},
			"result":
"You ran the ridge above the trail.

From higher ground you could read the general direction: south, always south, the same bearing as the highland. Whatever was being tracked was heading for high ground, which was sensible. Whatever was tracking it had not been discouraged by that.

You came down off the ridge when the ferns gave way to the open rock that preceded the highland proper.",
			"next": "s14_refuge",
		},
	],
},

"s14_refuge": {
	"id":    "s14_refuge",
	"music": "low_tension_140bpm",
	"act":   "Act Two  —  After the Flood",
	"title": "Mother's Abandoned Refuge",
	"image": IMG + "act02_img32_mothers_abandoned_refuge.jpg",
	"text":
"The hollow was small and well-chosen: a shelf of overhanging rock with a narrow entrance, screened by root growth old enough to have calcified into something almost architectural. The kind of place that took time to find and cost nothing to defend once you had it.

She had been here. You knew before you finished examining it: the scent was hers, specific and unmistakable, the particular warmth of the place above the stone temperature that said recently and not long ago. The ground inside showed where she had rested. Where she had stood and watched the entrance.

At the threshold: a wide impression in the soft ground, the weight of it significant. The thing that had been following the trail had found this place and come to the edge of it.

Mother was not here. She had left while it was still possible to leave.

The trail continued south, toward the highland. She was ahead of something that was not going to stop.",
	"choices": [
		{
			"label": "Leave immediately — follow her trail before it goes cold",
			"effects": {"mother_trust": 1},
			"result":
"You took the bearing from the exit trail and moved.

Her prints were lighter now: fast movement, covering ground the way she covered ground when urgency mattered more than sound. The trail climbed steadily, the forest giving way to exposed root and old stone, and somewhere above the tree line you found the first view of the highland proper.

The ridge stood against the sky, dry and solid and above everything the flood had touched.

She was up there. You could feel the direction of it.",
			"next": "s15_ascent",
		},
		{
			"label": "Read the hollow carefully before leaving",
			"effects": {"shelf_prepared": true},
			"result":
"You spent time inside, reading the evidence.

The predator had not entered. Had come to the threshold and stopped. Either caution or calculation had kept it outside, and then it had waited. The depth of the impression at the threshold showed how long: long enough that the ground had settled under it.

Mother had left before dawn. She had read the same waiting and made the same calculation: the thing outside would not stop, and the hollow would not hold.

You found the route she had taken: not the obvious one, a narrower way that climbed faster. She had picked it in the dark, which meant she had known it was there before she needed it.",
			"next": "s15_ascent",
		},
		{
			"label": "Rest here briefly before the climb",
			"effects": {},
			"result":
"You rested.

The hollow was defensible enough for a short time. You kept the entrance in view and ate what you had and let the accumulated effort of the past days settle into something you could move on.

When you left, you felt the difference. The trail ahead was steep but you were carrying it better.",
			"next": "s15_ascent",
		},
		{
			"label": "Let Scarjaw lead — he knows this ground",
			"requires": {"scarjaw_trust_min": 1},
			"effects": {"scarjaw_trust": 1, "scarjaw_friendly": true},
			"result":
"He was there when you turned: at the hollow's entrance, watching you with the same contained attention he had given you since the ferns.

He had been following at a distance since you parted. You had half-known it without confirming it.

You looked at him. He held the look. Then he turned and moved south at a pace that was an invitation as much as a statement.

He took you by a way that was not the obvious one and not the one Mother had used: a third path, narrower but more sheltered, the stone beneath it solid where the others had begun to crack. He had been through this terrain before. Perhaps often.

By the time you reached the highland edge, you understood something about trust that you had not understood that morning.",
			"next": "s15_ascent",
		},
	],
},

"s15_ascent": {
	"id":    "s15_ascent",
	"act":   "Act Two  —  After the Flood",
	"title": "The Rocky Ascent",
	"image": IMG + "act02_img33_the_rocky_ascent.jpg",
	"text":
"The highland's edge rose in tiers: old rock, older than the forest it sheltered, the stone a grey-brown that held the afternoon light in amber until the sun dropped behind the ridge and the whole face went into shadow at once.

The ascent was not technically difficult. It was the kind of climb that worn legs, done in a hurry, turned into something else.

{name} read the face for routes.

There was a direct line through the loose shale: faster, but the shale was unconsolidated, the kind that shifted under weight and cascaded. To the left, a route of old root growth that threaded between the rock faces, slower, more certain underfoot. Above and to the right, a narrow line through sheltered gullies that looked like it had been traveled recently.

Somewhere above, beyond the ridge line, something large was moving. Faster and more purposeful than the herd.

Whatever Mother was running from was running faster.",
	"choices": [
		{
			"label": "Take the shale path — faster, and you need the time",
			"effects": {"loose_shale_used": true},
			"result":
"The shale gave you most of the way.

On the third tier it shifted: a plate of it sliding sideways, taking your footing with it, and you went down one knee on the exposed rock beneath before catching the outcrop with your foreleg. The scrape was real but shallow. You climbed the last section more carefully.

At the top, your legs were shaking slightly and there was stone dust in your eyes, but you had made it in half the time.

Below you, the descent was marked with the cascading evidence of your passage.",
			"next": "s_text_ridge_crest",
		},
		{
			"label": "Take the root path — certain footing matters more than speed",
			"effects": {},
			"result":
"The roots held. Every one of them, which was what you had read, and the reading had been right.

The climb was slow in the way climbs are slow when you are moving carefully, but you arrived at the ridge line with full footing and nothing twisted.

The view from the top opened all at once: the valley below, the flood-scarred forest, the ravine ahead. Across it, something that stopped everything.",
			"next": "s_text_ridge_crest",
		},
		{
			"label": "Take the gully route — something has been through it recently",
			"effects": {"alternate_route": true},
			"result":
"The gullies were sheltered and the footing was good. Someone had been here, recently, moving in the same direction. The prints were the right size to be family.

You climbed faster than you had intended, following a route someone else had already solved, and the ridge appeared above you sooner than expected.

At the top you paused to read the view. The valley below. The flood-scarred forest. The ravine ahead.",
			"next": "s_text_ridge_crest",
		},
		{
			"label": "Follow Scarjaw's route — stay close",
			"requires": {"scarjaw_friendly": true},
			"result":
"He moved through the face with the familiarity of something that had crossed it many times and from many directions. No hesitation at transitions, no wasted motion at the tricky sections, he simply moved, and the route he chose was neither the shale nor the roots but something between them.

You matched him. The climb took the time it took and cost almost nothing.

At the top, he stopped and looked back down the ascent without expression. You looked too. The forest below. The flood plain. The thing that was coming through it, still following.",
			"next": "s_text_ridge_crest",
		},
	],
},

"s_text_ridge_crest": {
	"id":    "s_text_ridge_crest",
	"music": "tension_leadup_135bpm",
	"act":   "Act Two  —  After the Flood",
	"title": "The Top",
	"image": IMG + "act02_img33_the_rocky_ascent.jpg",
	"text":
"{name} came over the ridge crest and stopped.

The valley was below. All of it. More of it than you had ever seen from one place: the flood-rearranged forest, the moved river, the pale scars in the soil where the water had been moving too fast for anything to grow. The world looked different from up here. Less like somewhere you had known, more like somewhere that was going to require learning.

Ahead, between the ridge top and the highland proper, the ravine cut the terrain in a clean diagonal. A bridge crossed it. It was the kind of structure that looked like it had been tested many times and held, which was not the same as saying it would hold now.

On the far side, movement.

Mother was there.",
	"choices": [
		{"label": "Cross to her", "effects": {}, "next": "s16_ravine"},
	],
},

"s16_ravine": {
	"id":    "s16_ravine",
	"act":   "Act Two  —  After the Flood",
	"title": "Mother Across the Ravine",
	"image": IMG + "act02_img34_mother_across_the_ravine.jpg",
	"text":
"The ravine was not wide. That was the thing.

It was not wide at all: ten body lengths, perhaps twelve, a gap in the ridge stone that had been forming since before any of you existed. The walls were sheer and the bottom was well below visible from the edge. On the far side, on a ledge of darker stone, Mother stood.

She was alive. Moving, watchful, her attention split between you on this side and whatever was behind you. The distance from her face you could read: she had found this side and could not come back across, or had judged the crossing unsound and was waiting to see what you knew.

Between you and her: a natural bridge of layered stone, three body widths at its widest, narrowing toward the center. The rock had a quality that you wanted to examine more carefully before trusting it. The flood had been below this level, but stone this old held its own history of stress.

Behind you, the forest was making the particular silence it made when something large was close.",
	"choices": [
		{
			"label": "Cross carefully — one at a time, test each step",
			"effects": {},
			"result":
"You went first.

The stone was solid at the near end, solid in the middle. Where it narrowed you tested before shifting weight, and it held. At the far side you were across before the adrenaline had time to turn into anything.

Whoever was with you followed your exact line. You watched their feet and the stone beneath them, and it held for them too.

Mother moved to meet you when you reached her side. She pressed her nose against your neck with a force that was not quite controlled.",
			"next": "act3_coming",
		},
		{
			"label": "Rush across — Mother needs you now and there is no time",
			"effects": {},
			"next": "s16_rush_route",
		},
		{
			"label": "Get your companion across first, then follow",
			"effects": {"player_fell": true},
			"result_image": IMG + "act02_img35A_player_fell.jpg",
			"result":
"You stayed at the near side while your companion crossed, watching the stone beneath their feet, ready if anything shifted.

They made it. Clean. On the far side they turned to watch you.

You stepped onto the bridge, and halfway across, the center section dropped.

Not all at once: a plate of stone giving without warning, your footing vanishing, and you caught the far lip with your foreleg by the kind of margin that belongs in the category of luck rather than skill. You hung above the drop for a moment, the bottom of the ravine far enough below that you did not want to think about it, and then pulled yourself up by inches onto the far ledge.

Your foreleg was shaking. Everything was shaking. You were across.",
			"next": "s17_fell",
		},
		{
			"label": "Trust Scarjaw's signal — he has been reading this terrain all day",
			"requires": {"scarjaw_friendly": true},
			"result":
"He was at the bridge's edge before you, crouched low, pressing his jaw to the stone at the centerline. When he rose he moved left. You understood: he had found the denser section, the part where the layers ran parallel to the crossing rather than perpendicular, the part that would not separate under weight.

It was narrower than the obvious route. It required more precision.

You went that way. Whoever was with you went that way. The stone held as though it had been waiting for someone who knew which part of it to trust.

On the far side, Scarjaw looked back across the ravine once, reading something in the distance. Then he went very still.",
			"next": "act3_coming",
		},
	],
},

"s16_rush_route": {
	"id":   "s16_rush_route",
	"type": "auto_redirect",
	"choices": [
		{"next": "s16_rush_moss",  "requires": {"flood_companion": "moss"},  "effects": {"moss_stranded": true}},
		{"next": "s16_rush_flint", "requires": {"flood_companion": "flint"}, "effects": {"flint_stranded": true}},
		{"next": "s16_rush_d", "effects": {}},
	],
},

"s16_rush_moss": {
	"id":    "s16_rush_moss",
	"act":   "Act Two  —  After the Flood",
	"title": "Moss, Left Behind",
	"image": IMG + "act02_img35B_moss_left.jpg",
	"text":
"You ran for Mother and made it, and then the center of the bridge dropped.

The stone fell in a single clean motion, leaving a gap that was not crossable by anything without wings. Moss was still on the near side. Had been one step from the bridge when the stone went.

They stood at the far lip of the gap and looked at you without expression. Which was not to say without feeling: Moss was very precise about the difference between showing nothing and feeling nothing. What you were seeing was Moss making a calculation.

Mother arrived at your side. She read the gap. She read Moss. She made a sound too low to carry across the distance, which meant it was for you.",
	"choices": [
		{
			"label": "Call across — tell Moss to find another crossing east",
			"effects": {"moss_trust": 1},
			"result":
"You called the way Mother called, the sustained low sound that meant I know where you are, and held it long enough for Moss to read all of it.

Moss looked at you from the far lip of the gap. Something passed across their posture.",
			"next": "s16_moss_trust_route",
		},
		{
			"label": "Go back to Moss — find the east crossing and come back together",
			"effects": {"family_unity": 1, "moss_stranded": false},
			"result":
"You moved fast along the far edge, looking for a narrowing.

Two hundred lengths east, the ravine stepped down enough that the drop was survivable. You crossed there and got back to Moss, and the two of you found the narrower crossing together.

You arrived at Mother's side from the east, out of breath, Moss beside you. The reunion had cost you time. The time was behind you now.",
			"next": "act3_coming",
		},
	],
},

"s16_rush_flint": {
	"id":    "s16_rush_flint",
	"act":   "Act Two  —  After the Flood",
	"title": "Flint, Left Behind",
	"image": IMG + "act02_img35C_flint_left.jpg",
	"text":
"You ran for Mother and made it, and the center section gave.

The stone dropped clean: one motion, one sudden absence. Flint was on the near side, one step from the bridge. He had been right behind you.

He stood at the gap and looked at you with a stillness that was not his usual kind. The coiled readiness was gone. He was simply reading the situation the same way he read everything: fast, comprehensive, not much showing.

Mother appeared at your side. She read the gap. She read Flint. She made a sound too low to carry across the distance.",
	"choices": [
		{
			"label": "Signal Flint east — he knows what to do",
			"effects": {},
			"result":
"You gave the signal for east, the one he knew from training. Flint acknowledged it with his tail and started moving along the near rim without argument.",
			"next": "s16_flint_trust_route",
		},
		{
			"label": "Go back to him — don't leave him on the other side",
			"effects": {"flint_trust": 1, "family_unity": 1, "flint_stranded": false},
			"result":
"You found the narrow crossing east and went back.

Flint watched you come back across with an expression that contained several things at once. Not gratitude. Not surprise. Something more complicated, which was unusual for Flint.

The two of you crossed at the east narrowing together. It was slower. It was the only way both of you were on the same side at the end.",
			"next": "act3_coming",
		},
	],
},

"s16_rush_d": {
	"id":    "s16_rush_d",
	"act":   "Act Two  —  After the Flood",
	"title": "The Crossing Gives Way",
	"image": IMG + "act02_img35D_the_crossing_gives_way.jpg",
	"text":
"You ran for the bridge and made it halfway when the center went.

The stone dropped in pieces: not all at once but in a sequence, one plate releasing the next, a geological statement about how long the bridge had been waiting to do this. You cleared the gap with three running steps and your body at the edge of its geometry and landed on the far side with your shoulder against the stone face.

Whoever had been crossing with you was not across.

The bridge was gone. A gap where it had been, the bottom invisible, the two of you on opposite sides of the same situation.",
	"choices": [
		{
			"label": "Signal east — find the narrow crossing, meet there",
			"effects": {},
			"result":
"You gave the signal for east, sustained and clear, then started moving east along the far rim so they could track your position.

The ravine narrowed two hundred lengths on. The crossing there was awkward but manageable: the walls stepping down enough that the drop was real but survivable.

Both of you arrived from opposite sides and met above a drop that neither of you looked at directly. You came out the other side with the ground solid underfoot and the hard part behind you.",
			"next": "act3_coming",
		},
		{
			"label": "Go down into the ravine — the bottom can be crossed",
			"effects": {"alternate_route": true},
			"result":
"You went down.

The wall was stepped enough to descend without falling, and the ravine floor was dry. The flood had not reached this high. You crossed at the base, and the far wall went up the same way the near one had come down.

It was not fast. It was the only way both of you stood on the same side afterward.

You climbed out above the gap, legs burning, and found Mother waiting at the ridge with an expression that had been waiting some time.",
			"next": "act3_coming",
		},
	],
},

"s17_fell": {
	"id":    "s17_fell",
	"act":   "Act Two  —  After the Flood",
	"title": "After the Fall",
	"image": IMG + "act02_img35A_player_fell.jpg",
	"text":
"You lay on the far ledge and held very still while your body decided what it thought about what had just happened.

The foreleg was scraped but working. Both rear legs responded when you asked them to. The shaking would stop in a few minutes.

Mother was beside you before you had fully processed the sequence. She pressed her snout against your face, checking, moving from one landmark to the next the way she had since you were hatched. You let her check. You were still working on the part where the bridge had not been there.

Whoever had crossed first was there too, not saying anything, which was the correct thing to not say.

The sound in the forest behind you had grown.",
	"choices": [
		{
			"label": "Get up — you're across, and across is what matters",
			"effects": {},
			"result":
"You stood.

The foreleg protested and then cooperated, which was the order you had hoped for. You put weight on it carefully and then moved, because moving was what there was to do.

The highland waited above. The threat below was not getting smaller.

You were across. That was the only fact that counted right now.",
			"next": "act3_coming",
		},
		{
			"label": "Let Mother check you properly before moving",
			"effects": {"mother_trust": 1},
			"result":
"You held still and let her finish.

She worked methodically, the way she worked everything, and you watched her face while she worked. When she reached the foreleg she paused, but only for a moment. Then she made the small sound she made when the answer was acceptable rather than good, which was different from the sound she made when the answer was bad.

You were going to be fine. She had just told you, in the language that preceded language.

You stood when she stepped back, and this time the foreleg held without complaint.",
			"next": "act3_coming",
		},
	],
},

# ── Pre-final sibling death (low trust at the ravine) ────────────────────────

"s16_moss_trust_route": {
	"id":   "s16_moss_trust_route",
	"type": "auto_redirect",
	"choices": [
		{"next": "act3_coming", "requires": {"moss_trust_min": 1}},
		{"next": "s16_moss_prefinal_death", "effects": {"moss_alive": false, "moss_stranded": false}},
	],
},

"s16_moss_prefinal_death": {
	"id":    "s16_moss_prefinal_death",
	"act":   "Act Two  —  After the Flood",
	"title": "The Signal That Did Not Hold",
	"image": IMG + "act02_img35B_moss_left.jpg",
	"text":
"The call reached across the gap, but there was nothing on the other side of it for Moss to trust.

You had not built that. Too many mornings spent elsewhere, too many moments that had belonged to Flint or to yourself, and Moss had learned to read the difference between a signal that came with weight behind it and one that was just sound.

They looked at you from the far rim for a long time. Then they looked at the drop. Then they looked east, at the narrow crossing, which was a long way alone.

You turned for the highland and heard nothing behind you for a while. Then you heard, once, something that was not wind.

You did not find Moss at the narrow crossing.

Mother met you at the ridge. She read your face, and then she read the space beside you, and the sound she made was very quiet and not meant for you.",
	"choices": [
		{"label": "Continue", "effects": {}, "next": "act3_coming"},
	],
},

"s16_flint_trust_route": {
	"id":   "s16_flint_trust_route",
	"type": "auto_redirect",
	"choices": [
		{"next": "act3_coming", "requires": {"flint_trust_min": 1}},
		{"next": "s16_flint_prefinal_death", "effects": {"flint_alive": false, "flint_stranded": false}},
	],
},

"s16_flint_prefinal_death": {
	"id":    "s16_flint_prefinal_death",
	"act":   "Act Two  —  After the Flood",
	"title": "The Signal That Did Not Hold",
	"image": IMG + "act02_img35C_flint_left.jpg",
	"text":
"The signal reached him. He acknowledged it, which meant he had read the direction.

But Flint had spent most of these days running on his own reading, not yours. You had been together in the same places and arrived at different conclusions too many times for him to default to your judgment over his. He thought he knew a better line.

He did not come in from the east. He came in from somewhere you had not told him to go, and the crossing there had not held.

You waited at the narrow section longer than you should have. Mother found you there. She looked at the water a long time before she looked at you, and then she turned for the highland without speaking, and you followed, and the distance between you on the ridge felt different than it had before.",
	"choices": [
		{"label": "Continue", "effects": {}, "next": "act3_coming"},
	],
},

# ══════════════════════════════════════════════════════════════════════════════
# ACT THREE — The Ridge
# ══════════════════════════════════════════════════════════════════════════════

"act3_coming": {
	"id":    "act3_coming",
	"act":   "Act Three  —  The Ridge",
	"title": "Reunion",
	"image": IMG + "act03_img36_mother_reunioun.jpg",
	"text":
"She was here.

The accounting of the crossing could be reckoned later: who had come by the long route, who had waited on the wrong side, who had made it by a margin they would not understand until later. Mother was here. On solid stone above the flood line, on the high ground that the water had not reached.

{name} stood on the ridge and let the moment be what it was.

Below, the forest was a different country. The flood had reorganized it, and the days since had reorganized it further, and none of it was the hollow anymore. What you had come from was behind you in a way that was final now.

What was ahead was not peaceful.

Something large had followed Mother up the ridge, and it had not stopped following. In the forest below, moving through the treeline with the particular focused patience of something that did not detour and did not tire, a Ceratosaurus was climbing toward the highland.

It had been following this trail for three days.

It was not going to stop.",
	"choices": [
		{
			"label": "Face what is coming",
			"next": "s_text_carno_emerges",
			"effects": {},
		},
		{
			"label": "Return to main menu",
			"next": "_main_menu",
			"effects": {},
		},
	],
},

# ══════════════════════════════════════════════════════════════════════════════
# ACT THREE — The Ridge
# ── Text-only slide: the carno clears the treeline ──────────────────────────

"s_text_carno_emerges": {
	"id":    "s_text_carno_emerges",
	"music": "tension_leadup_135bpm",
	"act":   "Act Three  —  The Ridge",
	"title": "What Had Been Following",
	"image": IMG + "act03_img37_standoff.jpg",
	"text":
"The sound reached the ridge before it did.

Something large enough, moving without care for the noise it made. A sound that was its size rather than its intention: the breaking of undergrowth in the rhythm of something that had been walking for three days without stop and saw no reason to stop now.

Then the treeline gave way and there it was.

{name} had known it was coming. Knowing and seeing were different things.

The Ceratosaurus stood at the highland edge and looked at the ridge. It had the horns above its brow that the species was named for, and they were not symbolic. It was lean from the pursuit but not tired. Nothing that had spent three days following a trail without losing it was tired in any way that was going to help you.

It looked at all of you the way it had been looking at the trail: with complete attention, with the patience of something that had never once believed the answer was going to say no.

Mother was behind you.

The ridge was solid under your feet.

The drop was at your back.",
	"choices": [
		{"label": "Hold the line", "effects": {}, "next": "s18_standoff"},
	],
},

# ══════════════════════════════════════════════════════════════════════════════

"s18_standoff": {
	"id":    "s18_standoff",
	"music": "tension_leadup_135bpm",
	"act":   "Act Three  —  The Ridge",
	"title": "The Standoff",
	"image": IMG + "act03_img37_standoff.jpg",
	"text":
"The Ceratosaurus came up through the forest at dusk.

You heard it before the treeline: the sound of something large moving without care for the noise it made, which was what size like that allowed. Then it emerged at the highland edge, and {name} finally understood the full scale of what had been following Mother for three days.

It was enormous. Not the largest of its kind, the largest would not have fit through the terrain it had tracked, but sized exactly to be the apex thing in any space it entered. Its skull bore a pair of short horns above the brows and one longer one at the nose, and the horns had the look of weapons that had been used before. It was lean from the pursuit but not exhausted. Things like this did not exhaust.

It stopped at the treeline and read the ridge.

Thirty body lengths of exposed stone, dropping away on the east side in a sheer fall to the valley floor. To the west, the ascent you had just climbed. You stood between the predator and the edge, and so did Mother, and whoever else had made it to the ridge with you.

The Ceratosaurus looked at all of you with the particular attention of something deciding which problem to solve first.",
	"choices": [
		{
			"label": "Form a defensive line — face it together",
			"effects": {"family_unity": 1},
			"result":
"You moved without speaking and the others understood and moved with you.

A line: {name} in the center, whoever was on either side taking the flanks, the whole group visible and present and not running, which was the part that required the most from all of you, the not-running, because everything in your body had a very clear opinion about what to do when something that size looked at you.

The Ceratosaurus read the line and stopped its advance.

Not permanently. Reading it.",
			"next": "s19_fight_r1",
		},
		{
			"label": "Position yourself on the flank — angle it toward the cliff edge",
			"effects": {"alternate_route": true},
			"result":
"You moved left and low, reading the ridge geometry the way you had been reading terrain all week.

The cliff was thirty lengths east. If the Ceratosaurus moved toward you, if you could hold its attention on the left side, the angle between the animal and the drop would get smaller with every step it took.

You held the position and waited to see if it would take the bait.",
			"next": "s19_fight_r1",
		},
		{
			"label": "Signal Scarjaw to circle wide and come in from the north",
			"requires": {"scarjaw_friendly": true},
			"effects": {"scarjaw_trust": 1},
			"result":
"The signal you gave him was not one you had been taught. It was something you constructed from the things you had already used with him: the movement of your head, the angle of your body, a direction.

He read it in the way he read everything: completely, without visible acknowledgment.

Then he was gone from the position where he had been, and you trusted that he was going somewhere useful.",
			"next": "s19_fight_r1",
		},
		{
			"label": "Step forward — draw its attention to yourself",
			"effects": {"player_condition": 1},
			"result":
"You stepped forward from the line, one deliberate step, and the Ceratosaurus's eyes moved.

The focus of something that size, when it lands on you, is a specific physical experience. Your body had a very clear response to it. You noted the response and held the position anyway.

It was looking at you.

Now you had to make that mean something.",
			"next": "s19_fight_r1",
		},
	],
},

# Fight rounds replace s19_choose and all s19_* target scenes.
# Each round: creature presses; player picks who responds.
# Intervention counters and doom flags determine outcomes.

"s19_fight_r1": {
	"id":    "s19_fight_r1",
	"music": "tension_fight_120bpm",
	"act":   "Act Three  —  The Ridge",
	"title": "It Charges",
	"image": IMG + "act03_img37_standoff.jpg",
	"text":
"The Ceratosaurus chose.

It had been reading the ridge long enough to have a calculation, and now the calculation was finished, and the thing it landed on was to move. Not at the whole group at once. At one of you.

{name} had a fraction of a second to decide who was going to answer for it.

The others were reading you.",
	"choices": [
		# FLINT — 1st use (succeeds)
		{
			"label": "Signal Flint — let him lead the counter",
			"requires": {"flint_alive": true, "flint_doomed": false, "flint_interventions_max": 0},
			"effects": {"flint_interventions_inc": 1},
			"result":
"Flint read the signal before you finished it.

He moved fast and clean, the way he moved when the situation was clear enough to stop thinking and just act. He caught the line of the charge before it could commit, drove into it from the side, and the Ceratosaurus lost its angle and overshot.

It circled. Reassessing.

Flint came back to the line, breathing hard, not saying anything. He never said anything afterward. It was the thing you had always known about him: he was better when the only language available was the one you made with your body.",
			"next": "s19_fight_r2",
		},
		# FLINT — 2nd use (knocked out, doomed)
		{
			"label": "Signal Flint again",
			"requires": {"flint_alive": true, "flint_doomed": false, "flint_interventions_min": 1},
			"effects": {"flint_interventions_inc": 1, "flint_doomed": true},
			"result":
"Flint went out again.

He was a little slower this time, which you noticed and set aside. He made contact, interrupted the charge, held the line long enough for it to matter.

Then the Ceratosaurus corrected faster than he expected, and the hit caught him across the shoulder instead of glancing past. He went down. Got up. Made it back to the edge of the group.

He was still there, but he was not in the fight anymore. His legs were working and his eyes were tracking but he was not going to be able to make that move again. You could see it in the way he was holding his shoulder.

You had pushed him one time too many.",
			"next": "s19_fight_r2",
		},
		# MOSS — 1st use (succeeds)
		{
			"label": "Signal Moss — they've been reading it since it emerged",
			"requires": {"moss_alive": true, "moss_doomed": false, "moss_interventions_max": 0},
			"effects": {"moss_interventions_inc": 1},
			"result":
"Moss had already seen the opening before you pointed to it.

They moved sideways rather than into the charge, which was exactly right: not blocking but redirecting, creating a new problem for the Ceratosaurus to solve in the middle of its committed momentum. It adjusted, lost half a step, and by the time it had its footing back the angle had changed.

Moss came back to you, quiet, and took their position. Their eyes did not leave the creature.

They had always been better at this than anyone gave them credit for.",
			"next": "s19_fight_r2",
		},
		# MOSS — 2nd use (knocked out, doomed)
		{
			"label": "Signal Moss again",
			"requires": {"moss_alive": true, "moss_doomed": false, "moss_interventions_min": 1},
			"effects": {"moss_interventions_inc": 1, "moss_doomed": true},
			"result":
"Moss went out a second time.

It worked, in the sense that the charge did not land where it intended. But Moss was not built for this, and the Ceratosaurus had learned something from the first encounter, and this time when it corrected it corrected into Moss's path.

Not a full hit. But enough.

Moss made it back. They were upright and aware but there was something careful about the way they were moving now, and you recognized the careful. You had made Moss use the thing they had one more time than it was meant to be used.",
			"next": "s19_fight_r2",
		},
		# PLAYER — 1st use
		{
			"label": "Step in yourself — you have the best read on its movement",
			"requires": {"player_doomed": false, "player_interventions_max": 0},
			"effects": {"player_interventions_inc": 1},
			"result":
"You went out.

The Ceratosaurus had more reach than you and more weight than you, and you had been counting on it not having more speed. It did not have more speed, at least not at the turn, and you caught the edge of its commitment and redirected, and it went past.

It turned, and you were where you had started, and the others were still on the ridge, and you were still standing.

That was round one.",
			"next": "s19_fight_r2",
		},
		# PLAYER — 2nd use (last, doomed)
		{
			"label": "Step in yourself again",
			"requires": {"player_doomed": false, "player_interventions_min": 1},
			"effects": {"player_interventions_inc": 1, "player_doomed": true},
			"result":
"You went out again.

You held the line. You did what needed doing. The Ceratosaurus went wide and the group was still on the ridge and that was the thing that mattered.

But when it turned back toward you, something changed in the way it was looking at you. It had run its own calculation. And it had reached out, once, in the moment before you pulled back, and you had felt what the tips of those teeth felt like from close range.

You were still standing. You were going to keep standing.

You were not going to step out again. Not because you were afraid. Because you had the feeling, clear and quiet as a thing that has been decided, that this was already where this was going to end for you. That you had already made the last choice. That the only thing left to do was make it mean something.",
			"next": "s19_fight_r2",
		},
		# SCARJAW — 1st use
		{
			"label": "Signal Scarjaw — this is what the trust was for",
			"requires": {"scarjaw_friendly": true, "scarjaw_doomed": false, "scarjaw_interventions_max": 0},
			"effects": {"scarjaw_interventions_inc": 1},
			"result":
"Scarjaw moved the moment you signaled, like the signal was formality.

He came in at an angle you could not have calculated, using his size against the Ceratosaurus's bulk in a way that only made sense if he had been planning it since the creature emerged from the treeline. The charge collapsed. The Ceratosaurus staggered, recalculating.

Scarjaw returned to the far flank. He did not look at you. He did not need to.",
			"next": "s19_fight_r2",
		},
		# SCARJAW — 2nd use (hurt)
		{
			"label": "Signal Scarjaw again",
			"requires": {"scarjaw_friendly": true, "scarjaw_doomed": false, "scarjaw_interventions_min": 1, "scarjaw_interventions_max": 1},
			"effects": {"scarjaw_interventions_inc": 1},
			"result":
"Scarjaw went again.

He made contact. He held the line. But this time the Ceratosaurus had a different answer for his angle and the correction caught him across the ribs. You heard the sound from where you were standing.

He stayed on his feet. Moved back to the flank slowly, breathing in a way that was different from before. He had taken damage. He was still in this, but something had changed in the calculus of what he had left.",
			"next": "s19_fight_r2",
		},
		# SCARJAW — 3rd use (doomed)
		{
			"label": "Signal Scarjaw one more time",
			"requires": {"scarjaw_friendly": true, "scarjaw_doomed": false, "scarjaw_interventions_min": 2},
			"effects": {"scarjaw_interventions_inc": 1, "scarjaw_doomed": true},
			"result":
"Scarjaw went out a third time.

He did not hesitate and he did not ask for anything. He committed the way he committed to everything: completely, without reservation, using everything he had left.

He pushed the charge, and the Ceratosaurus went wide, and the group was safe.

And then Scarjaw was too close to the edge, and the momentum he had built to do the thing did not have anywhere left to go, and there was a sound, and then there was not a Scarjaw on the ridge anymore.

You stood on the stone and let the wind come through and did not finish the thing you had started to feel about that. There was still work to do.",
			"next": "s19_fight_r2",
		},
		# MOTHER — 1st use
		{
			"label": "Trust Mother — let her read it and respond",
			"requires": {"mother_interventions_max": 0},
			"effects": {"mother_interventions_inc": 1},
			"result":
"Mother had already been reading it.

She moved with the particular economy of something that does not waste effort because it understands the situation completely. The Ceratosaurus found a different problem than the one it had aimed at. It adjusted. The adjustment came too late.

Mother returned to her position and made the small sound she made when a calculation had resolved the way she expected it to. You had heard that sound your whole life.

The ridge held. For now.",
			"next": "s19_fight_r2",
		},
		# MOTHER — 2nd use NOT freed (doomed)
		{
			"label": "Trust Mother again",
			"requires": {"mother_freed_in_flood": false, "mother_interventions_min": 1},
			"effects": {"mother_interventions_inc": 1, "mother_doomed": true},
			"result":
"Mother went out again.

She read it correctly. She moved correctly. But the Ceratosaurus had three days of her trail in its memory and it had updated its model, and this time when she moved it moved with her, and the correction it made was faster than she had calculated.

The hit was glancing. She held. But she was closer to the edge than she had been, and she did not come back to her position. She stood where she was, at the margin of the ridge, and she was looking at the drop and then at the animal and running something behind her eyes that you could not read from where you were.

Something had shifted in the geometry of this, and it was not a shift in your favor.",
			"next": "s19_fight_r2",
		},
		# MOTHER — 2nd use FREED (hurt, not doomed)
		{
			"label": "Trust Mother again",
			"requires": {"mother_freed_in_flood": true, "mother_interventions_min": 1, "mother_interventions_max": 1},
			"effects": {"mother_interventions_inc": 1},
			"result":
"Mother went again.

She took a glancing hit on the return, something the Ceratosaurus had held back until she was moving away. Not a full contact. She absorbed it, kept her footing, came back to the line.

She was shaken. You could see it in the way she held herself: the extra care in each step, the way she was breathing. She had more in her than she had used. How much more was harder to say.",
			"next": "s19_fight_r2",
		},
		# MOTHER — 3rd use FREED (doomed)
		{
			"label": "Trust Mother one more time",
			"requires": {"mother_freed_in_flood": true, "mother_interventions_min": 2},
			"effects": {"mother_interventions_inc": 1, "mother_doomed": true},
			"result":
"Mother went out a third time.

She was spent. You could see it before she moved. She went anyway, because that was who she was, because the alternative was something she had not been built to choose.

She drove the charge wide. The ridge was safe. And then she was at the edge of the ridge and the momentum of three days of fighting had arrived at a place with no more ground left in it.

She did not fall immediately. She held the edge a long time, looking at you.

Then the stone gave under her rear foot, and she was gone, and the wind came through the space where she had been, and there was nothing left to do but finish what she had started for you.",
			"next": "s19_fight_r2",
		},
	],
},

"s19_fight_r2": {
	"id":    "s19_fight_r2",
	"act":   "Act Three  —  The Ridge",
	"title": "It Is Not Done",
	"image": IMG + "act03_img37_standoff.jpg",
	"text":
"It had not given up.

The Ceratosaurus circled back, slower now, recalculating. You could see it rebuilding its model of the ridge, the group, the options. It was going to make another run.

{name} read the faces around you. Whoever was still in this was going to have to answer for it one more time.",
	"choices": [
		{
			"label": "Signal Flint — let him lead the counter",
			"requires": {"flint_alive": true, "flint_doomed": false, "flint_interventions_max": 0},
			"effects": {"flint_interventions_inc": 1},
			"result":
"Flint moved the moment you signaled.

He came in at an angle the Ceratosaurus had not seen from him yet, and it had not updated its model fast enough. He drove into its path, redirected, came back. Clean.

He returned to the line breathing hard and held his position. He did not say anything about it. He never did.",
			"next": "s19_fight_r3",
		},
		{
			"label": "Signal Flint again",
			"requires": {"flint_alive": true, "flint_doomed": false, "flint_interventions_min": 1},
			"effects": {"flint_interventions_inc": 1, "flint_doomed": true},
			"result":
"Flint went out a second time.

He interrupted the charge. He did everything right. But the Ceratosaurus landed a correction that caught him across his shoulder and he went down hard.

He got up. He made it back to the group. But you could see in the way he was holding himself that the second run had taken everything Flint had left for this fight.",
			"next": "s19_fight_r3",
		},
		{
			"label": "Signal Moss — they've been watching every move",
			"requires": {"moss_alive": true, "moss_doomed": false, "moss_interventions_max": 0},
			"effects": {"moss_interventions_inc": 1},
			"result":
"Moss read the Ceratosaurus's angle before you finished signaling.

They moved laterally, pulling its attention sideways, creating a geometry problem in the middle of the creature's committed approach. It lost the line. Moss came back without comment and took their position again, eyes still on the animal.",
			"next": "s19_fight_r3",
		},
		{
			"label": "Signal Moss again",
			"requires": {"moss_alive": true, "moss_doomed": false, "moss_interventions_min": 1},
			"effects": {"moss_interventions_inc": 1, "moss_doomed": true},
			"result":
"Moss went out again.

The Ceratosaurus had updated from the first time and the correction was faster. Moss got the redirect but took a glancing hit on the return and went down to one knee. Got up. Made it back.

They were there, at the edge of the group, eyes still tracking. But the way they were standing told you they had used everything they had to make it back, and you had been the one to ask for it.",
			"next": "s19_fight_r3",
		},
		{
			"label": "Step in yourself",
			"requires": {"player_doomed": false, "player_interventions_max": 0},
			"effects": {"player_interventions_inc": 1},
			"result":
"You went out again.

The Ceratosaurus had a new read on your speed, and you had a new read on its turning radius, and neither of you had the advantage anymore, just information. You redirected it by a body length. It reassessed.

One more time you came back to the ridge with everyone still on it.",
			"next": "s19_fight_r3",
		},
		{
			"label": "Step in yourself again",
			"requires": {"player_doomed": false, "player_interventions_min": 1},
			"effects": {"player_interventions_inc": 1, "player_doomed": true},
			"result":
"You went out again.

You held the line. You kept the group intact. The Ceratosaurus went wide, and for a moment everything was still, and you were still standing.

Then it looked at you, and it reached, and you felt the graze of its teeth across your side before you got clear. You stayed upright. You made it back.

You knew what that look had meant. It had found you. It was going to find you again at the end of this, and there was a part of you that had already accepted that, quiet and clear, without drama.",
			"next": "s19_fight_r3",
		},
		{
			"label": "Signal Scarjaw",
			"requires": {"scarjaw_friendly": true, "scarjaw_doomed": false, "scarjaw_interventions_max": 0},
			"effects": {"scarjaw_interventions_inc": 1},
			"result":
"Scarjaw went.

Clean, fast, exact. He had been waiting for the signal, or maybe he had not been waiting for anything, maybe he had already been in motion and the signal was just confirmation. The charge fell apart on the ridge stone and the Ceratosaurus circled away to recalculate.",
			"next": "s19_fight_r3",
		},
		{
			"label": "Signal Scarjaw again",
			"requires": {"scarjaw_friendly": true, "scarjaw_doomed": false, "scarjaw_interventions_min": 1, "scarjaw_interventions_max": 1},
			"effects": {"scarjaw_interventions_inc": 1},
			"result":
"Scarjaw went again.

He was slower on the approach than the first time. He still made the contact. Still redirected the charge. But the Ceratosaurus landed a correction on his ribs on the return, the same side as before, and the sound it made told you something in there was not right.

He stayed on his feet. Moved back to the flank. Breathing wrong.",
			"next": "s19_fight_r3",
		},
		{
			"label": "Signal Scarjaw one more time",
			"requires": {"scarjaw_friendly": true, "scarjaw_doomed": false, "scarjaw_interventions_min": 2},
			"effects": {"scarjaw_interventions_inc": 1, "scarjaw_doomed": true},
			"result":
"Scarjaw committed for the last time.

He put everything left in him into the angle. The charge broke. The group was safe.

And then the momentum carried him past the edge, and there was nothing left to carry him back, and the sound of the valley rose up in the place where he had been.

You stood on the stone where it had happened and did not look away from what the Ceratosaurus was doing. There was still work to do.",
			"next": "s19_fight_r3",
		},
		{
			"label": "Trust Mother",
			"requires": {"mother_interventions_max": 0},
			"effects": {"mother_interventions_inc": 1},
			"result":
"Mother moved.

She had been watching it rebuild its approach and she had an answer ready before the approach was finished. The charge hit a different geometry than it intended. The Ceratosaurus adjusted too late and overran the position.

Mother returned to the line. She said nothing. She never needed to.",
			"next": "s19_fight_r3",
		},
		{
			"label": "Trust Mother again",
			"requires": {"mother_freed_in_flood": false, "mother_interventions_min": 1},
			"effects": {"mother_interventions_inc": 1, "mother_doomed": true},
			"result":
"Mother went again.

She handled the charge. She did everything correctly. But the hit that caught her on the return was harder than the last one, and she was at the edge of the ridge now, and the way she was standing told you she was working very hard to stay where she was.

She was still there. She was not going to be able to tell you for how much longer.",
			"next": "s19_fight_r3",
		},
		{
			"label": "Trust Mother again",
			"requires": {"mother_freed_in_flood": true, "mother_interventions_min": 1, "mother_interventions_max": 1},
			"effects": {"mother_interventions_inc": 1},
			"result":
"Mother went again.

She took a hit on the way back that she absorbed without going down. Came back to the line moving carefully. She was still reading the animal, still in the fight, but something in how much she had used was visible now to anyone paying attention.",
			"next": "s19_fight_r3",
		},
		{
			"label": "Trust Mother one more time",
			"requires": {"mother_freed_in_flood": true, "mother_interventions_min": 2},
			"effects": {"mother_interventions_inc": 1, "mother_doomed": true},
			"result":
"Mother went a third time.

She had nothing left to be afraid with. She moved with the calm of something past the point where the outcome mattered to her personally. The charge broke. The ridge held.

And then she was at the margin where the stone ended, and the space behind her was open air, and the ridge gave, and she was gone.

She had given everything she had to the thing she had always given everything to.

You turned back to the Ceratosaurus. There was still one more thing to do.",
			"next": "s19_fight_r3",
		},
	],
},

"s19_fight_r3": {
	"id":    "s19_fight_r3",
	"act":   "Act Three  —  The Ridge",
	"title": "One More Time",
	"image": IMG + "act03_img37_standoff.jpg",
	"text":
"The Ceratosaurus was still on the ridge. But the ridge behind it was running out.

But it was different now. Slower. The back of it was closer to the drop than it had been. Every time the group had held, every body that had stepped into its path, had moved it incrementally back, trading ground it had not noticed losing.

{name} saw the geometry.

It was almost there. One more hold and the edge would be behind it.",
	"choices": [
		{
			"label": "Signal Flint — one last push",
			"requires": {"flint_alive": true, "flint_doomed": false, "flint_interventions_max": 0},
			"effects": {"flint_interventions_inc": 1},
			"result":
"Flint gave it everything he had for one final run.

He drove into the charge at the moment it committed, forcing the Ceratosaurus to correct away from its target. The correction cost it the last of the ground it had been standing on.

Flint came back to the line and stood next to you, breathing hard, and neither of you said anything because there was nothing left to say before the end.",
			"next": "s_text_count_the_faces",
		},
		{
			"label": "Signal Flint — last chance",
			"requires": {"flint_alive": true, "flint_doomed": false, "flint_interventions_min": 1},
			"effects": {"flint_interventions_inc": 1, "flint_doomed": true},
			"result":
"Flint went out one too many times.

He made the hold. He kept the group intact. And the Ceratosaurus caught him on the way back with everything it had left, and this time he did not come back to the line.

He was still on the ridge. He was upright. But he was not going to be in the final moment of this.

You turned back to the creature. The edge was right behind it.",
			"next": "s_text_count_the_faces",
		},
		{
			"label": "Signal Moss — you trust their read",
			"requires": {"moss_alive": true, "moss_doomed": false, "moss_interventions_max": 0},
			"effects": {"moss_interventions_inc": 1},
			"result":
"Moss moved without hesitation.

They had been reading the Ceratosaurus's weight distribution for the past two rounds and they had found the angle. They cut into its path sideways, creating a geometry problem in the middle of its committed charge, and it overstepped by just enough.

The edge was closer now than it had been.",
			"next": "s_text_count_the_faces",
		},
		{
			"label": "Signal Moss — last chance",
			"requires": {"moss_alive": true, "moss_doomed": false, "moss_interventions_min": 1},
			"effects": {"moss_interventions_inc": 1, "moss_doomed": true},
			"result":
"Moss went one time too many.

The redirect worked. The Ceratosaurus lost ground. But the correction caught Moss fully this time, and they went down hard, and getting back up took everything.

They made it back to the edge of the group. They were there, but barely, and you had been the one to ask for that last run.",
			"next": "s_text_count_the_faces",
		},
		{
			"label": "Step in yourself — hold the line",
			"requires": {"player_doomed": false, "player_interventions_max": 0},
			"effects": {"player_interventions_inc": 1},
			"result":
"You went out one last time before the edge moment.

It read your movement and tried to correct, but you had its pattern now and you moved through the gap. The push was enough. The Ceratosaurus had less ground behind it than it had started with.

You came back to the ridge and looked at what remained of the fight.",
			"next": "s_text_count_the_faces",
		},
		{
			"label": "Step in yourself — one more time",
			"requires": {"player_doomed": false, "player_interventions_min": 1},
			"effects": {"player_interventions_inc": 1, "player_doomed": true},
			"result":
"You went out for the last time.

You made the hold. The group stayed on the ridge. The Ceratosaurus lost ground.

And it reached out as you cleared it, the way it had been reaching out, and this time the teeth found something real, and you felt it, and you held, and you got back.

You were standing on the ridge. You were going to keep standing on the ridge. But the thing that had found you was going to find you again at the end, and both of you knew it now.

You looked at the cliff edge and made your calculation.",
			"next": "s_text_count_the_faces",
		},
		{
			"label": "Signal Scarjaw — one last run",
			"requires": {"scarjaw_friendly": true, "scarjaw_doomed": false, "scarjaw_interventions_max": 0},
			"effects": {"scarjaw_interventions_inc": 1},
			"result":
"Scarjaw went.

He had been waiting for the moment when the geometry was exactly right and this was it. He drove into the Ceratosaurus at the angle that cost it the most ground and it staggered back, back, and the drop was right there.",
			"next": "s_text_count_the_faces",
		},
		{
			"label": "Signal Scarjaw again",
			"requires": {"scarjaw_friendly": true, "scarjaw_doomed": false, "scarjaw_interventions_min": 1, "scarjaw_interventions_max": 1},
			"effects": {"scarjaw_interventions_inc": 1},
			"result":
"Scarjaw went again, damaged ribs and all.

He made the contact. He lost ground on his feet afterward, barely staying upright. But the Ceratosaurus lost more ground than he did, and the cliff was closer.",
			"next": "s_text_count_the_faces",
		},
		{
			"label": "Signal Scarjaw — everything he has",
			"requires": {"scarjaw_friendly": true, "scarjaw_doomed": false, "scarjaw_interventions_min": 2},
			"effects": {"scarjaw_interventions_inc": 1, "scarjaw_doomed": true},
			"result":
"Scarjaw gave everything he had left.

One final committed drive. The Ceratosaurus went back, back, and the edge found it, and in the same motion that pushed the creature over, the momentum carried Scarjaw with it.

Both of them went over the cliff.

You stood on the stone and the wind came through the space where they had been, and after a moment you looked away from the edge and at the family still on the ridge.",
			"next": "s_text_count_the_faces",
		},
		{
			"label": "Trust Mother — let her finish it",
			"requires": {"mother_interventions_max": 0},
			"effects": {"mother_interventions_inc": 1},
			"result":
"Mother read the final approach and moved before you signaled.

She had already seen what you had seen: the animal's position, the edge behind it, the narrowing corridor of options. She moved into that corridor and closed it, and the Ceratosaurus had nowhere left to go.

She stepped back. The creature did not.",
			"next": "s_text_count_the_faces",
		},
		{
			"label": "Trust Mother — one more time",
			"requires": {"mother_freed_in_flood": false, "mother_interventions_min": 1},
			"effects": {"mother_interventions_inc": 1, "mother_doomed": true},
			"result":
"Mother went out.

She made the hold. She held the line for every one of you. And when the Ceratosaurus corrected this time it corrected into her, and the ridge gave, and she went with the stone.

She had used the last of what she had to keep you on solid ground.

The Ceratosaurus teetered at the edge.",
			"next": "s_text_count_the_faces",
		},
		{
			"label": "Trust Mother — one more time",
			"requires": {"mother_freed_in_flood": true, "mother_interventions_min": 1, "mother_interventions_max": 1},
			"effects": {"mother_interventions_inc": 1},
			"result":
"Mother went out.

She absorbed the hit, held her ground, pushed the Ceratosaurus back one more body length toward the edge. She came back to the line moving carefully, every step deliberate. Spent. Still standing.",
			"next": "s_text_count_the_faces",
		},
		{
			"label": "Trust Mother — give her everything",
			"requires": {"mother_freed_in_flood": true, "mother_interventions_min": 2},
			"effects": {"mother_interventions_inc": 1, "mother_doomed": true},
			"result":
"Mother gave the last of it.

She put everything she had into the final drive, and the Ceratosaurus went back toward the edge, and she went with it to the margin, and the stone at the very edge gave, and she was gone.

The creature was right there. One step from the drop. You had one moment left.",
			"next": "s_text_count_the_faces",
		},
	],
},

"s19_moss": {
	"id":    "s19_moss",
	"act":   "Act Three  —  The Ridge",
	"title": "It Chooses",
	"image": IMG + "act03_img38A_target_moss_no_scarjaw.jpg",
	"text":
"It moved for Moss.

The Ceratosaurus read the ridge the way predators read situations: with the complete cold intelligence of something that has spent its entire life extracting information from the arrangement of bodies. What it read was this: one member of the group was smaller, was positioned a half-step outside the line, was carrying the particular exhaustion of someone who had found a longer route to the same destination.

Moss had made it across the ravine. Moss had climbed the ascent and arrived on the ridge. Moss was here.

And now three thousand pounds of Ceratosaurus had decided that Moss was the easiest thing in the arrangement to separate from the rest.",
	"choices": [
		{
			"label": "Get between it and Moss — take the impact yourself",
			"effects": {"player_condition": 1},
			"result_image": IMG + "act03_img38B_target_moss_no_scarjaw.jpg",
			"result":
"You moved into the gap before the charge was fully committed, which was the only moment that worked.

The Ceratosaurus had to recalculate, you were not Moss, were not small, were not positioned the way Moss had been positioned, and the recalculation bought you half a second, which was enough to drive Moss sideways and take the space where they had been.

It hit you with its shoulder, a glancing thing, not the full charge. Enough to sit you down hard on the ridge stone. Enough to make the world ring for a moment.

You got back up.

Moss was behind you, out of the line of the next charge. The Ceratosaurus was three body lengths away, reassessing.",
			"next": "s_text_count_the_faces",
		},
		{
			"label": "Call to Moss — signal which way to move",
			"effects": {"moss_trust": 1},
			"result":
"The signal you gave was the one Moss knew: the same one from the night before the flood, the one that meant move, this direction, do not look.

Moss moved.

Clean and fast, the way Moss moved when the decision had been made for them: not the frozen hesitation, but the actual movement underneath it that had always been there waiting. They cleared the Ceratosaurus's angle in two seconds and closed the gap to the rest of the group.

The predator arrived at the position where Moss had been and found nobody there.",
			"next": "s_text_count_the_faces",
		},
		{
			"label": "Display — make yourself bigger and louder than Moss",
			"effects": {"family_unity": 1},
			"result":
"You did not know if it would work. You did it anyway: the posture, the full extension, every signal you had that said large and present and not the thing you are looking for.

The others understood, or felt the shift in the moment, and joined it, the whole group suddenly more present than it had been before.

The Ceratosaurus's attention moved off Moss.

It had not lost interest. It had found a different calculation to run.",
			"next": "s_text_count_the_faces",
		},
		{
			"label": "Press forward as a group — give it no space to commit",
			"effects": {"family_unity": 1},
			"result":
"You moved the whole group forward three steps, which was not the instinctive direction but was the correct one: take its space, reduce the gap, become a problem too large and too close to ignore in favor of a smaller target at the periphery.

The Ceratosaurus held its position. So did you.

The standoff re-established at a shorter distance. Shorter was not comfortable. Shorter was better than Moss being separated.",
			"next": "s_text_count_the_faces",
		},
		{
			"label": "Freeze — you can't make yourself reach her in time",
			"effects": {"moss_alive": false},
			"result":
"Your legs did not respond.

It was not cowardice, exactly. Or it was, but the kind that comes from overloading, from too much information arriving at once and the body shutting down its movement while the mind sorted through what it had no time to sort through.

The Ceratosaurus committed.

{name} found their legs again when it was already too late. Moss went down at the far edge of the ridge, still fighting, which was not a surprise. Moss always found something to fight for even at the worst moments. But the thing that had committed to her was too large.

By the time you reached the position where Moss had been, Moss was not there.

You stood on the ridge and the wind moved across the stone, and the Ceratosaurus turned back toward the rest of you, and what was left was less than had climbed the highland together.",
			"next": "s_text_count_the_faces",
		},
	],
},

"s19_flint": {
	"id":    "s19_flint",
	"act":   "Act Three  —  The Ridge",
	"title": "It Chooses",
	"image": IMG + "act03_img38C_target_flint_moss_present.jpg",
	"text":
"It moved for Flint.

Flint had come in from the east crossing. He had arrived last, moving fast and slightly annoyed, and his position in the line reflected that: slightly outside, angled wrong, the footprint of someone who had run a different route and not yet settled into the group's geometry.

The Ceratosaurus read all of this in the same amount of time it took to read anything: instantly.

It had been alive long enough to know that the one who arrives last and stands at the edge of the group is almost always the one who has the least support on three sides.

Flint looked at it looking at him and did not move, which was either very smart or very Flint.",
	"choices": [
		{
			"label": "Close the gap to Flint's side — be there before it commits",
			"effects": {},
			"result":
"You crossed the space between you and Flint in the time you had, which was not much time, and the Ceratosaurus adjusted its approach angle and found two of you instead of one.

Flint looked at you arriving beside him with an expression that lasted less than a second before he shut it away.

'On the right,' you told him, or something like it. He nodded once. You both held.",
			"next": "s_text_count_the_faces",
		},
		{
			"label": "Signal Flint to drive toward the center — collapse the flank",
			"effects": {"flint_trust": 1},
			"result":
"The signal you gave him was simple: the move, this way signal, the one that didn't require explanation.

Flint moved without questioning it, which was not always Flint, but it was Flint now. He drove toward the center of the group's position and the Ceratosaurus arrived at the edge where he had been and found the flank closed.

A predator that hunts by reading situations reads the new situation immediately. This one's new situation was a tighter group with fewer gaps.

Flint slotted into the line without comment, breathing hard.",
			"next": "s_text_count_the_faces",
		},
		{
			"label": "Let Flint hold it — he is faster than he looks",
			"effects": {},
			"result":
"You held your position.

Flint had not moved because Flint had calculated the same thing you had: that moving was what prey did, and Flint was choosing not to be that right now. He was standing his ground with a stillness he had spent the last three days building, and the Ceratosaurus was reading it.

It recalculated.

Flint did not flinch while it was reading him, which required something that did not come easily to someone built the way Flint was built.

The recalculation took longer than you expected.",
			"next": "s_text_count_the_faces",
		},
		{
			"label": "Move the whole group to Flint's position — surround him with bodies",
			"effects": {"family_unity": 1},
			"result":
"You moved the line toward Flint rather than pulling Flint toward the line, which felt wrong and turned out to be right: the Ceratosaurus had been aiming for the gap between Flint and the rest, and when the gap closed, its angle of attack disappeared.

It adjusted. But adjusting took time, and you had bought it.",
			"next": "s_text_count_the_faces",
		},
		{
			"label": "Hold your position — Flint has survived everything else",
			"effects": {"flint_alive": false},
			"result":
"You held.

Flint was fast and resourceful and had survived a flood and a ravine crossing and three days of unfamiliar territory. He had survived everything.

The Ceratosaurus was faster than anything Flint had survived before.

You watched from across the ridge and understood what was happening before it finished happening, and by the time you moved the conclusion was already set. Flint took the impact and it drove him toward the eastern edge of the ridge, and the eastern edge was the cliff, and then he was gone.

The Ceratosaurus turned back to face you.

There were fewer of you now. You held the weight of having held, and let the weight be what it was.",
			"next": "s_text_count_the_faces",
		},
	],
},

"s19_player": {
	"id":    "s19_player",
	"act":   "Act Three  —  The Ridge",
	"title": "It Chooses",
	"image": IMG + "act03_img38G_target_player.jpg",
	"text":
"It had picked you.

The Ceratosaurus had been alive long enough to become expert at reading injury, at finding the particular signature of something that was moving at a cost. It had read the shale dust still in your eye. The slight hesitation on the landing foot. The way your weight shifted on the bad side without you noticing you were doing it.

{name} had survived a flood and three days of unfamiliar terrain and a fall at a ravine crossing. You were still moving well by any standard that mattered.

By the standard a three-thousand-pound predator applied to the problem of which target was going to be easiest to separate from the group, you were the answer.",
	"choices": [
		{
			"label": "Use its focus on you — lead it east, toward the cliff",
			"effects": {"alternate_route": true},
			"result":
"If it wanted you, it was going to have to come and get you.

You stepped left, east, slowly, slow enough to be read as trying not to attract attention, which was not true, which was the point. The Ceratosaurus tracked the movement with its eyes and took one step in your direction.

You took another step east. It took another toward you.

The cliff was behind you. You needed to stay far enough ahead of its reach that it was chasing rather than catching, close enough to the edge that when it committed, the ground was already running out.",
			"next": "s_text_count_the_faces",
		},
		{
			"label": "Drop low and cover — don't run until there's somewhere to run to",
			"effects": {},
			"result":
"You went low, making yourself a smaller profile, and held very still.

The Ceratosaurus was triggered by movement. You knew this the way you knew the arithmetic of targets: not because anyone had told you, but because you had been paying attention.

Without movement to lock onto, it hesitated. The hesitation was brief, but it was too experienced to be confused by stillness for long. But the others used the moment, shifting positions, changing the shape of the group.

When the Ceratosaurus chose to charge, it found a different geometry than the one it had started toward.",
			"next": "s_text_count_the_faces",
		},
		{
			"label": "Call the others to close in — break its targeting",
			"effects": {"family_unity": 1},
			"result":
"You gave the signal and the group responded.

Not all of them, perhaps, and not perfectly. But enough: enough movement, enough bodies repositioning, enough change in the shape of the situation that what the Ceratosaurus had been reading was no longer what it was looking at.

It shifted its head. Read the new arrangement. Found {name} still at the center of it, but no longer isolated from the edges.

It was deciding again.",
			"next": "s_text_count_the_faces",
		},
		{
			"label": "Stand and display — make it reconsider its assessment",
			"effects": {},
			"result":
"You drew yourself up.

You were not large by the relevant standard. But you were present, fully, deliberately, with everything you had available after three days of flood and flight and forty feet of falling, and you made that presence as visible as you could.

The Ceratosaurus stared.

It did not charge immediately, which was information. Something in what it was reading did not match the category it had assigned you to. You held the display and let it read you until it revised.

The revision took a long time. You stood very still for all of it.",
			"next": "s_text_count_the_faces",
		},
	],
},

"s19_scarjaw": {
	"id":    "s19_scarjaw",
	"act":   "Act Three  —  The Ridge",
	"title": "It Chooses",
	"image": IMG + "act03_img38E_target_scarjaw.jpg",
	"text":
"It moved for Scarjaw.

He had positioned himself at the front of the group, between the predator and the family, which was not a position you had asked him to take. It was one he had arrived at through the same internal calculation that had led him to follow you from the ferns to the refuge to the highland: the calculation you had not fully understood but had decided to trust.

The Ceratosaurus had decided Scarjaw was the thing blocking access to the rest of you. It was not wrong. And it had decided to remove him first.

Scarjaw watched it move toward him with an expression you could not read, which was not unusual, except that there was something in it now that was different from the contained patience you had learned to recognize. Something that looked, for the first time since you had known him, like it might be afraid.",
	"choices": [
		{
			"label": "Move to Scarjaw's side — he is not in this alone",
			"effects": {"scarjaw_trust": 1},
			"result":
"You closed the distance before you had time to think about it.

He heard you coming and did not turn, keeping his eyes on the Ceratosaurus, which was the correct priority, but something shifted in his posture when you arrived beside him. A very small adjustment, the kind that meant something.

The two of you held the line together. The Ceratosaurus slowed.

Two was not ten. But two was not what it had calculated for.",
			"next": "s_text_count_the_faces",
		},
		{
			"label": "Call him back — regroup before it commits to the charge",
			"effects": {},
			"result":
"You gave him the signal: the move signal, backward, the one you had assembled from everything you had learned to say to him.

He moved.

Not retreating. Repositioning, which was a different thing and which Scarjaw executed without it looking like the former. He folded back into the group's line without losing ground or presence, and the Ceratosaurus's angle of attack changed from a clear corridor to a front.

Fronts were harder. The Ceratosaurus liked corridors.",
			"next": "s_text_count_the_faces",
		},
		{
			"label": "Hold — let Scarjaw control what he can control, and get ready to close in",
			"effects": {"alternate_route": true},
			"result":
"You did not call him back.

You held your position at the flank and watched, and what you watched was Scarjaw doing something you had only seen him do in pieces before: reading a dangerous situation with complete stillness and no urgency, absorbing every variable the Ceratosaurus offered him, saving his response for the moment when the response would matter most.

The Ceratosaurus slowed. Not much. But some.

Something in what it was reading had made it uncertain.",
			"next": "s_text_count_the_faces",
		},
		{
			"label": "Push the whole group forward — make Scarjaw the tip of something larger",
			"effects": {"family_unity": 1},
			"result":
"You moved the line forward, bringing everyone up to Scarjaw's position rather than pulling Scarjaw back to theirs.

He noticed. He did not look, but he noticed, and you could tell by the shift in how he held himself, the way the lone quality that had always been in his posture changed slightly, toward something else.

The Ceratosaurus read a different size than it had planned for.",
			"next": "s_text_count_the_faces",
		},
		{
			"label": "Fall back — protect the family, not the stranger",
			"effects": {"scarjaw_alive": false},
			"result":
"You pulled back toward the family and the gap opened.

Scarjaw was between the Ceratosaurus and the gap, which meant Scarjaw was between the Ceratosaurus and nothing. You watched him hold the position, not retreating, not because he could not but because retreating would simply move the problem to wherever he retreated to, and the Ceratosaurus recognized the isolation and committed to it.

The sound of it was something you would carry for a long time.

When the Ceratosaurus turned back toward the group, Scarjaw was not there. The ridge where he had been was empty and the wind moved across the stone without any care for the accounting.

He had stayed. He had stayed even when you had left him there to do it.

You did not have time to finish what you were feeling about that. You had time to face what was still coming.",
			"next": "s_text_count_the_faces",
		},
	],
},

"s19_mother": {
	"id":    "s19_mother",
	"act":   "Act Three  —  The Ridge",
	"title": "It Chooses",
	"image": IMG + "act03_img38F_target_mother.jpg",
	"text":
"It had always been here for Mother.

The Ceratosaurus had followed her scent for three days, over terrain that should have broken any trail, through a flood's aftermath and a highland ascent and a ravine. It had come to the threshold of her refuge and waited. It had tracked her to the highland and climbed to find her.

It looked at {name} and the others on the ridge, and then it looked at Mother, and everything it had been doing for three days resolved into a single focused intention.

Mother looked back at it.

She had the expression she wore when she had finished reading something and arrived at the part where she had to act on what she knew.",
	"choices": [
		{
			"label": "Step in front of her — take the focus yourself",
			"effects": {"player_condition": 1},
			"result":
"You stepped between them.

Mother's foreleg touched your side briefly, the gesture she made when something needed to stop. You kept moving anyway, until you were between her and three thousand pounds of focused intention.

The Ceratosaurus shifted its eyes to you. The shift was a physical thing.

Behind you, Mother made a sound so low you felt it more than heard it. You did not know if it was disapproval or something else. You stayed where you were.",
			"next": "s_text_count_the_faces",
		},
		{
			"label": "Move Mother to a different position — break the sightline",
			"effects": {"mother_trust": 1},
			"result":
"You moved to Mother's side and pressed against her, a specific pressure that was a direction rather than a request.

She understood the difference, as she always did, and moved with you, lateral, away from the direct line. The Ceratosaurus tracked the movement and stepped to correct its angle.

But now the angle was different. Now the group was between them rather than Mother being at the edge of it. Now whatever came next was harder for the animal and easier for you.",
			"next": "s_text_count_the_faces",
		},
		{
			"label": "Spread the group wide — make it too many targets to choose between",
			"effects": {"family_unity": 1},
			"result":
"You spread your arms, the signaling gesture, the one for disperse, and the group opened up, each of you putting distance between yourself and the next, until the Ceratosaurus faced a wide arc rather than a cluster.

Spreading out against a predator was counterintuitive. You did it anyway.

A predator pursuing one target loses the others. Multiple targets spread across forty feet of ridge required a different decision, and decisions took time, and the cliff was behind it.",
			"next": "s_text_count_the_faces",
		},
		{
			"label": "Stand beside Mother — let her read the situation and trust what she does with it",
			"effects": {},
			"result":
"You moved to Mother's side and held there.

She was reading. She had been reading since the animal cleared the treeline, absorbing every variable, running every calculation, doing the thing she had always done: understanding a situation so completely before she acted that by the time she moved, the movement was already finished in her mind.

You did not know what she was going to do.

You knew she was going to do it correctly.",
			"next": "s_text_count_the_faces",
		},
	],
},

"s_text_count_the_faces": {
	"id":    "s_text_count_the_faces",
	"act":   "Act Three  —  The Ridge",
	"title": "The Count",
	"image": IMG + "act03_img37_standoff.jpg",
	"text":
"The Ceratosaurus was backing toward the cliff.

It was not retreating. It was running out of ridge.

{name} stopped pressing and looked at the faces around you. The count was the thing: quick, deliberate, beginning with Mother and ending at the last edge of the group. Whoever was still standing. Whoever was still there.

The counting was something Mother had done every morning since the hollow, and it had been easy then, and it was not easy now, but you did it. You took in each face. You noted what was in each one.

Then you looked at the creature.

Three body lengths from the drop. Reading you. Reading the geometry. One last moment before it committed to something.",
	"choices": [
		{"label": "Look at the cliff edge", "effects": {}, "next": "s20_cliff"},
	],
},

"s20_cliff": {
	"id":    "s20_cliff",
	"act":   "Act Three  —  The Ridge",
	"title": "The Edge",
	"image": IMG + "act03_img37_standoff.jpg",
	"text":
"The Ceratosaurus was close to the cliff now.

It had not gone there on purpose. It had gone there because you had given it fewer options than it had started with. Bodies had closed the angles, stone had closed others, and what remained was a narrowing corridor of ridge and the drop behind it.

{name} stopped and looked at the group around you.

Counted the faces. Counted who was standing, who was holding, who was watching from the edge of what they had left. The ridge was quiet in the way that comes after something enormous has been expended, and the Ceratosaurus was three body lengths from the drop, still calculating, and you had one moment.

You saw the weak section of the cliff edge. The stone there had a different color than the rest, a shelf that the ridge water had undermined season by season until it was waiting rather than standing.

If something of the right weight stepped onto it in the right way, it would go.",
	"choices": [
		{
			"label": "Drive it over — all of you, one line, one push",
			"effects": {"family_unity": 1},
			"result":
"You gave the signal and did not wait to see if it landed.

You moved, and they moved with you, and that was the thing about a group that had been tested: it moved when you moved. Because it trusted you, or because it trusted the situation, or because all of you had arrived at the same reading at the same time.

The Ceratosaurus did not retreat. But it also could not hold its position against something closing from three directions at once, and the ridge narrowed behind it, and for one suspended moment it was neither going forward nor going back.

And then it was going back, and back was the edge, and the edge was the end of the ridge.",
			"next": "s_end_route",
		},
		{
			"label": "Run at it yourself — drive it onto the weak shelf and go over together",
			"requires": {},
			"effects": {"player_doomed": true, "flint_doomed": false, "moss_doomed": false, "mother_doomed": false, "scarjaw_doomed": false},
			"result":
"You ran.

Not away from it. At it.

You cut between its legs while it was still reading the movement, and the half-second of confusion was exactly what you needed to get past its reach and turn so that now you were behind it and it was between you and everyone else. You kept moving. It followed, because something moving at its back was the problem it could not ignore.

You drove it toward the weak shelf, reading the color of the stone the way Mother had taught you to read terrain.

You hit it from behind, one full-weight impact at the moment its rear foot found the shelf, and felt the stone give, and heard the sound of everything letting go at once.

The Ceratosaurus went over.

You went with it.

The last thing you felt was the wind, and the last thing you saw was the ridge above you with the faces of your family looking down, and then there was nothing but the long open air of the valley, and that was enough.",
			"next": "s_end_player_lost",
		},
		{
			"label": "Let Mother finish it — give her room to do what she came here to do",
			"effects": {"mother_trust": 1},
			"next": "s20_mother_route",
		},
		{
			"label": "Signal Scarjaw — this is what trust is for",
			"requires": {"scarjaw_friendly": true},
			"result":
"You gave him the signal you had assembled over three days of watching him move through the world.

He was already moving.

From the far flank, from the angle you had not been able to hold yourself, he came in at a speed that was different from what you had seen from him before: not patient and careful but committed, full, a lean body going fast toward something that was going to require all of it.

The Ceratosaurus turned toward him and turned was the wrong direction.",
			"next": "s_end_route",
		},
	],
},

"s20_mother_route": {
	"id":   "s20_mother_route",
	"type": "auto_redirect",
	"choices": [
		{"next": "s_end_route",            "requires": {"mother_freed_in_flood": true}},
		{"next": "s_end_sacrifice_mother"},
	],
},

"s_end_route": {
	"id":   "s_end_route",
	"type": "auto_redirect",
	"choices": [
		# Full reunion: player and mother and all living kids survived with no doom flags
		{"next": "s_end_together",  "requires": {
			"player_doomed": false, "mother_doomed": false,
			"flint_doomed": false,  "moss_doomed": false,
			"moss_alive": true,     "flint_alive": true,
		}},
		# Player went over (doomed in fight, or destined)
		{"next": "s_end_player_lost",  "requires": {"player_doomed": true}},
		# Mother went over in the fight
		{"next": "s_end_mother_gone",  "requires": {"mother_doomed": true}},
		# Both siblings lost (pre-final deaths only — in-fight doom checked above)
		{"next": "s_end_siblings_gone","requires": {"flint_alive": false, "moss_alive": false}},
		# Flint lost (pre-final or doomed in fight)
		{"next": "s_end_flint_gone",   "requires": {"flint_alive": false}},
		{"next": "s_end_flint_gone",   "requires": {"flint_doomed": true}},
		# Moss lost
		{"next": "s_end_moss_gone",    "requires": {"moss_alive": false}},
		{"next": "s_end_moss_gone",    "requires": {"moss_doomed": true}},
		# Scarjaw went over (but family whole)
		{"next": "s_end_scarjaw_gave_all", "requires": {"scarjaw_doomed": true}},
		# Fallback: everyone made it
		{"next": "s_end_together"},
	],
},

"s_end_moss_gone": {
	"id":    "s_end_moss_gone",
	"music": "emotional_70bpm",
	"act":   "Act Three  —  The Ridge",
	"title": "What the Count Said",
	"image": IMG + "final.jpg",
	"text":
"The Ceratosaurus fell.

{name} stood at the cliff edge and looked down into the valley where the sound was still settling, and did not feel the thing you were supposed to feel when something like this was over.

The ridge was quiet. Mother was behind you. Flint was on the stone to your right. You counted the faces the way you had learned to count them and the count was almost what you needed it to be.

Moss had been the one who noticed the water marks on the trees. The one who had pressed close to your side in the dark before the flood, their weight against yours a kind of language. Who had looked at you a certain way on the shelf the morning after the water receded, the weight of them settling against you meaning: I know you are there.

The valley below the ridge was full of clean light and open distance.

You looked at it for a long time before you were ready to go into it.",
	"choices": [
		{
			"label": "Return to main menu",
			"next": "_main_menu",
			"effects": {},
		},
	],
},

"s_end_flint_gone": {
	"id":    "s_end_flint_gone",
	"music": "emotional_70bpm",
	"act":   "Act Three  —  The Ridge",
	"title": "What the Count Said",
	"image": IMG + "final.jpg",
	"text":
"The Ceratosaurus fell.

{name} stood at the cliff edge and looked down.

The ridge was quiet. Mother was there. Moss was there. The count was almost right. Almost.

Flint had been the first awake every morning since hatching. The first to move, the first to try, the one who stood at the hollow mouth in the early dark with his whole body asking: well? The one who knocked his head against your shoulder when you kept up and never made anything of it afterward.

You had raced him to the tree line on the first morning of your lives, and it had felt like something that would keep happening.

The valley below the ridge was full of clean light and open distance.

You went into it with what you had, which was the only way anyone ever went anywhere.",
	"choices": [
		{
			"label": "Return to main menu",
			"next": "_main_menu",
			"effects": {},
		},
	],
},

"s_end_siblings_gone": {
	"id":    "s_end_siblings_gone",
	"music": "emotional_70bpm",
	"act":   "Act Three  —  The Ridge",
	"title": "What the Count Said",
	"image": IMG + "final.jpg",
	"text":
"The Ceratosaurus fell.

The ridge went quiet in the way that comes at the end of an accounting you did not want to finish.

{name} counted. Mother. Yourself. If Scarjaw was somewhere at the edge of the group, if he had made it through, then three. The count stopped there.

Moss had been the one who noticed things nobody else noticed, who pressed close in the dark and made silence into a kind of company. Flint had been the one who moved first, always, and made everything feel possible by the way he stood at the hollow mouth and waited.

You had started in a hollow with three of you and you had come a long distance, and the distance had cost.

The valley below was full of light. Open. More of it than you had ever seen.

You stood on the ridge and let the wind come through, and after a while you started walking, because that was the only thing left to do.",
	"choices": [
		{
			"label": "Return to main menu",
			"next": "_main_menu",
			"effects": {},
		},
	],
},

"s_end_scarjaw_gave_all": {
	"id":    "s_end_scarjaw_gave_all",
	"music": "emotional_70bpm",
	"act":   "Act Three  —  The Ridge",
	"title": "What He Left",
	"image": IMG + "final.jpg",
	"text":
"The Ceratosaurus fell.

Everyone was there when you did the count: Mother, whoever of the siblings had made the climb, yourself. The count was right.

There was a space at the edge of the group that should have had something in it.

{name} stood at the cliff edge and looked at the place where he had been. Lean and scarred and alone in the way of something that had been alone long enough to be good at it, and then, briefly, at the end of something, not alone.

You did not know his name. You had named him by the feature on his jaw that had healed from some previous story you would never read. You did not know what had happened before the ferns, before the flood, before the highland. You knew what he had done when the moment that required it arrived.

He had not been asked. He had simply made the calculation and committed to it with the same completeness he brought to everything.

The valley below the ridge was full of clean light and space.

You went into it carrying what he had given you, which was more than the ground you were standing on.",
	"choices": [
		{
			"label": "Return to main menu",
			"next": "_main_menu",
			"effects": {},
		},
	],
},

"s_end_together": {
	"id":    "s_end_together",
	"music": "happy_ending_130bpm",
	"act":   "Act Three  —  The Ridge",
	"title": "The Ridge Holds",
	"image": IMG + "final_happy_ending.jpg",
	"text":
"The Ceratosaurus fell.

It did not fall gracefully, because nothing that size falls gracefully. It went over the cliff edge in a sequence of sounds: first the weight shifting wrong, then the scramble that could not correct itself, then the long absence that ended somewhere below the visible. And then the absence became the loudest thing on the ridge.

{name} stood at the edge and looked down into the valley where the sound was still settling.

The ridge was quiet. The kind of quiet that comes after something enormous leaves a space it has been filling.

Mother was behind you. Whoever had made it to the highland stood on solid stone in the long afternoon light: exhausted, damp, marked across the places that had been tested, and alive. All of you. The counting was important. You did it twice.

The valley below stretched south in clean light and open distance. You did not know yet what was in it: what territory, what water, what other things that moved and had their own purposes. You were going to find out.

You were going to get to find out.

You had started in a hollow beneath a tangle of roots, and you were here, and you had made every choice that connected those two places, and now there was more of the story left to build than had already been built.

You looked at the others on the ridge. They looked at you.

The sun went down over the highland, and it was warm, and the ground was solid, and it was enough.",
	"choices": [
		{
			"label": "Return to main menu",
			"next": "_main_menu",
			"effects": {},
		},
	],
},

"s_end_sacrifice_player": {
	"id":    "s_end_sacrifice_player",
	"music": "emotional_70bpm",
	"act":   "Act Three  —  The Ridge",
	"title": "The Ledge",
	"image": IMG + "final.jpg",
	"text":
"The edge found you.

You had aimed for it: had driven the Ceratosaurus east, had kept your body between it and the others, had made yourself the most urgent problem it could think about. The plan was to clear the drop with it going over and you stopping at the edge.

The plan almost worked.

At the last moment it turned into your angle rather than away from it, and you hit it with your shoulder, and the edge was one step closer than you had mapped it, and then you were below the edge and the valley was a long way down.

You caught something. A ledge, narrow, the kind of thing that exists on cliff faces because geology does not consult your intentions. You caught it and held and pressed yourself against the stone while the Ceratosaurus continued its fall in the dark below you.

The ridge was quiet.

Above you, someone appeared at the cliff edge looking down. Then another. Then, after a moment, a lean shape that you recognized by the way it held itself.

You could not see their faces clearly from where you were. But you heard the sound one of them made, the low call that meant I know where you are, and you answered it, and they answered back, and you started looking for a way up.

The climb was going to hurt. You had enough left to make it.

Below, somewhere in the valley, something that had followed Mother for three days had found the bottom of its last descent.

Above you, the faces were waiting.",
	"choices": [
		{
			"label": "Return to main menu",
			"next": "_main_menu",
			"effects": {},
		},
	],
},

"s_end_sacrifice_mother": {
	"id":    "s_end_sacrifice_mother",
	"music": "emotional_70bpm",
	"act":   "Act Three  —  The Ridge",
	"title": "What She Knew",
	"image": IMG + "final.jpg",
	"text":
"Mother moved before anyone else had finished reading what was happening.

She had been waiting. Not hesitating. Waiting, the way she waited for everything: collecting the geometry of the situation until she understood it completely, running the calculation until the output was certain. And then she moved.

Her path was not the path you would have taken. Not the most direct approach: the right angle, the calculated one, adjusted for the Ceratosaurus's weight distribution and the ridge stone's footing and the precise number of steps between her starting position and the edge. She had solved the problem while you were still reading it.

She drove into it from the side and the Ceratosaurus turned and turning was not enough, and at the cliff edge she was still driving, still going forward, and then she was not there.

{name} stood at the edge and did not look away.

The valley was a long way below. The silence that followed was the longest and heaviest thing you had ever been inside of, and you stayed inside it and did not try to leave.

Then something on the cliff face moved. Not the Ceratosaurus, which was not moving and would not move again. Something smaller, lower, something that had caught a ledge and pressed against the stone and was holding very still.

You recognized the way she held herself. You would recognize it anywhere.

She was alive. She had read the cliff face before she ran for it, because she was Mother and she read everything before she acted, and she had seen the ledge, and she had aimed for it, and she had caught it.

She could not climb alone from where she was. But she was alive, and you knew where she was, and that was enough to start from.

You lay down at the cliff edge and reached.",
	"choices": [
		{
			"label": "Return to main menu",
			"next": "_main_menu",
			"effects": {},
		},
	],
},


"s_end_player_lost": {
	"id":    "s_end_player_lost",
	"music": "emotional_70bpm",
	"act":   "Act Three  —  The Ridge",
	"title": "What the Morning Held",
	"image": IMG + "final.jpg",
	"text":
"The Ceratosaurus fell.

So did {name}.

The sun came up over the valley the next morning the way it always did: indifferent to what had happened on the ridge the night before, concerned only with light and the things that grew toward it. It moved across the highland and down the stone face and into the valley where the forest was beginning to learn what it was without the flood.

On the ridge above, whoever had made it through stood in the early light and counted.

Mother was there, if she had survived the fight. Moss was there, if they had made the crossing. Flint was there, if he had. Scarjaw stood at the far edge of the group, if he had made it. The count was what it was.

{name} was not in it.

They had driven the creature over the cliff and gone with it, and the valley below held both of them now, and the ridge held everyone who was left. The family that had been built across three days of flood and stone and something that had followed for reasons it could not have explained was still here.

What they did next was their own story to tell.

The sun moved east across the highland. The morning was clear and the valley was open and there was a long way left to go.",
	"choices": [
		{
			"label": "Return to main menu",
			"next": "_main_menu",
			"effects": {},
		},
	],
},

"s_end_mother_gone": {
	"id":    "s_end_mother_gone",
	"music": "emotional_70bpm",
	"act":   "Act Three  —  The Ridge",
	"title": "What the Morning Held",
	"image": IMG + "final.jpg",
	"text":
"The Ceratosaurus fell.

The sun came up the next morning and found what was left on the ridge.

{name} stood at the cliff edge and did the count and the count was not what it needed to be. Mother was not in it. Mother had given what she had in the fight, the way she gave everything, without reservation and without complaint, and the ridge had taken the rest.

Moss was there, if they had made the crossing. Flint was there, if he had. Scarjaw stood at the far edge of the group, if he had survived the night.

The valley below stretched south in clean light and open space. It looked the same as it would have looked with her in it.

{name} had been her middle one. Old enough to notice things, young enough to have believed the world would hold still long enough to be understood. She had spent every day since hatching showing you the difference between those two things: how to notice, and how to act on what you noticed.

The morning was clear. The ground was solid underfoot.

You went into the valley carrying what she had taught you, which was more than enough to build something from.",
	"choices": [
		{
			"label": "Return to main menu",
			"next": "_main_menu",
			"effects": {},
		},
	],
},

	}


