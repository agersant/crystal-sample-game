/*
 * auto-export.js
 *
 * This extension automatically exports tilesets and maps when
 * they are saved.
 */

/* global tiled */

tiled.assetSaved.connect(function(asset) {
	if (asset.isTileset || asset.isTileMap) {
		tiled.trigger("Export");
	}
	if (asset.isTileset && asset.image) {
		// File.copy(asset.image, asset.image);
	}
});
