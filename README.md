# NetAtmoDL

`netatmo-dl` is a library for downloading CSV or XLS data from your NetAtmo weather station. It does not support other NetAtmo API features at this time, only CSV/XLS download.

Requires Ruby 2.0 or newer.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'netatmo-dl', github: 'openfirmware/netatmo-dl'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ git clone https://github.com/openfirmware/netatmo-dl
    $ cd netatmo-dl
    $ bundle install
    $ bundle exec rake build
    $ gem install pkg/netatmo-dl-0.1.0.gem

## Usage

The gem can be used as a library for your own downloader or instead you can use the bundled `netatmo-dl` tool to download the files automatically. You will need your NetAtmo account username and password.

Here is an example that reads the username/password from the shell environment, downloads data from the device and module specified for the time range between `start` and `end`, and outputs the data as CSV files in the output directory, one per 24 hour period.

```sh
    $ mkdir $HOME/data/netatmo
    $ netatmo-dl --user=$NETATMO_USER --pass=$NETATMO_PASS --device=$DEVICE --module=$MODULE --output=$HOME/data/netatmo --start=2016-01-01T00:00:00Z --end=2016-01-01T00:06:00Z
```

* `user`: email address you use to login to NetAtmo
* `pass`: password you use to login to NetAtmo
* `device`: MAC address of the device set to download
* `module`: MAC address of the module to download — same as device for the base station, different for secondary modules
* `output-directory`: path to directory where data will be dumped in CSV files split by 24 hour increments. This is done to avoid hitting the limits of the CSV download API.
* `start`: Start date to download data, in ISO8601 format with a timezone.
* `end`: End date to download data, in ISO8601 format with a timezone.

I suggest keeping your environment variables in an environment file like `$HOME/.netatmo-dl`, and sourcing that before running the script:

```sh
    $ cat $HOME/.netatmo-dl
    export $NETATMO_USER="you@example.com"
    export $NETATMO_PASS="your-hopefully-better-password"
    export $DEVICE="00:00:00:00:00:00"
    export $MODULE="00:00:00:00:00:00"
    $ source $HOME/.netatmo-dl && netatmo-dl --user=$NETATMO_USER --pass=$NETATMO_PASS --device=$DEVICE --module=$MODULE --output=$HOME/data/netatmo --start=2016-01-01T00:00:00Z --end=2016-01-01T00:06:00Z
```

**PRO TIP**: Do not run the tool too frequently as NetAtmo only updates the data every five minutes. In fact, you may want to run the tool only once per day to archive the data. If you need more frequent data access, you may have to build your own library to connect to the [NetAtmo API](https://dev.netatmo.com/doc).

TODO: Add documentation about the library API.

### Why not use NetAtmo OAuth?

Because the `getmeasurecsv` API call does not seem to work with access tokens generated with OAuth2. So the library uses web login instead.

### Where do I get my Device ID and Module IDs?

The Device ID and Module IDs for your NetAtmo weather station can be retrieved from the [NetAtmo dashboard][Dashboard] or from the [NetAtmo API][getstationsdata].

To download data from the base station, set the Module ID to be the same as the Device ID. To download from outdoor or other modules, the Device ID will correspond to the base station and the Module ID will correspond to the specific module.

To find your Device ID, [from the dashboard][Dashboard] select the settings icon (a gear) and scroll down to find the Indoor Module MAC address. It should have the pattern `00:00:00:00:00:00`, with letters or numbers in each two-character set.

Also in the same page, each other module will have a serial number of the pattern `h123456` or `i123456`. For outdoor modules starting with `h`, a serial number of `h123456` will make the MAC address will be `02:00:00:12:34:56`. For indoor modules starting with `i`, a serial number of `i123456`  will make the MAC address will be `03:00:00:12:34:56`.

[Dashboard]: (https://my.netatmo.com/app/station)
[getstationsdata]: (https://dev.netatmo.com/doc/methods/getstationsdata)

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/openfirmware/netatmo-dl. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Acknowledgements

Thanks to [Michael Miklis' work on decoding the CSV download API](https://www.michaelmiklis.de/export-netatmo-weather-station-data-to-csv-excel/).
