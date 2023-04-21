# Godot Destruction Plugin ![Godot v4.0](https://img.shields.io/badge/Godot-v4.1-%23478cbf) ![GitHub](https://img.shields.io/github/license/Jummit/godot-destruction-plugin)

Addon for creating a destruction effect for meshes based on a segmented version.

https://user-images.githubusercontent.com/28286961/232236134-19868773-dd9f-402a-b21e-c8ecc36beb81.mp4

## Usage

1. Install the **Cell Fracture** addon in Blender, **join your mesh** and use **F3** to search for Cell Fracture. Set the Source Limit to how many RigidBodies you want in your game. (\~5 – 20)
2. Select everything, right click and select `Set Origin > Origin to Center of Mass (Volume)`.
3. Export it as a .ojb or GLTF, import it in Godot **as a scene** and create an **instance** of this scene.
4. For Godot **3** Install and **enable** the **Destruction plugin** from the asset library. On Godot **4** and above, currently the best method is to download this repository; and extract the **addons/** folder into the root of your project. It can then be enabled under plugin settings as usual.
5. Add a **Destruction** node to the **intact** scene and set the `Fragmented` scene to the **fragmented** scene.
6. Set the `Shard Container` to the node the fragmented objects will be added to at runtime or leave it empty.
7. Call **destroy()** to destroy the object.
