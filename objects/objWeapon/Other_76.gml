if event_data[? "event_type"] == "sequence event"
{
switch (event_data[? "message"])
    {
    case "seqWeaponGreatswordPrimary1":
        owner.hVel += sign(owner.sprite_xscale)*1;
        break;
    }
}