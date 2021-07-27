function getClientObj(clientID){
    for (var i = 0; i < global.clients.length; i++)
    {
        if (myArray[i].clientID === clientID)
        {
            return myArray[i];
        }
    }
}