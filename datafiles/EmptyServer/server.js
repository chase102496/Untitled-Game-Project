require('./config.js')
const net = require('net');
const port = config.port;

const fs = require('fs');

const packet = require('./internal/packet.js'); // { build(), parse() }
const Client = require('./internal/entities/client.js'); // class Client {...}
const { delayReceive } = require('./internal/artificial_delay.js');


// load some init scripts (to not put everything in this file)
const init_files = fs.readdirSync(__dirname + '/internal/initializers', 'utf8');
init_files.forEach(function(file) {
    require(__dirname + '/internal/initializers/' + file);
})
console.log('loaded initializers!');


// The Actual Server
const server = net.createServer(function (socket)
{
    var c = new Client(socket);
    c.onConnect();

    // Bind functions on events
    socket.on('error', function (err) {
        if (err.message.includes('ECONNRESET')) {

        }
        console.log(`${err}`);
    });
    
    // When data arrived
    socket.on('data', function (data)
    {
        //console.log("Data received");

        // create artificial_delay
        if (delayReceive.enabled) {
            setTimeout(function() {
                packet.parse(c, data); // handle the logic
            }, delayReceive.get());
        }
        else { // just parse normally
            packet.parse(c, data); // handle the logic
        }
    });

    // When a socket/connection closed
    socket.on('close', function () {
        c.onDisconnect();
    });
});

server.listen(port);
console.log("Server running on port " + port + "!");