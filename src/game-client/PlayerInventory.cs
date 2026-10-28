
using System;

public sealed class PlayerInventory
{
    // Validates only the client request input.
    // This does not authorize an item grant.
    public bool CanSubmitItemRequest(string itemId)
    {
        return !string.IsNullOrWhiteSpace(itemId);
    }
}
