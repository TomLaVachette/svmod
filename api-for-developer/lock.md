# Lock

## ![](../.gitbook/assets/server.svg) SV\_IsLocked

Returns true if the vehicle is locked, false otherwhise.

```graphql
boolean SV_Vehicle:SV_IsLocked()
```

## ![](../.gitbook/assets/server.svg) SV\_Lock

Locks the vehicle. Returns true if the operation was successful, false if the vehicle was already locked.

```graphql
boolean SV_Vehicle:SV_Lock()
```

## ![](../.gitbook/assets/server.svg) SV\_Unlock

Unlocks the vehicle. Returns true if the operation was successful, false if the vehicle was already unlocked.

```graphql
boolean SV_Vehicle:SV_Unlock()
```

## ![](../.gitbook/assets/client.svg) SetLockState

 Sets the lock of the vehicle driven by the player.

```graphql
SVMOD:SetLockState(boolean value = false)
```

## ![](../.gitbook/assets/client.svg) SwitchLockState

 Switch the lock of the vehicle driven by the player.

```graphql
SVMOD:SwitchLockState()
```

