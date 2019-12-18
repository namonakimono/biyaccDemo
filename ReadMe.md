# A web-GUI for demonstrating BiYacc

## Installation

### Install node
Please refer to: [https://nodejs.org/en/](https://nodejs.org/en/)

### Install this web-GUI
At the root of the folder, run: `npm install`  
the command will install all the needed packages specified in the `package.json` file.

## Host
Run `node app` or `./start` to start the server.  
(`./start` will run the server forever, use `./stop` to stop the server.)  
If any error occurs, you can find the logs in app.log.

The app runs at port 8080 by default and you can change the port in `app.js`.


If you want to make the app running forever, run  
`sudo npm install forever -g`  
to install the needed modules. Here `-g` means globally installing forever module.
After installation, use `./start` to 

