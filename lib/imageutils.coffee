# imageutils.coffee

fs = require 'fs'
gm = require 'gm'

emptyFn = () ->

class ImageUtils
  resizeLongEdge:(cfg) ->

    me = @
    cfg?={}

    images = cfg.images ? []
    longEdgePixels = cfg.longEdgePixels ? 1200
    remaining = images.length
    outputDirectory = cfg.outputDirectory ? '.'

    onSuccess = cfg.success ? emptyFn
    onError = cfg.error ? emptyFn

    # loop through images.
    images.forEach (f) ->

      # ensure supported file type.
      if /.+\.(jpg|gif|png)$/.test f.toLowerCase()

        # check image size.
        gm(f)
          .size (err,size) ->
            if !err
              [width,height,portrait] = [size.width,size.height,width < height]
              longEdge = if portrait then height else width

              console.log "#{f} - #{width}x#{height} - #{if portrait then 'portrait' else 'landscape'}"

              if longEdge > longEdgePixels

                console.log "Resizing image #{f}...";

                outputPath = "#{outputDirectory}/#{f.replace /.+\/|\\(.+)$/, '$1'}"
                # portrait --> .resize(longEdgePixels) // landscape --> .resize(null,longEdgePixels)
                resizeArgs = if portrait then [null,longEdgePixels] else [longEdgePixels]

                ref = gm(f)
                ref.resize.apply(ref,resizeArgs)
                  # removes / optimizes image
                  .noProfile()
                  .write outputPath,(err) ->

                    if !err
                      console.log "Successfully wrote #{outputPath}"
                      onSuccess.call(this) if !--remaining
                    else
                      console.log "Error writing image: #{err.message or err}"
                      onError.call(this,err)
              else
                onSuccess.call(this) if !--remaining
            else
                onError.call(this,err)
      else
        onSuccess.call(this) if !--remaining

module.exports = new ImageUtils()