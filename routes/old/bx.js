const fs = require('fs');
const sys = require('util');
const exec = require('child_process').exec;

exports.bx = function (req, res){
  const rdirectory = req.body.rdirectory;
  const source = req.body.source;
  const view = req.body.view;
  const flag = req.body.flag;
  // fileModified is automatically converted to String type and need jason.parse! it is should be a BUG!!!
  const fileModified = JSON.parse(req.body.fileModified);
  const langChoice = req.body.langChoice;

  fs.writeFile("/tmp/" + rdirectory + "/code.txt", source, function(err){
    if(err){console.log("generating code.txt failed"); console.log(err);}
    else {
      const prefixDir = "/tmp/" + rdirectory + "/";
      const inOptFile = prefixDir + "code.txt" + " " + prefixDir + "AST.txt"
      var bxCommand = "";

      // set execution command
      if(flag == "f") {
        switch (langChoice) {
          case "expr":
            bxCommand = fileModified ? prefixDir + "testcase get" + " " + inOptFile
                                     : "ByExpr get" + " " + inOptFile;
            break;

          case "tigerUnambi":
            bxCommand = fileModified ? prefixDir + "testcase get" + " " + inOptFile
                                     : "ByTigerUnambi get" + " " + inOptFile;
            break;

          case "exprKleene":
            bxCommand = fileModified ? prefixDir + "testcase get" + " " + inOptFile
                                     : "ByExprKleene get" + " " + inOptFile;
            break;

          case "exprNonlinear":
            bxCommand = fileModified ? prefixDir + "testcase get" + " " + inOptFile
                                     : "ByExprNonlinear get" + " " + inOptFile;
            break;

          case "exprAdapt":
            bxCommand = fileModified ? prefixDir + "testcase get" + " " + inOptFile
                                     : "ByExprAdapt get" + " " + inOptFile;
            break;

          case "exprAmbi":
            bxCommand = fileModified ? prefixDir + "testcase get" + " " + inOptFile
                                     : "ByExprAmbi get" + " " + inOptFile;
            break;

          case "tigerUnambiKleene":
            bxCommand = fileModified ? prefixDir + "testcase get" + " " + inOptFile
                                     : "ByTigerUnambiKleene get" + " " + inOptFile;
            break;

          default:
            res.send({resultXML: "", success: "fail", msg: "panic. unexpected language example flag" });
            return;
        }
      }
      else if (flag == "b") {
        switch (langChoice) {
          case "expr":
            bxCommand = fileModified ? prefixDir + "testcase put" + " " + inOptFile
                                     : "ByExpr put" + " " + inOptFile;
            break;

          case "tigerUnambi":
            bxCommand = fileModified ? prefixDir + "testcase put" + " " + inOptFile
                                     : "ByTigerUnambi put" + " " + inOptFile;
            break;

          case "exprKleene":
            bxCommand = fileModified ? prefixDir + "testcase put" + " " + inOptFile
                                     : "ByExprKleene put" + " " + inOptFile;
            break;

          case "exprNonlinear":
            bxCommand = fileModified ? prefixDir + "testcase put" + " " + inOptFile
                                     : "ByExprNonlinear put" + " " + inOptFile;
            break;

          case "exprAdapt":
            bxCommand = fileModified ? prefixDir + "testcase put" + " " + inOptFile
                                     : "ByExprAdapt put" + " " + inOptFile;
            break;

          case "exprAmbi":
            bxCommand = fileModified ? prefixDir + "testcase put" + " " + inOptFile
                                     : "ByExprAmbi put" + " " + inOptFile;
            break;

          case "tigerUnambiKleene":
            bxCommand = fileModified ? prefixDir + "testcase put" + " " + inOptFile
                                     : "ByTigerUnambiKleene put" + " " + inOptFile;
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
                res.send({resultXML: data, success: "success", msg: "Forward transformation was successfully done\n" });
                return;
              }
            });//end fs.readFile
          }
        }); // end exec prefixDir
      }// end (if flag == "f")

      //backward transformation
      else if (flag == "b") {
        fs.writeFile(prefixDir + "AST.txt", view, function(err){
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
                    res.send({resultXML: data, success: "success", msg: "Backward transformation was successfully done\n" });
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
