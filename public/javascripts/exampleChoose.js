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

    case "tiger":
      langChoice = "tiger";
      $("#program").load("./testcases/tiger/tiger.txt", function(data){
        document.getElementById("program").value = data;});

      unselectBut("tiger");
      $('select option[value="tiger"]').attr("selected", true);
      return;

    case "exprAmb":
      langChoice = "exprAmb";
      $("#program").load("./testcases/exprAmb/exprAmb.txt", function(data){
        document.getElementById("program").value = data;});

      unselectBut("exprAmb");
      $('select option[value="exprAmb"]').attr("selected", true);
      return;

    case "tigerAmb":
      langChoice = "tigerAmb";
      $("#program").load("./testcases/tigerAmb/tigerAmb.txt", function(data){
        document.getElementById("program").value = data;});

      unselectBut("tigerAmb");
      $('select option[value="tigerAmb"]').attr("selected", "selected");
      return;
  }
}

// Tiger has many test cases. This function chooses the input test case
function chooseTiger(value) {
  if(value =="tiger_mergesort"){
    $("#sourceText").load("./testcases/tiger/mergesort.txt", function(data){
    console.log(data);
    document.getElementById("sourceText").value = data;});
    document.getElementById("viewText").value = "";
  }
  if(value =="tiger_queens"){
    $("#sourceText").load("./testcases/tiger/queens.txt", function(data){
    document.getElementById("sourceText").value = data;});
    document.getElementById("viewText").value = "";
  }
  if(value =="tiger_mutu_rec_fun"){
    $("#sourceText").load("./testcases/tiger/mutually_recursive_functions.txt", function(data){
    document.getElementById("sourceText").value = data;});
    document.getElementById("viewText").value = "";
  }
  if(value =="tiger_rec_types"){
    $("#sourceText").load("./testcases/tiger/valid_recursive_types.txt", function(data){
    document.getElementById("sourceText").value = data;});
    document.getElementById("viewText").value = "";
  }
}


// TigerAmb has many test cases. This function chooses the input test case
function chooseTigerAmb(value) {
  if(value =="tiger_mergesort"){
    $("#sourceText").load("./testcases/tigerAmb/mergesort.txt", function(data){
    console.log(data);
    document.getElementById("sourceText").value = data;});
    document.getElementById("viewText").value = "";
  }
  if(value =="tiger_queens"){
    $("#sourceText").load("./testcases/tigerAmb/queens.txt", function(data){
    document.getElementById("sourceText").value = data;});
    document.getElementById("viewText").value = "";
  }
  if(value =="tiger_mutu_rec_fun"){
    $("#sourceText").load("./testcases/tigerAmb/mutually_recursive_functions.txt", function(data){
    document.getElementById("sourceText").value = data;});
    document.getElementById("viewText").value = "";
  }
  if(value =="tiger_if_then_else"){
    $("#sourceText").load("./testcases/tigerAmb/if_then_else_opt.txt", function(data){
    document.getElementById("sourceText").value = data;});
    document.getElementById("viewText").value = "";
  }
  if(value =="general_if"){
    $("#sourceText").load("./testcases/tigerAmb/general_if.txt", function(data){
    document.getElementById("sourceText").value = data;});
    document.getElementById("viewText").value = "";
  }
}

function rechooseLang(){
  $('#step5').remove();
  $('#compileSubmit').remove();
  $('#rechoose-lang').remove();
  $('#updatedSource').remove();
  $('#pppButtonG').remove();
  $('#view').remove();
  $('#hrline').remove();
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

  if ("tiger" != val) {
    $('select option[value="tiger"]').attr("selected", false);
  }

  if ("exprAmb" != val) {
    $('select option[value="exprAmb"]').attr("selected", false);
  }

  if ("tigerAmb" != val) {
    $('select option[value="tigerAmb"]').attr("selected", false);
  }

  return;
  // $('select option[value="tigerAmb"]').attr("selected", false);
}