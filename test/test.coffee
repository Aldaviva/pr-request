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
  request('http://google.com/search', {qs: {q: "pr-request"}})
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
  request.head('https://httpbin.org/ip')
  .then((resp)->
    console.log("resp.body = #{resp.body}")
    throw new Error("HEAD shouldn't return body") if resp.body?
    console.log('request.head(uri): OK')
  ).fail((err)->
    console.log('request.head(uri): FAIL (' + err + ')')
  )

test_verb_post = ()->
  _data = "hello!"
  request.post('https://httpbin.org/post', {body: _data})
  .then((resp)->
    json_data = JSON.parse(resp.body)
    throw new Error("POST should contain body same as we gave it") if json_data.data != _data
    console.log('request.post(uri, options): OK')
  ).fail((err)->
    console.log('request.post(uri, options): FAIL (' + err + ')')
  )

test_verb_put = ()->
  _data = "PUT hello!"
  request.put('https://httpbin.org/put', {body: _data})
  .then((resp)->
    json_data = JSON.parse(resp.body)
    throw new Error("PUT should contain body same as we gave it") if json_data.data != _data
    console.log('request.put(uri, options): OK')
  ).fail((err)->
    console.log('request.put(uri, options): FAIL (' + err + ')')
  )

test_verb_delete = ()->
  _data = "DELETE me"
  request.del('https://httpbin.org/delete', {body: _data})
  .then((resp)->
    json_data = JSON.parse(resp.body)
    throw new Error("DELETE should contain body same as we gave it") if json_data.data != _data
    console.log('request.del(uri, options): OK')
  ).fail((err)->
    console.log('request.del(uri, options): FAIL (' + err + ')')
  )

Q.all(
  test_simple(),
  test_options(),
  test_verb_get(),
  test_verb_head(),
  test_verb_post(),
  test_verb_put(),
  test_verb_delete()
)
