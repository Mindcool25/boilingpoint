using System;
using System.ComponentModel.DataAnnotations;
using Godot;

public partial class Main : Node2D
{

	private Camera2D camera;
	private CharacterBody2D player;
	private AudioStreamPlayer music;
	[Export]
	public float LockVelocity {get; set;} = 2500F;
	[Export]
	public float ScreenEdges {get;set;} = 500F;
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		this.camera = GetNode<Camera2D>("Camera");
		this.player = GetNode<CharacterBody2D>("Player");
		this.music = GetNode<AudioStreamPlayer>("Music");
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		camera.Position = new Vector2(Math.Clamp(player.Position.X, -ScreenEdges, ScreenEdges), player.Position.Y);
		if (player.Velocity.Y > LockVelocity){
			camera.PositionSmoothingEnabled = false;
		}
		else {
			camera.PositionSmoothingEnabled = true;
		}
		if (!music.Playing){
			music.Play();
		}

	}
}
