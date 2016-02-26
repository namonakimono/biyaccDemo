var fs = require('fs');
var sys = require('sys');
var exec = require('child_process').exec;
var config = require('../config');

exports.bx = function (req, res){
  var rdirectory = req.query.rdirectory;
  var sourceString = req.query.sourceString;
  var targetXML = req.query.targetXML;
  var flag = req.query.flag;
  // console.log("bx trans, random directory:");
  // console.log(rdirectory);

  fs.writeFile("/tmp/" + rdirectory + "/code.txt", sourceString, function(err){
    if(err){console.log("generating code.txt failed"); console.log(err);}
    else {
      var prefixDir = "/tmp/" + rdirectory + "/";

      if(flag == "f") { // forward transformation
        exec(prefixDir + "expr get "    + prefixDir + "code.txt "   + prefixDir + "AST.txt", {timeout:10000}, function(err){
          if(err){
            res.contentType('json');
            res.send({resultXML: "", success: "failed", error: err.toString() });
          }
          else {
            fs.readFile(prefixDir + "AST.txt", 'utf-8', function(err, data){
              if(err){
                 res.contentType('json');
                 res.send({resultXML: "", success: "failed", error: err.toString() });
              }
              else {
                res.contentType('json');
                res.send({resultXML: data, success: "success", error: "Forward transformation successfully done\n" });
              }
            });//end fs.readFile
          }
        }); // end exec prefixDir
      }// end (if flag == "f")

      //backward transformation
      else if (flag == "b") {
        fs.writeFile(prefixDir + "/AST.txt", targetXML, function(err){
          if(err){console.log("error in writing AST.txt, in a backward transformation")}
          else {
            exec(prefixDir + "expr put "    + prefixDir + "code.txt "   + prefixDir + "AST.txt", {timeout:10000}, function(err){
              if(err){
                res.contentType('json');
                res.send({resultXML: "", success: "falied", error: err.toString() });
              }
              else {
                fs.readFile(prefixDir + "code.txt", 'utf-8', function(err, data){
                  if(err){
                     res.contentType('json');
                     res.send({resultXML: "", success: "falied", error: err.toString() });
                  }
                  else {
                    res.contentType('json');
                    res.send({resultXML: data, success: "success", error: "Backward transformation successfully done\n" });
                  }
                }); //end fs.readFile
              }// end else
            }); // end exec
          } // end else
        }); // end fs.writeFile
      }// end if flag == "b"
      else {console.log("error flag, must me forward or backword transformation");}
    } // end else ...
  });// end fs.writeFile
};// end exports.bx = function (req, res){...}
