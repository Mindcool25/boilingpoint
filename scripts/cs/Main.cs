using Godot;
using System;

public partial class Main : Node2D
{

	private Camera2D camera;
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		this.camera = GetNode<Camera2D>("Camera");
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{

	}
}
