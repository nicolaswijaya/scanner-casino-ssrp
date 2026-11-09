local sampev = require 'lib.samp.events'
local imgui = require 'imgui'
local key = require 'vkeys'

local main_window_state = imgui.ImBool(true)
local current_card = "None"
local card_history = {}
local prediction_text = "Menunggu data..."

-- Representasi nilai kartu (2-10 = Angka, A=1, J=11, Q=12, K=13)
local function getCardValue(cardStr)
    if cardStr == "A" then return 1
    elseif cardStr == "J" then return 11
    elseif cardStr == "Q" then return 12
    elseif cardStr == "K" then return 13
    else return tonumber(cardStr) or 7 end
end

-- Logika Prediksi Probabilitas
local function calculatePrediction()
    if current_card == "None" then 
        prediction_text = "Mulai permainan."
        return 
    end
    
    local current_val = getCardValue(current_card)
    
    -- Inisialisasi deck standar (4 kartu untuk setiap nilai 1-13)
    local deck = {}
    for i = 1, 13 do deck[i] = 4 end
    
    -- Kurangi deck berdasarkan history kartu yang sudah keluar
    for _, c in ipairs(card_history) do
        local val = getCardValue(c)
        if deck[val] and deck[val] > 0 then
            deck[val] = deck[val] - 1
        end
    end
    
    local total_remaining = 0
    local higher_count = 0
    local lower_count = 0
    
    for val, count in pairs(deck) do
        total_remaining = total_remaining + count
        if val > current_val then
            higher_count = higher_count + count
        elseif val < current_val then
            lower_count = lower_count + count
        end
    end
    
    if total_remaining == 0 then
        prediction_text = "Deck Habis! Reset."
        return
    end
    
    local pct_high = (higher_count / total_remaining) * 100
    local pct_low = (lower_count / total_remaining) * 100
    
    if pct_high > pct_low then
        prediction_text = string.format("PILIH: HIGH (Peluang: %.1f%%)", pct_high)
    elseif pct_low > pct_high then
        prediction_text = string.format("PILIH: LOW (Peluang: %.1f%%)", pct_low)
    else
        prediction_text = "Peluang Seimbang (50:50)"
    end
end

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end
    
    sampAddChatMessage("{00FF00}[HighLow Ultimate]{FFFFFF} Auto-Scanner & Predictor Aktif! [F4]", -1)
    
    while true do
        wait(0)
        if wasKeyPressed(key.VK_F4) then
            main_window_state = not main_window_state
        end
        imgui.Process = main_window_state
    end
end

-- Membaca TextDraw otomatis dari dealer kasino SSRP
function sampev.onShowTextDraw(id, data)
    if data.text and data.text ~= "" then
        -- Mencari kecocokan textdraw berupa angka (1-10) atau huruf kartu (A, K, Q, J)
        local card = string.match(data.text, "^%d+$") or string.match(data.text, "[AKQJ]")
        if card then
            current_card = card
            table.insert(card_history, card)
            calculatePrediction()
        end
    end
end

function imgui.OnDrawFrame()
    if not main_window_state then return end
    
    imgui.SetNextWindowSize(imgui.ImVec2(250, 420), imgui.Cond.FirstUseEver)
    imgui.Begin("CARD SCANNER & PREDICTOR", main_window_state, imgui.WindowFlags.NoResize)
    
    imgui.Text("GTA SA-MP | HighLow Ultimate")
    imgui.Separator()
    
    imgui.TextColored(imgui.ImVec4(1, 1, 0, 1), "CURRENT CARD:")
    imgui.Text("Kartu Saat Ini: " .. current_card)
    imgui.Spacing()
    
    -- TAMPILAN PREDIKSI (Rekomendasi gerakan berikutnya)
    imgui.Separator()
    imgui.TextColored(imgui.ImVec4(0, 1, 1, 1), "AI PREDICTION / NEXT MOVE:")
    imgui.TextWrapped(prediction_text)
    imgui.Separator()
    
    imgui.Text("MANUAL INPUT (Jika Otomatis Meleset):")
    local btn_size = imgui.ImVec2(68, 25)
    local cards_list = {"A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"}
    
    for i, c in ipairs(cards_list) do
        if imgui.Button(c, btn_size) then 
            current_card = c 
            table.insert(card_history, current_card)
            calculatePrediction()
        end
        if i % 3 ~= 0 then imgui.SameLine() end
    end
    
    imgui.Spacing()
    imgui.Separator()
    imgui.TextColored(imgui.ImVec4(1, 0, 0, 1), "CARD HISTORY:")
    local history_str = table.concat(card_history, ", ")
    imgui.TextWrapped(history_str == "" and "History is empty" or history_str)
    
    imgui.Spacing()
    imgui.Text("TOTAL CARDS: " .. #card_history)
    
    if imgui.Button("RESET HISTORY", imgui.ImVec2(120, 30)) then
        card_history = {}
        current_card = "None"
        prediction_text = "Menunggu data..."
    end
    imgui.SameLine()
    if imgui.Button("CLOSE", imgui.ImVec2(100, 30)) then
        main_window_state = false
    end
    
    imgui.End()
end
