const donationContainer = document.getElementById('donationContainer');
const donationVideo = document.getElementById('donationVideo');
const donationMusic = document.getElementById('donationMusic');
const donationMessage = document.getElementById('donationMessage');
const donationAmount = document.getElementById('donationAmount');

// روابط الفيديو والموسيقى
const DONATION_VIDEO_URL = 'https://www.w3schools.com/html/mov_bbb.mp4';
const DONATION_MUSIC_URL = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';

// استقبال البيانات من FiveM
window.addEventListener('message', (event) => {
    const data = event.data;
    
    if (data.type === 'playDonation') {
        playDonationMedia(data.playerName, data.amount);
    }
    
    if (data.type === 'stopDonation') {
        stopDonationMedia();
    }
});

function playDonationMedia(playerName, amount) {
    console.log('[Donation] Playing media for:', playerName);
    
    // تحديث المعلومات
    donationMessage.textContent = '🎉 شكراً ' + playerName + ' على تبرعك! 🎉';
    donationAmount.textContent = 'المبلغ: $' + amount;
    
    // عرض الحاوية
    donationContainer.classList.remove('hidden');
    
    // تشغيل الفيديو
    donationVideo.src = DONATION_VIDEO_URL;
    donationVideo.play();
    
    // تشغيل الموسيقى
    donationMusic.src = DONATION_MUSIC_URL;
    donationMusic.volume = 0.7;
    donationMusic.play();
    
    console.log('[Donation] Media started');
}

function stopDonationMedia() {
    console.log('[Donation] Stopping media');
    
    // إيقاف الفيديو والموسيقى
    donationVideo.pause();
    donationMusic.pause();
    
    // إخفاء الحاوية
    donationContainer.classList.add('hidden');
    
    // إعادة تعيين المصادر
    donationVideo.src = '';
    donationMusic.src = '';
}

// اختبار (اضغط F8 في اللعبة)
console.log('[Donation System] Loaded - Use /testdonate command');