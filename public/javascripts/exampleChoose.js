// choose Expr or Tiger example.
function chooseExample(value) {
  if(value =="arithExpr"){
    langChoice = "arithExpr";
    $("#abstractSyntax").load("./testcases/arithExpr/abstract.txt", function(data){
    document.getElementById("abstractSyntax").value = data;});
    $("#concreteSyntax").load("./testcases/arithExpr/concrete.txt", function(data){
    document.getElementById("concreteSyntax").value = data;});
    $("#actions").load("./testcases/arithExpr/actions.txt", function(data){
    document.getElementById("actions").value = data;});

    $('select option[value="arithExpr"]').attr("selected", "selected");
    $('select option[value="tiger"]').attr("selected", false);
    $('select option[value="empty"]').attr("selected", false);

  }

  if(value =="tigerAmbi"){
    langChoice = "tigerAmbi";
    $("#abstractSyntax").load("./testcases/tigerAmbiguous/abstract.txt", function(data){
    document.getElementById("abstractSyntax").value = data;});
    $("#concreteSyntax").load("./testcases/tigerAmbiguous/concrete.txt", function(data){
    document.getElementById("concreteSyntax").value = data;});
    $("#actions").load("./testcases/tigerAmbiguous/actions.txt", function(data){
    document.getElementById("actions").value = data;});

    $('select option[value="tigerAmbi"]').attr("selected", "selected");
    $('select option[value="arithExpr"]').attr("selected", false);
    $('select option[value="tigerUnambi"]').attr("selected", false);
    $('select option[value="empty"]').attr("selected", false);
  }

  if (value =="tigerUnambi"){
    langChoice = "tigerUnambi";
    $("#abstractSyntax").load("./testcases/tigerUnambiguous/abstract.txt", function(data){
    document.getElementById("abstractSyntax").value = data;});
    $("#concreteSyntax").load("./testcases/tigerUnambiguous/concrete.txt", function(data){
    document.getElementById("concreteSyntax").value = data;});
    $("#actions").load("./testcases/tigerUnambiguous/actions.txt", function(data){
    document.getElementById("actions").value = data;});

    $('select option[value="tigerUnambi"]').attr("selected", "selected");
    $('select option[value="arithExpr"]').attr("selected", false);
    $('select option[value="tigerAmbi"]').attr("selected", false);
    $('select option[value="empty"]').attr("selected", false);
  }
}

// Tiger has many test cases. This function choose the input test case
function chooseTigerAmbiEg(value) {
  if(value =="tiger_mergesort"){
    $("#actions").load("./testcases/tigerAmbiguous/mergesort.tig", function(data){
    document.getElementById("sourceText").value = data;});
    document.getElementById("targetText").value = viewAST;
  }
  if(value =="tiger_queens"){
    $("#actions").load("./testcases/tigerAmbiguous/queens.tig", function(data){
    document.getElementById("sourceText").value = data;});
    document.getElementById("targetText").value = viewAST;
  }
  if(value =="tiger_mutu_rec_fun"){
    $("#actions").load("./testcases/tigerAmbiguous/mutually_recursive_functions.tig", function(data){
    document.getElementById("sourceText").value = data;});
    document.getElementById("targetText").value = viewAST;
  }
  if(value =="tiger_rec_types"){
    $("#actions").load("./testcases/tigerAmbiguous/valid_recursive_types.tig", function(data){
    document.getElementById("sourceText").value = data;});
    document.getElementById("targetText").value = viewAST;
  }
}

// Tiger has many test cases. This function choose the input test case
function chooseTigerUnambiEg(value) {
  if(value =="tiger_mergesort"){
    $("#actions").load("./testcases/tigerUnambiguous/mergesort.tig", function(data){
    document.getElementById("sourceText").value = data;});
    document.getElementById("targetText").value = viewAST;
  }
  if(value =="tiger_queens"){
    $("#actions").load("./testcases/tigerUnambiguous/queens.tig", function(data){
    document.getElementById("sourceText").value = data;});
    document.getElementById("targetText").value = viewAST;
  }
  if(value =="tiger_mutu_rec_fun"){
    $("#actions").load("./testcases/tigerUnambiguous/mutually_recursive_functions.tig", function(data){
    document.getElementById("sourceText").value = data;});
    document.getElementById("targetText").value = viewAST;
  }
  if(value =="tiger_rec_types"){
    $("#actions").load("./testcases/tigerUnambiguous/valid_recursive_types.tig", function(data){
    document.getElementById("sourceText").value = data;});
    document.getElementById("targetText").value = viewAST;
  }
}
