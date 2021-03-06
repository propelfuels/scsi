# scsi

[![Gem Version](https://badge.fury.io/rb/scsi.svg)](https://badge.fury.io/rb/scsi) [![Code Climate](https://codeclimate.com/github/propelfuels/scsi/badges/gpa.svg)](https://codeclimate.com/github/propelfuels/scsi) [![security](https://hakiri.io/github/propelfuels/scsi/master.svg)](https://hakiri.io/github/propelfuels/scsi/master)

A Ruby server for receiving Slack Slash Command and responding with Slack info.

## Requirements

- [Ruby](https://www.ruby-lang.org/) 2.1 <=
- [Kajiki](https://kenjij.github.io/kajiki/) 1.1 <=
- [Sinatra](http://www.sinatrarb.com) 1.4 <=

## Getting Started

### Install

```
$ gem install scsi
```

Optionally install [Thin](http://code.macournoyer.com/thin/) for more robustness.

### Configure

Optionally, create a configuration file following the example below.

```ruby
# Configure application logging
SCSI.logger = Logger.new(STDOUT)
SCSI.logger.level = Logger::DEBUG

SCSI::Config.setup do |c|
  # Optional: if any number of strings are set, it will require a matching
  #           "token" parameter in the incoming request (generated by Slack)
  c.tokens = [
    'sLaCkG3nEr4TeDt0KeN'
  ]
  # HTTP server (Sinatra) settings
  c.dump_errors = true
  c.logging = true
end
```

### Run

In Slack, add a [Slash Command](https://my.slack.com/apps/A0F82E8CA-slash-commands) configuration. Set the URL to wherever you're exposing the SCSI server at. (Hint: setup an SSL front; Slack requires your server to talk HTTPS. E.g., NGINX reverse proxy, [Cloudflare](https://www.cloudflare.com/ssl/).) Also, turn on the "Escape channels, users, and links" setting.

The minimum to start the SCSI server:

```
$ scsi-server start
```

Or, to use your configuration file:

```
$ scsi-server start -c config.rb
```

See help for more options:

```
$ scsi-server -h
```

### Use

In any Slack channel, type your slash command; e.g., `/slackinfo`. You'll get a response like:

> BOT 00:00 Only visible to you

> SCSI: Slash Command Slack Info v0.0.0

> > **channel_name**  
> > general

> > **channel_id**  
> > C000AAAAA
