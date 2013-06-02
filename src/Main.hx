package ;

import flambe.asset.AssetPack;
import flambe.asset.Manifest;
import flambe.System;

/**
 * ...
 * @author sonygod
 */
class Main 
{
    private static function onSuccess (pack :AssetPack) 
    {
    }

    private static function main () 
    {
        // Wind up all platform-specific stuff
        System.init();

        // Load up the compiled pack in the assets directory named "bootstrap"
        var manifest = Manifest.build("bootstrap");
        var loader = System.loadAssetPack(manifest);
        loader.get(onSuccess);
    }
}
