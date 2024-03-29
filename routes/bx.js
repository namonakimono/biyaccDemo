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

          case "tiger":
            bxCommand = fileModified ? prefixDir + "testcase get" + " " + inOptFile
                                     : "ByTiger get" + " " + inOptFile;
            break;

          case "exprAmb":
            bxCommand = fileModified ? prefixDir + "testcase get" + " " + inOptFile
                                     : "ByExprAmb get" + " " + inOptFile;
            break;

          case "tigerAmb":
            bxCommand = fileModified ? prefixDir + "testcase get" + " " + inOptFile
                                     : "ByTigerAmb get" + " " + inOptFile;
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

          case "tiger":
            bxCommand = fileModified ? prefixDir + "testcase put" + " " + inOptFile
                                     : "ByTiger put" + " " + inOptFile;
            break;

          case "exprAmb":
            bxCommand = fileModified ? prefixDir + "testcase put" + " " + inOptFile
                                     : "ByExprAmb put" + " " + inOptFile;
            break;

          case "tigerAmb":
            bxCommand = fileModified ? prefixDir + "testcase put" + " " + inOptFile
                                     : "ByTigerAmb put" + " " + inOptFile;
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
