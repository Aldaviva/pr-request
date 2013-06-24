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

Q.all(
  test_simple(),
  test_options()
)
