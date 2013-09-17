# hue-jenkins

Simple script to update a Philips Hue bulb red/green based on Jenkins build status.

## Requirements

- The modified [hue](http://github.com/chaione/hue) gem [originally by Sam Soffes](http://github.com/soffes/hue).  This adds SSDP discovery
of the bridge which we needed in our setup.  I have no idea if it will work in other setups.
- The updated ruby 1.9 [upnp gem](https://github.com/turboladen/upnp).

## Usage

1. Clone the project
2. Run `bundle install`
3. Define the environment vars outlined below
4. Run `ruby hue.rb` on a schedule

## ENV vars

- `JENKINS_URL` - the base URL of your jenkins installation (required)
- `JENKINS_HTTP_BASIC_USERNAME` - if you have basic auth, set this.
- `JENKINS_HTTP_BASIC_PASSWORD` - if you have basic auth, set this.
- `HUE_LIGHT_INDEX` - if not defined, will use the first light.  0-based.
- `JENKINS_JOB_PATTERN` - if present, it will only match jobs with this regex.

## License

MIT License.
