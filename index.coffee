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
#
# Create simple wrapper that will handle the get/post/put methods
_create_method = (uri, options={}, method)->
  params = r.initParams(uri, options, null)
  params.options.method = method
  return request(params.uri || null, params.options)

# Handle the HTTP verbs
request.get = (uri, options)-> _create_method(uri, options, 'GET')
request.post = (uri, options)-> _create_method(uri, options, 'POST')
request.put = (uri, options)-> _create_method(uri, options, 'PUT')
request.patch = (uri, options)-> _create_method(uri, options, 'PATCH')
request.head = (uri, options={})->
  deferred = Q.defer()
  req = r.head(uri, options, (err, res)->
    if err
      deferred.reject(err)
    else
      deferred.resolve(res)
  )
  return deferred.promise
request.del = (uri, options)-> _create_method(uri, options, 'DELETE')

# Export it
module.exports = request
