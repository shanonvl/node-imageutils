#
# @description application entry point
#
# command line args
fs = require 'fs'
imageutils = require './lib/imageutils'

dir = process.argv[2]
files = (fs.readdirSync dir).map (f) -> "#{dir}/#{f}"

imageutils.resizeLongEdge
  images:files
  longEdgePixels:1200
  outputDirectory:process.argv[3]
