class_name BaseEnemy
extends RefCounted

# Each enemy script defines its own ATTACK_STYLE, SIZE, and BASE_STATS consts.
# GDScript 4 does not allow child classes to redeclare consts from a parent,
# so no defaults are declared here — the base exists only for type-checking purposes.
