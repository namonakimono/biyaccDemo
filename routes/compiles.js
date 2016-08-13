const fs = require('fs');
const sys = require('sys');
const exec = require('child_process').exec;
const config = require('../config');
const platform = process.platform

exports.compile = function(req, res){
  // get --- req.query.xxx post --- req.body.xxx
  const concreteSyntax = req.body.concreteSyntax;
  const abstractSyntax = req.body.abstractSyntax;
  const actions = req.body.actions;
  const rdirectory = req.body.rdirectory;
  const langChoice = req.body.langChoice;

  exec("mkdir /tmp/" + rdirectory, function(err){
    if (err){console.log(err); console.log("folder exists. it does not matter. goes on.")}
    var byFile = "/tmp/" + rdirectory + "/testcase.by";
    var byFileContent = abstractSyntax + concreteSyntax + actions;

    fs.writeFile(byFile, byFileContent, function(err){
      if(err){console.log(err); res.send({success: "fail", msg: err.toString() })}
      else {
        var md5Command = "";
        var isPlatformSupported = false;
        if (platform == "darwin") {
          md5Command = 'md5 -q' + " " + byFile;
          isPlatformSupported = true;
        } else
        if (platform == "linux") {
          md5Command = "md5sum" + " " + byFile + " | awk '{print $1}'";
          isPlatformSupported = true;
        } else {
          console.log("(on server) service for other system not implemented!!!" +
            "1 fall back to generate new executable biyacc file");
          isPlatformSupported = false;
        }

        if (isPlatformSupported) {
	  console.log("CHECKOUT1");
          exec(md5Command, function (error, stdout, stderr) {
            if (error) {
              console.error('exec error when checking md5 for biyacc file: ${error}');
              res.send({success: "fail", msg: err.toString()});
            }
            switch (langChoice) {
              case "arithExpr":
	        console.log(stdout);
	        console.log(stdout == "049125af86b481184035ff33a6ea5ea0\n");
                if (stdout == "049125af86b481184035ff33a6ea5ea0\n") {
                  res.send({success: "success", msg: "unmodified arithExpr example detected." +
                    "use previous generated executable file!", fileModified: false });
                  return;
                }
              case "tigerAmbi":
                if (stdout == "a8d0ebf4e638521099bd2a732d7d7ca8\n") {
                  res.send({success: "success", msg: "unmodified tigerAmbiguous example detected." +
                    "use previous generated executable file!", fileModified: false });
                  return;
                }
              case "tigerUnambi":
                if (stdout == "d16f3c2c75dab8a190a71bd5513fb341\n") {
                  res.send({success: "success", msg: "unmodified tigerUnambiguous example detected." +
                    "use previous generated executable file!", fileModified: false });
                  return;
                }
              default: break;
            }

            console.log("2 fall back to generate new executable biyacc file");
            exec(config.biyacc + " /tmp/" + rdirectory + "/testcase.by "    + "/tmp/" + rdirectory + "/testcase", function(err){
              if(err){console.log(err); res.send({success: "fail", msg: err.toString() });}
              else {
                console.log("executable generated");
                res.send({success: "success", msg: "an executable file is successfully generated !", fileModified: true });
              }
            });//exec(config.biyacc + " /tmp/" + rdirectory + "/testcase.by...)

          }) // exec
        } // if isPlatformSupported

        // (server) platform not supported
        else {
          exec(config.biyacc + " /tmp/" + rdirectory + "/testcase.by "    + "/tmp/" + rdirectory + "/testcase", function(err){
            if(err){console.log(err); res.send({success: "fail", msg: err.toString() });}
            else {
              console.log("executable generated");
              res.send({success: "success", msg: "an executable file is successfully generated !" });
            }
          });//exec(config.biyacc + " /tmp/" + rdirectory + "/testcase.by...)
        }

      }//else { console.log("biyacc file generated"); ...

    }); // end fs.writeFile("/tmp/" + rdirectory + "/testcase.by...)
  }); // end exec("mkdir /tmp/" + rdirectory ... )
};
