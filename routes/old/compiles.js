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
                if (stdout == "e2363f93ac2fb2c8229dac94c4fc1846\n") {
                  res.send({success: "success", msg: "Unmodified example detected." +
                    "Use previous generated executable file!", fileModified: false });
                  return;
                }

              case "tigerUnambi":
                if (stdout == "fb7d39950748a5537070904bfc5f3d00\n") {
                  res.send({success: "success", msg: "Unmodified example detected." +
                    "Use previous generated executable file!", fileModified: false });
                  return;
                }

              case "exprKleene":
                if (stdout == "2ec2f6a18884370fe96eb98c587bf1bb\n") {
                  res.send({success: "success", msg: "Unmodified example detected." +
                    "Use previous generated executable file!", fileModified: false });
                  return;
                }

              case "exprNonlinear":
                if (stdout == "37447ae0467b61f5b10d75d1308dbe57\n") {
                  res.send({success: "success", msg: "Unmodified example detected." +
                    "Use previous generated executable file!", fileModified: false });
                  return;
                }

              case "exprAdapt":
                if (stdout == "5c6454d0c78ca422238e986dd100ff3f\n") {
                  res.send({success: "success", msg: "Unmodified example detected." +
                    "Use previous generated executable file!", fileModified: false });
                  return;
                }

              case "exprAmbi":
                if (stdout == "52f44656213aa326c73b653b2c1f7784\n") {
                  res.send({success: "success", msg: "Unmodified example detected." +
                    "Use previous generated executable file!", fileModified: false });
                  return;
                }

              // case "tigerUnambiKleene":
              //   if (stdout == "82822f4c4ae9651c9b61994260050d41\n") {
              //     res.send({success: "success", msg: "Unmodified example detected." +
              //       "Use previous generated executable file!", fileModified: false });
              //     return;
              //   }

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
