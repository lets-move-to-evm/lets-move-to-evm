#[evm_contract]
module Evm::date {
    use std::error;

    const SECONDS_PER_DAY: u128 = 24 * 60 * 60;
    const SECONDS_PER_HOUR: u128 = 60 * 60;
    const SECONDS_PER_MINUTE: u128 = 60;
    const OFFSET19700101: u128 = 2440588;

    const DOW_MON: u128 = 1;
    const DOW_TUE: u128 = 2;
    const DOW_WED: u128 = 3;
    const DOW_THU: u128 = 4;
    const DOW_FRI: u128 = 5;
    const DOW_SAT: u128 = 6;
    const DOW_SUN: u128 = 7;

    const EYEAR_BEFORE_1970: u64 = 0;
    const EADDITION_ASSERTION_FAILED: u64 = 1;
    const ESUBTRACTION_ASSERTION_FAILED: u64 = 2;
    const EFROM_TIMESTAMP_LATER_THAN_TO_TIMESTAMP: u64 = 3;

    // ------------------------------------------------------------------------
    // Calculate the number of days from 1970/01/01 to year/month/day using
    // the date conversion algorithm from
    //   https://aa.usno.navy.mil/faq/JD_formula.html
    // and subtracting the offset 2440588 so that 1970/01/01 is day 0
    //
    // days = day
    //      - 32075
    //      + 1461 * (year + 4800 + (month - 14) / 12) / 4
    //      + 367 * (month - 2 - (month - 14) / 12 * 12) / 12
    //      - 3 * ((year + 4900 + (month - 14) / 12) / 100) / 4
    //      - offset
    // ------------------------------------------------------------------------
    #[callable(sig=b"daysFromDate(uint128,uint128,uint128) returns (uint128)")]
    public fun days_from_date(_year: u128, _month: u128, _day: u128): u128 {
        assert!(_year >= 1970, error::invalid_argument(EYEAR_BEFORE_1970));
        let monthMinus14DividedBy12TimesNegative1 = if (_month < 3) 1 else 0;
        let __days = _day
            + 1461 * (_year + 4800 - monthMinus14DividedBy12TimesNegative1) / 4;
        let mm14db12tn1Times12PlusMonth = monthMinus14DividedBy12TimesNegative1 * 12 + _month;
        __days = if (mm14db12tn1Times12PlusMonth >= 2) __days + 367 * (mm14db12tn1Times12PlusMonth - 2) / 12 else __days - 367 * (2 - mm14db12tn1Times12PlusMonth) / 12;
        __days = __days - 3 * ((_year + 4900 - monthMinus14DividedBy12TimesNegative1) / 100) / 4
            - 32075
            - OFFSET19700101;
        __days
    }

    // ------------------------------------------------------------------------
    // Calculate year/month/day from the number of days since 1970/01/01 using
    // the date conversion algorithm from
    //   http://aa.usno.navy.mil/faq/docs/JD_Formula.php
    // and adding the offset 2440588 so that 1970/01/01 is day 0
    //
    // int L = days + 68569 + offset
    // int N = 4 * L / 146097
    // L = L - (146097 * N + 3) / 4
    // year = 4000 * (L + 1) / 1461001
    // L = L - 1461 * year / 4 + 31
    // month = 80 * L / 2447
    // dd = L - 2447 * month / 80
    // L = month / 11
    // month = month + 2 - 12 * L
    // year = 100 * (N - 49) + year + L
    // ------------------------------------------------------------------------
    #[callable(sig=b"daysToDate(uint128) returns (uint128,uint128,uint128)")]
    public fun days_to_date(days: u128): (u128, u128, u128) {
        let l = days + 68569 + OFFSET19700101;
        let n = 4 * l / 146097;
        l = l - (146097 * n + 3) / 4;
        let _year = 4000 * (l + 1) / 1461001;
        l = l - 1461 * _year / 4 + 31;
        let _month = 80 * l / 2447;
        let _day = l - 2447 * _month / 80;
        l = _month / 11;
        _month = _month + 2 - 12 * l;
        _year = 100 * (n - 49) + _year + l;

        (_year, _month, _day)
    }

    #[callable(sig=b"timestampFromDate(uint128,uint128,uint128) returns (uint128)")]
    public fun timestamp_from_date(year: u128, month: u128, day: u128): u128 {
        days_from_date(year, month, day) * SECONDS_PER_DAY
    }

