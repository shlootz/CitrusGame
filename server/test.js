var net = require('net');
var mySockets = {}

// create the server and register event listeners
var server = net.createServer(function(socket) {
                                socket.on("connect", function(){
                                    console.log("Connected to Flash");
                                });
                                socket.on("disconnect", function(socket)
                                {
                                    console.log("aaaaa");
                                })
                                socket.on("timeout", function()
                                {
                                   console.log("timeout");
                                   socket.end();
                                })
                                socket.on("data", function(d){
                                    // Parse the answer from client
                                    var answer = new Object();
                                    var data = new Object();
                                    var nName = "";
                                    var type = "";
                                    var message = "";

                                    answer = JSON.parse(d);

                                    for (x in answer)
                                    {
                                        data[String(x)] = answer[x];
                                    }

                                    nName =  data["nickName"];
                                    type = data["type"];
                                    message = data["msg"]

                                    if(type == "connecting") {
                                        mySockets[nName] = {
                                            socket: socket
                                        }

                                        console.log(nName + " just connected");

                                        socket.setTimeout(1000)

                                    }
                                    else {
                                        genericData(socket);
                                    }
                                })
                              });

// When flash sends us data, this method will handle it
function genericData(socket)
{
    console.log('again');
    socket.write("Hello")
}

// listen for connections
server.listen(9001, "127.0.0.1");