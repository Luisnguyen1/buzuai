"""
Ví dụ sử dụng BuzuAI Client - Cách đơn giản nhất
"""

from buzuai import send_message_to_buzuai
import logging

# Setup logging để xem quá trình
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)

def main():
    print("="*60)
    print("🤖 BUZUAI CLIENT - VÍ DỤ ĐƠN GIẢN")
    print("="*60)
    
    # Gửi tin nhắn và nhận response
    user_id = "demo_user_123"
    message = "Xin chào! Bạn có thể giới thiệu về mình không?"
    
    print(f"\n📤 Gửi tin nhắn: {message}")
    print(f"👤 User ID: {user_id}")
    print("\n⏳ Đang chờ response từ AI...")
    
    response = send_message_to_buzuai(
        user_id=user_id,
        message_text=message,
        language_code="vi"
    )
    
    if response:
        print("\n" + "="*60)
        print("✅ NHẬN ĐƯỢC RESPONSE")
        print("="*60)
        
        # In toàn bộ response
        print("\n📦 Response đầy đủ:")
        for key, value in response.items():
            print(f"  {key}: {value}")
        
        # Lấy text từ response
        text = response.get("text", response.get("content", ""))
        if text:
            print(f"\n💬 AI trả lời:")
            print(f"  {text}")
    else:
        print("\n❌ Không nhận được response từ AI")
        print("Có thể do:")
        print("  - Timeout (quá 300s)")
        print("  - Lỗi kết nối")
        print("  - Bot không phản hồi")
    
    print("\n" + "="*60)
    print("✅ Hoàn tất!")
    print("="*60)

if __name__ == "__main__":
    main()
