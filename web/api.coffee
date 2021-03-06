coffee   = require("coffee-script")
express  = require("express")
https    = require("https")
stylus   = require("stylus")
nib      = require("nib")
qs       = require("querystring")
url      = require("url")
util     = require("util")
moment   = require("moment")
marked   = require("../lib/marked").init()
ohiru    = require("../lib/ohiru").init()

app = express.createServer(
  express.logger()
  express.cookieParser()
  express.bodyParser()
  stylus.middleware(
    force: true
    compile: (str, path, fn) ->
      stylus(str).set("filename", path).set("compress", true).use(nib()).import("nib")
    src:  "#{__dirname}/../stylus"
    dest: "#{__dirname}/../public")
  express.static("#{__dirname}/../public"))

app.helpers
  params: (params) ->
    require("querystring").stringify(params)
  moment: moment
  marked: marked

app.get "/", (req, res) ->
  ohiru.getLunches((lunches)->
    if req.headers.accept and req.headers.accept.match("json")
      res.send(lunches)
    else
      res.render "lunches.jade", {lunches: lunches}
  )

app.get "/dash", (req, res) ->
  ohiru.getLunches((lunches)->
    res.render "dash.jade", {layout: false, lunches: lunches}
  )

app.get "/lunches.json", (req, res) ->
  ohiru.getLunches((lunches)->
    res.send(lunches)
  )

module.exports = app
