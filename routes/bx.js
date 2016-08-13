const fs = require('fs');
const sys = require('sys');
const exec = require('child_process').exec;
const config = require('../config');

exports.bx = function (req, res){
  const rdirectory = req.body.rdirectory;
  const sourceString = req.body.sourceString;
  const targetXML = req.body.targetXML;
  const flag = req.body.flag;
  // fileModified is automatically converted to String type and need jason.parse! it is should be a BUG!!!
  const fileModified = JSON.parse(req.body.fileModified);
  const langChoice = req.body.langChoice;

  fs.writeFile("/tmp/" + rdirectory + "/code.txt", sourceString, function(err){
    if(err){console.log("generating code.txt failed"); console.log(err);}
    else {
      const prefixDir = "/tmp/" + rdirectory + "/";
      const inOptFile = prefixDir + "code.txt" + " " + prefixDir + "AST.txt"
      var bxCommand = "";

      // set execution command
      if(flag == "f") {
        switch (langChoice) {
          case "arithExpr":
            bxCommand = fileModified ? prefixDir + "testcase get" + " " + inOptFile
                                     : "ByExExpr get" + " " + inOptFile;
            break;
          case "tigerUnambi":
            bxCommand = fileModified ? prefixDir + "testcase get" + " " + inOptFile
                                     : "ByExTigerUnambi get" + " " + inOptFile;
            break;
          case "tigerAmbi":
            bxCommand = fileModified ? prefixDir + "testcase get" + " " + inOptFile
                                     : "ByExTigerAmbi get" + " " + inOptFile;
            break;
          default:
            res.send({resultXML: "", success: "fail", msg: "panic. unexpected language example flag" });
            return;
        }
      }
      else if (flag == "b") {
        switch (langChoice) {
          case "arithExpr":
            bxCommand = fileModified ? prefixDir + "testcase put" + " " + inOptFile
                                     : "ByExExpr put" + " " + inOptFile;
            break;
          case "tigerUnambi":
            bxCommand = fileModified ? prefixDir + "testcase put" + " " + inOptFile
                                     : "ByExTigerUnambi put" + " " + inOptFile;
            break;
          case "tigerAmbi":
            bxCommand = fileModified ? prefixDir + "testcase put" + " " + inOptFile
                                     : "ByExTigerAmbi put" + " " + inOptFile;
            break;
          default:
            res.send({resultXML: "", success: "fail", msg: "panic. unexpected language example flag" });
            return;
        }
      }
      else {
        res.send({resultXML: "", success: "fail", msg: "panic. unexpected transformation direction flag" });
        return;
      }
      // ends for set execution command

      if(flag == "f") { // forward transformation
        exec(bxCommand, {timeout:10000}, function(err){
          if(err){
            res.contentType('json');
            res.send({resultXML: "", success: "fail", msg: err.toString() });
            return;
          } else {
            fs.readFile(prefixDir + "AST.txt", 'utf-8', function(err, data){
              if(err){
                 res.contentType('json');
                 res.send({resultXML: "", success: "fail", msg: err.toString() });
                 return;
              }
              else {
                res.contentType('json');
                res.send({resultXML: data, success: "success", msg: "Forward transformation successfully done\n" });
                return;
              }
            });//end fs.readFile
          }
        }); // end exec prefixDir
      }// end (if flag == "f")

      //backward transformation
      else if (flag == "b") {
        fs.writeFile(prefixDir + "AST.txt", targetXML, function(err){
          if(err){console.log("error in writing AST.txt, in a backward transformation")}
          else {
            exec(bxCommand, {timeout:10000}, function(err){
              if(err){
                res.contentType('json');
                res.send({resultXML: "", success: "fail", msg: err.toString() });
                return;
              }
              else {
                fs.readFile(prefixDir + "code.txt", 'utf-8', function(err, data){
                  if(err){
                     res.contentType('json');
                     res.send({resultXML: "", success: "fail", msg: err.toString() });
                     return;
                  }
                  else {
                    res.contentType('json');
                    res.send({resultXML: data, success: "success", msg: "Backward transformation successfully done\n" });
                    return;
                  }
                }); //end fs.readFile
              }// end else
            }); // end exec
          } // end else
        }); // end fs.writeFile
      }// end if flag == "b"
      else {
        res.send({resultXML: "", success: "fail", msg: "panic. unexpected transformation direction flag" });
        return;
      }
    } // end else ...
  });// end fs.writeFile
};// end exports.bx = function (req, res){...}
