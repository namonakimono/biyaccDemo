var arithEgSrc = "// some comments\n(-2 /* more comments */ ) * ((2+3) /  (0 - 4))"
var tigerEgSrc = "/* define valid mutually recursive functions */\nlet\n\nfunction do_nothing1(a: int, b: string):int=\n  (do_nothing2(a+1);0)\n\nfunction do_nothing2(d: int):string =\n  (do_nothing1(d, \"str\");\" \")\n\nin\n  do_nothing1(0, \"str2\")\nend\n"
var viewAST = "please run forward transformation first"
var rdirectory = Math.random().toString(36).substring(7);
var isFileModified = true;
var langChoice = "";

function exeUpdate() {
  var concreteSyntax = document.getElementById("concreteSyntax").value;
  var abstractSyntax = document.getElementById("abstractSyntax").value;
  var actions   = document.getElementById("actions").value;
  if(!actions){
    alert("Please check whether actions are filled in.");
    return;
  }

  $.ajax({
    url: "/compile",
    type: 'post',
    data: {
        concreteSyntax: concreteSyntax,
        abstractSyntax: abstractSyntax,
        actions:        actions,
        rdirectory:     rdirectory,
        langChoice:     langChoice
    },
    success: function(data){
      if(data.success  == "success"){
        isFileModified = data.fileModified;
        // $('#step5').remove();
        
        $('#compileSubmit').remove();
        //this one is for unsuccessful situation added.
        // $('#consoleLog0').remove();
        // rechoose another language
        $('<div><button id="rechoose-lang" class="btn btn-info" style="margin:auto; display:block" onclick="rechooseLang()">' +
            'Click here to try another example</button></div>').insertAfter('#div-before-compilation-button');

        // execution info
        $('<div id="step5">Execution<p class="NotGood">You can execute either forward transformation or backward transformation.</p></div>').insertAfter('#rechoose-lang');

        //program text area
        $('<div class="ResultSource" id="updatedSource"><p>Source</p><textarea class="code" id="sourceText"> </textarea></div>').insertAfter("#step5");

        // AST area
        $('<div class="Target" id="target"> <p>View</p>  <textarea class="code" id="targetText"> </textarea> </div>').insertAfter('#updatedSource');
        $('<hr id="hrline" style="height:10px; width=800px; display:none">').insertAfter('#target');

        // forward and backward transformation button
        $('<div class="FBButton" id="fbButton"">' +
            '<input style="float:left" type="submit" value="Forward Transformation" onclick="forward(rdirectory, isFileModified, langChoice)"/>' +
            '<input style="float:left" type="submit" value="Backward Transformation" onclick="backward(rdirectory, isFileModified, langChoice)"/>' +
            '</div>').insertAfter('#hrline');

        // console showing information
        $('<hr id="conhrline" style="height:10px; width=800px; display:none">').insertAfter('#fbButton');
        $('<div class="ConsoleLog" id="consoleLog"><p>Console:</p> <textarea id="consoleText"></textarea></div>').insertAfter('#conhrline');

        //according to the selected option to get the data;
        if ($('select option[value="arithExpr"]').attr('selected')){
          document.getElementById("sourceText").value= arithEgSrc;
          document.getElementById("targetText").value= viewAST;
        }

        else if ($('select option[value="tigerAmbi"]').attr('selected')){
          $('<div class="styled-select" id ="tigerChoice">' +
             '<select name="tigerExampleChoice" onchange="chooseTigerAmbiEg(value)">' +
               '<option value="tiger_mutu_rec_fun">Mutually recursive functions</option>' +
               '<option value="tiger_rec_types">Recursive types</option>' +
               '<option value="tiger_queens">8 Queens</option>' +
               '<option value="tiger_mergesort">Mergesort</option>' +
             '</select></div>').insertAfter("#updatedSource > p");
          document.getElementById("sourceText").value = tigerEgSrc;
          document.getElementById("targetText").value = viewAST;
        }
        else if ($('select option[value="tigerUnambi"]').attr('selected')){
          $('<div class="styled-select" id ="tigerChoice">' +
              '<select name="tigerExampleChoice" onchange="chooseTigerUnambiEg(value)">' +
                '<option value="tiger_mutu_rec_fun">Mutually recursive functions</option>' +
                '<option value="tiger_rec_types">Recursive types</option>' +
                '<option value="tiger_queens">8 Queens</option>' +
                '<option value="tiger_mergesort">Mergesort</option>' +
              '</select></div>').insertAfter("#updatedSource > p");
          document.getElementById("sourceText").value = tigerEgSrc;
          document.getElementById("targetText").value = viewAST;
        }
        else{
          console.log("output empty");
          document.getElementById("targetText").value= "";
          document.getElementById("sourceText").value= "";
        }
        document.getElementById('consoleText').value = document.getElementById('consoleText').value  +"\n" + data.msg;
      }// end if (data.success  == "success")
      else {
        $('#consoleLog0').remove();
        $('<div class="ConsoleLog0" id="consoleLog0" style="width:800px; margin-right: 20px">' +
            '<p>Console:</p> <textarea class="code" id="consoleText"></textarea>' +
          '</div>').insertAfter('#compileSubmit');
        document.getElementById('consoleText').value = data.msg;
      }
    }
  });
}



function forward(rdirectory, isFileModified, langChoice) {
  var sourceString = document.getElementById("sourceText").value;
  var targetXML = document.getElementById("targetText").value;
  document.getElementById('consoleText').value =
    document.getElementById('consoleText').value + "\n" + "Transformation starts... Please wait...";

  $.ajax({
    url: "/bx",
    type: 'post',
    data: {
      sourceString: sourceString,
      targetXML: targetXML,
      flag: "f",
      rdirectory: rdirectory,
      fileModified: isFileModified,
      langChoice:   langChoice
    },
    success: function(data){
      document.getElementById('consoleText').value = document.getElementById('consoleText').value + "\n" +data.msg;
      if(data.success == "success"){
      document.getElementById("targetText").value = data.resultXML;
      } else {
        document.getElementById("targetText").value = "transformation fails\n" + data.msg;
      }
    }
  });
}


function backward(rdirectory, isFileModified, langChoice) {
  var sourceString = document.getElementById("sourceText").value;
  var targetXML = document.getElementById("targetText").value;
  if(!targetXML){
    alert("Please check whether view is filled in.");
    return;
  }
  document.getElementById('consoleText').value =
    document.getElementById('consoleText').value + "\n" + "Transformation starts... Please wait...";

  $.ajax({
    url: "/bx",
    type: 'post',
    data: {
      sourceString: sourceString,
      targetXML: targetXML,
      flag: "b",
      rdirectory: rdirectory,
      fileModified: isFileModified,
      langChoice:   langChoice
    },
    success: function(data){
      document.getElementById('consoleText').value = document.getElementById('consoleText').value + "\n"+ data.msg;
      if (data.success == "success"){
        document.getElementById("sourceText").value = data.resultXML;
      } else {
        document.getElementById("sourceText").value = "transformation fails\n" + data.msg;
      }
    }
  });

}
