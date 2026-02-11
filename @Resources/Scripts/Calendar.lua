-- Calendar Lua Script for Rainmeter

-- Function to check if a year is a leap year
local function isLeapYear(year)
    return (year % 4 == 0 and year % 100 ~= 0) or (year % 400 == 0)
end

-- Function to create calendar
function CreateCalendar()
    -- Get current date from Rainmeter measures
    local currentMonth = tonumber(SKIN:GetMeasure('MeasureMonth'):GetStringValue())
    local currentYear = tonumber(SKIN:GetMeasure('MeasureYear'):GetStringValue())
    local currentDate = tonumber(SKIN:GetMeasure('MeasureDate'):GetStringValue())

    -- Array of days in each month (non-leap year)
    local daysInMonth = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }

    -- Adjust February for leap years
    if isLeapYear(currentYear) then
        daysInMonth[2] = 29
    end

    local totalDays = daysInMonth[currentMonth]
    local dateCounter = 1
    local cellPosition = tonumber(SKIN:GetMeasure('MeasureStart'):GetStringValue())

    local baseX = tonumber(SKIN:GetVariable('CalendarBaseX'))
    local baseY = tonumber(SKIN:GetVariable('CalendarBaseY'))
    local padX = tonumber(SKIN:GetVariable('PadX'))
    local padY = tonumber(SKIN:GetVariable('PadY'))
    local sundayFontColor = SKIN:GetVariable('SundayFontColor')
    local dateFontColor = SKIN:GetVariable('DateFontColor')

    -- Loop through all days of the current month
    for day = 1, totalDays do
        -- Calculate the date meter name (Date1, Date2, ..., Date31)
        local dateMeterName = 'Date' .. dateCounter
        local dateMeter = SKIN:GetMeter(dateMeterName)

        -- Show the meter
        dateMeter:Show()

        -- Calculate X and Y position based on calendar grid (7 columns for days of week)
        local column = (cellPosition) % 7
        local row = math.floor((cellPosition) / 7)

        local xPos = baseX + (column * padX)
        local yPos = baseY + (row * padY)

        if column == 0 and day == currentDate then
            SKIN:Bang('!SetOption', dateMeterName, 'FontColor', "85, 101, 133")
            SKIN:Bang('!SetOption', "MeterToday", 'X', xPos)
            SKIN:Bang('!SetOption', "MeterToday", 'Y', yPos)
        elseif day == currentDate then
            SKIN:Bang('!SetOption', dateMeterName, 'FontColor', "85, 101, 133")
            SKIN:Bang('!SetOption', "MeterToday", 'X', xPos - 13)
            SKIN:Bang('!SetOption', "MeterToday", 'Y', yPos - 13.5)
        elseif column == 0 then
            SKIN:Bang('!SetOption', dateMeterName, 'FontColor', sundayFontColor)
        else
            SKIN:Bang('!SetOption', dateMeterName, 'FontColor', dateFontColor)
        end

        -- Set meter properties
        dateMeter:SetX(xPos)
        dateMeter:SetY(yPos)

        cellPosition = cellPosition + 1

        dateCounter = dateCounter + 1
    end

    -- Hide remaining date meters beyond the current month's days
    for day = dateCounter, 31 do
        local dateMeterName = 'Date' .. day
        local dateMeter = SKIN:GetMeter(dateMeterName)
        dateMeter:Hide()
    end
    -- Redraw the skin to apply changes
    SKIN:Bang("!UpdateMeter *")
    SKIN:Bang("!Redraw")
end
