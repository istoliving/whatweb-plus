#!/usr/bin/env ruby
#
# .$$$     $.                                   .$$$     $.
# $$$$     $$. .$$$  $$$ .$$$$$$.  .$$$$$$$$$$. $$$$     $$. .$$$$$$$. .$$$$$$.
# $ $$     $$$ $ $$  $$$ $ $$$$$$. $$$$$ $$$$$$ $ $$     $$$ $ $$   $$ $ $$$$$$.
# $ `$     $$$ $ `$  $$$ $ `$  $$$ $$' $ `$ `$$ $ `$     $$$ $ `$      $ `$  $$$'
# $. $     $$$ $. $$$$$$ $. $$$$$$ `$  $. $  :' $. $     $$$ $. $$$$   $. $$$$$.
# $::$  .  $$$ $::$  $$$ $::$  $$$     $::$     $::$  .  $$$ $::$      $::$  $$$$
# $;;$ $$$ $$$ $;;$  $$$ $;;$  $$$     $;;$     $;;$ $$$ $$$ $;;$      $;;$  $$$$
# $$$$$$ $$$$$ $$$$  $$$ $$$$  $$$     $$$$     $$$$$$ $$$$$ $$$$$$$$$ $$$$$$$$$'
#
#
# WhatWeb - Next generation web scanner.
# Developed by Andrew Horton (urbanadventurer) and Brendan Coles (bcoles)
#
# Homepage: https://morningstarsecurity.com/research/whatweb
#
# Copyright 2009 to 2020 Andrew Horton and Brendan Coles
#
# This file is part of WhatWeb.
#
# WhatWeb is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# WhatWeb is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with WhatWeb.  If not, see <http://www.gnu.org/licenses/>.

$LOAD_PATH.unshift(File.join(File.expand_path(__dir__)), '.')

require 'lib/whatweb'

#
# Command-line usage information (full)
#
def usage_full
  puts blue(WhatWeb::BANNER)

  puts(<<-EOT)
WhatWeb - Next generation web scanner version #{WhatWeb::VERSION}.
Developed by Andrew Horton (urbanadventurer) and Brendan Coles (bcoles).
Homepage: https://morningstarsecurity.com/research/whatweb

Usage: whatweb [options] <URLs>

TARGET SELECTION:
  <TARGETs>\t\t\tEnter URLs, hostnames, IP addresses, filenames or
  \t\t\t\tIP ranges in CIDR, x.x.x-x, or x.x.x.x-x.x.x.x
  \t\t\t\tformat.
  --input-file=FILE, -i\t\tRead targets from a file. You can pipe
\t\t\t\thostnames or URLs directly with -i /dev/stdin.

TARGET MODIFICATION:
  --url-prefix\t\t\tAdd a prefix to target URLs.
  --url-suffix\t\t\tAdd a suffix to target URLs.
  --url-pattern\t\t\tInsert the targets into a URL.
\t\t\t\te.g. example.com/%insert%/robots.txt

New Features REQUEST  CONTROL:
 --no-max-match, -X\t\tNew features, Shut down Ignore matching :url require, Default True.
 --no-min-urls, -Y\t\tNew features, Shut down Minimize Access the  plugins :urls , Default True.
 --no-base-path, -Z\t\tNew features, Shut down Add  finger paths IN $BASEPATH Like /favicon.ico,/robots.txt, Default True.

AGGRESSION:
The aggression level controls the trade-off between speed/stealth and
reliability.
  --aggression, -a=LEVEL\tSet the aggression level. Default: 1.
  1. Stealthy\t\t\tMakes one HTTP request per target and also
  \t\t\t\tfollows redirects.
  3. Aggressive\t\t\tIf a level 1 plugin is matched, additional
  \t\t\t\trequests will be made.
  4. Heavy\t\t\tMakes a lot of HTTP requests per target. URLs
  \t\t\t\tfrom all plugins are attempted.

