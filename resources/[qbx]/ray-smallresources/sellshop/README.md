# Sellshop Resource - Security Enhanced

This resource has been enhanced with comprehensive security measures to prevent exploits and cheating.

## Security Features

### 1. Distance Validation
- Players must be within 3.0 units of the shop NPC to interact
- All transactions are validated against player position
- Prevents remote triggering of shop events

### 2. Session Management
- Players must start a valid session by opening the shop menu
- Sessions expire after 5 minutes of inactivity
- Sessions are tied to specific shop locations
- Sessions are cleared when players die or disconnect

### 3. Rate Limiting
- Maximum 10 transactions per minute per player
- 2-second cooldown between individual transactions
- Prevents spam selling and rapid exploitation

### 4. Transaction Limits
- Maximum 1000 items per transaction
- Maximum $100,000 value per transaction
- Prevents massive item dumps and value exploits

### 5. Comprehensive Validation
- Item validation against shop inventory
- Price validation to prevent price manipulation
- Quantity validation to prevent negative or excessive amounts
- Shop index validation to prevent cross-shop exploits

### 6. Exploit Detection
- Automatic detection of common exploit attempts
- Discord logging of suspicious activities
- Optional automatic banning for detected exploits
- Detailed logging of all transactions

## Configuration

### Security Settings (config.lua)

```lua
Config.Security = {
    MAX_DISTANCE = 3.0, -- Maximum distance from shop NPC
    COOLDOWN_TIME = 2000, -- 2 seconds between transactions
    MAX_TRANSACTIONS_PER_MINUTE = 10,
    SESSION_TIMEOUT = 300000, -- 5 minutes session timeout
    MAX_QUANTITY_PER_TRANSACTION = 1000, -- Maximum items per transaction
    MAX_VALUE_PER_TRANSACTION = 100000, -- Maximum value per transaction
    ENABLE_DISCORD_LOGGING = true, -- Enable/disable Discord logging
    ENABLE_EXPLOIT_BANNING = true, -- Enable/disable automatic banning for exploits
}
```

### Adjusting Security Settings

- **MAX_DISTANCE**: Increase if players have trouble interacting with NPCs
- **COOLDOWN_TIME**: Increase to prevent rapid clicking, decrease for better UX
- **MAX_TRANSACTIONS_PER_MINUTE**: Adjust based on your server's economy
- **SESSION_TIMEOUT**: Increase for longer shopping sessions
- **MAX_QUANTITY_PER_TRANSACTION**: Adjust based on item rarity and economy
- **MAX_VALUE_PER_TRANSACTION**: Set based on your server's economy scale
- **ENABLE_DISCORD_LOGGING**: Set to false to disable Discord notifications
- **ENABLE_EXPLOIT_BANNING**: Set to false to only log exploits without banning

## Security Events

### Server Events
- `atleast-sellshop:startSession` - Starts a shop session (client → server)
- `atleast-sellshop:processTransaction` - Processes individual item sales
- `atleast-sellshop:sellAllItems` - Processes bulk item sales

### Security Checks Performed
1. **Distance Check**: Player must be near the shop NPC
2. **Session Validation**: Valid session must exist for the shop
3. **Cooldown Check**: Time between transactions
4. **Rate Limit Check**: Transactions per minute limit
5. **Item Validation**: Item must be in shop inventory
6. **Price Validation**: Price must match configured price
7. **Quantity Validation**: Quantity must be within limits
8. **Value Validation**: Total transaction value must be within limits

## Anti-Exploit Measures

### Prevented Exploits
- **Remote Triggering**: Events can only be triggered near NPCs
- **Price Manipulation**: Prices are validated against config
- **Item Spoofing**: Items are validated against shop inventory
- **Session Hijacking**: Sessions are tied to specific shops and players
- **Spam Selling**: Rate limiting prevents rapid transactions
- **Massive Dumps**: Transaction limits prevent large-scale exploits
- **Cross-Shop Exploits**: Sessions are shop-specific

### Detection and Response
- **Automatic Logging**: All suspicious activities are logged to Discord
- **Exploit Banning**: Automatic banning for detected exploits (configurable)
- **Session Invalidation**: Invalid sessions are immediately terminated
- **Transaction Tracking**: All transactions are tracked for analysis

## Performance Considerations

- **Memory Management**: Old sessions and transaction data are automatically cleaned up
- **Efficient Validation**: Security checks are optimized for performance
- **Minimal Overhead**: Security measures add minimal performance impact
- **Periodic Cleanup**: Old data is cleaned up every 5 minutes

## Troubleshooting

### Common Issues

1. **"Invalid session" errors**: Player needs to reopen the shop menu
2. **"Too many transactions" errors**: Player needs to wait before making more sales
3. **"You must be near the shop" errors**: Player needs to move closer to the NPC
4. **"Transaction value too high" errors**: Reduce the quantity being sold

### Debugging

Enable Discord logging to monitor all transactions and detect potential issues:
```lua
Config.Security.ENABLE_DISCORD_LOGGING = true
```

## Updates and Maintenance

- Security settings can be adjusted without restarting the resource
- New security measures can be easily added to the validation pipeline
- All security events are logged for monitoring and analysis
- Regular cleanup prevents memory leaks and performance issues 