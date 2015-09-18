require_relative 'app/server'

use Rack::Deflater
run WhosGotDirt::Server
