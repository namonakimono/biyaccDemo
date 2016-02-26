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

    // document.getElementById("concreteSyntax").value = concreteSyntax;
    // document.getElementById("abstractSyntax").value = abstractSyntax;
    // document.getElementById("actions").value= exprActions;
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

    // document.getElementById("concreteSyntax").value = "";
    // document.getElementById("abstractSyntax").value = "";
    // document.getElementById("actions").value = "";
    }
}



