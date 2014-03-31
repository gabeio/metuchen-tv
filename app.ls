#!/usr/bin/env livescript
#internal
fs = require \fs

#external
ex = require \express
swig = require \swig
yaml = require \js-yaml
mo = require \moment
argv = require(\yargs).argv

app = ex() #create server

switch process.env.NODE_ENV
  when 'production'
    console.log 'running production mode'
  else
    console.log 'running development mode'
    console.log 'cache set to off'
    app.set 'view cache', false
    swig.setDefaults {cache:false}

app.use \/fonts ex.static __dirname+\/statics maxAge:2629740000 #static files
app.use \/stc ex.static __dirname+\/statics maxAge:2629740000 #static files

app.engine \html swig.renderFile #.html file extension for default
app.set 'view engine' \html #.html file extension for default

app.set \views __dirname #local directory for views

app.use ex.compress() #allow ex to handle gzip requests
app.use ex.bodyParser() #allow POST/GET params and file posting
app.enable 'trust proxy'

cap=->
    it.charAt(0).toUpperCase() + it.toLowerCase().slice 1

app.all \/ (req,res)->
    schedule = yaml.safeLoad fs.readFileSync \schedule.yaml \utf-8
    console.log \schedule schedule
    surfaces = {}
    for a,b of schedule # go through this week's data
        if mo().format(\M/DD/YYYY) is a # if the start of today a
            for e,f of b # go through everything for today
                for c,d of f # list
                    if mo().startOf(\hour).format('h:mm a') is mo(a+' '+c).format('h:mm a') # if the start of this hour is b
                        surfaces[d.area.toLowerCase().replace(/ /g,'')] = d.title
                    if mo().startOf(\hour).format('h:30 a') is mo(a+' '+c).format('h:mm a') # if the start of the hour +30 is the time of the rental
                        surfaces[d.area.toLowerCase().replace(/ /g,'')] = d.title
    console.log \surfaces surfaces
    res.render \app surfaces:surfaces

if argv.http
    console.log \argv.http argv.http
    app.listen argv.http