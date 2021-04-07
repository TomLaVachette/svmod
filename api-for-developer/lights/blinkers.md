---
description: >-
  Light that turns on and off quickly to show other people you are going to turn
  in that direction.
---

# Blinkers

## ![](../../.gitbook/assets/shared.svg) SV\_GetLeftBlinkerState

 Returns true if the left blinkers are on, false otherwise.

```graphql
boolean SV_Vehicle:SV_GetLeftBlinkerState()
```

## ![](../../.gitbook/assets/shared.svg) SV\_GetRightBlinkerState

 Returns true if the right blinkers are on, false otherwise.

```graphql
boolean SV_Vehicle:SV_GetRightBlinkerState()
```

## ![](../../.gitbook/assets/server.svg) SV\_TurnOnLeftBlinker

Turns on the left blinkers of a vehicle.  
Returns true if the left blinkers have been switched on, false otherwise. The operation will fail if the left blinkers are already on, if the vehicle has no left blinkers, or if the blinkers have been disabled.

```graphql
boolean SV_Vehicle:SV_TurnOnLeftBlinker()
```

## ![](../../.gitbook/assets/server.svg) SV\_TurnOffLeftBlinker 

Turns off the left blinkers of a vehicle.  
Returns true if the left blinkers have been switched off, false otherwise. The operation will fail if the left blinkers are already switched off.

```graphql
boolean SV_Vehicle:SV_TurnOffLeftBlinker()
```

## ![](../../.gitbook/assets/server.svg) SV\_TurnOnRightBlinker

Turns on the right blinkers of a vehicle.  
Returns true if the right blinkers have been switched on, false otherwise. The operation will fail if the right blinkers are already on, if the vehicle has no right blinkers, or if the blinkers have been disabled.

```graphql
boolean SV_Vehicle:SV_TurnOnRightBlinker()
```

## ![](../../.gitbook/assets/server.svg) SV\_TurnOffRightBlinker

Turns off the right blinkers of a vehicle.  
Returns true if the right blinkers have been switched off, false otherwise. The operation will fail if the right blinkers are already switched off.

```graphql
boolean SV_Vehicle:SV_TurnOffRightBlinker()
```

## ![](../../.gitbook/assets/client.svg) SetLeftBlinkerState

 Sets the state of the left blinker of the vehicle driven by the player.

```graphql
SVMOD:SetLeftBlinkerState(boolean value = false)
```

## ![](../../.gitbook/assets/client.svg) SetRightBlinkerState

Sets the state of the right blinker of the vehicle driven by the player.

```graphql
SVMOD:SetRightBlinkerState(boolean value)
```

