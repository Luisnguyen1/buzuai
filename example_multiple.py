"""
Ví dụ sử dụng BuzuAI Client - Gửi nhiều tin nhắn
"""

from buzuai import get_buzuai_client
import logging

# Setup logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)

def main():
    print("="*60)
    print("🤖 BUZUAI CLIENT - NHIỀU TIN NHẮN")
    print("="*60)
    
    # Lấy client singleton
    client = get_buzuai_client()
    
    # Kết nối
    print("\n🔌 Đang kết nối đến BuzuAI...")
    if not client.connect():
        print("❌ Không thể kết nối!")
        return
    
    print("✅ Đã kết nối thành công!")
    
    # User ID
    user_id = "demo_user_123"
    
    # Danh sách câu hỏi
    questions = [
        "Xin chào! Bạn có thể giới thiệu về mình không?",
        "Bạn có thể làm gì?",
        "Hôm nay thời tiết Hà Nội thế nào?",
        "Cảm ơn bạn nhé!",
    ]
    
    # Gửi từng câu hỏi
    for i, question in enumerate(questions, 1):
        print(f"\n{'='*60}")
        print(f"📤 [{i}/{len(questions)}] Hỏi: {question}")
        print("⏳ Đang chờ response...")
        
        response = client.send_message(
            visitor_id=user_id,
            text=question,
            language_code="vi"
        )
        
        if response:
            text = response.get("text", response.get("content", ""))
            print(f"💬 AI trả lời: {text}")
        else:
            print("⚠️ Không nhận được response")
    
    # Ngắt kết nối
    print(f"\n{'='*60}")
    print("🔌 Đang ngắt kết nối...")
    client.disconnect()
    print("✅ Đã ngắt kết nối")
    print("="*60)

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\n\n⚠️ Đã dừng bởi người dùng")
    except Exception as e:
        print(f"\n❌ Lỗi: {e}")
        import traceback
        traceback.print_exc()
