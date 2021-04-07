# Hooks

{% hint style="danger" %}
**Never return false or true if you don't need it**. Otherwise, you can break other addons or even break the SVMod. More information [here](https://wiki.facepunch.com/gmod/Hook_Library_Usage#returningfromhooks).
{% endhint %}

## ![](../.gitbook/assets/shared.svg) SV\_Enabled

Called when SVMod is enabled.

```lua
hook.Add("SV_Enabled", "Hello", function()
    print("Say hello to SVMod!")
    -- RETURN NOTHING PLEASE
end)
```

## ![](../.gitbook/assets/shared.svg) SV\_Disabled

Called when SVMod is disabled.

```lua
hook.Add("SV_Disabled", "Hello", function()
    print("Goodbye SVMod!")
    -- RETURN NOTHING PLEASE
end)
```

## ![](../.gitbook/assets/server.svg) SV\_UsePetrolCanister

Called when a player interacts with a can of gasoline.

| Argument | Type | Description |
| :--- | :--- | :--- |
| ent | [Entity](https://wiki.facepunch.com/gmod/Entity) | Gas can concerned |
| ply | [Player](https://wiki.facepunch.com/gmod/Player) | Player who interacted with |

```lua
hook.Add("SV_UsePetrolCanister", "AddGasCanInInventory", function(ent, ply)
    -- Add the gas can to the player inventory
    ply:AddItem(ent:GetClass(), 1)
    -- RETURN NOTHING PLEASE
end)
```

## ![](../.gitbook/assets/server.svg) SV\_OutOfFuel

Called when a vehicle is out of fuel.

| Argument | Type | Description |
| :--- | :--- | :--- |
| svVeh | SV\_Vehicle | Vehicle out of fuel |

```lua
hook.Add("SV_OutOfFuel", "NotificationWhenOutOfFuel", function(svVeh)
    for _, ply in ipairs(svVeh:SV_GetAllPlayers()) do
        SendNotification(ply, "The vehicle is out of gas.")
    end
    -- RETURN NOTHING PLEASE
end)
```

## ![](../.gitbook/assets/server.svg) SV\_ExplodedVehicle

Called when a vehicle has exploded \(has 0 health\).

| Argument | Type | Description |
| :--- | :--- | :--- |
| svVeh | SV\_Vehicle | Vehicle exploded |

```lua
hook.Add("SV_ExplodedVehicle", "VehicleFees", function(svVeh)
    local lastDriver = svVeh:SV_GetLastDriver()
    
    if IsValid(lastDriver) then
        lastDriver:addMoney(-500)
    end
    -- RETURN NOTHING PLEASE
end)
```

## ![](../.gitbook/assets/server.svg) SV\_PartRepaired

Called when a part of the car has been partially repaired.

| Argument | Type | Description |
| :--- | :--- | :--- |
| svVeh | SV\_Vehicle | Vehicle \(partially\) repaired |
| ply | [Player](https://wiki.facepunch.com/gmod/Player) | Player repairing the vehicle |

```lua
hook.Add("SV_PartRepaired", "AddExperience", function(svVeh, ply)
    ply:addExperience("Mechanic", 3)
    -- RETURN NOTHING PLEASE
end)
```

## ![](../.gitbook/assets/server.svg) SV\_TriedToEnterLockedVehicle

Called when a player tries to get out of a locked vehicle.

| Argument | Type | Description |
| :--- | :--- | :--- |
| svVeh | SV\_Vehicle | Locked vehicle |
| ply | [Player](https://wiki.facepunch.com/gmod/Player) | Player wanting to get out of the vehicle |

## ![](../.gitbook/assets/server.svg) SV\_TriedToLeaveLockedVehicle

Called when a player tries to get out of a locked vehicle.

| Argument | Type | Description |
| :--- | :--- | :--- |
| svVeh | SV\_Vehicle | Locked vehicle |
| ply | [Player](https://wiki.facepunch.com/gmod/Player) | Player wanting to get out of the vehicle |

## ![](../.gitbook/assets/shared.svg) SV\_PlayerEnteredVehicle

Called when a player enters in a vehicle.

| Argument | Type | Description |
| :--- | :--- | :--- |
| ply | [Player](https://wiki.facepunch.com/gmod/Global.Player) | Player who entered the vehicle |
| svVeh | SV\_Vehicle | Vehicle |

## ![](../.gitbook/assets/shared.svg) SV\_PlayerLeaveVehicle

Called when a player leaves a vehicle.

| Argument | Type | Description |
| :--- | :--- | :--- |
| ply | [Player](https://wiki.facepunch.com/gmod/Global.Player) | Player who has left the vehicle |
| svVeh | SV\_Vehicle | Vehicle |

## ![](../.gitbook/assets/shared.svg) SV\_LoadVehicle

Called when a vehicle is loaded by SVMod.

{% hint style="warning" %}
Warning, the vehicle is not necessarily an SV\_Vehicle at the time.
{% endhint %}

| Argument | Type | Description |
| :--- | :--- | :--- |
| veh | [Vehicle](https://wiki.facepunch.com/gmod/Vehicle) | Vehicle being loaded \(not SV\_Vehicle!\) |

## ![](../.gitbook/assets/shared.svg) SV\_UnloadVehicle

Called when a vehicle is unloaded by SVMod.

| Argument | Type | Description |
| :--- | :--- | :--- |
| svVeh | SV\_Vehicle | Vehicle that unloads |