HTTP OPTIONS:
  --user-agent, -U=AGENT\tIdentify as AGENT instead of WhatWeb/#{WhatWeb::VERSION}.
  --header, -H\t\t\tAdd an HTTP header. eg "Foo:Bar". Specifying a
\t\t\t\tdefault header will replace it. Specifying an
\t\t\t\tempty value, e.g. "User-Agent:" will remove it.
  --follow-redirect=WHEN\tControl when to follow redirects. WHEN may be
\t\t\t\t`never', `http-only', `meta-only', `same-site',
\t\t\t\tor `always'. Default: #{$FOLLOW_REDIRECT}.
  --max-redirects=NUM\t\tMaximum number of redirects. Default: 10.

AUTHENTICATION:
  --user, -u=<user:password>\tHTTP basic authentication.
  --cookie, -c=COOKIES\t\tUse cookies, e.g. 'name=value; name2=value2'.
  --cookie-jar=FILE\t\tRead cookies from a file.
  --update-cookies\t\tUpdate cookies according to responses.

PROXY:
  --proxy, -P\t\t\t<hostname[:port]> Set proxy hostname and port.
\t\t\t\tDefault: #{$PROXY_PORT}.
  --proxy-user\t\t\t<username:password> Set proxy user and password.

PLUGINS:
  --list-plugins, -l\t\tList all plugins.
  --info-plugins, -I=[SEARCH]\tList all plugins with detailed information.
\t\t\t\tOptionally search with keywords in a comma
\t\t\t\tdelimited list.
  --search-plugins=STRING\tSearch plugins for a keyword.
  --plugins, -p=LIST\t\tSelect plugins. LIST is a comma delimited set
\t\t\t\tof selected plugins. Default is all.
\t\t\t\tEach element can be a directory, file or plugin
\t\t\t\tname and can optionally have a modifier, +/-.
\t\t\t\tExamples: +/tmp/moo.rb,+/tmp/foo.rb
\t\t\t\ttitle,md5,+./plugins-disabled/
\t\t\t\t./plugins-disabled,-md5
\t\t\t\t-p + is a shortcut for -p +plugins-disabled.
  --grep, -g=STRING|REGEXP\tSearch for STRING or a Regular Expression. Shows
\t\t\t\tonly the results that match.
\t\t\t\tExamples: --grep "hello"
\t\t\t\t--grep "/he[l]*o/"
  --custom-plugin=DEFINITION\tDefine a custom plugin named Custom-Plugin,
\t\t\t\tExamples: ":text=>'powered by abc'"
\t\t\t\t":version=>/powered[ ]?by ab[0-9]/"
\t\t\t\t":ghdb=>'intitle:abc \\"powered by abc\\"'"
\t\t\t\t":md5=>'8666257030b94d3bdb46e05945f60b42'"
\t\t\t\t"{:text=>'powered by abc'}"
  --dorks=PLUGIN\t\tList Google dorks for the selected plugin.

OUTPUT:
  --verbose, -v\t\t\tVerbose output includes plugin descriptions.
\t\t\t\tUse twice for debugging.
  --colour,--color=WHEN\t\tcontrol whether colour is used. WHEN may be
\t\t\t\t`never', `always', or `auto'.
  --quiet, -q\t\t\tDo not display brief logging to STDOUT.
  --no-errors\t\t\tSuppress error messages.

LOGGING:
  --log-brief=FILE\t\tLog brief, one-line output.
  --log-verbose=FILE\t\tLog verbose output.
  --log-errors=FILE\t\tLog errors.
  --log-xml=FILE\t\tLog XML format.
  --log-json=FILE\t\tLog JSON format.
  --log-sql=FILE\t\tLog SQL INSERT statements.
  --log-sql-create=FILE\t\tCreate SQL database tables.
  --log-json-verbose=FILE\tLog JSON Verbose format.
  --log-magictree=FILE\t\tLog MagicTree XML format.
  --log-object=FILE\t\tLog Ruby object inspection format.
  --log-mongo-database\t\tName of the MongoDB database.
  --log-mongo-collection\tName of the MongoDB collection.
