request = require('../index')

request('http://google.com')
.then((resp)->
  console.log('Simple: Status code: ' + resp.statusCode)
).fail((err)->
  console.log(err)
  console.log('(request error)')
)
