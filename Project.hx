
#if macro
import haxe.Json;
import haxe.macro.Context;
import haxe.macro.Expr;
import sys.FileSystem.*;
import sys.io.File;
using StringTools;
using haxe.io.Path;
using haxe.macro.ExprTools;
#end

class Project {

    #if macro

    static function build( path : String, name : String, dst : String, forceRebuild = true, backgroundMode = true, buildScript = 'ArmoryBuildFilesGH/build_project.py' ) {
        if( !exists( path ) )
            throw 'Directory [$path] not found';
        var srcdir = '$path';
        if( !exists( path ) )
            throw 'Directory [$srcdir] not found';
        var dstdir = '$dst';
        if( exists( dstdir ) )
            forceRebuild ? rmdir(dstdir) : return 0;
        var blend = '$srcdir/$name.blend';
        var args = [];
        if( backgroundMode ) args.push('-b');
        args = args.concat( [blend,'--python',buildScript] );
        Sys.println( 'blender '+args.join(' ') );
        final code = Sys.command('blender', args);
        if( code == 0 ) {
            var builddir = '$srcdir/build_$name/html5';
            if( !exists( builddir ) ) {
                trace( 'Exit code 0 but build directory not found: $builddir' );
                return 1;
            }
            if( !exists( '$dstdir/html5' ) ) createDirectory( '$dstdir/html5' );
            rename( builddir, '$dstdir/html5' );

            builddir = '$srcdir/build_$name/html5-resources';
            if( !exists( builddir ) ) {
                trace( 'Exit code 0 but build directory not found: $builddir' );
                return 1;
            }
            if( !exists( '$dstdir/html5-resources' ) ) createDirectory( '$dstdir/html5-resources' );
            rename( builddir, '$dstdir/html5-resources' );

            var nojekylldir = '$dstdir/.nojekyll';
            var fout = File.write(nojekylldir, false);
            if(fout != null) fout.close();
            
        }
        return code;
    }
   
    static function rmdir( path : String ) {
		if( exists( path ) ) {
			for( e in readDirectory( path ) ) {
				var p = '$path/$e';
				isDirectory( p ) ? rmdir( p ) : deleteFile( p );
			}
			deleteDirectory( path );
		}
	}

    #end
}
