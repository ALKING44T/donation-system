# FiveM Donation System with PayPal

سكربت FiveM متكامل للتبرعات عبر PayPal مع عرض فيديو وتشغيل موسيقى 🎬💚

## المميزات

✅ تبرعات عبر PayPal  
✅ عرض فيديو عند كل تبرع  
✅ تشغيل موسيقى معها  
✅ إيقاف تلقائي بعد 30 ثانية  
✅ رسالة شكر مخصصة لكل لاعب  
✅ يظهر لكل لاعبي السيرفر  
✅ واجهة رسومية احترافية  
✅ دعم اللغة العربية  

## التثبيت

1. انسخ المجلد `donation-system` إلى مجلد `resources` في سيرفرك
2. أضف هذا السطر إلى `server.cfg`:
   ```
   ensure donation-system
   ```
3. أعد تشغيل السيرفر

## الأوامر

### للاعبين
```
/donate          - فتح قائمة التبرعات
/testdonate      - اختبار الفيديو والموسيقى
```

### للمسؤولين
```
/playdonationmedia [اسم] [مبلغ]  - تشغيل الفيديو يدويّاً
```

## الإعدادات

عدّل الروابط في `html/script.js`:

```javascript
const DONATION_VIDEO_URL = 'https://your-video-url.mp4';
const DONATION_MUSIC_URL = 'https://your-music-url.mp3';
```

## ملفات المشروع

- `fxmanifest.lua` - ملف الإعدادات الرئيسي
- `server.lua` - البرنامج من جانب الخادم
- `client.lua` - البرنامج من جانب اللاعب
- `html/index.html` - الواجهة الرسومية
- `html/style.css` - تنسيق الواجهة
- `html/script.js` - منطق الواجهة

## قاعدة البيانات (اختياري)

يمكنك إضافة جدول لحفظ التبرعات:

```sql
CREATE TABLE `donations` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `player_id` VARCHAR(50),
  `amount` DECIMAL(10, 2),
  `transaction_id` VARCHAR(100),
  `date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## الدعم

إذا واجهت أي مشاكل:
1. تأكد من أن الروابط صحيحة وقابلة للوصول
2. تحقق من أن السيرفر قيد التشغيل
3. تأكد من تفعيل السكربت في `server.cfg`

---

**تم الإنشاء بواسطة:** ALKING44T ✨
**النسخة:** 1.0.0
