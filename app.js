var fs = require('fs');
var express    = require('express');
var bodyParser = require("body-parser");
var routes = require('./routes');
var bx = require('./routes/bx');
var compiles = require('./routes/compiles');
var http = require('http');
var path = require('path');
var ejs = require('ejs');
var app = express();

// all environments
app.set('port', process.env.PORT || 8080);
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'html');
app.engine('html', ejs.renderFile);
app.use(express.favicon());
app.use(express.logger('dev'));
app.use(express.json());
app.use(express.urlencoded());
app.use(express.methodOverride());
app.use(app.router);
app.use(express.static(path.join(__dirname, 'public')));

//Here we are configuring express to use body-parser as middle-ware.
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

var errorLogFile = fs.createWriteStream('error.log', {flags: 'a'});

process.on('uncaughtException', function(err){
    var meta = 'process.on:[' + new Date() + ']\n';
    errorLogFile.write(meta + err.stack + '\n');
});


// development only
if ('development' == app.get('env')) {
  app.use(express.errorHandler());
}

app.get('/', routes.index);
app.post('/bx', bx.bx);
// app.get('/compile', compiles.compile);
app.post('/compile', compiles.compile);

http.createServer(app).listen(app.get('port'), function(){
  console.log('Express server listening on port ' + app.get('port'));
});
