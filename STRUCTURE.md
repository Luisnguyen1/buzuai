# BuzuAI Python Client

📦 **Cấu trúc thư viện hoàn chỉnh và tối giản**

## 📁 Cấu trúc

```
buzuai/
├── buzuai/                    # Package chính
│   ├── __init__.py           # Exports
│   └── client.py             # BuzuAIClient implementation
│
├── example_simple.py          # Ví dụ đơn giản
├── example_multiple.py        # Ví dụ nhiều tin nhắn
├── example_interactive.py     # Ví dụ chat tương tác
│
├── pyproject.toml            # Project metadata
├── setup.py                  # Setup script
├── requirements.txt          # Dependencies
├── MANIFEST.in               # Package files
│
├── README.md                 # Tài liệu đầy đủ
├── QUICKSTART.md             # Hướng dẫn nhanh
├── LICENSE                   # MIT License
└── .gitignore                # Git ignore
```

## ✅ Đã hoàn thành

- ✅ Core client với code đúng theo yêu cầu
- ✅ Singleton pattern
- ✅ Helper functions (send_message_to_buzuai, get_buzuai_client)
- ✅ Socket.IO với events đúng (sendMessageToAI, receiveMessage, etc.)
- ✅ Threading.Event để đợi response
- ✅ Timeout 300s
- ✅ Logging tự động
- ✅ 3 examples đơn giản
- ✅ Documentation đầy đủ
- ✅ PyPI-ready structure
- ✅ Loại bỏ files không cần thiết

## 🎯 Sử dụng

### Helper function (Khuyến nghị)

```python
from buzuai import send_message_to_buzuai

response = send_message_to_buzuai("user_123", "Xin chào")
print(response)
```

### Client singleton

```python
from buzuai import get_buzuai_client

client = get_buzuai_client()
client.connect()
response = client.send_message("user_123", "Xin chào")
client.disconnect()
```

## 📦 Cài đặt

```bash
# Development
pip install -e .

# Sau khi publish lên PyPI
pip install buzuai
```

## 🧪 Test

```bash
python example_simple.py
python example_multiple.py
python example_interactive.py
```

## 📖 Docs

- **README.md** - Tài liệu đầy đủ với API reference
- **QUICKSTART.md** - Hướng dẫn bắt đầu nhanh

## 🚀 Publish lên PyPI

```bash
# Build
python -m build

# Upload lên PyPI
python -m twine upload dist/*
```

## 📝 Notes

- Bot ID mặc định: `4489b201-a08a-4d87-81e1-632bcbdb44a8`
- Endpoint: `https://api.buzuai.com/app-chat`
- Namespace: `/app-chat`
- Response timeout: 300 seconds
- Sử dụng singleton pattern để tái sử dụng connection

---

**Version:** 0.1.0  
**License:** MIT  
**Python:** 3.7+
