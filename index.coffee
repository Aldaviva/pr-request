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

# Patch the other methods (they don't use promises) right through
request.initParams = r.initParams
request.jar = r.jar
request.cookie = r.cookie

request.defaults = (options)->
  def = (method)->
    (uri, opt)->
      params = r.initParams(uri, opt, null)
      for key in options
        if parms.options[key] is undefined
          parms.options[key] = options[key]
      return method(params.uri, params.options)
  de = def(request)
  for key in ['get', 'post', 'put', 'patch', 'head', 'del', 'cookie', 'defaults']
    de[key] = def(request[key])
  de.jar = request.jar
  return de

# Export it
module.exports = request