\t\t\t\tDefault: whatweb.
  --log-mongo-host\t\tMongoDB hostname or IP address.
\t\t\t\tDefault: 0.0.0.0.
  --log-mongo-username\t\tMongoDB username. Default: nil.
  --log-mongo-password\t\tMongoDB password. Default: nil.
  --log-elastic-index\t\tName of the index to store results. Default: whatweb
  --log-elastic-host\t\tHost:port of the elastic http interface. Default: 127.0.0.1:9200

PERFORMANCE & STABILITY:
  --max-threads, -t\t\tNumber of simultaneous threads. Default: 25.
  --open-timeout\t\tTime in seconds. Default: #{$HTTP_OPEN_TIMEOUT}.
  --read-timeout\t\tTime in seconds. Default: #{$HTTP_READ_TIMEOUT}.
  --wait=SECONDS\t\tWait SECONDS between connections.
\t\t\t\tThis is useful when using a single thread.

HELP & MISCELLANEOUS:
  --short-help\t\t\tShort usage help.
  --help, -h\t\t\tComplete usage help.
  --debug\t\t\tRaise errors in plugins.
  --version, -V\t\t\tDisplay version information.

EXAMPLE USAGE:
* Scan example.com.
  ./whatweb example.com

* Scan reddit.com slashdot.org with verbose plugin descriptions.
  ./whatweb -v reddit.com slashdot.org

* An aggressive scan of wired.com detects the exact version of WordPress.
  ./whatweb -a 3 www.wired.com

* Scan the local network quickly and suppress errors.
  whatweb --no-errors 192.168.0.0/24

* Scan the local network for https websites.
  whatweb --no-errors --url-prefix https:// 192.168.0.0/24

* Scan for crossdomain policies in the Alexa Top 1000.
  ./whatweb -i plugin-development/alexa-top-100.txt \\
  --url-suffix /crossdomain.xml -p crossdomain_xml

EOT
=begin
  suggestions = ''
  suggestions << "To enable MongoDB logging install the mongo gem.\n" unless gem_available?('mongo')
  suggestions << "To enable character set detection and MongoDB logging install the rchardet gem.\n" unless gem_available?('rchardet')

  unless suggestions.empty?
    puts
    puts 'OPTIONAL DEPENDENCIES'
    puts '-' * 80
    puts suggestions
    puts
  end
=end
end

#
# Command-line usage information (short)
#
def usage_short
  puts blue(WhatWeb::BANNER)

  puts(<<-EOT)
WhatWeb - Next generation web scanner version #{WhatWeb::VERSION}.
Developed by Andrew Horton (urbanadventurer) and Brendan Coles (bcoles)
Homepage: https://morningstarsecurity.com/research/whatweb

Usage: whatweb [options] <URLs>

  <TARGETs>\t\t\tEnter URLs, hostnames, IP addresses, filenames or
  \t\t\t\tIP ranges in CIDR, x.x.x-x, or x.x.x.x-x.x.x.x
  \t\t\t\tformat.
  --input-file=FILE, -i\t\tRead targets from a file.

  --aggression, -a=LEVEL\tSet the aggression level. Default: 1.
  1. Stealthy\t\t\tMakes one HTTP request per target and also
  \t\t\t\tfollows redirects.
  3. Aggressive\t\t\tIf a level 1 plugin is matched, additional
  \t\t\t\trequests will be made.

  --list-plugins, -l\t\tList all plugins.
  --info-plugins, -I=[SEARCH]\tList all plugins with detailed information.
\t\t\t\tOptionally search with a keyword.

  --verbose, -v\t\t\tVerbose output includes plugin descriptions.

Note: This is the short usage help. For the complete usage help use -h or --help.

EOT
end

if ARGV.empty? # faster usage info
  usage_short
  exit
end

### logging
$semaphore = Mutex.new
# this is noisy in debug
def $semaphore.reentrant_synchronize(&work)
  # This test is noisy in debug, shame there isn't a good way to test for mutex ownership
  $semaphore.lock
  $semaphore.unlock
