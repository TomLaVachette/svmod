# Seats

## ![](../.gitbook/assets/server.svg) SV\_EnterVehicle

Sit the player on the nearest available seat. The seat can be a driver or passenger seat.  
The operation will fail if the vehicle is locked.

```graphql
number SV_Vehicle:SV_EnterVehicle(Player ply)
```

| Return value | Explanations |
| :--- | :--- |
| 1 | OK - Successfully completed |
| -1 | ERROR - No seat for this vehicle \(weird but ok..\) |
| -2 | ERROR - Vehicle locked |
| -3 | ERROR - No seat available \(all seats are occupied by players\) |
| -4 | ERROR - Error on creating seat |

{% hint style="info" %}
If you want to bypass the vehicle lock or seat a player in a specific seat, use [Player:EnterVehicle](https://wiki.facepunch.com/gmod/Player:EnterVehicle) instead.
{% endhint %}

## ![](../.gitbook/assets/server.svg) SV\_ExitVehicle

Take the player out of the vehicle. The operation will fail if the vehicle is locked.

```graphql
number SV_Vehicle:SV_ExitVehicle(Player ply)
```

| Return value | Explanations |
| :--- | :--- |
| 1 | OK - Successfully completed |
| -1 | ERROR - The player is not sitting in this vehicle |
| -2 | ERROR - Vehicle locked |
|  |  |

{% hint style="info" %}
If you want to bypass the vehicle lock, use [Player:ExitVehicle](https://wiki.facepunch.com/gmod/Player:ExitVehicle) instead.
{% endhint %}

## ![](../.gitbook/assets/server.svg) SV\_GetLastDriver

Returns the last driver of a vehicle.

```graphql
Player SV_Vehicle:SV_GetLastDriver()
```

## ![](../.gitbook/assets/shared.svg) SV\_IsDriverSeat

Returns true if it is a driver seat, false otherwise.

```graphql
boolean SV_Vehicle:SV_IsDriverSeat()
```

## ![](../.gitbook/assets/shared.svg) SV\_GetDriverSeat

 Returns the driver seat of the vehicle, self if the vehicle is already the driver seat.

```graphql
SV_Vehicle SV_Vehicle:SV_GetDriverSeat()
```

## ![](../.gitbook/assets/shared.svg) SV\_IsPassengerSeat

Returns true if it is a passenger seat, false otherwise.

```graphql
boolean SV_Vehicle:SV_IsPassengerSeat()
```

## ![](../.gitbook/assets/shared.svg) SV\_GetPassengerSeats

Returns a list of all passenger seats of the vehicle. Seats with no seated players are not created, and therefore cannot be included in this table.

```graphql
table SV_Vehicle:SV_GetPassengerSeats()
```

## ![](../.gitbook/assets/shared.svg) SV\_GetAllPlayers

Returns a table with with the driver and passengers of a vehicle.

```graphql
table SV_Vehicle:SV_GetAllPlayers()
```



