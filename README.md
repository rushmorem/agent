# Introduction

Intecture is a developer friendly, language agnostic configuration management tool for server systems.

* Extensible support for virtually any programming language
* Standard programming interface. No DSL. No magic.
* Rust API library (and bindings for popular languages)

You can find out more at [intecture.io](http://intecture.io).

# System Requirements

Intecture relies on [ZeroMQ](http://zeromq.org) for communication between your project (intecure-api) and your managed servers (intecture-agent). You can usually install ZMQ via the package manager, or from source: [libzmq](https://github.com/zeromq/libzmq).

# Install

## Auto

The quick way to get up and running is by using the Intecture installer.

```
$ curl -sSf https://static.intecture.io/install.sh | sh
```

## Manual

First, as this project is written in Rust, you'll need...well, [Rust!](https://www.rust-lang.org)

Next, clone this repository to your local machine and use the Makefile to build it:

```
$ git clone https://github.com/betweenlines/intecture-agent.git
$ cd intecture-agent/
$ make && sudo make install
```

Once this has finished, you should have a shiny new binary called *inagent*, which lives in your system's *bin/* directory.

# Uninstall

Run the uninstall target on the Makefile:

```
$ cd intecture-agent/
$ sudo make uninstall
```

# Support

For enterprise support and consulting services, please email <mailto:support@intecture.io>.

For any bugs, feature requests etc., please ticket them on GitHub.