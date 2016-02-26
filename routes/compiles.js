var fs = require('fs');
var sys = require('sys');
var exec = require('child_process').exec;
var config = require('../config');

exports.compile = function(req, res){
  var concreteSyntax = req.query.concreteSyntax;
  var abstractSyntax = req.query.abstractSyntax;
  var actions = req.query.actions;
  var rdirectory = req.query.rdirectory;
  // console.log("compile, random directory:");
  // console.log(rdirectory);
  exec("mkdir /tmp/" + rdirectory,function(err){
    if (err){console.log(err); console.log("folder exists. it does not matter. goes on.")}
    fs.writeFile("/tmp/" + rdirectory + "/expr.by", abstractSyntax + "\n" + concreteSyntax + "\n" + actions, function(err){
      if(err){console.log(err); res.send({success: "failed", error : err.toString() })}
      else {
        console.log("biyacc file generated");
        exec(config.biyacc + " /tmp/" + rdirectory + "/expr.by "    + "/tmp/" + rdirectory + "/expr", function(err){
          if(err){console.log(err); res.send({success: "failed", error : err.toString() });}
          else {
            console.log("executable generated");
            res.send({success: "success", error : "An executable file is successfully generated !" });
          }
        });//exec(config.biyacc + " /tmp/" + rdirectory + "/expr.by...)
      }//else
    }); // end fs.writeFile("/tmp/" + rdirectory + "/expr.by...)
  }) // end exec("mkdir /tmp/" + rdirectory ... )
}
