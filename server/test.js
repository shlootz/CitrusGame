var net = require('net');
var mySockets = {};

// create the server and register event listeners
var server = net.createServer(function(socket) {
                                socket.on("connect", function(socket){
                                    console.log("Connected to Flash");
                                });
                                socket.on("disconnect", function()
                                {
                                    console.log("client disconnected");
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

                                    if(message == "connecting") {
                                        mySockets[nName] = {
                                            socket: socket,
                                            type: type
                                        }

                                        console.log(nName +" of race "+type+ " just connected");

                                        socket.setTimeout(2000)

                                    }
                                    else {
                                        var receivedObject = data["obj"];
                                        genericData(socket, receivedObject);
                                    }
                                })
                              });

// When flash sends us data, this method will handle it
function genericData(socket, obj)
{
    console.log('again');

    var data = new Object();
    for (x in obj)
    {
        data[String(x)] = obj[x];
    }

    console.log(data["produced"])

    socket.write("Hello")
}

// listen for connections
server.listen(9001, "127.0.0.1");