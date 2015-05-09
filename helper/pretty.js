
function pretty(fileData){
    // part1: read data from file
    //var fs = require('fs');
    //var fileData = fs.readFileSync('s.xml', 'utf-8');
    //console.log(fileData);

    //part2: pretty the data
    // angleBStack is used to store
    var angleBStack = new Array();
    var depth = -1;

    var resultData = "";

    //step1: first line
    for (var i = 0; i < fileData.length; i++) {
        resultData += fileData[i];
        if( fileData[i] == '\n') {
            fileData = fileData.slice(i+1, fileData.length);
            //console.log("first line: ");
            //console.log(resultData);
            //console.log("rest data: ")
            console.log(fileData);
            break;
        }
    };

    //console.log("step 2");
    //step2: rest part
    for (var i = 0; i < fileData.length; i++) {
            //todo

            if(fileData[i] == '\n'){
                //console.log("newline", i);
                //console.log("length: ", fileData.length);
                if( i == fileData.length-1){
                    //console.log("break");
                    break;
                }
                str = fileData.slice(i+1, fileData.length);
                //console.log("jump step: ", skipNewLineSpaces(str));
                i += skipNewLineSpaces(str);
                //test out put
                //console.log("After skip: ", fileData[i+1]);
                //break;
            }
            else if(fileData[i] == '<' && fileData[i+1] != '/' ){
                // case: <
                //console.log("case: <");
                angleBStack.push("<");
                depth += 1;
                resultData += depthSpace(depth);
                resultData += fileData.substring(i,i+1);
            }

            else if (fileData[i] == '/' && fileData[i+1] == '>'){
                //case: />
                var pre = angleBStack.pop();
                /*
                console.log("front: ", pre);
                console.log("end: ", "/>");
                console.log("location: ", i);
                */
                depth -= 1;
                i += 1;
                resultData += "/>\n";
            }
            else if(fileData[i] == '<' && fileData[i+1] == '/') {
                //case </
                //console.log("case: </");
                angleBStack.push("</");
                //resultData += "\n";
                //console.log("depth: ", depth);

                if(lookBack(fileData.slice(0,i-1))){
                    resultData += "\n";
                    resultData += depthSpace(depth);
                }
                resultData += "</";        
                depth -= 1;
                i += 1;
            }
            else if(fileData[i] == '>'){
                //case: >
                var pre = angleBStack.pop();
                /*
                console.log("front: ", pre);
                console.log("end: ", ">");
                console.log("location: ", i);
                */
                //lookahead: if it is data, then just it. else new line.
                if(lookAhead(fileData.slice(i+1, fileData.length))){
                    resultData += ">\n";
                    resultData += depthSpace(depth);    
                }
                else {
                    resultData += ">";
                }

            }
            else {
                resultData += fileData.substring(i, i+1);
                //console.log("next data: ", fileData[i+1]);
            }
            //console.log("here");
        };
        resultData = resultData.replace("\n\n", "\n");
        //console.log(resultData);
        return resultData;
}

/*
 A helper function: skip newline and spaces.
*/
function skipNewLineSpaces(str){
    for (var i = 0; i < str.length; i++) {
        if(str[i] == ' ' || str[i] == '\n') {
            i++;
        }
        else {
            return i ;
        }
    };
}

function depthSpace (depth){
    var space = "";
    for (var i = 0; i < depth; i++) {
        space += "  ";
    };
    return space;
}


function lookAhead (str){
    var flag = false;
    for (var i = 0; i < str.length; i++) {
        if(str[i] == ' '){
            continue;
        }
        else if(str[i] == '<'){
            flag = true;
        }
        else {
            break;
        }
    };
    //console.log("flag: ", flag);

    return flag;
}

function lookBack (str){
    var flag = false;
    for (var i = str.length - 1; i >= 0; i--) {
        if(str[i] == ' ') {
            contine;
        }
        else if(str[i] == '\n'){
            contine;
        }
        else if (str[i] == '>'){
            falg = true;;
        }
        else {
            break;
        }
    };
    //console.log("back flag: ", flag);
    return flag;
}

exports.pretty = pretty;