    #[callable(sig=b"timestampFromDateTime(uint128,uint128,uint128,uint128,uint128,uint128) returns (uint128)")]
    public fun timestamp_from_date_time(year: u128, month: u128, day: u128, hour: u128, minute: u128, second: u128): u128 {
        days_from_date(year, month, day) * SECONDS_PER_DAY + hour * SECONDS_PER_HOUR + minute * SECONDS_PER_MINUTE + second
    }

    #[callable(sig=b"timestampToDate(uint128) returns (uint128,uint128,uint128)")]
    public fun timestamp_to_date(tmstmp: u128): (u128, u128, u128) {
        days_to_date(tmstmp / SECONDS_PER_DAY)
    }

    #[callable(sig=b"timestampToDateTime(uint128) returns (uint128,uint128,uint128,uint128,uint128,uint128)")]
    public fun timestamp_to_date_time(tmstmp: u128): (u128, u128, u128, u128, u128, u128) {
        let (year, month, day) = days_to_date(tmstmp / SECONDS_PER_DAY);
        let secs = tmstmp % SECONDS_PER_DAY;
        let hour = secs / SECONDS_PER_HOUR;
        secs = secs % SECONDS_PER_HOUR;
        let minute = secs / SECONDS_PER_MINUTE;
        let second = secs % SECONDS_PER_MINUTE;
        (year, month, day, hour, minute, second)
    }

    #[callable(sig=b"isValidDate(uint128,uint128,uint128) returns (bool)")]
    public fun is_valid_date(year: u128, month: u128, day: u128): bool {
        if (year >= 1970 && month > 0 && month <= 12) {
            let days_in_month = get_days_in_year_month(year, month);
            if (day > 0 && day <= days_in_month) return true;
        };
        false
    }

    #[callable(sig=b"isValidDateTime(uint128,uint128,uint128,uint128,uint128,uint128) returns (bool)")]
    public fun is_valid_date_time(year: u128, month: u128, day: u128, hour: u128, minute: u128, second: u128): bool {
        is_valid_date(year, month, day) && hour < 24 && minute < 60 && second < 60
    }

    #[callable(sig=b"isTimestampLeapYear(uint128) returns (bool)")]
    public fun is_timestamp_leap_year(tmstmp: u128): bool {
        let (year, _, _) = days_to_date(tmstmp / SECONDS_PER_DAY);
        is_year_leap_year(year)
    }

