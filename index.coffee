Q = require 'q'
r = require 'request'

request = (uri)->
  deferred = Q.defer()
  req = r(uri, (err, res)->
      if err
        deferred.reject(err)
      else
        deferred.resolve(res)
  )
  return deferred.promise

# Export it
module.exports = request
