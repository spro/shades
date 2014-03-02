polar = require 'polar'
fs = require 'fs'
styl = require 'styl'
variant = require 'rework-variant'
shade = require 'rework-shade'

LMAX = 100 # Maximum lightness, 0 - 255

randcolor = ->
    r = Math.floor Math.random()*LMAX
    g = Math.floor Math.random()*LMAX
    b = Math.floor Math.random()*LMAX
    return "rgb(#{ r }, #{ g }, #{ b })"

# Generate a random color and inject it into the stylesheet,
# replacing all instances of "$base" appearing in declarations.
colorize = (styles) ->
    color = randcolor()
    for rule in styles.rules
        for declaration in rule.declarations
            declaration.value = declaration.value.replace '$base', color

app = polar.setup_app
    port: 8585

app.get '/', (req, res) ->
    res.render 'index'

# Render the stylesheet as CSS by first parsing from SASS,
# then generating the base color, then applying rework-shade's
# color shifting functions to that base color.
app.get '/css/styles.css', (req, res) ->
    sass_src = fs.readFileSync('static/css/styles.sass').toString()
    res.end styl(sass_src, {whitespace: true})
        .use(colorize)
        .use(shade())
        .toString()

app.start()

