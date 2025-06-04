const {
    BN,
    constants,
    expectRevert,
    time,
} = require('@openzeppelin/test-helpers');
const { expect } = require('chai');
const { ethers } = require('ethers');
const { ZERO_ADDRESS } = constants;

const Dates = artifacts.require('Date');

contract('Dates', function (accounts) {
    const [deployer, user1, user2] = accounts;

    before(async function () {
        this.dates = await Dates.new({
            from: deployer,
        });
    });

    describe('Dates', function () {
        // sig=b"daysFromDate(uint64,uint64,uint64) returns (uint64)"
        // sig=b"daysToDate(uint64) returns (uint64,uint64,uint64)"
        // sig=b"timestampFromDate(uint64,uint64,uint64) returns (uint64)"
        // sig=b"timestampFromDateTime(uint64,uint64,uint64,uint64,uint64,uint64) returns (uint64)"
        // sig=b"timestampToDate(uint64) returns (uint64,uint64,uint64)"
        // sig=b"timestampToDateTime(uint64) returns (uint64,uint64,uint64,uint64,uint64,uint64)"
        // sig=b"isValidDate(uint64,uint64,uint64) returns (bool)"
        // sig=b"isValidDateTime(uint64,uint64,uint64,uint64,uint64,uint64) returns (bool)"
        // sig=b"isTimestampLeapYear(uint64) returns (bool)"
        // sig=b"isYearLeapYear(uint64) returns (bool)"
        // sig=b"isWeekday(uint64) returns (bool)"
        // sig=b"isWeekend(uint64) returns (bool)"
        // sig=b"getDaysInTimestampMonth(uint64) returns (uint64)"
        // sig=b"getDaysInYearMonth(uint64,uint64) returns (uint64)"
        // sig=b"getDayOfWeek(uint64) returns (uint64)"
        // sig=b"getYear(uint64) returns (uint64)"
        // sig=b"getMonth(uint64) returns (uint64)"
        // sig=b"getDay(uint64) returns (uint64)"
        // sig=b"getHour(uint64) returns (uint64)"
        // sig=b"getMinute(uint64) returns (uint64)"
        // sig=b"getSecond(uint64) returns (uint64)"
        // sig=b"addYears(uint64,uint64) returns (uint64)"
        // sig=b"addMonths(uint64,uint64) returns (uint64)"
        // sig=b"addDays(uint64,uint64) returns (uint64)"
        // sig=b"addHours(uint64,uint64) returns (uint64)"
        // sig=b"addMinutes(uint64,uint64) returns (uint64)"
        // sig=b"addSeconds(uint64,uint64) returns (uint64)"
        // sig=b"subYears(uint64,uint64) returns (uint64)"
        // sig=b"subMonths(uint64,uint64) returns (uint64)"
        // sig=b"subDays(uint64,uint64) returns (uint64)"
        // sig=b"subHours(uint64,uint64) returns (uint64)"
        // sig=b"subMinutes(uint64,uint64) returns (uint64)"
        // sig=b"subSeconds(uint64,uint64) returns (uint64)"
        // sig=b"diffYears(uint64,uint64) returns (uint64)"
        // sig=b"diffMonths(uint64,uint64) returns (uint64)"
        // sig=b"diffDays(uint64,uint64) returns (uint64)"
        // sig=b"diffHours(uint64,uint64) returns (uint64)"
        // sig=b"diffMinutes(uint64,uint64) returns (uint64)"
        // sig=b"diffSeconds(uint64,uint64) returns (uint64)"
        it('should call daysFromDate', async function () {
            let result = await this.dates.daysFromDate(2025, 5, 22, {
                from: user1,
            });
            console.log('Days from date cost: ', result.receipt.gasUsed);
        });
        xit('should call daysToDate', async function () {
            let result = await this.dates.daysToDate(12, {
                from: user1,
            });
            console.log('Days to date cost: ', result.receipt.gasUsed);
        });
        xit('should call timestampFromDate', async function () {
            let result = await this.dates.timestampFromDate(2023, 10, 1, {
                from: user1,
            });
            console.log('Timestamp from date cost: ', result.receipt.gasUsed);
        });
        xit('should call timestampFromDateTime', async function () {
            let result = await this.dates.timestampFromDateTime(
                2023,
                10,
                1,
                0,
                0,
                0,
                {
                    from: user1,
                }
            );
            console.log(
                'Timestamp from date time cost: ',
                result.receipt.gasUsed
            );
        });
        xit('should call timestampToDate', async function () {
            let result = await this.dates.timestampToDate(0, {
                from: user1,
            });
            console.log('Timestamp to date cost: ', result.receipt.gasUsed);
        });
        xit('should call timestampToDateTime', async function () {
            let result = await this.dates.timestampToDateTime(0, {
                from: user1,
            });
            console.log(
                'Timestamp to date time cost: ',
                result.receipt.gasUsed
            );
        });
        xit('should call isValidDate', async function () {
            let result = await this.dates.isValidDate(2023, 10, 1, {
                from: user1,
            });
            console.log('Is valid date cost: ', result.receipt.gasUsed);
        });
        xit('should call isValidDateTime', async function () {
            let result = await this.dates.isValidDateTime(
                2023,
                10,
                1,
                0,
                0,
                0,
                {
                    from: user1,
                }
            );
            console.log('Is valid date time cost: ', result.receipt.gasUsed);
        });
        xit('should call isTimestampLeapYear', async function () {
            // random timestamp
            let timestamp = Math.floor(Date.now() / 1000);
            let result = await this.dates.isTimestampLeapYear(timestamp, {
                from: user1,
            });
            console.log(
                'Is timestamp leap year cost: ',
                result.receipt.gasUsed
            );
        });
        xit('should call isYearLeapYear', async function () {
            let result = await this.dates.isYearLeapYear(2023, {
                from: user1,
            });
            console.log('Is year leap year cost: ', result.receipt.gasUsed);
        });
        xit('should call isWeekday', async function () {
            // random timestamp
            let timestamp = Math.floor(Date.now() / 1000);
            let result = await this.dates.isWeekday(timestamp, {
                from: user1,
            });
            console.log('Is weekday cost: ', result.receipt.gasUsed);
        });
        xit('should call isWeekend', async function () {
            // random timestamp
            let timestamp = Math.floor(Date.now() / 1000);
            let result = await this.dates.isWeekend(timestamp, {
                from: user1,
            });
            console.log('Is weekend cost: ', result.receipt.gasUsed);
        });
        xit('should call getDaysInTimestampMonth', async function () {
            // random timestamp
            let timestamp = Math.floor(Date.now() / 1000);
            let result = await this.dates.getDaysInTimestampMonth(timestamp, {
                from: user1,
            });
            console.log(
                'Get days in timestamp month cost: ',
                result.receipt.gasUsed
            );
        });
        xit('should call getDaysInYearMonth', async function () {
            let result = await this.dates.getDaysInYearMonth(2023, 10, {
                from: user1,
            });
            console.log(
                'Get days in year month cost: ',
                result.receipt.gasUsed
            );
        });
        xit('should call getDayOfWeek', async function () {
            // random timestamp
            let timestamp = Math.floor(Date.now() / 1000);
            let result = await this.dates.getDayOfWeek(timestamp, {
                from: user1,
            });
            console.log('Get day of week cost: ', result.receipt.gasUsed);
        });
        xit('should call getYear', async function () {
            // random timestamp
            let timestamp = Math.floor(Date.now() / 1000);
            let result = await this.dates.getYear(timestamp, {
                from: user1,
            });
            console.log('Get year cost: ', result.receipt.gasUsed);
        });
        xit('should call getMonth', async function () {
            // random timestamp
            let timestamp = Math.floor(Date.now() / 1000);
            let result = await this.dates.getMonth(timestamp, {
                from: user1,
            });
            console.log('Get month cost: ', result.receipt.gasUsed);
        });
        xit('should call getDay', async function () {
            // random timestamp
            let timestamp = Math.floor(Date.now() / 1000);
            let result = await this.dates.getDay(timestamp, {
                from: user1,
            });
            console.log('Get day cost: ', result.receipt.gasUsed);
        });
        xit('should call getHour', async function () {
            // random timestamp
            let timestamp = Math.floor(Date.now() / 1000);
            let result = await this.dates.getHour(timestamp, {
                from: user1,
            });
            console.log('Get hour cost: ', result.receipt.gasUsed);
        });
        xit('should call getMinute', async function () {
            // random timestamp
            let timestamp = Math.floor(Date.now() / 1000);
            let result = await this.dates.getMinute(timestamp, {
                from: user1,
            });
            console.log('Get minute cost: ', result.receipt.gasUsed);
        });
        xit('should call getSecond', async function () {
            // random timestamp
            let timestamp = Math.floor(Date.now() / 1000);
            let result = await this.dates.getSecond(timestamp, {
                from: user1,
            });
            console.log('Get second cost: ', result.receipt.gasUsed);
        });
        xit('should call addYears', async function () {
            // random timestamp
            let timestamp = Math.floor(Date.now() / 1000);
            let result = await this.dates.addYears(timestamp, 1, {
                from: user1,
            });
            console.log('Add years cost: ', result.receipt.gasUsed);
        });
        xit('should call addMonths', async function () {
            // random timestamp
            let timestamp = Math.floor(Date.now() / 1000);
            let result = await this.dates.addMonths(timestamp, 1, {
                from: user1,
            });
            console.log('Add months cost: ', result.receipt.gasUsed);
        });
        xit('should call addDays', async function () {
            // random timestamp
            let timestamp = Math.floor(Date.now() / 1000);
            let result = await this.dates.addDays(timestamp, 1, {
                from: user1,
            });
            console.log('Add days cost: ', result.receipt.gasUsed);
        });
    });
});
