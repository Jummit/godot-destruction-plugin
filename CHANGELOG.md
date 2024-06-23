<!--
SPDX-FileCopyrightText: 2023 Jummit

SPDX-License-Identifier: CC0-1.0
-->

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 7.2

### Fixed

* Freeing shards before their animation finishes no longer results in errors.

## 7.1

### Changed

* The demo now features multiple cubes, which can be destroyed by clicking on them.
* The background now is a more neutral color.

### Added

* Reuse modified shard materials if they are the same.

## 7.0

### Changed

* Material overrides now have priority over the mesh materials.
* Mention asset library for 4.0 installation.

### Removed

* Removed the shard scene, shards are now generated in the destruction node.

### Added

* Allow non-standard spatial materials for shards.

## 6.1

### Breaking

* Added `mesh_instance` property which is used to provide the mesh with the shard material.

### Changed

* Made the cube in the demo a RigidBody3D, which is closer to real-world usage.
* Only one material is generated for each destroyed object.
* Names are now forced human readable.

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
