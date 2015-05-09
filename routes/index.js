
/*
 * GET home page.
 */

exports.index = function(req, res){
    console.log("render index page");
    res.render("index.html");
};