var exprDefSrc = "-- some comments\n(-2 {- more comments -} ) * ((2+3) /  (0 - 4))"
var tigerDefSrc = "/* define valid mutually recursive functions */\nlet\n\nfunction do_nothing1(a: int, b: string):int=\n  (do_nothing2(a+1);0)\n\nfunction do_nothing2(d: int):string =\n  (do_nothing1(d, \"str\");\" \")\n\nin\n  do_nothing1(0, \"str2\")\nend\n"
var exprAmbDefSrc = "(1 + 2) * 3 / -4"
var tigeAmbDefSrc = "/* define valid mutually recursive functions */\nlet\n\nfunction do_nothing1(a: int, b: string):int=\n    {do_nothing2(a+1);0}\n\nfunction do_nothing2(d: int):string =\n   {do_nothing1(a, \"str\");\" \"}\n\nin\n do_nothing1(0, \"str2\")\nend\n"

var emptyView = "Please run forward transformation first."

var rdirectory = Math.random().toString(36).substring(7);
var isFileModified = true;
var langChoice = "";

function exeCompile() {
  var program = document.getElementById("program").value;

  $.ajax({
    url: "/compile",
    type: 'post',
    data: {
        program:    program,
        rdirectory: rdirectory,
        langChoice: langChoice
    },
    success: function(data){
      if(data.success  == "success"){
        isFileModified = data.fileModified;

        $('#compileSubmit').remove();

        // rechoose another language
        $('<div><button id="rechoose-lang" class="btn btn-info" style="margin:auto; display:block" onclick="rechooseLang()">' +
            'Click here to try another example</button></div>').insertAfter('#div-before-compilation-button');

        // execution info
        $('<div id="step5">Execution<p>You can execute either forward transformation or backward transformation.</p></div>').insertAfter('#rechoose-lang');

        //program text area
        $('<div class="ResultSource" id="updatedSource"><p>Source</p><textarea class="code" id="sourceText"> </textarea></div>').insertAfter("#step5");

        // AST area
        $('<div class="View" id="view"> <p>View</p>  <textarea class="code" id="viewText"> </textarea> </div>').insertAfter('#updatedSource');
        $('<hr id="hrline" style="height:10px; width=1000px; display:none">').insertAfter('#view');

        // forward and backward transformation button
        $('<div id="pppButtonG">' +
            '<button type="button" class="btn btn-primary"   onclick="forward(rdirectory, isFileModified, langChoice)">Parse</button>' +
            '<button type="button" class="btn btn-secondary" onclick="backward(rdirectory, isFileModified, langChoice)">Print</button>' +
          '</div>'
         ).insertAfter('#hrline');

        // console showing information
        $('<hr id="conhrline">').insertAfter('#pppButtonG');
        $('<div id="consoleLog"><p>Console:</p> <textarea class="code" id="consoleText"></textarea></div>').insertAfter('#conhrline');

        //according to the selected option to get the data;
        if ($('select option[value="expr"]').attr('selected')){
          document.getElementById("sourceText").value = exprDefSrc;
          document.getElementById("viewText").value = emptyView;
        }

        else if ($('select option[value="tiger"]').attr('selected')){
          $('<div class="styled-select" id ="tigerChoice">' +
              '<select name="tigerExampleChoice" onchange="chooseTiger(value)">' +
                '<option value="tiger_mutu_rec_fun">Mutually recursive functions</option>' +
                '<option value="tiger_rec_types">Recursive types</option>' +
                '<option value="tiger_queens">8 Queens</option>' +
                '<option value="tiger_mergesort">Mergesort</option>' +
              '</select></div>').insertAfter("#updatedSource > p");
          document.getElementById("sourceText").value = tigerDefSrc;
          document.getElementById("viewText").value = emptyView;
        }

        else if ($('select option[value="exprAmb"]').attr('selected')){
          document.getElementById("sourceText").value = exprAmbDefSrc;
          document.getElementById("viewText").value = emptyView;
        }

        else if ($('select option[value="tigerAmb"]').attr('selected')){
          $('<div class="styled-select" id ="tigerChoice">' +
              '<select name="tigerExampleChoice" onchange="chooseTigerAmb(value)">' +
                '<option value="tiger_mutu_rec_fun">Mutually recursive functions</option>' +
                '<option value="tiger_queens">8 Queens</option>' +
                '<option value="tiger_mergesort">Mergesort</option>' +
                '<option value="tiger_if_then_else">Dangling else</option>' +
                '<option value="general_if">Generalised If</option>' +
              '</select></div>').insertAfter("#updatedSource > p");
          document.getElementById("sourceText").value = tigeAmbDefSrc;
          document.getElementById("viewText").value = emptyView;
        }

        else{
          console.log("output empty");
          document.getElementById("viewText").value= "";
          document.getElementById("sourceText").value= "";
        }
        document.getElementById('consoleText').value = document.getElementById('consoleText').value  +"\n" + data.msg;
      }// end if (data.success  == "success")
      else {
        $('#consoleLog').remove();
        $('<div class="ConsoleLog" id="consoleLog" style="float:right; width:500px; margin-right: 20px">' +
            '<p>Console:</p> <textarea id="consoleText"></textarea>' +
          '</div>').insertAfter('#compileSubmit');
        document.getElementById('consoleText').value = data.msg;
      }
    }
  });
}



function forward(rdirectory, isFileModified, langChoice) {
  var source = document.getElementById("sourceText").value;
  var view = document.getElementById("viewText").value;
  document.getElementById('consoleText').value =
    document.getElementById('consoleText').value + "\n" + "Transformation starts... Please wait...";

  $.ajax({
    url: "/bx",
    type: 'post',
    data: {
      source: source,
      view: view,
      flag: "f",
      rdirectory:   rdirectory,
      fileModified: isFileModified,
      langChoice:   langChoice
    },
    success: function(data){
      document.getElementById('consoleText').value = document.getElementById('consoleText').value + "\n" +data.msg;
      if(data.success == "success"){
      document.getElementById("viewText").value = data.resultXML;
      } else {
        document.getElementById("viewText").value = "transformation fails\n" + data.msg;
      }
    }
  });
}


function backward(rdirectory, isFileModified, langChoice) {
  var source = document.getElementById("sourceText").value;
  var view = document.getElementById("viewText").value;
  if(!view){
    alert("Please check whether view is filled in.");
    return;
  }
  document.getElementById('consoleText').value =
    document.getElementById('consoleText').value + "\n" + "Transformation starts... Please wait...";

  $.ajax({
    url: "/bx",
    type: 'post',
    data: {
      source: source,
      view: view,
      flag: "b",
      rdirectory:   rdirectory,
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