rescue ThreadError
  raise if $WWDEBUG
  work.call
else
  $semaphore.synchronize(&work)
end

#
# Display error messages
#
def error(s)
  return if $NO_ERRORS

  $semaphore.reentrant_synchronize do
    # TODO: make use_color smart, so it detects a tty
    STDERR.puts((($use_colour == 'auto') || ($use_colour == 'always')) ? red(s) : s)
    STDERR.flush
    $LOG_ERRORS.out(s) if $LOG_ERRORS
  end
end

#
# Default options
#

# Plugins
plugin_selection = nil
use_custom_plugin = false
use_custom_grep_plugin = false

# Targets
input_file = nil

# Output
logging_list = []
mongo = {}
mongo[:use_mongo_log] = false
elastic = {}
elastic[:use_elastic_log] = false

# Target modification
url_prefix = ''
url_suffix = ''
url_pattern = nil

# HTTP connection
max_threads = 25
max_redirects = 10

# optional arguments work badly with URLs
opts = GetoptLong.new(
  ['-h', '--help', GetoptLong::NO_ARGUMENT],
  ['--short-help', GetoptLong::NO_ARGUMENT],
  ['-v', '--verbose', GetoptLong::NO_ARGUMENT],
  ['-X','--no-max-match', GetoptLong::NO_ARGUMENT],
  ['-Y','--no-min-urls', GetoptLong::NO_ARGUMENT],
  ['-Z','--no-base-path', GetoptLong::NO_ARGUMENT],
  ['-l', '--list-plugins', GetoptLong::NO_ARGUMENT],
  ['-p', '--plugins', GetoptLong::REQUIRED_ARGUMENT],
  ['-I', '--info-plugins', '--search-plugins', GetoptLong::OPTIONAL_ARGUMENT],
  ['--dorks', GetoptLong::REQUIRED_ARGUMENT],
  ['--colour', '--color', GetoptLong::REQUIRED_ARGUMENT],
  ['--log-object', GetoptLong::REQUIRED_ARGUMENT],
  ['--log-brief', GetoptLong::REQUIRED_ARGUMENT],
  ['--log-xml', GetoptLong::REQUIRED_ARGUMENT],
  ['--log-json', GetoptLong::REQUIRED_ARGUMENT],
  ['--log-json-verbose', GetoptLong::REQUIRED_ARGUMENT],
  ['--log-magictree', GetoptLong::REQUIRED_ARGUMENT],
  ['--log-verbose', GetoptLong::REQUIRED_ARGUMENT],
  ['--log-mongo-collection', GetoptLong::REQUIRED_ARGUMENT],
  ['--log-mongo-host', GetoptLong::REQUIRED_ARGUMENT],
  ['--log-mongo-database', GetoptLong::REQUIRED_ARGUMENT],
  ['--log-mongo-username', GetoptLong::REQUIRED_ARGUMENT],
  ['--log-mongo-password', GetoptLong::REQUIRED_ARGUMENT],
  ['--log-elastic-index', GetoptLong::REQUIRED_ARGUMENT],
  ['--log-elastic-host', GetoptLong::REQUIRED_ARGUMENT],
  ['--log-sql', GetoptLong::REQUIRED_ARGUMENT],
  ['--log-sql-create', GetoptLong::REQUIRED_ARGUMENT],
  ['--log-errors', GetoptLong::REQUIRED_ARGUMENT],
  ['--no-errors', GetoptLong::NO_ARGUMENT],
  ['-i', '--input-file', GetoptLong::REQUIRED_ARGUMENT],
  ['-U', '--user-agent', GetoptLong::REQUIRED_ARGUMENT],
  ['-a', '--aggression', GetoptLong::REQUIRED_ARGUMENT],
  ['-t', '--max-threads', GetoptLong::REQUIRED_ARGUMENT],
  ['--follow-redirect', GetoptLong::REQUIRED_ARGUMENT],
  ['--max-redirects', GetoptLong::REQUIRED_ARGUMENT],
  ['-P', '--proxy', GetoptLong::REQUIRED_ARGUMENT],
  ['--proxy-user', GetoptLong::REQUIRED_ARGUMENT],
  ['--url-prefix', GetoptLong::REQUIRED_ARGUMENT],
  ['--url-suffix', GetoptLong::REQUIRED_ARGUMENT],
  ['--url-pattern', GetoptLong::REQUIRED_ARGUMENT],
  ['--custom-plugin', GetoptLong::REQUIRED_ARGUMENT],
  ['-g', '--grep', GetoptLong::REQUIRED_ARGUMENT],
  ['--open-timeout', GetoptLong::REQUIRED_ARGUMENT],
  ['--read-timeout', GetoptLong::REQUIRED_ARGUMENT],
  ['--header', '-H', GetoptLong::REQUIRED_ARGUMENT],
  ['--cookie', '-c', GetoptLong::REQUIRED_ARGUMENT],
  ['--cookie-jar', GetoptLong::REQUIRED_ARGUMENT],
  ['--update-cookies', GetoptLong::NO_ARGUMENT],
  ['--user', '-u', GetoptLong::REQUIRED_ARGUMENT],
  ['--wait', GetoptLong::REQUIRED_ARGUMENT],
  ['--debug', GetoptLong::NO_ARGUMENT],
  ['-V', '--version', GetoptLong::NO_ARGUMENT],
  ['-q', '--quiet', GetoptLong::NO_ARGUMENT]
)

