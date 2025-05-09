
# 🪐 Space Golf

**Space Golf** is a 2D mini-golf inspired game with a futuristic vibe, built using [Ruby2D](https://www.ruby2d.com/). Aim, drag, and release to shoot the golf ball around space-themed obstacles and into the goal!

---

## 🎮 Features

- 🟣 Drag-and-release ball mechanics with visual aiming indicators.
- 🧱 Multiple levels with unique obstacle layouts.
- 🔊 Background music and sound effects for immersive play.
- 🧠 Escape key toggles the in-game menu.
- ⛳ Stroke counter and visual feedback upon goal completion.
- 🌌 Fully resizable window with neon-themed visual design.

---

## 🧰 Requirements

- **Ruby** (version 2.5 or later)
- [Ruby2D gem](https://www.ruby2d.com/)

```bash
gem install ruby2d
```

---

## 🚀 How to Run

```bash
ruby space_golf.rb
```

Make sure all the audio files (`.mp3`) are in the same directory as the Ruby file.

---

## ⌨️ Controls

| Key | Action |
|-----|--------|
| `1` to `5` | Load levels 1–5 from menu |
| `ESC` | Toggle in-game menu |
| `Mouse Drag` | Aim and shoot ball |
| `Mouse Click (on ball)` | Initiate shot |
| `Mouse Click (Quit button)` | Exit game |

---

## 🗺️ Level Design

Each level contains:
- A **starting ball position**
- An **end goal (orange circle)**
- A variety of **static obstacles** made of rectangles
- Border walls to keep the ball in bounds

Level logic dynamically updates the layout depending on player choice (keys `1` through `5`).

---

## 🔊 Audio

This game includes 3 sound assets:
- **Background Music**: Looped while playing
- **Putt Sound**: Played when the ball is hit
- **Goal Sound**: Played upon successful completion

---

## 🧱 Game Objects

| Object Type | Description |
|-------------|-------------|
| `@ball` | The player-controlled ball |
| `@goal` | The goal (target) area |
| `@obstacleN` | Level-specific obstacles |
| `@menu` | UI overlay during level select |
| `@block_arr` | Active collision objects in each level |

---

## 💡 Gameplay Mechanics

- Dragging shows a dotted yellow trajectory and a red line in the opposite direction.
- Releasing the mouse launches the ball in the aimed direction.
- Collisions with obstacles and screen boundaries affect ball trajectory.
- When the ball reaches the goal, a sound is played and the player can choose a new level.

---

## 📁 File Structure

```
space_golf/
├── space_golf.rb               # Main game logic
├── golf-ball-landing.mp3       # Goal sound
├── golf-putt.mp3               # Putt sound
├── background-music.mp3        # Background music
└── README.md                   # You're reading it!
```

---

## 📌 Notes

- Game is currently single-screen.
- Levels can be extended or edited by modifying the level switch logic under the `on :key_down` event.
