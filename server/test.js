//Connection variables
var net = require('net');
var mySockets = {};

//Socket events
const NICK_NAME = "nickName";
const PLAYER_TYPE = "type";
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

//Game related
var miners = 0;
var producers = 0;
var transporters = 0;

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

                                    answer = JSON.parse(d);

                                    for (x in answer)
                                    {
                                        data[String(x)] = answer[x];
                                    }

                                    nName =  data[NICK_NAME];
                                    type = data[PLAYER_TYPE];
                                    message = data[MESSAGE]

                                    if(message == CLIENT_CONNECTING) {
                                        mySockets[nName] = {
                                            socket: socket,
                                            type: type
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

    updateClient(socket);
}

function updateClient(socket)
{
    var data = {
        "miners":miners,
        "transporters":transporters,
        "producers":producers
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
       miners ++;
       console.log("Miners :"+miners);
   }

    if(type == TYPE_TRANSPORTER)
    {
        transporters ++;
        console.log("Transporters :"+transporters);
    }

    if(type == TYPE_PRODUCER)
    {
        producers ++;
        console.log("Producers :"+producers);
    }
}

// listen for connections
server.listen(9001, "127.0.0.1");