function wr(){

  if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <name>"
    echo "Example: $0 new-cloudflare-project"
    exit 1
  fi

  # --- Assign parameters to variables ---
  WORKER_NAME=$(basename "$PWD")

  # --- Generate the current date in YYYY-MM-DD format ---
  # The format for Cloudflare Workers compatibility_date is typically YYYY-MM-DD
  COMPATIBILITY_DATE=$(date +%Y-%m-%d)

  OUTPUT_DIR="./dist"
  FILE_NAME="wrangler.jsonc"

  # --- Create the JSONC content using a here-document ---
  # The COMPATIBILITY_DATE variable is substituted here
  cat > "$FILE_NAME" << EOF
  {
    "name": "$WORKER_NAME",
    "compatibility_date": "$COMPATIBILITY_DATE",
    "assets": {
      "directory": "$OUTPUT_DIR"
    }
}
EOF

# --- Success message ---
echo "✅ Successfully created $FILE_NAME."
echo "   Worker Name: $WORKER_NAME"
echo "   Compatibility Date: $COMPATIBILITY_DATE (Current Date)"
echo "---"
cat "$FILE_NAME"
echo "---"
}

alias wrang="npx wrangler"

