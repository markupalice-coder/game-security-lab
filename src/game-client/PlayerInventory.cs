
using System;



public sealed class PlayerInventory

{

public bool CanGrantItem(string itemId, string role)

{

if (string.IsNullOrWhiteSpace(itemId))

{

return false;

}



return string.Equals(role, "server", StringComparison.Ordinal);

}

}

