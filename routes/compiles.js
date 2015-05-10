var fs = require('fs');
var sys = require('sys');
var exec = require('child_process').exec;
var config = require('../config');

exports.compile = function(req, res){
  console.log("compilation");
  var concreteSyntax = req.query.concreteSyntax;
  var abstractSyntax = req.query.abstractSyntax;
  var actions = req.query.actions;
  var rdirectory = req.query.rdirectory;
  // console.log(abstractSyntax);
  // console.log(concreteSyntax);
  // console.log(actions);
  console.log("compile, random directory:");
  console.log(rdirectory);
  exec("mkdir /tmp/" + rdirectory,function(err){
    if (err){console.log(err); res.send({success: "failed", error : err.toString() });}
    else {
      fs.writeFile("/tmp/" + rdirectory + "/expr.by", abstractSyntax + "\n" + concreteSyntax + "\n" + actions, function(err){
        if(err){console.log(err); res.send({success: "failed", error : err.toString() })}
        else {
          console.log("biyacc file generated");
          exec(config.biyacc + " /tmp/" + rdirectory + "/expr.by /tmp/" + rdirectory + "/expr.upd", function(err){
            if(err){console.log(err); res.send({success: "failed", error : err.toString() });}
            else {
              console.log("BiFluX upd file generated");
              exec(config.BiFluX + " --sdtd=/tmp/" + rdirectory + "/concrete.dtd --vdtd=/tmp/" + rdirectory + "/abstract.dtd --shs=/tmp/" + rdirectory + "/Concrete.hs --vhs=/tmp/" + rdirectory + "/Abstract.hs  --bx=/tmp/" + rdirectory + "/expr.upd  --bxhs=/tmp/" + rdirectory + "/expr.hs", function(err){
                if(err){console.log("generating BiFluX executable failed"); console.log(err);
                  res.send({success: "failed", error : err.toString() })}
                else {
                  console.log("BiFluX hs file generated");
                  exec(config.ghc + " -i/tmp /tmp/" + rdirectory + "/expr.hs", function(err, stdout, stderr){
                    if(err) {console.log(err); res.contentType('json');
                      res.send({resultXML : "", success: "failed", error : err.toString() });}
                    else {
                      console.log("/usr/local/bin/ghc out.hs finished.");
                      res.send({success: "success", error : "An executable file is successfully generated !" });
                    }
                  });// exec(config.ghc ..)
                }//else
              });// end writeFle u.upd
            }
          });//exec(config.biyacc + " /tmp/" + rdirectory + "/expr.by...)
        }//else
      }); // end fs.writeFile("/tmp/" + rdirectory + "/expr.by...)
    }
  }) // end exec("mkdir /tmp/" + rdirectory ... )
}
