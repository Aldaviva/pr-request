Q = require('q')
request = require('../index')

test_simple = ()->
  request('http://google.com')
  .then((resp)->
    console.log('request(uri): OK')
  ).fail((err)->
    console.log('request(uri): FAIL (' + err + ')')
  )

test_options = ()->
  request({url: 'http://google.com/search', qs: {q: "pr-request"}})
  .then((resp)->
    if resp.body.indexOf('pr-request') == -1
      throw new Error('"pr-request" not found on page')
    console.log('request(uri, options): OK')
  ).fail((err)->
    console.log('request(uri, options): FAIL (' + err + ')')
  )

test_verb_get = ()->
  request.get('http://google.com')
  .then((resp)->
    console.log('request.get(uri): OK')
  ).fail((err)->
    console.log('request.get(uri): FAIL (' + err + ')')
  )

test_verb_head = ()->
  request.head('https://httpbin.org/get')
  .then((resp)->
    if resp.body.length
      console.log("resp.body.length =", resp.body.length)
      console.log("resp.body =", resp.body)
      throw new Error("HEAD shouldn't return body")
    console.log('request.head(uri): OK')
  ).fail((err)->
    console.log('request.head(uri): FAIL (' + err + ')')
  )

test_verb_post = ()->
  _data = "hello!"
  request.post({ url: 'https://httpbin.org/post', body: _data})
  .then((resp)->
    json_data = JSON.parse(resp.body)
    throw new Error("POST should contain body same as we gave it") if json_data.data != _data
    console.log('request.post(uri, options): OK')
  ).fail((err)->
    console.log('request.post(uri, options): FAIL (' + err + ')')
  )

test_verb_put = ()->
  _data = "PUT hello!"
  request.put({ url: 'https://httpbin.org/put', body: _data})
  .then((resp)->
    json_data = JSON.parse(resp.body)
    throw new Error("PUT should contain body same as we gave it") if json_data.data != _data
    console.log('request.put(uri, options): OK')
  ).fail((err)->
    console.log('request.put(uri, options): FAIL (' + err + ')')
  )

test_verb_delete = ()->
  _data = "DELETE me"
  request.del({ url: 'https://httpbin.org/delete', body: _data})
  .then((resp)->
    json_data = JSON.parse(resp.body)
    throw new Error("DELETE should contain body same as we gave it") if json_data.data != _data
    console.log('request.del(uri, options): OK')
  ).fail((err)->
    console.log('request.del(uri, options): FAIL (' + err + ')')
  )

test_cookie_jar = ()->
  request = request.defaults({jar: request.jar()})
  request({ url: 'https://httpbin.org/cookies/set', qs: {foo: "bar"}})
  .then((resp)->
    json_data = JSON.parse(resp.body)
    throw new Error('COOKIE "foo" not stored') if json_data.cookies.foo != "bar"
    request('https://httpbin.org/cookies')
  )
  .then((resp)->
    json_data = JSON.parse(resp.body)
    throw new Error("COOKIE isn't stored, while it should have been.") if json_data.cookies.foo != "bar"
    console.log('request(uri, {jar: …}): OK')
  ).fail((err)->
    console.log('request(uri, {jar: …}): FAIL (' + err + ')')
  )

test_chaining = ()->
  r = request.defaults({headers: {"X-Request": "knock, knock"}})
  r = r.defaults({qs: {who: "is there"}})
  r.get('https://httpbin.org/get')
  .then((resp)->
    json_data = JSON.parse(resp.body)
    throw new Error("Header wasn't passed.") if json_data.headers['X-Request'] != 'knock, knock'
    throw new Error("QS wasn't passed.") if json_data.args.who != 'is there'
    console.log('request.defaults().defaults().get(uri): OK')
  ).fail((err)->
    console.log('request.defaults().defaults().get(uri): FAIL (' + err + ')')
  )


Q.all(
  test_simple(),
  test_options(),
  test_verb_get(),
  test_verb_head(),
  test_verb_post(),
  test_verb_put(),
  test_verb_delete(),
  test_cookie_jar(),
  test_chaining()
)
