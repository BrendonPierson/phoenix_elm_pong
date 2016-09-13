console.log("we are wired up!")

const Elm = require('../elm/Main.elm')
const mountNode = document.getElementById('main')

var app = Elm.Main.embed(mountNode)
