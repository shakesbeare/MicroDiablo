class_name Entities
extends Node


static var list: Array[Entity]

static func add(entity: Entity) -> void:
    list.append(entity)


static func get_entities_in_rect(top_left: Vector2, bottom_right: Vector2):
    var entities: Array[Entity] = []
    var not_in: Array[Entity] = []

    for entity in list:
        var position = entity.position
        var left_bound = min(top_left.x, bottom_right.x)
        var right_bound = max(bottom_right.x, top_left.x)
        var top_bound = min(top_left.y, bottom_right.y)
        var bottom_bound = max(bottom_right.y, top_left.y)

        if entity.position.x > left_bound and entity.position.x < right_bound and entity.position.y > top_bound and entity.position.y < bottom_bound:
            entities.append(entity)
        else:   
            not_in.append(entity)

    return { "in": entities, "not": not_in}


class Entity:
    extends Node2D

    var sprite: Sprite2D

    var grid_position: Vector2
    var grid_height: float

    var tags: Array[String]
    
    func has_tag(tag: String) -> bool:
        return tags.find(tag) != -1

