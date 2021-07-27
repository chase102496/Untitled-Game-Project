function getClientObj(clientID)
{
    for (var i = 0; i < global.clients.length; i++)
    {
        if (global.clients[i].clientID === clientID)
        {
            return global.clients[i];
        }
    }
}