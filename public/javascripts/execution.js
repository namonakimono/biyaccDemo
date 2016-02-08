var sourceStr = "(2) * (0 - 4)"
var viewAST = "please run forward transformation first"
var rdirectory = Math.random().toString(36).substring(7);

function exeUpdate() {
  console.log("random directory:");
  console.log(rdirectory);
  console.log("now execute the update query.");
  var concreteSyntax = document.getElementById("concreteSyntax").value;
  var abstractSyntax = document.getElementById("abstractSyntax").value;
  var actions   = document.getElementById("actions").value;
  if(!actions){
    alert("Please check whether actions are filled in.");
    return;
  }

  //when do compilation, remove this part.
  $('#step5').remove();
  $.ajax({
    url: "/compile",
    type: 'get',
    data: {
        concreteSyntax: concreteSyntax,
        abstractSyntax: abstractSyntax,
        actions  : actions,
        rdirectory : rdirectory
    },
    success: function(data){
      // console.log("XD here success");
      // data = JSON.parse(data);
      console.log(data);
      console.log(data.success);
      if(data.success  == "success"){
        // console.log("success");
        $('#step5').remove();
        //this one is for unsuccessful situation added.
        $('#consoleLog0').remove();
        //add a new sec
        $('<li style="float:left" id="step5">Execution<p class="NotGood">You can execute either forward transformation or backward transformation.</p> </li>').insertAfter('#step4');
        $('<div class="ResultSource" id="updatedSource"> <p>Source</p>  <textarea id="sourceText"> </textarea> </div>').insertAfter("#step5 > p");

        $('<div class="Target" id="target"> <p>View</p>  <textarea id="targetText"> </textarea> </div>').insertAfter('#updatedSource');
        $('<hr id="hrline" style="height:10px; width=800px; display:none">').insertAfter('#target')
        $('<div class="FBButton" id="fbButton""><input style="float:left" type="submit" value="Forward Transformation" onclick="forward(rdirectory)"/><input style="float:left" type="submit" value="Backward Transformation" onclick="backward(rdirectory)"/></div>').insertAfter('#hrline');
        //todo: add Console info
        $('<hr id="conhrline" style="height:10px; width=800px; display:none">').insertAfter('#fbButton');
        $('<div class="ConsoleLog" id="consoleLog"><p>Console:</p> <textarea id="consoleText"></textarea></div>').insertAfter('#conhrline');

        //according to the selected option to get the data;
        if ($('select option[value="expr"]').attr('selected')){
          console.log("output arithmetic expression");
          document.getElementById("targetText").value= viewAST;
          document.getElementById("sourceText").value= sourceStr;
        }
        else {
          console.log("output empty");
          document.getElementById("targetText").value= "";
          document.getElementById("sourceText").value= "";
        }
        document.getElementById('consoleText').value = document.getElementById('consoleText').value  +"\n" + data.error;
      }// end if (data.success  == "success")
      else {
        $('#consoleLog0').remove();
        $('<div class="ConsoleLog0" id="consoleLog0" style="float:right; width:500px; margin-right: 20px"><p>Console:</p> <textarea id="consoleText"></textarea></div>').insertAfter('#compileSubmit');
        document.getElementById('consoleText').value = data.error;
      }
    }
  });
}



function forward(rdirectory) {
  x = 1;
  
  var sourceString = document.getElementById("sourceText").value;
  var targetXML = document.getElementById("targetText").value;
  console.log("forward");

  console.log("source:");
  console.log(sourceString);
  // console.log(targetXML)
  // if(!sourceString){
  //   alert("Please check whether DTD, XML, Update Query are all filled in.");
  //   return;
  // }
  document.getElementById('consoleText').value = document.getElementById('consoleText').value + "\n" + "Transformation starts... Please wait...";

  $.ajax({
  url: "/bx",
  type: 'get',
  data: {
    sourceString: sourceString,
    targetXML: targetXML,
    flag: "f",
    rdirectory: rdirectory
  },
  success: function(data){
    //split the data into log and data
    // data = JSON.parse(data);
    document.getElementById('consoleText').value = document.getElementById('consoleText').value + "\n" +data.error;
    if(data.success == "success"){
    document.getElementById("targetText").value = data.resultXML;
    }
    else {
      document.getElementById("targetText").value = "transformation failed";
    }
  }
  });
}


function backward(rdirectory) {
  var sourceString = document.getElementById("sourceText").value;
  var targetXML = document.getElementById("targetText").value;
  console.log("backward");
  console.log("sourceString");
  console.log(sourceString);
  if(!targetXML){
    alert("Please check whether view is filled in.");
    return;
  }
  document.getElementById('consoleText').value = document.getElementById('consoleText').value + "\n" + "Transformation starts... Please wait...";

  $.ajax({
  url: "/bx",
  type: 'get',
  data: {
    sourceString: sourceString,
    targetXML: targetXML,
    flag: "b",
    rdirectory: rdirectory
  },
  success: function(data){
      // data = JSON.parse(data);
      document.getElementById('consoleText').value = document.getElementById('consoleText').value + "\n"+ data.error;
      if (data.success == "success"){
        console.log("finally success");
        console.log(data.resultXML);
        document.getElementById("sourceText").value = data.resultXML;
      }
      else {
        document.getElementById("sourceText").value = "transformation failed";
      }
  }
  });

}
