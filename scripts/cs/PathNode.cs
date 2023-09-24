using Godot;
using System.Collections.Generic;

public class PathNode {
    private double height;
    private Vector2 gridSize;

    public Vector2 position;
    public float gScore;
    public float hScore;
    public float fScore;

    public PathNode cameFrom;

    public PathNode(Vector2 position, Vector2 gridSize) {
        this.position = position;
        this.gScore = float.MaxValue;
        this.fScore = float.MaxValue;
        this.cameFrom = null;
        this.gridSize = gridSize;
    }

    public PathNode FromXY(float x, float y) {
        return new PathNode(new Vector2(x, y), gridSize);
    }

    public float CalculateFScore() {
        fScore = gScore + hScore;
        return fScore;
    }

    public List<PathNode> GetNeighbors() {
        List<PathNode> neighborList = new();
        if (position.X - 1 >= 0) {
            neighborList.Add(FromXY(position.X - 1, position.Y));

            if (position.Y - 1 >= 0) neighborList.Add(FromXY(position.X - 1, position.Y - 1));
            if (position.Y + 1 < gridSize.Y) neighborList.Add(FromXY(position.X - 1, position.Y + 1));
        }

        if (position.X + 1 < gridSize.X) {
            neighborList.Add(FromXY(position.X + 1, position.Y));

            if (position.Y - 1 >= 0) neighborList.Add(FromXY(position.X + 1, position.Y - 1));
            if (position.Y + 1 < gridSize.Y) neighborList.Add(FromXY(position.X + 1, position.Y + 1));
        }

         if (position.Y - 1 >= 0) neighborList.Add(FromXY(position.X, position.Y - 1));
         if (position.Y + 1 < gridSize.Y) neighborList.Add(FromXY(position.X, position.Y + 1));


        return neighborList;
    }

    public override string ToString() {
        return position.X + ", " + position.Y;
    }
}
