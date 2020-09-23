extends Node

var material_paths = [
	"res://Materials/DarkBrown.tres",
	"res://Materials/DarkRed.tres",
	"res://Materials/Green.material",
	"res://Materials/Orange.material",
	"res://Materials/Peach.material",
	"res://Materials/Purple.material",
	"res://Materials/Red.material",
	"res://Materials/White.material",
	"res://Materials/Yellow.tres"
]
var materials = []
var has_shading = true

func _ready():
	for material_path in material_paths:
		materials.append(load(material_path))
	
	set_material_shading(false)

func set_material_shading(shading):
	has_shading = shading
	for material in materials:
		material.set_flag(SpatialMaterial.FLAG_UNSHADED, !shading)
