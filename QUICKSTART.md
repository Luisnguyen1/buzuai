# BuzuAI Python Client - Quick Start

## 🚀 Cài đặt

```bash
pip install -e .
```

## ⚡ Sử dụng ngay

### Cách 1: Helper function (Đơn giản nhất)

```python
from buzuai import send_message_to_buzuai

response = send_message_to_buzuai(
    user_id="your_user_id",
    message_text="Xin chào",
    language_code="vi"
)

print(response)
```

### Cách 2: Sử dụng Client

```python
from buzuai import get_buzuai_client

client = get_buzuai_client()

if client.connect():
    response = client.send_message(
        visitor_id="your_user_id",
        text="Xin chào",
        language_code="vi"
    )
    print(response)
    client.disconnect()
```

## 📁 Examples

Chạy các ví dụ có sẵn:

```bash
# Ví dụ đơn giản
python example_simple.py

# Gửi nhiều tin nhắn
python example_multiple.py

# Chế độ chat tương tác
python example_interactive.py
```

## 🔧 Configuration

### Bot ID mặc định
```python
DEFAULT_BOT_ID = "4489b201-a08a-4d87-81e1-632bcbdb44a8"
```

### Response Timeout
```python
RESPONSE_TIMEOUT = 300  # seconds (5 phút)
```

### Bật logging
```python
import logging
logging.basicConfig(level=logging.INFO)
```

## 📖 API

### Functions

- `send_message_to_buzuai(user_id, message_text, language_code="vi")` - Gửi tin nhắn đơn giản
- `get_buzuai_client()` - Lấy client singleton

### Client Methods

- `connect()` - Kết nối đến server
- `join_room(visitor_id, bot_id=None)` - Join room chat
- `send_message(visitor_id, text, language_code="vi")` - Gửi tin nhắn và chờ response
- `disconnect()` - Ngắt kết nối

## 🐛 Troubleshooting

**Timeout?**
- Bot ID đúng chưa?
- Bot có đang online không?
- Thử tăng RESPONSE_TIMEOUT

**Không kết nối được?**
- Kiểm tra internet
- Kiểm tra firewall
- Thử lại sau

**Response là None?**
- Timeout
- Bot không phản hồi
- Lỗi network

## 📞 Support

- GitHub: https://github.com/Luisnguyen1/buzuai
- Issues: https://github.com/Luisnguyen1/buzuai/issues
