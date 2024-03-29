const fs = require('fs');
const sys = require('util');
const exec = require('child_process').exec;
const platform = process.platform

exports.compile = function(req, res){
  // get --- req.query.xxx post --- req.body.xxx
  const program = req.body.program;
  const rdirectory = req.body.rdirectory;
  const langChoice = req.body.langChoice;

  exec("mkdir /tmp/" + rdirectory, function(err){
    if (err){console.log(err); console.log("folder exists. it does not matter. goes on.")}
    var byFile = "/tmp/" + rdirectory + "/testcase.txt";
    var byFileContent = program;

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
          exec(md5Command, function (error, stdout, stderr) {
            if (error) {
              console.error('exec error when checking md5 for biyacc file: ${error}');
              res.send({success: "fail", msg: err.toString()});
            }

            switch (langChoice) {
              case "expr":
                if (stdout == "9088ffa61b9db93eb63117c73723c84d\n") {
                  res.send({success: "success", msg: "unmodified example detected." +
                    "use previous generated executable file!", fileModified: false });
                  return;
                }

              case "tiger":
                if (stdout == "d57c635642f89370139a099a81d3bac2\n") {
                  res.send({success: "success", msg: "unmodified example detected." +
                    "use previous generated executable file!", fileModified: false });
                  return;
                }

              case "exprAmb":
                if (stdout == "df8fe490806fd2e01d5c139fc3c245a9\n") {
                  res.send({success: "success", msg: "unmodified example detected." +
                    "use previous generated executable file!", fileModified: false });
                  return;
                }

              case "tigerAmb":
                if (stdout == "20037ed4eb3178014a696e267e837d2d\n") {
                  res.send({success: "success", msg: "unmodified example detected." +
                    "use previous generated executable file!", fileModified: false });
                  return;
                }

              default: break;
            }

            console.log("2 fall back to generate new executable biyacc file");
            exec("biyacc /tmp/" + rdirectory + "/testcase.txt "    + "/tmp/" + rdirectory + "/testcase", function(err){
              if(err){console.log(err); res.send({success: "fail", msg: err.toString() });}
              else {
                console.log("executable generated");
                res.send({success: "success", msg: "an executable file is successfully generated !", fileModified: true });
              }
            }); //exec("biyacc /tmp/" + rdirectory + "/testcase.txt...)

          }) // exec
        } // if isPlatformSupported

        // (server) platform not supported
        else {
          exec("biyacc /tmp/" + rdirectory + "/testcase.txt "    + "/tmp/" + rdirectory + "/testcase", function(err){
            if(err){console.log(err); res.send({success: "fail", msg: err.toString() });}
            else {
              console.log("executable generated");
              res.send({success: "success", msg: "an executable file is successfully generated !" });
            }
          });//exec("biyacc /tmp/" + rdirectory + "/testcase.txt...)
        }

      }//else { console.log("biyacc file generated"); ...

    }); // end fs.writeFile("/tmp/" + rdirectory + "/testcase.txt...)
  }); // end exec("mkdir /tmp/" + rdirectory ... )
};
