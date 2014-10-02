# Geminacontainer

Geminacontainer is a docker image for geminabox. By default it will proxy upstream gems from rubygems.org.

## Usage

To push to geminabox, you need to set your credentials to missing like this: 

*~/.gem/credentials*
```
---
:rubygems_api_key: 'missing'
```

This file must be set to have the permissions 0600.

## Examples

Running with no auth on port 8080:

```
docker run -p 8080:80 geminacontainer
```

Running with auth only for uploads and deletions:

```
docker run -e PERMISSIONS_FLAVOR=PUBLIC_READ -e USERNAME=username -e PASSWORD=password -p 8080:80 geminacontainer
```

Running with http basic auth for all actions:

```
docker run -e PERMISSIONS_FLAVOR=PRIVATE -e USERNAME=username -e PASSWORD=password -p 8080:80 geminacontainer
```

Running with a persistent data directory:

```
mkdir -p /opt/gems
docker run -v /opt/gems:/data/geminabox-data -p 8080:80 geminacontainer
```
