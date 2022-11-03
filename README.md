# LuaRocks Private Repository

It serves `.rock` files just like the [LuaRocks repository](luarocks.org) does.

It is built with Kong 3, so it is possible to configure Basic Auth and else.

## Usage

Place your `.rock` files inside the `/data/rocks` (you can override this by setting the `LUAROCKS_ADMIN_ROCKS_DIR` environment variable).

**The `luarocks-admin-watcher.sh` script will watch for changes and automatically update the index.**

LuaRocks will listen to `127.0.0.1:7080` by default, you can override this by setting the `LUAROCKS_ADMIN_LISTEN` environment variable.

You can use [Kong API Gateway](https://github.com/Kong/kong) features to add authentication, rate-limiting, etc. Use the `kong.yml` file as an example.

You can spin up the whole thing with this Docker command:

```bash
docker run -it \
  -u $(id -u) \
  --name luarocks \
  -v ${PWD}/rocks:/data/rocks \
  -v ${PWD}/kong.yml:/tmp/kong.yml \
  --rm \
  -e KONG_DECLARATIVE_CONFIG=/tmp/kong.yml \
  -e KONG_DATABASE=off \
  -e KONG_PLUGINS=bundled \
  -e KONG_ADMIN_LISTEN=0.0.0.0:8001 \
  -p 8000:8000 \
  -p 8001:8001 \
  leandrocarneiro/luarocks:kong-3
```

To set the `luarocks` client to use the private repository with basic authentication, you can use the `--server` flag:

```bash
luarocks --server=http://luarocks:s3cr3t@localhost:8000 install myrock
```

If no basic-auth is configured, just remove the `luarocks:s3cr3t@` part.

```bash
luarocks --server=http://localhost:8000 install myrock
```

Or you can configure the `~/.luarocks/config-5.1.lua` file, like this:

```lua
rocks_servers = {
   {
      "https://luarocks.org",
      "https://raw.githubusercontent.com/rocks-moonscript-org/moonrocks-mirror/master/",
      "http://luafr.org/moonrocks/",
      "http://luarocks.logiceditor.com/rocks"
   },
   {
    "https://luarocks:s3cr3t@my-mirror-1.com",
    "https://another:user@my-mirror-2.com",
    "http://my-unsecure-mirror-1.com:7080",
   }
}
```

It is possible to set multiple mirrors. Then the flag `--server` will not be necessary.