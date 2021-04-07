# Health

## ![](../.gitbook/assets/shared.svg) SV\_GetHealth

 Returns the vehicle health.

```graphql
number SV_Vehicle:SV_GetHealth()
```

## ![](../.gitbook/assets/shared.svg) SV\_GetMaxHealth

Returns the vehicle max health.

```graphql
number SV_Vehicle:SV_GetMaxHealth()
```

## ![](../.gitbook/assets/shared.svg) SV\_GetPercentHealth

 Returns the vehicle health as a percentage. \[0:100\]

```graphql
number SV_Vehicle:SV_GetPercentHealth()
```

## ![](../.gitbook/assets/server.svg) SV\_SetHealth

Sets the vehicle health.

```graphql
SV_Vehicle:SV_SetHealth(number value)
```

## ![](../.gitbook/assets/server.svg) SV\_SetMaxHealth

 Sets the vehicle max health.

```graphql
SV_Vehicle:SV_SetMaxHealth(number value)
```

## ![](../.gitbook/assets/server.svg) SV\_SendParts

 Sends the health parts of the vehicle.

```graphql
SV_Vehicle:SV_SendParts(Player ply)
```

