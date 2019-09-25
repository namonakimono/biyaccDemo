// choose Expr or Tiger example.
function chooseExample(value) {
  switch (value) {
    case "expr":
      langChoice = "expr";
      $("#program").load("./testcases/expr/expr.txt", function(data){
        document.getElementById("program").value = data;});

      unselectBut("expr");
      $('select option[value="expr"]').attr("selected", true);
      return;

    case "tigerUnambi":
      langChoice = "tigerUnambi";
      $("#program").load("./testcases/tigerUnambiguous/tiger.txt", function(data){
        document.getElementById("program").value = data;});

      unselectBut("tigerUnambi");
      $('select option[value="tigerUnambi"]').attr("selected", true);
      return;

    case "exprKleene":
      langChoice = "exprKleene";
      $("#program").load("./testcases/exprKleene/kleene.txt", function(data){
        document.getElementById("program").value = data;});

      unselectBut("exprKleene");
      $('select option[value="exprKleene"]').attr("selected", true);
      return;

    case "exprNonlinear":
      langChoice = "exprNonlinear";
      $("#program").load("./testcases/exprNonlinear/nonlinear.txt", function(data){
        document.getElementById("program").value = data;});

      unselectBut("exprNonlinear");
      $('select option[value="exprNonlinear"]').attr("selected", true);
      return;

    case "exprAdapt":
      langChoice = "exprAdapt";
      $("#program").load("./testcases/exprAdapt/adapt.txt", function(data){
        document.getElementById("program").value = data;});

      unselectBut("exprAdapt");
      $('select option[value="exprAdapt"]').attr("selected", true);
      return;

    case "exprAmbi":
      langChoice = "exprAmbi";
      $("#program").load("./testcases/exprAmbi/exprAmbi.txt", function(data){
        document.getElementById("program").value = data;});

      unselectBut("exprAmbi");
      $('select option[value="exprAmbi"]').attr("selected", true);
      return;

    // case "tigerUnambiKleene":
    //   langChoice = "tigerUnambiKleene";
    //   $("#program").load("./testcases/tigerUnambiKleene/tigerUnambiKleene.txt", function(data){
    //     document.getElementById("program").value = data;});

    //   unselectBut("tigerUnambiKleene");
    //   $('select option[value="tigerUnambiKleene"]').attr("selected", "selected");
    //   return;
  }
}

// Tiger has many test cases. This function chooses the input test case
function chooseTigerUnambi(value) {
  if(value =="tiger_mergesort"){
    $("#sourceText").load("./testcases/tigerUnambiguous/mergesort.tig", function(data){
    console.log(data);
    document.getElementById("sourceText").value = data;});
    document.getElementById("viewText").value = viewAST;
  }
  if(value =="tiger_queens"){
    $("#sourceText").load("./testcases/tigerUnambiguous/queens.tig", function(data){
    document.getElementById("sourceText").value = data;});
    document.getElementById("viewText").value = viewAST;
  }
  if(value =="tiger_mutu_rec_fun"){
    $("#sourceText").load("./testcases/tigerUnambiguous/mutually_recursive_functions.tig", function(data){
    document.getElementById("sourceText").value = data;});
    document.getElementById("viewText").value = viewAST;
  }
  if(value =="tiger_rec_types"){
    $("#sourceText").load("./testcases/tigerUnambiguous/valid_recursive_types.tig", function(data){
    document.getElementById("sourceText").value = data;});
    document.getElementById("viewText").value = viewAST;
  }
}

function rechooseLang(){
  $('#step5').remove();
  $('#compileSubmit').remove();
  $('#rechoose-lang').remove();
  $('#updatedSource').remove();
  $('#view').remove();
  $('#hrline').remove();
  $('#fbButton').remove();
  $('#conhrline').remove();
  $('#consoleLog').remove();
  $('<button id="compileSubmit" type="button" class="btn btn-primary" style="margin:auto; display:block"' +
      ' onclick="exeCompile()">Click here to compile</button>').insertAfter("#div-before-compilation-button");
}

function unselectBut(val) {
  console.log(val)
  if ("expr" != val) {
    $('select option[value="expr"]').attr("selected", false);
  }

  if ("tigerUnambi" != val) {
    $('select option[value="tigerUnambi"]').attr("selected", false);
  }

  if ("exprKleene" != val) {
    $('select option[value="exprKleene"]').attr("selected", false);
  }

  if ("exprNonlinear" != val) {
    $('select option[value="exprNonlinear"]').attr("selected", false);
  }

  if ("exprAdapt" != val) {
    $('select option[value="exprAdapt"]').attr("selected", false);
  }

  if ("exprAmbi" != val) {
    $('select option[value="exprAmbi"]').attr("selected", false);
  }

  return;
  // $('select option[value="tigerUnambiKleene"]').attr("selected", false);
}