Q = require 'q'
r = require 'request'

request = (options)->
  deferred = Q.defer()
  req = r(options, (err, res)->
      if err
        deferred.reject(err)
      else
        deferred.resolve(res)
  )
  return deferred.promise
#
# Create simple wrapper that will handle the get/post/put methods
_create_method = (options, method)->
  params = r.initParams(options, null)
  params.options.method = method
  if typeof params.options?._requester == 'function'
    _request = params.options._requester
  else
    _request = request
  return _request(params.options)

# Handle the HTTP verbs
request.get = (options)-> _create_method(options, 'GET')
request.post = (options)-> _create_method(options, 'POST')
request.put = (options)-> _create_method(options, 'PUT')
request.patch = (options)-> _create_method(options, 'PATCH')
request.head = (options)->
  deferred = Q.defer()
  if typeof options?._requester == 'function'
    _request = options._requester
  else
    _request = r
  req = _request.head(options, (err, res)->
    if err
      deferred.reject(err)
    else
      deferred.resolve(res)
  )
  return deferred.promise
request.del = (options)-> _create_method(options, 'DELETE')

# Patch the other methods (they dont use promises) right through
request.initParams = r.initParams
request.jar = r.jar
request.cookie = r.cookie

request.defaults = (options={})->
  if typeof options._requester == 'function'
    requester = options._requester
  else
    requester = request

  def = (method)->
    (opt)->
      params = r.initParams(opt, null)
      for key, value of options
        if params.options[key] is undefined
          params.options[key] = value
      params.options._requester = requester
      return method(params.options)
  de = def(requester)
  for key in ['get', 'post', 'put', 'patch', 'head', 'del', 'cookie']
    de[key] = def(requester[key])
  de.jar = requester.jar
  de.defaults = (opt)->
    params = r.initParams(opt, null)
    for key, value of options
      if params.options[key] is undefined
        params.options[key] = value
    params.options._requester = requester
    return requester.defaults(params.options)
  return de

# Export it
module.exports = request
