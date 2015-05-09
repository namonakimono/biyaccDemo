var fs = require('fs');
var sys = require('sys');
var exec = require('child_process').exec;
var config = require('../config');

exports.bx = function (req, res){
  var sourceString = req.query.sourceString;
  var targetXML = req.query.targetXML;
  var flag = req.query.flag;
  // console.log("here source string:");
  // console.log(sourceString);
  fs.writeFile("/tmp/cstring.txt", sourceString, function(err){
    if(err){console.log("writing cstring, error occured"); console.log(err);}
    else {
      console.log("cstring.txt saved");
      // console.log('Current directory: ' + process.cwd());
      exec("./exe/ExprPPP -p /tmp/cstring.txt /tmp/concrete.xml",
      function(err){
        if(err){console.log(err);}
        else {
          console.log("concrete.xml generated");
            if(err){console.log("generating concrete xml failed"); console.log(err);}
            else {

              if(flag == "f") { // forward transformation
                exec("/tmp/expr -f -s /tmp/concrete.xml -o /tmp/abstract.xml", {timeout:60000},function(err){
                  if(err){
                    console.log("error 01"); console.log(err); res.contentType('json');
                    res.send({resultXML: "", success: "failed", error: err.toString() });
                  }
                  else {
                    console.log("successfully generated abstract.xml file")
                    exec("./exe/ASTPPP -pp /tmp/abstract.xml /tmp/ast.txt",
                    function(err){
                      if(err){
                       console.log("error saving AST string file"); console.log(err); res.contentType('json');
                       res.send({resultXML: "", success: "failed", error: err.toString() });
                      }
                      else {
                        console.log("successfully generated ast.txt file");
                        fs.readFile("/tmp/ast.txt", 'utf-8', function(err, data){
                          if(err){
                             console.log("error reading result ast.txt file"); console.log(err); res.contentType('json');
                             res.send({resultXML: "", success: "failed", error: err.toString() });
                          }
                          else {
                            console.log("send updated source to client"); res.contentType('json');
                            res.send({resultXML: data, success: "success", error: "Forward transformation successfully done!\n" });
                          }
                        });//end fs.readFile("/tmp/abstract.xml"...)
                      }
                    }) // end exec("./exe/ASTPPP -pp ...)
                  }// end else
                }); // end exec("/tmp/expr -f -s /tmp/concrete.xml ...)
              }// end (if flag == "f")

              else {
                if (flag == "b"){//backward transformation
                  fs.writeFile("/tmp/ast.txt", targetXML, function(err){
                    if(err){console.log("error in writing ast.txt, in a backward transformation")}
                    else {
                      exec("./exe/ASTPPP -p /tmp/ast.txt /tmp/abstract.xml", function(err){
                        if(err){console.log("error in writing abstract.xml, in a backward transformation")}
                        else{
                          exec("/tmp/expr -b -s /tmp/concrete.xml -t /tmp/abstract.xml -o /tmp/concrete.xml",{timeout:60000}, function(err){
                            if(err){
                              console.log("error 02"); console.log(err); res.contentType('json');
                              res.send({resultXML: "", success: "falied", error: err.toString() });
                            }
                            else {
                              console.log("successfully generated result target xml file(concrete.xml)");
                              exec("./exe/ExprPPP -pp /tmp/concrete.xml /tmp/cstring.txt", function(err){
                                if(err){
                                  console.log("error 03"); console.log(err); res.contentType('json');
                                  res.send({resultXML: "", success: "falied", error: err.toString() });
                                }
                                else {
                                  fs.readFile("/tmp/cstring.txt", 'utf-8', function(err, data){
                                    if(err){
                                       console.log("error reading result string file"); console.log(err); res.contentType('json');
                                       res.send({resultXML: "", success: "falied", error: err.toString() });
                                    }
                                    else {
                                      console.log("send updated source to client"); res.contentType('json');
                                      res.send({resultXML: data, success: "success", error: "Backward transformation successfully done!\n" });
                                    }
                                  });//end fs.readFile("/tmp/abstract.xml"...)
                                }
                              });// end exec("/exe/ExprPPP -pp /tmp ...)
                            }// end else
                          }); // end exec("/tmp/expr -b -s /tmp/concrete.xml ...)
                        }
                      }) // end exec("./exe/ASTPPP -p /tmp/ast.txt  ...)
                    } // end else
                  }) // end fs.writeFile("/tmp/ast.txt", targetXML,...)
                }// end if flag == "b"
                else {console.log("error flag, must me forward or backword transformation");}
              }
            }
        }// end else
      });// end exec(ExprPPP -p ...)
    }// end else
  });// end fs.writeFile("/tmp/cstring.txt", sourceString, function(err){...})
}// end exports.bx = function (req, res){...}
