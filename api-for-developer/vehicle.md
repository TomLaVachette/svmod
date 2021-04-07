# Vehicle

## ![](../.gitbook/assets/shared.svg) IsVehicle

Returns true if the vehicle is a SV vehicle, false otherwise.

```graphql
boolean SVMOD:IsVehicle(Vehicle veh)
```

{% hint style="info" %}
This function will return false if the vehicle is \[NULL ENTITY\]. Therefore you should not call [IsValid](https://wiki.facepunch.com/gmod/Global.IsValid) before calling this function.
{% endhint %}

{% hint style="warning" %}
You MUST check if the vehicle is a SV vehicle before using our functions.
{% endhint %}

## ![](../.gitbook/assets/shared.svg) SV\_GetSpeed

Returns the vehicle speed in km/h.

```graphql
number SV_Vehicle:SV_GetSpeed()
```

{% hint style="info" %}
You should use the [cached version](vehicle.md#sv_getcachedspeed) if you are going to call it often \(like in a draw hook\).
{% endhint %}

## ![](../.gitbook/assets/shared.svg) SV\_GetCachedSpeed

Returns the vehicle cached speed in km/h. This value is updated once every 0.2 second.

```graphql
number SV_Vehicle:SV_GetCachedSpeed()
```

