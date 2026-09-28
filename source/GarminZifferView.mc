using Toybox.ActivityMonitor as ActivityMonitor;
using Toybox.Graphics as Graphics;
using Toybox.SensorHistory as SensorHistory;
using Toybox.System as System;
using Toybox.WatchUi as WatchUi;

class GarminZifferView extends WatchUi.WatchFace {
    const COLOR_BG = 0x000000;
    const COLOR_WHITE = 0xF5F4FA;
    const COLOR_ORANGE = 0xF3A332;

    var _lowPower = false;
    var _background = null;

    function initialize() {
        WatchFace.initialize();
    }

    function onLayout(dc) {
        _background = WatchUi.loadResource(Rez.Drawables.AutumnReference);
    }

    function onShow() {
    }

    function onHide() {
    }

    function onEnterSleep() {
        _lowPower = true;
    }

    function onExitSleep() {
        _lowPower = false;
    }

    function onUpdate(dc) {
        var w = dc.getWidth();
        var h = dc.getHeight();
        var size = (w < h) ? w : h;
        var scale = size.toFloat() / 454.0;
        var cx = w / 2;
        var cy = h / 2;

        dc.setColor(COLOR_BG, COLOR_BG);
        dc.clear();

        if (_lowPower) {
            drawAlwaysOn(dc, cx, cy, scale);
            return;
        }

        if (_background != null) {
            dc.drawBitmap(0, 0, _background);
        }

        drawReferenceLayout(dc, cx, cy, scale);
    }

    private function drawReferenceLayout(dc, cx, cy, scale) {
        var clock = System.getClockTime();
        var rawHour = clock.hour;
        var suffix = rawHour < 12 ? "AM" : "PM";
        var hour = rawHour % 12;

        if (hour == 0) {
            hour = 12;
        }

        var hourText = hour.format("%02d");
        var minuteText = clock.min.format("%02d");

        var steps = ActivityMonitor.getInfo().steps;
        if (steps == null) {
            steps = 0;
        }

        var heartRate = getLatestHeartRate();
        var bodyBattery = getLatestBodyBattery();
        var deviceBattery = System.getSystemStats().battery.toNumber();

        // Top row: AM/PM, heart, heart rate.
        dc.setColor(COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText((196 * scale).toNumber(), (137 * scale).toNumber(),
            Graphics.FONT_XTINY, suffix, Graphics.TEXT_JUSTIFY_CENTER);

        drawHeart(dc, (248 * scale).toNumber(), (153 * scale).toNumber(), scale);

        dc.drawText((292 * scale).toNumber(), (137 * scale).toNumber(),
            Graphics.FONT_XTINY, valueOrDash(heartRate), Graphics.TEXT_JUSTIFY_CENTER);

        // The same small phrase visible in the reference face.
        dc.drawText((286 * scale).toNumber(), (171 * scale).toNumber(),
            Graphics.FONT_XTINY, "IN DEN", Graphics.TEXT_JUSTIFY_CENTER);

        // Large two-color time.
        dc.setColor(COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText((145 * scale).toNumber(), (178 * scale).toNumber(),
            Graphics.FONT_NUMBER_HOT, hourText, Graphics.TEXT_JUSTIFY_CENTER);

        dc.setColor(COLOR_ORANGE, Graphics.COLOR_TRANSPARENT);
        dc.drawText((309 * scale).toNumber(), (202 * scale).toNumber(),
            Graphics.FONT_NUMBER_HOT, minuteText, Graphics.TEXT_JUSTIFY_CENTER);

        // Steps row.
        dc.setColor(COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText((170 * scale).toNumber(), (300 * scale).toNumber(),
            Graphics.FONT_XTINY, steps.format("%d"), Graphics.TEXT_JUSTIFY_CENTER);
        drawFootprints(dc, (225 * scale).toNumber(), (316 * scale).toNumber(), scale);

        // Bottom row: Body Battery, lightning, device battery.
        dc.drawText((185 * scale).toNumber(), (337 * scale).toNumber(),
            Graphics.FONT_XTINY, valueOrDash(bodyBattery), Graphics.TEXT_JUSTIFY_CENTER);
        drawLightning(dc, (226 * scale).toNumber(), (353 * scale).toNumber(), scale);
        dc.drawText((272 * scale).toNumber(), (337 * scale).toNumber(),
            Graphics.FONT_XTINY, deviceBattery.format("%d"), Graphics.TEXT_JUSTIFY_CENTER);
    }

    private function getLatestHeartRate() {
        try {
            var iterator = SensorHistory.getHeartRateHistory({
                :period => 1,
                :order => SensorHistory.ORDER_NEWEST_FIRST
            });

            if (iterator != null) {
                var sample = iterator.next();
                if (sample != null && sample.data != null) {
                    return sample.data.toNumber();
                }
            }
        } catch (e) {
        }

        return null;
    }

    private function getLatestBodyBattery() {
        try {
            var iterator = SensorHistory.getBodyBatteryHistory({
                :period => 1,
                :order => SensorHistory.ORDER_NEWEST_FIRST
            });

            if (iterator != null) {
                var sample = iterator.next();
                if (sample != null && sample.data != null) {
                    return sample.data.toNumber();
                }
            }
        } catch (e) {
        }

        return null;
    }

    private function valueOrDash(value) {
        if (value == null) {
            return "--";
        }

        return value.format("%d");
    }

    private function drawHeart(dc, x, y, scale) {
        var r = (7 * scale).toNumber();
        if (r < 4) {
            r = 4;
        }

        dc.setColor(COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(x - (r / 2), y - (r / 3), (r * 2 / 3).toNumber());
        dc.fillCircle(x + (r / 2), y - (r / 3), (r * 2 / 3).toNumber());
        dc.fillEllipse(x, y + (r / 2), r, r);
    }

    private function drawFootprints(dc, x, y, scale) {
        var r = (4 * scale).toNumber();
        if (r < 2) {
            r = 2;
        }

        dc.setColor(COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.fillEllipse(x - (7 * scale).toNumber(), y - (3 * scale).toNumber(), r, (r + 2).toNumber());
        dc.fillEllipse(x + (6 * scale).toNumber(), y + (3 * scale).toNumber(), r, (r + 2).toNumber());
        dc.fillCircle(x - (11 * scale).toNumber(), y - (10 * scale).toNumber(), (r / 2 + 1).toNumber());
        dc.fillCircle(x + (10 * scale).toNumber(), y - (5 * scale).toNumber(), (r / 2 + 1).toNumber());
    }

    private function drawLightning(dc, x, y, scale) {
        var dx = (7 * scale).toNumber();
        var dy = (12 * scale).toNumber();

        dc.setColor(COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth((3 * scale).toNumber());
        dc.drawLine(x + (dx / 2), y - dy, x - (dx / 2), y);
        dc.drawLine(x - (dx / 2), y, x + (dx / 3), y);
        dc.drawLine(x + (dx / 3), y, x - (dx / 2), y + dy);
    }

    private function drawAlwaysOn(dc, cx, cy, scale) {
        var clock = System.getClockTime();
        var hour = clock.hour % 12;

        if (hour == 0) {
            hour = 12;
        }

        var timeText = hour.format("%02d") + ":" + clock.min.format("%02d");
        var shift = ((clock.min % 5) - 2) * 2;

        dc.setColor(COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(cx + shift, cy - (24 * scale).toNumber(),
            Graphics.FONT_NUMBER_MILD, timeText, Graphics.TEXT_JUSTIFY_CENTER);
    }
}
