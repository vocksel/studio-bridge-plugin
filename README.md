# Studio Bridge Plugin

Syncs files served up by the Studio Bridge CLI to Roblox Studio.

For documentation on installing the CLI and using it with the plugin, see the [main repository](https://github.com/vocksel/studio-bridge).

## Install

The plugin is [hosted on Roblox's website](https://www.roblox.com/library/626028645/Studio-Bridge) and can be easily downloaded right from inside Studio.

## Compile From Source

You need Python 3+ and [Elixir](https://github.com/vocksel/elixir) installed. From there you can run the following commands to compile the plugin:

```shell
$ cd plugin/
$ python build.py
```

Note that the build script is setup to compile the plugin directly to Roblox's `Plugins` folder on **Windows**. You'll have to modify the paths if you're on OS X.
