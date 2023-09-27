# SPDX-FileCopyrightText: 2023 Jummit
#
# SPDX-License-Identifier: CC0-1.0

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 6.1

### Breaking

* Added `mesh_instance` property which is used to provide the mesh with the shard material.

### Changed

* Made the cube in the demo a RigidBody3D, which is closer to real-world usage.
* Only one material is generated for each destroyed object.

### Fixed

* Removed embedded scene in `destructible_cube.tscn`

### Added

* Added more documentation.
* Added "addon" tag to project.

## 6.0

### Breaking

* Removed `destruction_utils.gd` and moved the code to `destruction.gd`.
* Renamed `collision_layers` to `collision_layer`.
* Renamed `layer_masks` to `collision_mask`.

### Removed

* Scenes are no longer added in a separate thread. Godot 4.2 adds thread groups which can be used instead.

### Fixed

* Improve documentation.

### Added

* The mesh in the demo now has a texture.
* The project is now REUSE compliant.
