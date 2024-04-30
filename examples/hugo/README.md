# Ghost example

## Requirements

- druidfi/stonehenge up & running

## Setup

```console
cd examples/hugo
make up
```

Access the site in https://hugo.docker.so/

## Create a first post

Create a new post by:

```console
make hugo new posts/my-first-post.md
```

And see it: https://hugo.docker.so/posts/my-first-post

## Next steps

Go to https://gohugo.io/ and read how to manage your site.

## Teardown

You can tear down the whole example by:

```console
make down
```

This will put down the containers.
