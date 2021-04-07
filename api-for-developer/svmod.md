# SVMod

## ![](../.gitbook/assets/client.svg) SetAddonState

Enables or disables SVMod on the server.

```graphql
SVMOD:SetAddonState(boolean value = false)
```

## ![](../.gitbook/assets/shared.svg) GetAddonState

Returns true if SVMod is enabled, false otherwise. Can return nil if the addon does not yet know its status.

```graphql
boolean SVMOD:GetAddonState()
```

## ![](../.gitbook/assets/server.svg) Enable

Enables SVMod. The next vehicles that appear will be affected by the addon.

```graphql
SVMOD:Enable()
```

## ![](../.gitbook/assets/server.svg) Disable

Disables SVMod. The next vehicles that appear will no longer be affected by the addon.

```graphql
SVMOD:Disable()
```

