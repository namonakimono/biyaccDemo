function chooseTigerEg(value) {
  if(value =="tiger_mergesort"){
  $("#actions").load("./testcases/tiger/mergesort.tig", function(data){
  document.getElementById("sourceText").value = data;});
  document.getElementById("targetText").value = viewAST;
  }
  if(value =="tiger_queens"){
  $("#actions").load("./testcases/tiger/queens.tig", function(data){
  document.getElementById("sourceText").value = data;});
  document.getElementById("targetText").value = viewAST;
  }
  if(value =="tiger_mutu_rec_fun"){
  $("#actions").load("./testcases/tiger/mutually_recursive_functions.tig", function(data){
  document.getElementById("sourceText").value = data;});
  document.getElementById("targetText").value = viewAST;
  }
  if(value =="tiger_rec_types"){
  $("#actions").load("./testcases/tiger/valid_recursive_types.tig", function(data){
  document.getElementById("sourceText").value = data;});
  document.getElementById("targetText").value = viewAST;
  }
}



function chooseExample(value) {

  if(value =="expr"){
  $("#abstractSyntax").load("./testcases/expr/abstract.txt", function(data){
  document.getElementById("abstractSyntax").value = data;});
  $("#concreteSyntax").load("./testcases/expr/concrete.txt", function(data){
  document.getElementById("concreteSyntax").value = data;});
  $("#actions").load("./testcases/expr/actions.txt", function(data){
  document.getElementById("actions").value = data;});

  $('select option[value="expr"]').attr("selected", "selected");
  $('select option[value="tiger"]').attr("selected", false);
  $('select option[value="empty"]').attr("selected", false);

  }

  if(value =="tiger"){
  $("#abstractSyntax").load("./testcases/tiger/abstract.txt", function(data){
  document.getElementById("abstractSyntax").value = data;});
  $("#concreteSyntax").load("./testcases/tiger/concrete.txt", function(data){
  document.getElementById("concreteSyntax").value = data;});
  $("#actions").load("./testcases/tiger/actions.txt", function(data){
  document.getElementById("actions").value = data;});

  $('select option[value="tiger"]').attr("selected", "selected");
  $('select option[value="expr"]').attr("selected", false);
  $('select option[value="empty"]').attr("selected", false);

  }
}
