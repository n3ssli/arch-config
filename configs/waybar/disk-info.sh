# Get all mounted filesystems
MOUNTED_FS=$(df -h | grep '^/dev/' | awk '{print $6 ": " $3 "/" $2 " (" $5 ")"}')

# Format output
echo "Root: $(df -h / | awk 'NR==2 {print $3 "/" $2 " (" $5 ")"}')"
echo ""
echo "All Drives:"
echo "$MOUNTED_FS"
