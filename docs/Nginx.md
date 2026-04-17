> 👉 **Ubuntu (WSL/VPS) → git clone → build React → deploy bằng Nginx → chạy ở cổng 8080**

---

# 🚀 LAB: Deploy ReactJS trên Ubuntu + Nginx (Port 8080)

---

## 🎯 Mục tiêu

Sau bài này bạn sẽ:

* Clone project từ GitHub trên Ubuntu
* Cài đúng version Node.js (fix lỗi Vite)
* Build React thành file tĩnh (`dist/`)
* Cấu hình Nginx để phục vụ app
* Chạy app tại: **[http://localhost:8080](http://localhost:8080)**

---

# 🧩 PHẦN 1. CHUẨN BỊ MÔI TRƯỜNG

## 1. SSH vào Ubuntu

```bash
ssh gianglt@localhost
```

> Nếu là VPS thì thay `localhost` bằng IP

---

## 2. Cài các công cụ cần thiết

```bash
sudo apt update
sudo apt install -y curl git nginx
```

---

## 3. Cài Node.js (QUAN TRỌNG ⚠️)

👉 Vite yêu cầu Node ≥ 20 → dùng Node 22

```bash
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt install -y nodejs
```

Kiểm tra:

```bash
node -v
npm -v
```

> ✅ Kết quả mong đợi:

```
v22.x.x
```

---

# 📦 PHẦN 2. CLONE & BUILD ỨNG DỤNG

## 1. Clone source code từ GitHub

```bash
cd ~
git clone https://github.com/gianglt-dau/simple-reactjs.git
cd simple-reactjs
```

---

## 2. Cài dependency

```bash
npm install
```

---

## 3. Build ứng dụng

```bash
npm run build
```

---

## 4. Kiểm tra kết quả build

```bash
ls dist/
```

> ✅ Phải thấy:

```
index.html
assets/
```

---

# 🌐 PHẦN 3. DEPLOY BẰNG NGINX (PORT 8080)

---

## 1. Tạo thư mục web

```bash
sudo mkdir -p /var/www/simple-reactjs
sudo chown -R $USER:$USER /var/www/simple-reactjs
```

---

## 2. Copy file build vào Nginx

```bash
cp -r dist/* /var/www/simple-reactjs/
```

---

## 3. Tạo file cấu hình Nginx

```bash
sudo nano /etc/nginx/sites-available/simple-reactjs
```

Dán nội dung:

```nginx
server {
    listen 8080;
    server_name localhost;

    root /var/www/simple-reactjs;
    index index.html;

    # React Router (SPA)
    location / {
        try_files $uri $uri/ /index.html;
    }

    # Cache file tĩnh
    location ~* \.(?:js|css|png|jpg|jpeg|gif|ico|svg|woff2?)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # Security
    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-Content-Type-Options "nosniff";
    add_header X-XSS-Protection "1; mode=block";
}
```

👉 Lưu:

* `Ctrl + O` → Enter
  👉 Thoát:
* `Ctrl + X`

---

## 4. Kích hoạt config

```bash
sudo ln -s /etc/nginx/sites-available/simple-reactjs /etc/nginx/sites-enabled/
```

---

## 5. Tắt site mặc định (tránh xung đột)

```bash
sudo rm /etc/nginx/sites-enabled/default
```

---

## 6. Kiểm tra cấu hình

```bash
sudo nginx -t
```

> ✅ Kết quả:

```
syntax is ok
test is successful
```

---

## 7. Khởi động lại Nginx

```bash
sudo systemctl reload nginx
```

---

# 🌍 PHẦN 4. TRUY CẬP ỨNG DỤNG

Mở trình duyệt:

```text
http://localhost:8080
```

👉 Nếu là VPS:

```text
http://<IP_VPS>:8080
```

---

# 🔁 PHẦN 5. CẬP NHẬT ỨNG DỤNG

Khi có code mới:

```bash
cd ~/simple-reactjs
git pull origin main
npm run build
cp -r dist/* /var/www/simple-reactjs/
```

👉 Không cần restart Nginx

---

# ❗ PHẦN 6. LỖI THƯỜNG GẶP

---

## 1. ❌ Vite báo lỗi Node version

```bash
Vite requires Node.js version 20+
```

👉 Fix:

```bash
node -v
```

Nếu < 20 → cài lại Node 22 (phần trên)

---

## 2. ❌ Không truy cập được localhost:8080

### Kiểm tra Nginx:

```bash
sudo systemctl status nginx
```

---

### Kiểm tra port:

```bash
ss -ltnp | grep 8080
```

Phải thấy:

```
0.0.0.0:8080
```

---

### Kiểm tra file web:

```bash
ls /var/www/simple-reactjs
```

---

## 3. ❌ Trang trắng

👉 Nguyên nhân:

* build lỗi
* copy thiếu file

👉 Fix:

```bash
npm run build
cp -r dist/* /var/www/simple-reactjs/
```

---

## 4. ❌ 404 khi reload trang

👉 Thiếu dòng:

```nginx
try_files $uri $uri/ /index.html;
```

---

## 5. ❌ Port 8080 không vào được (VPS)

Nếu là VPS:

```bash
sudo apt install ufw -y
sudo ufw allow 8080
```

👉 Nếu là WSL → bỏ qua

---

# 🧠 TỔNG KẾT

Luồng hoạt động:

```
GitHub
   ↓
git clone
   ↓
npm install
   ↓
npm run build
   ↓
dist/
   ↓
copy → /var/www/
   ↓
Nginx serve (port 8080)
   ↓
Browser truy cập
```

---

# 🔥 BONUS (Hiểu bản chất)

* React **không chạy trên server**
* Chỉ có:

  * `index.html`
  * JS bundle
  * CSS
* Nginx chỉ **serve file tĩnh**

👉 Dòng quan trọng nhất:

```nginx
try_files $uri $uri/ /index.html;
```

=> giúp React Router hoạt động

---
