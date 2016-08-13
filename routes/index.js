
/*
 * GET home page.
 */
// var fs = require('fs');

exports.index = function(req, res){

  res.render("index.html");
  // var ip = req.connection.remoteAddress || (req.headers['x-forwarded-for'] || '').split(',')[0];
  // console.log(ip);
  // var str = "date: " + new Date() + "    ip: " + ip + "\n";
  // fs.appendFile("access.log", str, function(err, result){});

};
