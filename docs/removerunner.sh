bash << 'EOF'
#!/bin/bash

echo "===== RESET GITHUB RUNNER START ====="

RUNNER_DIR=~/actions-runner

echo "[1] Stop service (nếu có)..."
cd $RUNNER_DIR 2>/dev/null || true
sudo ./svc.sh stop 2>/dev/null || true
sudo ./svc.sh uninstall 2>/dev/null || true

echo "[2] Kill toàn bộ process runner..."
pkill -f Runner.Listener 2>/dev/null || true
pkill -f Runner.Worker 2>/dev/null || true
pkill -f actions.runner 2>/dev/null || true

sleep 3

echo "[3] Kiểm tra process còn sót..."
ps -ef | grep Runner | grep -v grep || echo "OK - No runner process"

echo "[4] Remove runner config (nếu còn)..."
cd $RUNNER_DIR 2>/dev/null || true
./config.sh remove --token DUMMY_TOKEN 2>/dev/null || echo "Skip remove (có thể đã bị kẹt hoặc removed)"

echo "[5] Xóa thư mục runner..."
cd ~
rm -rf actions-runner

echo "[6] Dọn rác Docker (nếu dùng runner docker)..."
docker system prune -af 2>/dev/null || true

echo "[7] Done. Ready to reinstall runner."

echo "===== RESET COMPLETE ====="
EOF