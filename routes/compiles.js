var fs = require('fs');
var sys = require('sys');
var exec = require('child_process').exec;
var config = require('../config');

exports.compile = function(req, res){
  console.log("compilation");
  var sourceDTD = req.query.sourceDTD;
  var targetDTD = req.query.targetDTD;
  var actions = req.query.actions;
  // console.log(targetDTD);
  // console.log(sourceDTD);
  // console.log(actions);

  fs.writeFile("/tmp/expr.by", targetDTD + "\n" + sourceDTD + "\n" + actions, function(err){
    if(err){console.log(err); res.send({success: "falied", error : err.toString() })}
    else {
      console.log("biyacc file generated");
      exec(config.biyacc + " /tmp/expr.by /tmp/expr.upd", function(err){
        if(err){console.log(err); res.send({success: "falied", error : err.toString() });}
        else {
          console.log("BiFluX upd file generated");
          exec(config.BiFluX + " --sdtd=/tmp/concrete.dtd --vdtd=/tmp/abstract.dtd --shs=/tmp/Concrete.hs --vhs=/tmp/Abstract.hs  --bx=/tmp/expr.upd  --bxhs=/tmp/expr.hs", function(err){
            if(err){console.log("generating BiFluX executable failed"); console.log(err);
              res.send({success: "falied", error : err.toString() })}
            else {
              console.log("BiFluX hs file generated");
              exec(config.ghc + " -i/tmp /tmp/expr.hs", function(err, stdout, stderr){
                if(err) {console.log(err); res.contentType('json');
                  res.send({resultXML : "", success: "falied", error : err.toString() });}
                else {
                  console.log("/usr/local/bin/ghc out.hs finished.");
                  res.send({success: "success", error : "An executable file is successfully generated !" });
                }
              });// exec(config.ghc ..)
            }//else
          });// end writeFle u.upd
        }
      });//exec(config.biyacc + " /tmp/expr.by...)

    }//else
  }); // end fs.writeFile("/tmp/expr.by...)
}