begin
  opts.each do |opt, arg|
    case opt
    when '-i', '--input-file'
      input_file = arg
    when '-l', '--list-plugins'
      PluginSupport.load_plugins(plugin_selection)  #加载-p --plugins参数输入的文件夹
      PluginSupport.plugin_list
      exit
    when '-p', '--plugins'
      plugin_selection = arg
    when '-I', '--info-plugins'  
      #'--search-plugins'参数没有填写,但其实已经被解析
      PluginSupport.load_plugins(plugin_selection)  #加载-p --plugins参数输入的文件夹
      PluginSupport.plugin_info(arg.split(','))
      exit
    when '--dorks'
      PluginSupport.load_plugins(plugin_selection)  #加载-p --plugins参数输入的文件夹
      PluginSupport.plugin_dorks(arg)
      exit

    when '--color', '--colour'
      $use_colour = 'always' unless arg # no argument
      case arg.downcase
      when 'auto'
        $use_colour = 'auto'
      when 'always'
        $use_colour = 'always'
      when 'never'
        $use_colour = false
      else
        raise('--colour argument not recognized')
      end
    when '--log-object'
      logging_list << LoggingObject.new(arg)
    when '--log-brief'
      logging_list << LoggingBrief.new(arg)
    when '--log-xml'
      logging_list << LoggingXML.new(arg)
    when '--log-magictree'
      logging_list << LoggingMagicTreeXML.new(arg)
    when '--log-verbose'
      logging_list << LoggingVerbose.new(arg)
    when '--log-sql'
      logging_list << LoggingSQL.new(arg)
    when '--log-sql-create'
      PluginSupport.load_plugins('+')
      # delete the file if it already exists
      begin
        File.delete(arg)
      rescue
        puts "File #{arg} already exists and cannot be removed"
      end
      LoggingSQL.new(arg).create_tables
      puts "SQL CREATE statements written to #{arg}"
      exit
    when '--log-json'
      logging_list << LoggingJSON.new(arg)
    when '--log-json-verbose'
      logging_list << LoggingJSONVerbose.new(arg)
    when '--log-mongo-collection'
      unless defined?(Mongo) && defined?(CharDet)
        raise "Mongo logging requires the following gems to be installed.\n - mongo\n - rchardet\n"
      end

      mongo[:collection] = arg
      mongo[:use_mongo_log] = true
    when '--log-mongo-host'
      unless defined?(Mongo) && defined?(CharDet)
        raise "Mongo logging requires the following gems to be installed.\n - mongo\n - rchardet\n"
      end

      mongo[:host] = arg
      mongo[:use_mongo_log] = true
    when '--log-mongo-database'
      unless defined?(Mongo) && defined?(CharDet)
        raise "Mongo logging requires the following gems to be installed.\n - mongo\n - rchardet\n"
      end

      mongo[:database] = arg
      mongo[:use_mongo_log] = true
    when '--log-mongo-username'
      unless defined?(Mongo) && defined?(CharDet)
        raise "Mongo logging requires the following gems to be installed.\n - mongo\n - rchardet\n"
      end

      mongo[:username] = arg
      mongo[:use_mongo_log] = true
    when '--log-mongo-password'
      unless defined?(Mongo) && defined?(CharDet)
        raise "Mongo logging requires the following gems to be installed.\n - mongo\n - rchardet\n"
      end

      mongo[:password] = arg
      mongo[:use_mongo_log] = true
    when '--log-elastic-index'
      elastic[:index] = arg
      elastic[:use_elastic_log] = true
    when '--log-elastic-host'
      elastic[:host] = arg
      elastic[:use_elastic_log] = true
    when '--log-errors'
      $LOG_ERRORS = LoggingErrors.new(arg)
    when '--no-errors'
      $NO_ERRORS = true
    when '-U', '--user-agent'
      $USER_AGENT = arg
    when '-t', '--max-threads'
      max_threads = arg.to_i
    when '-a', '--aggression'
      raise "Agression level must be 1,3, or 4. #{arg} is invalid." unless [1, 3, 4].include? arg.to_i

      $AGGRESSION = arg.to_i
    when '-P', '--proxy'
      $USE_PROXY = true
      $PROXY_HOST = arg.to_s.split(':')[0]
      $PROXY_PORT = arg.to_s.split(':')[1].to_i if arg.to_s.include?(':')
    when '--proxy-user'
      $PROXY_USER = arg.to_s.split(':')[0]
      $PROXY_PASS = arg.to_s.scan(/^[^:]*:(.+)/).to_s if arg =~ /^[^:]*:(.+)/
    when '-q', '--quiet'
      $QUIET = true
    when '-Y','--no-min-urls'
        $MIN_URLS  = false
    when '-X','--no-max-match'
        $MAX_MATCH = false
    when  '-Z','--no-base-path'
        $BASE_PATH =false
    when '--url-prefix'
      url_prefix = arg
    when '--url-suffix'
      url_suffix = arg
    when '--url-pattern'
      url_pattern = arg
    when '--custom-plugin'
      use_custom_plugin = true if PluginSupport.custom_plugin(arg)
    when '--grep', '-g'
      use_custom_grep_plugin = true if PluginSupport.custom_plugin(arg, 'grep')
    when '--follow-redirect'
      raise('Invalid --follow-redirect parameter.') unless %w[never http-only meta-only same-site always].include?(arg.downcase)

      $FOLLOW_REDIRECT = arg.downcase
    when '--max-redirects'
      max_redirects = arg.to_i
    when '--open-timeout'
      $HTTP_OPEN_TIMEOUT = arg.to_i
    when '--read-timeout'
      $HTTP_READ_TIMEOUT = arg.to_i
    when '--wait'
      $WAIT = arg.to_i
    when '-H', '--header'
      begin
        x = arg.scan(/([^:]+):(.*)/).flatten
        raise if x.empty?

        $CUSTOM_HEADERS[x.first] = x.last
      rescue
        raise('Invalid --header parameter.')
      end
    when '-c', '--cookie'
      begin
        raise if arg.empty?

        $CUSTOM_HEADERS['Cookie'] = arg
      rescue
        raise('Cookie require a parameter, e.g. name=value; name2=value2')
      end
    when '--cookie-jar'
      begin
        raise unless File.readable?(arg)
        # Reads cookies in document.cookie format
        # Permits empty lines and trailing spaces. Semicolons on the end of the line are optional.
        $CUSTOM_HEADERS['Cookie'] = File.readlines(arg).delete_if { |line| line.strip =~ /^$/ }.map { |line| line.strip.sub(/([^;])$/, '\1;') }.join(' ')
      rescue
        raise("Could not read cookies from #{arg}.")
      end
    when '--update-cookies'
      $UPDATE_COOKIES = true
    when '-u', '--user'
      unless arg.include?(':')
        raise("Incorrect credentials format.")
      end

      $BASIC_AUTH_USER, $BASIC_AUTH_PASS = arg.split(':', 2)
    when '--debug'
      $WWDEBUG = true
    when '--short-help'
      usage_short
      exit
    when '-h', '--help'
      usage_full
      exit
    when '-v', '--verbose'
      $verbose = $verbose + 1
    when  '-V','--version'
      puts "WhatWeb version #{WhatWeb::VERSION} ( https://morningstarsecurity.com/research/whatweb/ )"
      exit
    end
  end
