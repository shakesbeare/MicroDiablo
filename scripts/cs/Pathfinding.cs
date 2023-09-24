using Godot;
using System.Collections.Generic;

public partial class Pathfinding : Node
{
    Vector2 gridSize;
    GDScript GridItems = (GDScript)GD.Load("res://scripts/graphics/GridItem.gd");
    GodotObject gridItems;

    public Pathfinding() {
        gridItems = (GodotObject)GridItems.Call("init");
    }

    public void Setup(Vector2 gridSize) {
        this.gridSize = gridSize;
    }

    public Vector2[] FindPath(Vector2 start, Vector2 end)
    {
        bool targetPassable = (bool)gridItems.Call("is_cube_at_grid_pos_passable", end);
        if (!targetPassable) {
            return null;
        }
        PathNode startNode = new(start, gridSize);
        startNode.hScore = H(start, end);
        startNode.gScore = 0;
        startNode.CalculateFScore();
        startNode.cameFrom = null;

        PriorityQueue<PathNode, float> openSet = new();
        HashSet<Vector2> closedSet = new();

        openSet.Enqueue(startNode, startNode.fScore);

        PathNode current;
        while (openSet.Count > 0) {
            current = openSet.Dequeue();
            closedSet.Add(current.position);

            if (current.position == end) {
                // success
                return ReconstructPath(current).ToArray();
            }

            foreach (PathNode neighbor in current.GetNeighbors()) {
                if (OpenSetHasNode(openSet, neighbor) || closedSet.Contains(neighbor.position)) {
                    continue;
                }

                bool isPassable = (bool)gridItems.Call("is_cube_at_grid_pos_passable", neighbor.position);
                if (!isPassable) {
                    continue;
                }

                float gMod = 1;
                if (neighbor.position.X != current.position.X && neighbor.position.Y != current.position.Y) {
                    gMod = 1.4f;
                }
                float tentative_gScore = current.gScore + gMod;
                if (tentative_gScore < neighbor.gScore) {
                    neighbor.cameFrom = current;
                    neighbor.gScore = tentative_gScore;
                    neighbor.hScore = H(neighbor.position, end);
                    neighbor.CalculateFScore();

                    openSet.Enqueue(neighbor, neighbor.fScore);
                }
            }

        }

        return null;
    }

    List<Vector2> ReconstructPath(PathNode node) {
        List<Vector2> list = new();

        while (node.cameFrom != null) {
            list.Add(node.position);
            node = node.cameFrom;
        }

        list.Reverse();
        return list;
    }

    bool OpenSetHasNode(PriorityQueue<PathNode, float> openSet, PathNode node) {

        foreach ((PathNode setNode, float priority) in openSet.UnorderedItems) {
            if (setNode.position == node.position) {
                return true;
            }
        }

        return false;
    }

    float H(Vector2 start, Vector2 end)
    {
        Vector2 diff = end - start;
        return diff.Length();
    }

}
