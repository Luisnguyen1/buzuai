"""
Ví dụ sử dụng BuzuAI Client - Tương tác (Interactive)
"""

from buzuai import get_buzuai_client
import logging

# Setup logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)

def main():
    print("\n" + "="*60)
    print("💬 BUZUAI CLIENT - CHẾ ĐỘ TƯƠNG TÁC")
    print("="*60)
    
    # Lấy client singleton
    client = get_buzuai_client()
    
    # Kết nối
    print("\n🔌 Đang kết nối đến BuzuAI...")
    if not client.connect():
        print("❌ Không thể kết nối!")
        return
    
    print("✅ Đã kết nối thành công!")
    
    # Nhập user ID
    user_id = input("\n👤 Nhập User ID của bạn (Enter = 'demo_user'): ").strip()
    if not user_id:
        user_id = "demo_user"
    
    print(f"\n✅ Sử dụng User ID: {user_id}")
    print("\n💡 Hướng dẫn:")
    print("  - Gõ tin nhắn và Enter để gửi")
    print("  - Gõ 'quit', 'exit', hoặc 'bye' để thoát")
    print("  - Ctrl+C để dừng ngay lập tức")
    print("\n" + "="*60)
    
    # Interactive loop
    while True:
        try:
            # Nhập tin nhắn
            message = input("\n📝 Bạn: ").strip()
            
            # Kiểm tra lệnh thoát
            if not message:
                continue
            
            if message.lower() in ["quit", "exit", "bye", "thoát"]:
                print("👋 Tạm biệt!")
                break
            
            # Gửi tin nhắn
            print("⏳ Đang chờ AI trả lời...")
            response = client.send_message(
                visitor_id=user_id,
                text=message,
                language_code="vi"
            )
            
            if response:
                text = response.get("text", response.get("content", ""))
                print(f"🤖 AI: {text}")
            else:
                print("⚠️ Không nhận được response (timeout hoặc lỗi)")
        
        except KeyboardInterrupt:
            print("\n\n⚠️ Đã dừng bởi người dùng")
            break
        except Exception as e:
            print(f"❌ Lỗi: {e}")
    
    # Ngắt kết nối
    print("\n🔌 Đang ngắt kết nối...")
    client.disconnect()
    print("✅ Đã ngắt kết nối\n")

if __name__ == "__main__":
    main()
