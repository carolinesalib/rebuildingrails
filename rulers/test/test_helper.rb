# Magic to make sure we are requiring the local rulers gem instead of an installed gem
$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require "rulers"
require "rack/test"

require "minitest/autorun"
