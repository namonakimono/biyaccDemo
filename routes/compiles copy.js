var fs = require('fs');
var sys = require('sys');
var exec = require('child_process').exec;
var config = require('../config');

exports.compile = function(req, res){
    console.log("compilation");
    var sourceDTD = req.query.sourceDTD;
    var targetDTD = req.query.targetDTD;
    var uQuery = req.query.uQuery;
    

    


    fs.writeFile("/tmp/s.dtd", sourceDTD, function(err){
      if(err){console.log("s.dtd err"); console.log(err);}
      else {
        console.log("s.dtd saved");
         fs.writeFile("/tmp/v.dtd", targetDTD, function(err){
           if(err){console.log(err);}
           else {
               console.log("v.dtd saved");
               fs.writeFile("/tmp/u.upd", uQuery, function(err){
               if(err){console.log(err);}
               else {
                   console.log("update query saved");
                   exec(config.biflux + " --sdtd=/tmp/s.dtd --vdtd=/tmp/v.dtd  --shs=/tmp/S.hs --vhs=/tmp/V.hs  --bx=/tmp/u.upd  --bxhs=/tmp/out.hs",
                    function(err){
                    if(err){console.log("generate out.hs failed");
                            //return the err information
                        res.contentType('json');
                        res.send({success: "falied", error : err.toString() });
                           }
                    else {
                        console.log("PutXML command finished.");
                        exec(config.ghc + " -i/tmp /tmp/out.hs", function(err, stdout, stderr){
                        if(err){console.log(err);
                            res.contentType('json');
                            res.send({resultXML : "", success: "failed", error : err.toString()  });
                               }
                        else {
                             console.log("/usr/local/bin/ghc out.hs finished.");
                            res.send({success: "success", error : "An executable file is successfully generated !" });
                        }
                        });//exec
                    }//else
                    }//function
                   );//exec
               }//else
               });//writeFle u.upd
           }//else
         });//writeFile v.dtd
    }//else
    });// writeFle s.dtd
}
