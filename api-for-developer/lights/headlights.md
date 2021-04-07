---
description: 'Lights on the front of a vehicle, used for driving at night.'
---

# Headlights

## ![](../../.gitbook/assets/shared.svg) SV\_GetHeadlightsState

Returns true if headlights are on, false otherwise.

```graphql
boolean SV_Vehicle:SV_GetHeadlightsState()
```

## ![](../../.gitbook/assets/server.svg) SV\_TurnOnHeadlights

Turns on the headlights of a vehicle.  
Returns true if the headlights have been switched on, false otherwise. The operation will fail if the headlights are already on, if the vehicle has no headlights, or if the headlights have been disabled.

```graphql
boolean SV_Vehicle:SV_TurnOnHeadlights()
```

## ![](../../.gitbook/assets/server.svg) SV\_TurnOffHeadlights

Turns off the headlights of a vehicle.  
Returns true if the headlights have been switched off, false otherwise. The operation will fail if the headlights are already switched off.

```graphql
boolean SV_Vehicle:SV_TurnOffHeadlights()
```

## ![](../../.gitbook/assets/client.svg) SetHeadlightsState

Sets the state of the headlights of the vehicle driven by the player.

```graphql
SVMOD:SetHeadlightsState(int value = false)
```

