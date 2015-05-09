    var sourceStr = "(2 * (0 - 4))"
    var viewAST = "please run forward transformation firstly"

function exeUpdate() {
    console.log("execute the update query.");
    var sourceDTD = document.getElementById("sourceDTD").value;
    var targetDTD = document.getElementById("targetDTD").value;
    var actions   = document.getElementById("actions").value;
    // console.log("sourceDTD");
    // console.log(actions);
    // console.log(targetDTD);
    // console.log(sourceDTD);
    if(!sourceDTD || !targetDTD  || !actions){
      alert("Please check whether DTD,  Update Query are all filled in.");
      return;
    }

    //when do compilation, remove this part.
    $('#step5').remove();
    $.ajax({
      url: "/compile",
      type: 'get',
      data: {
          sourceDTD: sourceDTD,
          targetDTD: targetDTD,
          actions  : actions,
      },
      success: function(data){
          // console.log("XD here success");
          data = JSON.parse(data);
          console.log(data);
          console.log(data.success);
          if(data.success  == "success"){
            // console.log("success");
            $('#step5').remove();
            //this one is for unsuccessful situation added.
            $('#consoleLog0').remove();
            //add a new sec
            $('<li style="float:left" id="step5">Execution of Bidirectional Transformation<p class="NotGood">You can execute either forward transformation or backward transformation. Note: changes only can be propagated from one side to another side. Changes on both sides cannot be preserved at the same time.</p> </li>').insertAfter('#step4');
            $('<div class="ResultSource" id="updatedSource"> <p>Source</p>  <textarea id="sourceText"> </textarea> </div>').insertAfter("#step5 > p");

            $('<div class="Target" id="target"> <p>Target</p>  <textarea id="targetText"> </textarea> </div>').insertAfter('#updatedSource');
            $('<hr id="hrline" style="height:10px; width=800px; display:none">').insertAfter('#target')
            $('<div class="FBButton" id="fbButton""><input style="float:left" type="submit" value="Forward Transformation" onclick="forward()"/><input style="float:left" type="submit" value="Backward Transformation" onclick="backward()"/></div>').insertAfter('#hrline');
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



function forward() {
    var sourceString = document.getElementById("sourceText").value;
    var targetXML = document.getElementById("targetText").value;
    console.log("forward")

    console.log("source:")
    console.log(sourceString)
    // console.log(targetXML)
    if(!sourceString || !targetXML){
    alert("Please check whether DTD, XML, Update Query are all filled in.");
    return;
    }

    $.ajax({
    url: "/bx",
    type: 'get',
    data: {
        sourceString: sourceString,
        targetXML: targetXML,
        flag: "f"
    },
    success: function(data){
        //split the data into log and data
        data = JSON.parse(data);
        document.getElementById('consoleText').value = document.getElementById('consoleText').value + "\n" +data.error;
        if(data.success == "success"){
        document.getElementById("targetText").value = data.resultXML;
        } else {
          document.getElementById("targetText").value = "transformation failed";
        }
    }
    });
}


function backward() {
    var sourceString = document.getElementById("sourceText").value;
    var targetXML = document.getElementById("targetText").value;
    console.log("backward");
    console.log("sourceString");
    console.log(sourceString);
    if(!sourceString || !targetXML){
    alert("Please check whether DTD, XML, Update Query are all filled in.");
    return;
    }

    $.ajax({
    url: "/bx",
    type: 'get',
    data: {
        sourceString: sourceString,
        targetXML: targetXML,
        flag: "b"
    },
    success: function(data){
        data = JSON.parse(data);
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
