# #!/bin/bash
#
# # Cloudflare API details
# CF_EMAIL="your_cloudflare_email@example.com"
# CF_API_KEY="your_cloudflare_api_key" # Global API Key or an API Token with Zone:Read and Zone:Edit permissions
# ZONE_NAME="your_domain.com"
#
# # Record details
# RECORD_NAME="subdomain" # e.g., "subdomain" for subdomain.your_domain.com, or "@" for your_domain.com
# RECORD_TYPE="A" # A, AAAA, CNAME, TXT, etc.
# TTL=1 # 1 for automatic, or a specific value in seconds (e.g., 300)
# PROXIED=true # true or false
#
# # Get current public IP address
# get_current_ip() {
#     # You can use various services to get your public IP
#     # For IPv4:
#     curl -s https://api.ipify.org || curl -s https://ipv4.icanhazip.com
#     # For IPv6:
#     # curl -s https://api6.ipify.org || curl -s https://ipv6.icanhazip.com
# }
#
# CURRENT_IP=$(get_current_ip)
#
# if [ -z "$CURRENT_IP" ]; then
#     echo "Error: Could not determine current public IP address."
#         exit 1
# fi
#
# echo "Current public IP address: $CURRENT_IP"
#
# # Get Zone ID
# ZONE_ID=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones?name=$ZONE_NAME" \
#      -H "X-Auth-Email: $CF_EMAIL" \
#      -H "X-Auth-Key: $CF_API_KEY" \
#      -H "Content-Type: application/json" | jq -r '.result[0].id')
#
# if [ -z "$ZONE_ID" ]; then
#     echo "Error: Could not find Zone ID for $ZONE_NAME. Check ZONE_NAME and API credentials."
#     exit 1
# fi
#
# echo "Zone ID for $ZONE_NAME: $ZONE_ID"
#
# # Get Record ID and current content
# RECORD_DETAILS=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records?type=$RECORD_TYPE&name=$RECORD_NAME.$ZONE_NAME" \
#      -H "X-Auth-Email: $CF_EMAIL" \
#      -H "X-Auth-Key: $CF_API_KEY" \
#      -H "Content-Type: application/json")
#
# RECORD_ID=$(echo "$RECORD_DETAILS" | jq -r '.result[0].id')
# RECORD_CONTENT=$(echo "$RECORD_DETAILS" | jq -r '.result[0].content')
#
# if [ -z "$RECORD_ID" ]; then
#     echo "Error: Could not find DNS record for $RECORD_NAME.$ZONE_NAME. Check RECORD_NAME and RECORD_TYPE."
#     echo "Attempting to create the record..."
#     CREATE_RESPONSE=$(curl -s -X POST "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records" \
#          -H "X-Auth-Email: $CF_EMAIL" \
#          -H "X-Auth-Key: $CF_API_KEY" \
#          -H "Content-Type: application/json" \
#          --data "{\"type\":\"$RECORD_TYPE\",\"name\":\"$RECORD_NAME\",\"content\":\"$CURRENT_IP\",\"ttl\":$TTL,\"proxied\":$PROXIED}")
#
#     if echo "$CREATE_RESPONSE" | jq -e '.success == true' > /dev/null; then
#         echo "Successfully created DNS record for $RECORD_NAME.$ZONE_NAME with IP $CURRENT_IP."
#         exit 0
#     else
#         echo "Error creating DNS record: $(echo "$CREATE_RESPONSE" | jq -r '.errors[0].message')"
#         exit 1
#     fi
# fi
#
# echo "Existing record ID: $RECORD_ID"
# echo "Existing record content: $RECORD_CONTENT"
#
# # Compare current IP with existing record content
# if [ "$CURRENT_IP" == "$RECORD_CONTENT" ]; then
#     echo "IP address has not changed. No update needed."
#     exit 0
# else
#     echo "IP address has changed from $RECORD_CONTENT to $CURRENT_IP. Updating record..."
#     UPDATE_RESPONSE=$(curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID" \
#          -H "X-Auth-Email: $CF_EMAIL" \
#          -H "X-Auth-Key: $CF_API_KEY" \
#          -H "Content-Type: application/json" \
#          --data "{\"type\":\"$RECORD_TYPE\",\"name\":\"$RECORD_NAME\",\"content\":\"$CURRENT_IP\",\"ttl\":$TTL,\"proxied\":$PROXIED}")
#
#     if echo "$UPDATE_RESPONSE" | jq -e '.success == true' > /dev/null; then
#         echo "Successfully updated DNS record for $RECORD_NAME.$ZONE_NAME to $CURRENT_IP."
#         exit 0
#     else
#         echo "Error updating DNS record: $(echo "$UPDATE_RESPONSE" | jq -r '.errors[0].message')"
#         exit 1
#     fi
# fi
