#!/usr/bin/env python

# Setup options for display when running waf --help
def options(ctx):
    ctx.load("flambe")

# Setup configuration when running waf configure
def configure(ctx):
    ctx.load("flambe")

# Runs the build!
def build(ctx):
    platforms = ["flash"]

    # Only build mobile apps if the required tools are installed
    if ctx.env.has_android: platforms += ["android"]
    # if ctx.env.has_ios: platforms += ["ios"]

    # Kick off a build with the desired platforms
    ctx(features="flambe",
        platforms=platforms,
        libs="nape",
        flags="-D NAPE_RELEASE_BUILD" if not ctx.env.debug else "",
        air_password="samplePassword")