rescue Errno::EPIPE
  exit
rescue StandardError, GetoptLong::Error => e
  # Disable colours in Windows environments for errors in usage
  $use_colour = false if RbConfig::CONFIG['host_os'] =~ /mswin|mingw/
  puts
  error("Error in processing commandline options - #{e}")
  error e.backtrace if $WWDEBUG
  exit
end

# sanity check # Disable colours in Windows environments when set to auto
if RbConfig::CONFIG['host_os'] =~ /mswin|mingw/
  $use_colour = false unless $use_colour == 'always'
end

### PLUGINS
plugin_selection += ',+Custom-Plugin'	if use_custom_plugin && plugin_selection
plugin_selection += ',+Grep'	if use_custom_grep_plugin && plugin_selection
plugins = PluginSupport.load_plugins(plugin_selection)
# load all the plugins

# sanity check # no plugins?
if plugins.empty?
  error 'No plugins selected, exiting.'
  exit 1
end

# optimise plugins
PluginSupport.precompile_regular_expressions

### OUTPUT
logging_list << LoggingBrief.new unless $QUIET || $verbose > 0 # by default logging brief
logging_list << LoggingObject.new if $verbose > 1 # full logging if -vv
logging_list << LoggingVerbose.new if $verbose > 0 # full logging if -v

