var fs = require('fs');
var sys = require('sys');
var exec = require('child_process').exec;
var config = require('../config');

exports.bx = function (req, res){
  var rdirectory = req.query.rdirectory;
  var sourceString = req.query.sourceString;
  var targetXML = req.query.targetXML;
  var flag = req.query.flag;
  // console.log("here source string:");
  // console.log(sourceString);
  console.log("bx trans, random directory:");
  console.log(rdirectory);
  fs.writeFile("/tmp/" + rdirectory + "/cstring.txt", sourceString, function(err){
    if(err){console.log("writing cstring, error occured"); console.log(err);}
    else {
      console.log("cstring.txt saved");
      // console.log('Current directory: ' + process.cwd());
      exec("./exe/ExprPPP -p /tmp/" + rdirectory + "/cstring.txt /tmp/" + rdirectory + "/concrete.xml",
      function(err){
        if(err){console.log("error when parse concrete xml to string."); console.log(err); res.contentType('json');
                res.send({resultXML: "", success: "falied", error: err.toString() });}
        else {
          console.log("concrete.xml generated");
            if(err){console.log("generating concrete xml failed"); console.log(err);}
            else {

              if(flag == "f") { // forward transformation
                exec("/tmp/" + rdirectory + "/expr -f -s /tmp/" + rdirectory + "/concrete.xml -o /tmp/" + rdirectory + "/abstract.xml", {timeout:60000},function(err){
                  if(err){
                    console.log("error 01"); console.log(err); res.contentType('json');
                    res.send({resultXML: "", success: "failed", error: err.toString() });
                  }
                  else {
                    console.log("successfully generated abstract.xml file")
                    exec("./exe/ASTPPP -pp /tmp/" + rdirectory + "/abstract.xml /tmp/" + rdirectory + "/ast.txt",
                    function(err){
                      if(err){
                       console.log("error saving AST file"); console.log(err); res.contentType('json');
                       res.send({resultXML: "", success: "failed", error: err.toString() });
                      }
                      else {
                        console.log("successfully generated ast.txt file");
                        fs.readFile("/tmp/" + rdirectory + "/ast.txt", 'utf-8', function(err, data){
                          if(err){
                             console.log("error reading result ast.txt file"); console.log(err); res.contentType('json');
                             res.send({resultXML: "", success: "failed", error: err.toString() });
                          }
                          else {
                            console.log("send updated source to client"); res.contentType('json');
                            res.send({resultXML: data, success: "success", error: "Forward transformation successfully done\n" });
                          }
                        });//end fs.readFile("/tmp/" + rdirectory + "/abstract.xml"...)
                      }
                    }) // end exec("./exe/ASTPPP -pp ...)
                  }// end else
                }); // end exec("/tmp/" + rdirectory + "/expr -f -s /tmp/" + rdirectory + "/concrete.xml ...)
              }// end (if flag == "f")

              else {
                if (flag == "b"){//backward transformation
                  fs.writeFile("/tmp/" + rdirectory + "/ast.txt", targetXML, function(err){
                    if(err){console.log("error in writing ast.txt, in a backward transformation")}
                    else {
                      exec("./exe/ASTPPP -p /tmp/" + rdirectory + "/ast.txt /tmp/" + rdirectory + "/abstract.xml", function(err){
                        if(err){
                         console.log("error when parsing AST to abstract xml file"); console.log(err); res.contentType('json');
                         res.send({resultXML: "", success: "failed", error: err.toString() });}
                        else{
                          exec("/tmp/" + rdirectory + "/expr -b -s /tmp/" + rdirectory + "/concrete.xml -t /tmp/" + rdirectory + "/abstract.xml -o /tmp/" + rdirectory + "/concrete.xml",{timeout:60000}, function(err){
                            if(err){
                              console.log("error 02"); console.log(err); res.contentType('json');
                              res.send({resultXML: "", success: "falied", error: err.toString() });
                            }
                            else {
                              console.log("successfully generated result target xml file(concrete.xml)");
                              exec("./exe/ExprPPP -pp /tmp/" + rdirectory + "/concrete.xml /tmp/" + rdirectory + "/cstring.txt", function(err){
                                if(err){
                                  console.log("error when parsing concrete xml to string."); console.log(err); res.contentType('json');
                                  res.send({resultXML: "", success: "falied", error: err.toString() });
                                }
                                else {
                                  fs.readFile("/tmp/" + rdirectory + "/cstring.txt", 'utf-8', function(err, data){
                                    if(err){
                                       console.log("error reading result string file"); console.log(err); res.contentType('json');
                                       res.send({resultXML: "", success: "falied", error: err.toString() });
                                    }
                                    else {
                                      console.log("send updated source to client"); res.contentType('json');
                                      res.send({resultXML: data, success: "success", error: "Backward transformation successfully done\n" });
                                    }
                                  });//end fs.readFile("/tmp/" + rdirectory + "/abstract.xml"...)
                                }
                              });// end exec("/exe/ExprPPP -pp /tmp ...)
                            }// end else
                          }); // end exec("/tmp/" + rdirectory + "/expr -b -s /tmp/" + rdirectory + "/concrete.xml ...)
                        }
                      }) // end exec("./exe/ASTPPP -p /tmp/" + rdirectory + "/ast.txt  ...)
                    } // end else
                  }) // end fs.writeFile("/tmp/" + rdirectory + "/ast.txt", targetXML,...)
                }// end if flag == "b"
                else {console.log("error flag, must me forward or backword transformation");}
              }
            }
        }// end else
      });// end exec(ExprPPP -p ...)
    }// end else
  });// end fs.writeFile("/tmp/" + rdirectory + "/cstring.txt", sourceString, function(err){...})
}// end exports.bx = function (req, res){...}
