# A demonstration website for BiYacc
1. in the root folder, run:
   ```sudo npm install```
   this command will install all the needed packages    specified in the package.json

2. in the haskell folder, run the shell ```genexe.sh``` to generate parsers/pretty-printers for the arithmetic expression example. (parser/pretty-printers for xml <-> string, xml <-> AST).

3. modify **biyacc**, **BiFluX**, **ghc** executable path in **config.js** to your own path.
   Hint: use "*which*" to get the path directly in your terminal. E.g. ```# which ghc```
   
4. Run "**node app**" to start it.
   If not succesfully, you would see error info in app.log.
   
Note: this app is runs at port 8080. You can change the port in **app.js**.


***
If you want to make the app running forever: even in some cases, it occurs some problems and shut down. We hope it can be restarted automatically.

1. Use ```sudo npm install forever -g``` to install the needed modules. here '**-g**' means globally installing forever module. 

2. Use ```./start``` to run it and ```./stop``` to stop it.