## logging dependencies
if mongo[:use_mongo_log]
  unless plugins.map { |a, _b| a }.include?('Charset')
    error('MongoDB logging requires the Charset plugin to be activated. The Charset plugin is the slowest whatweb plugin, it not included by default, and resides in the plugins-disabled folder. Use ./whatweb -p +./plugins-disabled/charset.rb to enable it.')
    exit 1
  end

  logging_list << LoggingMongo.new(mongo)
end

logging_list << LoggingElastic.new(elastic) if elastic[:use_elastic_log]

## Headers
$CUSTOM_HEADERS['User-Agent'] = $USER_AGENT unless $CUSTOM_HEADERS['User-Agent']
$CUSTOM_HEADERS.delete_if { |_k, v| v == '' }

urls = ARGV


# Initialize Scanner
begin
  scanner = WhatWeb::Scan.new(
    # Targets
    urls,
    input_file: input_file,

    # HTTP connection
    max_threads: max_threads,

    # Target modification
    url_prefix: url_prefix,
    url_suffix: url_suffix,
    url_pattern: url_pattern
  )
rescue SystemExit, Interrupt
  error 'Interrupted. Exiting...'
  exit 1
rescue => e
  puts e.message
  puts e.backtrace
  exit 1
end

# run scan
scanner.scan do |target|
  # TODO: change so we can call it without Target object and with just Headers, HTML, etc.
  # note this modifies target with redirection info
  result = WhatWeb::Parser.run_plugins(target, plugins, scanner: scanner)

  # check for redirection
  WhatWeb::Redirect.new(target, scanner, max_redirects)

  WhatWeb::Parser.parse(
    target,
    result,
    logging_list: logging_list,
    grep_plugin: use_custom_grep_plugin
  )
end

# close down logging and plugins
logging_list.each(&:close)
Plugin.shutdown_all

# pp $PLUGIN_TIMES.sort_by {|x,y|y }
