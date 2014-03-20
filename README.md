pr-prequest2
============
promisified `request` module

**not yet stable or really tested. check back soon**

## usage

```javascript
var request = require('pr-request2');

request('http://www.google.com')
    .then(function(response) {
       console.log(response.body);
    });

request({ url: 'http://www.google.com' })
    .then(function(response) {
       console.log(response.body);
    });
```

## api

see [`request`](https://npm.im/request)'s docs.

Note, currently only the main `request` function is supported.

## see also

[`pr`](https://npm.im/pr) for promiseified node builtins

## installation

    $ npm install pr-request2

## tests

    $ npm test

## kudos and respect to

@mikeal and the rest of the `request` contributors

## contributors

* jden <jason@denizac.org>
* Ben Hutchison <ben@bluejeans.com>

## license

Public Domain.

<a rel="license"
   href="http://creativecommons.org/publicdomain/zero/1.0/">
  <img src="http://i.creativecommons.org/p/zero/1.0/88x31.png" style="border-style: none;" alt="CC0" />
</a>

To the extent possible under law, jason denizac has waived all copyright and related or neighboring rights to pr-request. This work is published from: United States.