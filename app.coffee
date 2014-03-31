ex = require 'express'
swig = require 'swig'

app = ex() #create server

app.use '/fonts', express.static __dirname+'/statics', {maxAge:2629740000}#static files
app.use '/stc', express.static __dirname+'/statics', {maxAge:2629740000} #static files

app.engine 'html', swig.renderFile #.html file extension for default
app.set 'view engine', 'html' #.html file extension for default

app.set 'views', __dirname #local directory for views

app.use express.compress() #allow express to handle gzip requests
app.use express.bodyParser() #allow POST/GET params and file posting
app.enable 'trust proxy'

