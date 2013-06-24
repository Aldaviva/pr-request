Q = require 'q'
r = require 'request'

request = (uri, options={})->
  deferred = Q.defer()
  req = r(uri, options, (err, res)->
      if err
        deferred.reject(err)
      else
        deferred.resolve(res)
  )
  return deferred.promise

# Export it
module.exports = request