    #[callable(sig=b"isYearLeapYear(uint128) returns (bool)")]
    public fun is_year_leap_year(year: u128): bool {
        ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0)
    }

    #[callable(sig=b"isWeekday(uint128) returns (bool)")]
    public fun is_weekday(tmstmp: u128): bool {
        get_day_of_week(tmstmp) <= DOW_FRI
    }

    #[callable(sig=b"isWeekend(uint128) returns (bool)")]
    public fun is_weekend(tmstmp: u128): bool {
        get_day_of_week(tmstmp) >= DOW_SAT
    }

    #[callable(sig=b"getDaysInTimestampMonth(uint128) returns (uint128)")]
    public fun get_days_in_timestamp_month(tmstmp: u128): u128 {
        let (year, month, _) = days_to_date(tmstmp / SECONDS_PER_DAY);
        get_days_in_year_month(year, month)
    }

    #[callable(sig=b"getDaysInYearMonth(uint128,uint128) returns (uint128)")]
    public fun get_days_in_year_month(year: u128, month: u128): u128 {
        if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) return 31;
        if (month != 2) return 30;
        if (is_year_leap_year(year)) 29 else 28
    }

    #[callable(sig=b"getDayOfWeek(uint128) returns (uint128)")]
    // 1 = Monday, 7 = Sunday
    public fun get_day_of_week(tmstmp: u128): u128 {
        let _days = tmstmp / SECONDS_PER_DAY;
        (_days + 3) % 7 + 1
    }

    #[callable(sig=b"getYear(uint128) returns (uint128)")]
    public fun get_year(tmstmp: u128): u128 {
        let (year, _, _) = days_to_date(tmstmp / SECONDS_PER_DAY);
        year
    }

    #[callable(sig=b"getMonth(uint128) returns (uint128)")]
    public fun get_month(tmstmp: u128): u128 {
        let (_, month, _) = days_to_date(tmstmp / SECONDS_PER_DAY);
        month
    }

    #[callable(sig=b"getDay(uint128) returns (uint128)")]
    public fun get_day(tmstmp: u128): u128 {
        let (_, _, day) = days_to_date(tmstmp / SECONDS_PER_DAY);
        day
    }

    #[callable(sig=b"getHour(uint128) returns (uint128)")]
    public fun get_hour(tmstmp: u128): u128 {
        let secs = tmstmp % SECONDS_PER_DAY;
        secs / SECONDS_PER_HOUR
    }

    #[callable(sig=b"getMinute(uint128) returns (uint128)")]
    public fun get_minute(tmstmp: u128): u128 {
        let secs = tmstmp % SECONDS_PER_HOUR;
        secs / SECONDS_PER_MINUTE
    }

    #[callable(sig=b"getSecond(uint128) returns (uint128)")]
    public fun get_second(tmstmp: u128): u128 {
        tmstmp % SECONDS_PER_MINUTE
    }

    #[callable(sig=b"addYears(uint128,uint128) returns (uint128)")]
    public fun add_years(tmstmp: u128, _years: u128): u128 {
        let (year, month, day) = days_to_date(tmstmp / SECONDS_PER_DAY);
        year = year + _years;
        let days_in_month = get_days_in_year_month(year, month);
        if (day > days_in_month) day = days_in_month;
        let new_timestamp = days_from_date(year, month, day) * SECONDS_PER_DAY + tmstmp % SECONDS_PER_DAY;
        assert!(new_timestamp >= tmstmp, error::internal(EADDITION_ASSERTION_FAILED));
        new_timestamp
    }

    #[callable(sig=b"addMonths(uint128,uint128) returns (uint128)")]
    public fun add_months(tmstmp: u128, _months: u128): u128 {
        let (year, month, day) = days_to_date(tmstmp / SECONDS_PER_DAY);
        month = month + _months;
        year = year + (month - 1) / 12;
        month = (month - 1) % 12 + 1;
        let days_in_month = get_days_in_year_month(year, month);
        if (day > days_in_month) day = days_in_month;
        let new_timestamp = days_from_date(year, month, day) * SECONDS_PER_DAY + tmstmp % SECONDS_PER_DAY;
        assert!(new_timestamp >= tmstmp, error::internal(EADDITION_ASSERTION_FAILED));
        new_timestamp
    }

    #[callable(sig=b"addDays(uint128,uint128) returns (uint128)")]
    public fun add_days(tmstmp: u128, _days: u128): u128 {
        tmstmp + _days * SECONDS_PER_DAY
    }

    #[callable(sig=b"addHours(uint128,uint128) returns (uint128)")]
    public fun add_hours(tmstmp: u128, _hours: u128): u128 {
        tmstmp + _hours * SECONDS_PER_HOUR
    }

    #[callable(sig=b"addMinutes(uint128,uint128) returns (uint128)")]
    public fun add_minutes(tmstmp: u128, _minutes: u128): u128 {
        tmstmp + _minutes * SECONDS_PER_MINUTE
    }

    #[callable(sig=b"addSeconds(uint128,uint128) returns (uint128)")]
    public fun add_seconds(tmstmp: u128, _seconds: u128): u128 {
        tmstmp + _seconds
    }

    #[callable(sig=b"subYears(uint128,uint128) returns (uint128)")]
    public fun sub_years(tmstmp: u128, _years: u128): u128 {
        let (year, month, day) = days_to_date(tmstmp / SECONDS_PER_DAY);
        year = year - _years;
        let days_in_month = get_days_in_year_month(year, month);
        if (day > days_in_month) day = days_in_month;
        let new_timestamp = days_from_date(year, month, day) * SECONDS_PER_DAY + tmstmp % SECONDS_PER_DAY;
        assert!(new_timestamp <= tmstmp, error::internal(ESUBTRACTION_ASSERTION_FAILED));
        new_timestamp
    }

    #[callable(sig=b"subMonths(uint128,uint128) returns (uint128)")]
    public fun sub_months(tmstmp: u128, _months: u128): u128 {
        let (year, month, day) = days_to_date(tmstmp / SECONDS_PER_DAY);
        let year_month = year * 12 + (month - 1) - _months;
        year = year_month / 12;
        month = year_month % 12 + 1;
        let days_in_month = get_days_in_year_month(year, month);
        if (day > days_in_month) day = days_in_month;
        let new_timestamp = days_from_date(year, month, day) * SECONDS_PER_DAY + tmstmp % SECONDS_PER_DAY;
        assert!(new_timestamp <= tmstmp, error::internal(ESUBTRACTION_ASSERTION_FAILED));
        new_timestamp
    }

    #[callable(sig=b"subDays(uint128,uint128) returns (uint128)")]
    public fun sub_days(tmstmp: u128, _days: u128): u128 {
        tmstmp - _days * SECONDS_PER_DAY
    }

    #[callable(sig=b"subHours(uint128,uint128) returns (uint128)")]
    public fun sub_hours(tmstmp: u128, _hours: u128): u128 {
        tmstmp - _hours * SECONDS_PER_HOUR
    }

    #[callable(sig=b"subMinutes(uint128,uint128) returns (uint128)")]
    public fun sub_minutes(tmstmp: u128, _minutes: u128): u128 {
        tmstmp - _minutes * SECONDS_PER_MINUTE
    }

    #[callable(sig=b"subSeconds(uint128,uint128) returns (uint128)")]
    public fun sub_seconds(tmstmp: u128, _seconds: u128): u128 {
        tmstmp - _seconds
    }

    #[callable(sig=b"diffYears(uint128,uint128) returns (uint128)")]
    public fun diff_years(from_timestamp: u128, to_timestamp: u128): u128 {
        assert!(from_timestamp <= to_timestamp, error::invalid_argument(EFROM_TIMESTAMP_LATER_THAN_TO_TIMESTAMP));
        let (from_year, _, _) = days_to_date(from_timestamp / SECONDS_PER_DAY);
        let (to_year, _, _) = days_to_date(to_timestamp / SECONDS_PER_DAY);
        to_year - from_year
    }

    #[callable(sig=b"diffMonths(uint128,uint128) returns (uint128)")]
    public fun diff_months(from_timestamp: u128, to_timestamp: u128): u128 {
        assert!(from_timestamp <= to_timestamp, error::invalid_argument(EFROM_TIMESTAMP_LATER_THAN_TO_TIMESTAMP));
        let (from_year, from_month, _) = days_to_date(from_timestamp / SECONDS_PER_DAY);
        let (to_year, to_month, _) = days_to_date(to_timestamp / SECONDS_PER_DAY);
        to_year * 12 + to_month - from_year * 12 - from_month
    }

    #[callable(sig=b"diffDays(uint128,uint128) returns (uint128)")]
    public fun diff_days(from_timestamp: u128, to_timestamp: u128): u128 {
        assert!(from_timestamp <= to_timestamp, error::invalid_argument(EFROM_TIMESTAMP_LATER_THAN_TO_TIMESTAMP));
        (to_timestamp - from_timestamp) / SECONDS_PER_DAY
    }

    #[callable(sig=b"diffHours(uint128,uint128) returns (uint128)")]
    public fun diff_hours(from_timestamp: u128, to_timestamp: u128): u128 {
        assert!(from_timestamp <= to_timestamp, error::invalid_argument(EFROM_TIMESTAMP_LATER_THAN_TO_TIMESTAMP));
        (to_timestamp - from_timestamp) / SECONDS_PER_HOUR
    }

    #[callable(sig=b"diffMinutes(uint128,uint128) returns (uint128)")]
    public fun diff_minutes(from_timestamp: u128, to_timestamp: u128): u128 {
        assert!(from_timestamp <= to_timestamp, error::invalid_argument(EFROM_TIMESTAMP_LATER_THAN_TO_TIMESTAMP));
        (to_timestamp - from_timestamp) / SECONDS_PER_MINUTE
    }

    #[callable(sig=b"diffSeconds(uint128,uint128) returns (uint128)")]
    public fun diff_seconds(from_timestamp: u128, to_timestamp: u128): u128 {
        assert!(from_timestamp <= to_timestamp, error::invalid_argument(EFROM_TIMESTAMP_LATER_THAN_TO_TIMESTAMP));
        to_timestamp - from_timestamp
    }

    #[test]
    public entry fun test_days_from_date_examples() {
        assert!(days_from_date(2019, 12, 20) == 18250, 0);
    }

    #[test]
    public entry fun test_days_to_date_examples() {
        let (y, m, d) = days_to_date(18250);
        assert!(m == 12, 0);
        assert!(d == 20, 1);
        assert!(y == 2019, 2);
    }

    #[test]
    public entry fun test_days_to_date_date_to_days() {
        let i = 0;
        while (i <= 200 * 365) {
            let (y, m, d) = days_to_date(i);
            assert!(days_from_date(y, m, d) == i, 0);
            i = i + 99;
        }
    }
}