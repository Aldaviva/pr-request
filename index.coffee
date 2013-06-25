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
  if typeof params.options?._requester == 'function'
    _request = params.options._requester
  else
    _request = request
  return _request(params.uri || null, params.options)

# Handle the HTTP verbs
request.get = (uri, options)-> _create_method(uri, options, 'GET')
request.post = (uri, options)-> _create_method(uri, options, 'POST')
request.put = (uri, options)-> _create_method(uri, options, 'PUT')
request.patch = (uri, options)-> _create_method(uri, options, 'PATCH')
request.head = (uri, options={})->
  deferred = Q.defer()
  if typeof options?._requester == 'function'
    _request = options._requester
  else
    _request = r
  req = _request.head(uri, options, (err, res)->
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

request.defaults = (options={})->
  if typeof options._requester == 'function'
    requester = options._requester
  else
    requester = request

  def = (method)->
    (uri, opt)->
      params = r.initParams(uri, opt, null)
      for key, value of options
        if params.options[key] is undefined
          params.options[key] = value
      params.options._requester = requester
      return method(params.uri, params.options)
  de = def(requester)
  for key in ['get', 'post', 'put', 'patch', 'head', 'del', 'cookie']
    de[key] = def(requester[key])
  de.jar = requester.jar
  de.defaults = (opt)->
    params = r.initParams(null, opt, null)
    for key, value of options
      if params.options[key] is undefined
        params.options[key] = value
    params.options._requester = requester
    return requester.defaults(params.options)
  return de

# Export it
module.exports = request
