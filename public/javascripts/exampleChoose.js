function chooseExample(value) {

    var concreteSyntax = "Concrete\n\nExpr -> Expr '+' Term\n      | Expr '-' Term\n      | Term\n\nTerm -> Term '*' Factor\n      | Term '/' Factor\n      | Factor\n\nFactor -> '-' Factor\n        | String\n        | '(' Expr ')'\n";
    var abstractSyntax = "Abstract\n\nArith = ADD Arith Arith\n      | SUB Arith Arith\n      | MUL Arith Arith\n      | DIV Arith Arith\n      | NUM String\n";
    var exprActions = "Actions\n\nArith +> Expr\nADD lhs       rhs  -> (lhs => Expr) '+' (rhs => Term)\nSUB lhs       rhs  -> (lhs => Expr) '-' (rhs => Term)\narith              -> (arith => Term)\n\nArith +> Term\nMUL lhs rhs -> (lhs => Term) '*' (rhs => Factor)\nDIV lhs rhs -> (lhs => Term) '/' (rhs => Factor)\narith       -> (arith => Factor)\n\nArith +> Factor\nSUB (NUM \"0\") rhs -> '-' (rhs => Factor)\nNUM n             -> (n => String)\narith             -> '(' (arith => Expr) ')'\n";


    if(value =="expr"){
    $('select option[value="expr"]').attr("selected", "selected");
    $('select option[value="empty"]').attr("selected", false);
    //remove upload dialog
    // $('#r1').remove();
    // $('#r3').remove();
    // $('#r5').remove();
    //remove update query slector.
    // $('#mulNQ').remove();
    // $('#mulQ').remove();
    // $('#step5').remove();
    document.getElementById("concreteSyntax").value = concreteSyntax;
    document.getElementById("abstractSyntax").value = abstractSyntax;
    document.getElementById("actions").value= exprActions;
    }
    if(value =="empty"){
    // console.log("expression example");
    // console.log(document.getElementById("concreteSyntax").value);
    $('select option[value="empty"]').attr("selected", "selected");
    $('select option[value="expr"]').attr("selected", false);
    //remove upload dialog
    // $('#r1').remove();
    // $('#r3').remove();
    // $('#r5').remove();
    //remove update query slector.
    // $('#mulNQ').remove();
    // $('#mulQ').remove();
    // $('#step5').remove();
    document.getElementById("concreteSyntax").value = "";
    document.getElementById("abstractSyntax").value = "";
    document.getElementById("actions").value = "";
    }
    // add Tiger later.
    // else if(value =="bookmark"){
    // console.log("bookmark DTD");
    // console.log(document.getElementById("concreteSyntax").value);
    // $('select option[value="people"]').attr("selected", false);
    // $('select option[value="bookmark"]').attr("selected", "selected");
    // $('select option[value="nestedsections"]').attr("selected", false);
    // $('select option[value="addressbook"]').attr("selected", false);
    // $('select option[value="bookstore"]').attr("selected", false);
    // $('select option[value="upload"]').attr("selected", false);
    // $('select option[value="please"]').attr("selected", false);
    // //remove upload dialog
    // $('#r1').remove();
    // $('#r3').remove();
    // $('#r5').remove();
    // //remove update query slector.
    // $('#mulNQ').remove();
    // $('#mulQ').remove();
    // $('#step5').remove();
    // document.getElementById("concreteSyntax").value = bookmarkSourceDTD;
    // document.getElementById("abstractSyntax").value = bookmarkTargetDTD;
    // document.getElementById("actions").value= bookmarkQuery;
    // }
}



