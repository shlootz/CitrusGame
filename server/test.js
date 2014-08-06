//Connection variables
var net = require('net');
var mySockets = {};

//Socket events
const NICK_NAME = "nickName";
const PLAYER_TYPE = "type";
const PLAYER_COUNTRY = "country";
const MESSAGE = "msg";
const EVENT_DATA_RECEIVED = "data";
const EVENT_CONNECT = "connect";
const EVENT_DISCONNECT = "disconnect";
const EVENT_TIMEOUT = "timeout";

//Client messages
const CLIENT_CONNECTING = "connecting";

//Client consts
const TYPE_MINER = "miner";
const TYPE_PRODUCER = "producer";
const TYPE_TRANSPORTER = "transporter";

// create the server and register event listeners
var server = net.createServer(function(socket) {
                                socket.on(EVENT_CONNECT, function(socket){
                                    console.log("Connected to Flash");
                                });
                                socket.on(EVENT_DISCONNECT, function()
                                {
                                    console.log("client disconnected");
                                })
                                socket.on(EVENT_TIMEOUT, function()
                                {
                                   console.log("timeout");
                                   socket.end();
                                })
                                socket.on(EVENT_DATA_RECEIVED, function(d){
                                    // Parse the answer from client
                                    var answer = new Object();
                                    var data = new Object();

                                    var nName = "";
                                    var type = "";
                                    var message = "";
                                    var country = "";

                                    answer = JSON.parse(d);

                                    for (x in answer)
                                    {
                                        data[String(x)] = answer[x];
                                    }

                                    nName =  data[NICK_NAME];
                                    type = data[PLAYER_TYPE];
                                    message = data[MESSAGE];
                                    country = data[PLAYER_COUNTRY];

                                    if(message == CLIENT_CONNECTING) {
                                        if (mySockets[country] == null)
                                        {
                                            mySockets[country] = {
                                                socketsList:{

                                                }
                                            }
                                        }

                                        mySockets[country]["socketsList"][nName] = {
                                            socketObj: socket,
                                            userType: type
                                        }

                                        updateTypesCounts(type);
                                        console.log(nName +" of race "+type+ " just connected");

                                        socket.setTimeout(3000)

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
    var data = new Object();
    for (x in obj)
    {
        data[String(x)] = obj[x];
    }

    console.log(data["produced"])

    updateClient(socket, data);
}

function updateClient(socket, dataFromClient)
{
    console.log("dataFromClient[country] "+dataFromClient["country"]);
    console.log(mySockets[dataFromClient["country"]]);

   // { sockets: { 'PlayerName25431.570017585065': { socket: [Object], type: 'miner' } } }

    var data = {
        "miners":1,
        "transporters":1,
        "producers":1,
        "users":{
            "list":mySockets[dataFromClient["country"]]
        }
    }
    var response = {
        "type":"updatePlayers",
        "data":data
    }
    socket.write(JSON.stringify(response));
}

// On each connect, the type is checked and the numbers are updated
function updateTypesCounts(type)
{
   if(type == TYPE_MINER)
   {
       console.log("Miners :");
   }

    if(type == TYPE_TRANSPORTER)
    {
        console.log("Transporters :");
    }

    if(type == TYPE_PRODUCER)
    {
        console.log("Producers :");
    }
}

// listen for connections
server.listen(9001, "127.0.0.1");