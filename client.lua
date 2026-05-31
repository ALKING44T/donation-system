local DonationOpen = false
local SelectedAmount = 1
local MediaPlaying = false

local DonationAmounts = {
    { label = '$5', amount = 5 },
    { label = '$10', amount = 10 },
    { label = '$25', amount = 25 },
    { label = '$50', amount = 50 },
    { label = '$100', amount = 100 },
    { label = '$250', amount = 250 },
    { label = '$500', amount = 500 }
}

-- فتح قائمة التبرعات
RegisterCommand('donate', function(source, args, rawCommand)
    if not DonationOpen then
        OpenDonationMenu()
    end
end, false)

function OpenDonationMenu()
    DonationOpen = true
    SelectedAmount = 1

    while DonationOpen do
        Wait(0)
        
        -- رسم الخلفية
        DrawRect(0.5, 0.5, 0.35, 0.5, 0, 0, 0, 180)
        
        -- رسم الحد
        DrawRect(0.5, 0.25, 0.35, 0.01, 0, 255, 0, 255)
        DrawRect(0.5, 0.75, 0.35, 0.01, 0, 255, 0, 255)
        
        -- رسم العنوان
        DrawText(0.5, 0.27, "~g~قائمة التبرعات~s~", 1.2)
        DrawText(0.5, 0.32, "اختر المبلغ الذي تريد التبرع به", 0.6)
        
        -- رسم الخيارات
        local yOffset = 0.37
        for i, donation in ipairs(DonationAmounts) do
            local color = i == SelectedAmount and "~g~" or "~w~"
            local marker = i == SelectedAmount and "► " or "  "
            DrawText(0.5, yOffset, color .. marker .. donation.label, 0.9)
            yOffset = yOffset + 0.05
        end
        
        -- رسم التعليمات
        DrawText(0.5, yOffset + 0.05, "~y~↑ / ↓~s~ - تحريك | ~y~ENTER~s~ - تأكيد | ~y~ESC~s~ - إغلاق", 0.65)
        
        -- التحكم بلوحة المفاتيح
        if IsControlJustReleased(0, 173) then -- UP
            SelectedAmount = SelectedAmount > 1 and SelectedAmount - 1 or #DonationAmounts
            PlaySoundFrontend(-1, "NAV_UP_DOWN", "PHONE_SOUNDSET_DEFAULT", true)
        end
        
        if IsControlJustReleased(0, 174) then -- DOWN
            SelectedAmount = SelectedAmount < #DonationAmounts and SelectedAmount + 1 or 1
            PlaySoundFrontend(-1, "NAV_UP_DOWN", "PHONE_SOUNDSET_DEFAULT", true)
        end
        
        if IsControlJustReleased(0, 191) then -- ENTER
            local selectedDonation = DonationAmounts[SelectedAmount]
            ProcessDonation(selectedDonation.amount)
            DonationOpen = false
            PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", true)
        end
        
        if IsControlJustReleased(0, 322) then -- ESC
            DonationOpen = false
            PlaySoundFrontend(-1, "CANCEL", "HUD_MINI_GAME_SOUNDSET", true)
        end
    end
end

function ProcessDonation(amount)
    TriggerEvent('chat:addMessage', {
        color = {0, 255, 0},
        multiline = true,
        args = {"Donation", "جاري معالجة تبرعك بقيمة $" .. amount}
    })
    
    TriggerServerEvent('donation:requestPayment', amount)
end

-- استقبال رابط PayPal
RegisterNetEvent('donation:showPayPalLink')
AddEventHandler('donation:showPayPalLink', function(paypalUrl, paymentId)
    TriggerEvent('chat:addMessage', {
        color = {0, 0, 255},
        multiline = true,
        args = {"💳 PayPal", "الرجاء فتح الرابط أدناه لإكمال التبرع"}
    })
    
    print("^4[PayPal Link]^7 " .. paypalUrl)
    print("^3[Payment ID]^7 " .. paymentId)
end)

-- تشغيل الفيديو والموسيقى عند التبرع
RegisterNetEvent('donation:playMediaForAll')
AddEventHandler('donation:playMediaForAll', function(playerName, amount)
    if MediaPlaying then
        return
    end
    
    MediaPlaying = true
    
    print("^2[Donation Media]^7 Playing for: " .. playerName)
    
    -- تشغيل الفيديو والموسيقى
    SendNUIMessage({
        type = 'playDonation',
        playerName = playerName,
        amount = amount
    })
    
    -- إيقاف تلقائي بعد انتهاء الفيديو (30 ثانية)
    SetTimeout(30000, function()
        StopDonationMedia()
    end)
end)

function StopDonationMedia()
    if MediaPlaying then
        SendNUIMessage({
            type = 'stopDonation'
        })
        MediaPlaying = false
        print("^1[Media]^7 Stopped")
    end
end

-- أمر اختبار
RegisterCommand('testdonate', function(source, args, rawCommand)
    TriggerEvent('donation:playMediaForAll', 'لاعب تجريبي', 100)
end, false)

function DrawText(x, y, text, scale)
    SetTextFont(0)
    SetTextScale(scale or 0.7, scale or 0.7)
    SetTextColour(255, 255, 255, 255)
    SetTextCentre(true)
    BeginTextCommandDisplayText("STRING")
    AddTextComponentString(text)
    EndTextCommandDisplayText(x, y)
end