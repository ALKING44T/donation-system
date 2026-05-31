print("^2[Donation System]^7 Started!")

local BACKEND_URL = "http://localhost:3000" -- غير هذا برابط خادمك
local active_donations = {}

-- معالجة طلب التبرع من العميل
RegisterNetEvent('donation:requestPayment')
AddEventHandler('donation:requestPayment', function(amount)
    local source = source
    local playerName = GetPlayerName(source)
    local playerId = GetPlayerIdentifier(source, 0)
    
    print("^3[Donation]^7 " .. playerName .. " requested donation: $" .. amount)
    
    local payload = {
        amount = tostring(amount),
        playerName = playerName,
        playerId = playerId
    }
    
    -- إرسال الطلب للخادم الخارجي
    PerformHttpRequest(BACKEND_URL .. "/api/create-donation", function(errorCode, resultData, resultHeaders)
        if errorCode == 200 then
            local result = json.decode(resultData)
            
            if result.success then
                print("^2[Donation]^7 Payment created: " .. result.paymentId)
                
                -- حفظ معلومات العملية
                active_donations[result.paymentId] = {
                    playerId = playerId,
                    playerName = playerName,
                    amount = amount,
                    source = source,
                    createdAt = os.time()
                }
                
                TriggerClientEvent('donation:showPayPalLink', source, result.approvalUrl, result.paymentId)
            else
                TriggerClientEvent('chat:addMessage', source, {
                    color = {255, 0, 0},
                    multiline = true,
                    args = {"Error", "فشل إنشاء عملية الدفع"}
                })
            end
        else
            print("^1[HTTP Error]^7 Code: " .. errorCode)
            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 0, 0},
                multiline = true,
                args = {"Error", "حدث خطأ في الاتصال بالخادم"}
            })
        end
    end, "POST", json.encode(payload), {
        ["Content-Type"] = "application/json"
    })
end)

-- تأكيد الدفع بنجاح
RegisterNetEvent('donation:confirmPayment')
AddEventHandler('donation:confirmPayment', function(paymentId, transactionId)
    local source = source
    local donationInfo = active_donations[paymentId]
    
    if donationInfo then
        print("^2[Donation Success]^7 " .. donationInfo.playerName .. " donated $" .. donationInfo.amount)
        
        -- حفظ في قاعدة البيانات
        SaveDonationToDB(donationInfo.playerId, donationInfo.amount, transactionId)
        
        -- تشغيل الفيديو والموسيقى
        TriggerClientEvent('donation:playMediaForAll', -1, donationInfo.playerName, donationInfo.amount)
        
        -- إرسال رسالة التبرع لكل اللاعبين
        TriggerClientEvent('chat:addMessage', -1, {
            color = {0, 255, 0},
            multiline = true,
            args = {"💚 Donation", donationInfo.playerName .. " تبرع بـ $" .. donationInfo.amount .. " 🙏"}
        })
        
        -- مسح من السجل
        active_donations[paymentId] = nil
    end
end)

-- حفظ التبرع في قاعدة البيانات
function SaveDonationToDB(playerId, amount, transactionId)
    local date = os.date("%Y-%m-%d %H:%M:%S")
    print("^3[DB]^7 Saving donation: " .. playerId .. " | Amount: $" .. amount .. " | Transaction: " .. transactionId)
    
    -- إذا كان لديك قاعدة بيانات، أضف استعلام هنا
    -- MySQL.Async.execute('INSERT INTO donations (player_id, amount, transaction_id, date) VALUES (?, ?, ?, ?)',
    --     {playerId, amount, transactionId, date})
end

-- أمر للمسؤولين لتشغيل الفيديو يدويّاً
RegisterCommand('playdonationmedia', function(source, args, rawCommand)
    local playerName = args[1] or "لاعب مجهول"
    local amount = args[2] or "100"
    
    TriggerClientEvent('donation:playMediaForAll', -1, playerName, amount)
    print("^2[Admin]^7 Triggered donation media")
end, false)

print("^2[Donation System]^7 Ready!")