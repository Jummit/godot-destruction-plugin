<!--
SPDX-FileCopyrightText: 2023 Jummit

SPDX-License-Identifier: CC0-1.0
-->

# Godot Destruction Plugin ![Godot v4.0](https://img.shields.io/badge/Godot-v4.2-%23478cbf) ![GitHub](https://img.shields.io/github/license/Jummit/godot-destruction-plugin)

Addon for creating a destruction effect for meshes based on a segmented version.

https://github.com/Jummit/godot-destruction-plugin/assets/28286961/a84ef9c2-fca0-446e-a5af-322f03dc753e

## Installation

For Godot **3** install and enable the **Destruction plugin** from the asset library.

For Godot **4** and above, download the addon from the [releases](https://github.com/Jummit/godot-destruction-plugin/releases) and put the contents in the `addons` folder. It can then be enabled under plugin settings as usual.

## Usage

1. Install the **Cell Fracture** addon in Blender, **join your mesh** and use **F3** to search for Cell Fracture. Set the Source Limit to how many RigidBodies you want in your game. (\~5 – 20)
2. Select everything, right click and select `Set Origin > Origin to Center of Mass (Volume)`.
3. Export it as a .ojb or GLTF, import it in Godot **as a scene** and create an **instance** of this scene.
4. Add a `Destruction` node to the **intact** node and set the `Fragmented` scene to the **fragmented** scene.
5. Call `destroy()` to destroy the object.

## Performance

The plugin is only tested in very small scenes. It currently creates a new material for each shard, resulting in a lot of unecessary draw calls. It also creates the shards on the main thread by default. Set the thread group to separate when that becomes an issue.

## License

Code licensed under the MIT license.

[Marble texture](https://3dtextures.me/2019/01/02/marble-gray-001/) licensed CC0 by [3DTextures](https://3dtextures.me), optimized for file size.

All other files licensed under CC0.

This project is [REUSE compliant](https://reuse.software/).
